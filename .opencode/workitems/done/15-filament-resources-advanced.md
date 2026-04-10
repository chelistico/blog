# Workitem: 15-filament-resources-advanced

## Fase 3: Recursos Avanzados

### Objetivo
Crear recursos para Advertisements, Footer, Settings y Users.

---

## Tasks

### 3.1 Resource: Advertisement

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource Advertisement --generate
```

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\TextInput::make('name')
                ->required()
                ->maxLength(255),
            Forms\Components\Select::make('position')
                ->options([
                    'top' => 'Top (728x90)',
                    'sidebar' => 'Sidebar (300x250)',
                    'inline' => 'Inline (728x90)',
                    'bottom' => 'Bottom (728x90)',
                    'mobile' => 'Mobile (320x100)',
                ])
                ->required(),
            Forms\Components\TextInput::make('dimensions')
                ->placeholder('ej: 728x90'),
            
            Forms\Components\Section::make('Tipo de Anuncio')
                ->schema([
                    Forms\Components\Radio::make('ad_type')
                        ->options([
                            'image' => 'Imagen',
                            'code' => 'Código HTML (AdSense)',
                        ])
                        ->default('image')
                        ->inline(),
                ]),
            
            // Campos para imagen
            Forms\Components\TextInput::make('image')
                ->label('URL de imagen')
                ->url(),
            Forms\Components\TextInput::make('link')
                ->label('URL de destino')
                ->url(),
            
            // Campo para código
            Forms\Components\RichEditor::make('code')
                ->label('Código HTML')
                ->columnSpanFull(),
            
            Forms\Components\Section::make('Programación')
                ->schema([
                    Forms\Components\Toggle::make('is_active')
                        ->default(true),
                    Forms\Components\DateTimePicker::make('start_date'),
                    Forms\Components\DateTimePicker::make('end_date'),
                    Forms\Components\TextInput::make('order')
                        ->numeric()
                        ->default(1),
                ])->columns(4),
        ]);
}

public static function table(Table $table): Table
{
    return $table
        ->columns([
            Tables\Columns\TextColumn::make('name'),
            Tables\Columns\BadgeColumn::make('position')
                ->colors(['primary']),
            Tables\Columns\TextColumn::make('dimensions'),
            Tables\Columns\IconColumn::make('is_active')
                ->boolean(),
            Tables\Columns\TextColumn::make('order'),
        ])
        ->defaultSort('order');
}
```

### 3.2 Resource: FooterItem

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource FooterItem --generate
```

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\Select::make('section')
                ->options([
                    'categories' => 'Categorías',
                    'legal' => 'Legal',
                    'info' => 'Información',
                    'social' => 'Redes Sociales',
                ])
                ->required(),
            Forms\Components\TextInput::make('title')
                ->required(),
            Forms\Components\Textarea::make('content'),
            Forms\Components\TextInput::make('link_url')
                ->url(),
            Forms\Components\TextInput::make('order')
                ->numeric()
                ->default(0),
            Forms\Components\Toggle::make('is_active')
                ->default(true),
        ]);
}

public static function table(Table $table): Table
{
    return $table
        ->columns([
            Tables\Columns\TextColumn::make('section'),
            Tables\Columns\TextColumn::make('title'),
            Tables\Columns\TextColumn::make('link_url'),
            Tables\Columns\TextColumn::make('order'),
            Tables\Columns\IconColumn::make('is_active')->boolean(),
        ])
        ->defaultSort('section')
        ->defaultSort('order');
}
```

### 3.3 Resource: SiteSetting

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource SiteSetting --generate
```

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\TextInput::make('key')
                ->disabled(),
            Forms\Components\TextInput::make('description')
                ->disabled(),
            Forms\Components\Select::make('type')
                ->options([
                    'text' => 'Texto',
                    'textarea' => 'Área de texto',
                    'image' => 'URL de imagen',
                    'json' => 'JSON',
                    'boolean' => 'Booleano',
                ])
                ->disabled(),
            
            // Renderizar según el tipo
            Forms\Components\Placeholder::make('value_label')
                ->content(fn (SiteSetting $record): ?string => match($record->type) {
                    'text' => 'Valor:',
                    'textarea' => 'Valor:',
                    'image' => 'URL de imagen:',
                    'json' => 'JSON:',
                    'boolean' => 'Activado:',
                    default => 'Valor:',
                }),
            
            Forms\Components\TextInput::make('value')
                ->visible(fn (SiteSetting $record): bool => in_array($record->type, ['text', 'image']))
                ->columnSpanFull(),
            
            Forms\Components\Textarea::make('value')
                ->visible(fn (SiteSetting $record): bool => $record->type === 'textarea')
                ->columnSpanFull(),
            
            Forms\Components\Toggle::make('bool_value')
                ->visible(fn (SiteSetting $record): bool => $record->type === 'boolean')
                ->afterStateUpdated(fn ($set, $state) => $set('value', $state ? '1' : '0'))
                ->label(fn (SiteSetting $record): string => $record->value === '1' ? 'Activado' : 'Desactivado'),
            
            Forms\Components\KeyValue::make('json_value')
                ->visible(fn (SiteSetting $record): bool => $record->type === 'json'),
        ]);
}
```

### 3.4 Resource: User (gestión del sistema)

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource User --generate
```

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\TextInput::make('name')->required(),
            Forms\Components\TextInput::make('email')
                ->email()
                ->required()
                ->unique(ignoreRecord: true),
            Forms\Components\TextInput::make('password')
                ->password()
                ->required(fn (string $context): bool => $context === 'create')
                ->confirmed(),
            Forms\Components\Select::make('role')
                ->options([
                    'admin' => 'Administrador',
                    'editor' => 'Editor',
                    'author' => 'Autor',
                ])
                ->default('author'),
        ]);
}
```

### 3.5 Ocultar recursos sensibles

En el provider, excluir recursos de la navegación si es necesario:

```php
// En AdminPanelProvider.php
public function panel(Panel $panel): Panel
{
    return $panel
        // ...
        ->when(false, function (Panel $panel) {
            // Ocultar User resource si solo admins deben verlo
        });
}
```

### 3.6 Página de configuración rápida

Crear una página personalizada para Site Settings:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-page SiteSettings --resource=SiteSettingResource
```

---

## Verificación

- [ ] Advertisement Resource funcionando
- [ ] FooterItem Resource funcionando
- [ ] SiteSetting Resource funcionando
- [ ] User Resource funcionando

---

## Siguiente Paso
Ver [16-filament-widgets.md](./16-filament-widgets.md) para crear el dashboard.
