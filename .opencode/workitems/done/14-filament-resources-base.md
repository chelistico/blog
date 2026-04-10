# Workitem: 14-filament-resources-base

## Fase 2: Recursos Base

### Objetivo
Crear los recursos Filament para las entidades principales: Articles, Authors y Tags.

---

## Tasks

### 2.1 Resource: Tag

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource Tag --generate
```

Personalizar `app/Filament/Resources/TagResource.php`:

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\TextInput::make('name')
                ->required()
                ->maxLength(255),
            Forms\Components\TextInput::make('slug')
                ->required()
                ->maxLength(255),
            Forms\Components\Textarea::make('description')
                ->maxLength(500),
        ]);
}

public static function table(Table $table): Table
{
    return $table
        ->columns([
            Tables\Columns\TextColumn::make('name')->searchable(),
            Tables\Columns\TextColumn::make('slug')->searchable(),
            Tables\Columns\TextColumn::make('articles_count')
                ->label('Articles')
                ->counts('articles'),
            Tables\Columns\TextColumn::make('created_at')
                ->dateTime(),
        ])
        ->filters([
            Tables\Filters\Filter::make('has_articles')
                ->toggle()
                ->query(fn (Builder $query) => $query->has('articles')),
        ]);
}
```

### 2.2 Resource: Author

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource Author --generate
```

Personalizar `app/Filament/Resources/AuthorResource.php`:

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\TextInput::make('name')->required(),
            Forms\Components\TextInput::make('slug')->required(),
            Forms\Components\TextInput::make('email')
                ->email()
                ->required()
                ->unique(ignoreRecord: true),
            Forms\Components\Textarea::make('bio'),
            Forms\Components\TextInput::make('avatar')
                ->url()
                ->label('Avatar URL'),
            Forms\Components\KeyValue::make('social_links')
                ->label('Social Links'),
            Forms\Components\Toggle::make('is_active')
                ->default(true),
        ]);
}

public static function table(Table $table): Table
{
    return $table
        ->columns([
            Tables\Columns\ImageColumn::make('avatar'),
            Tables\Columns\TextColumn::make('name')->searchable(),
            Tables\Columns\TextColumn::make('email'),
            Tables\Columns\IconColumn::make('is_active')
                ->boolean(),
            Tables\Columns\TextColumn::make('articles_count')
                ->counts('articles'),
        ]);
}
```

### 2.3 Resource: Article (con editor Tiptap)

Primero, instalar Tiptap para el editor rico:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 composer require filament/forms:"^3.2" -W
```

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-resource Article --generate
```

Personalizar con editor Tiptap:

```php
public static function form(Form $form): Form
{
    return $form
        ->schema([
            Forms\Components\Section::make('Información básica')
                ->schema([
                    Forms\Components\TextInput::make('title')
                        ->required()
                        ->maxLength(255),
                    Forms\Components\TextInput::make('slug')
                        ->maxLength(255),
                    Forms\Components\Textarea::make('summary')
                        ->required()
                        ->rows(2),
                    Forms\Components\Select::make('author_id')
                        ->relationship('author', 'name')
                        ->required()
                        ->searchable(),
                    Forms\Components\Select::make('tags')
                        ->relationship('tags', 'name')
                        ->multiple()
                        ->searchable(),
                ])->columns(2),
            
            Forms\Components\Section::make('Contenido')
                ->schema([
                    Forms\Components\RichEditor::make('content')
                        ->required()
                        ->fileAttachmentsDisk('public')
                        ->fileAttachmentsDirectory('images/articles'),
                ]),
            
            Forms\Components\Section::make('Multimedia')
                ->schema([
                    Forms\Components\TextInput::make('main_image')
                        ->label('Imagen Principal')
                        ->url()
                        ->columnSpanFull(),
                    Forms\Components\TextInput::make('video_url')
                        ->label('Video URL (YouTube/Vimeo)')
                        ->url(),
                    Forms\Components\KeyValue::make('embedded_images')
                        ->label('Imágenes Embedidas'),
                ])->collapsible(),
            
            Forms\Components\Section::make('Publicación')
                ->schema([
                    Forms\Components\Toggle::make('is_published')
                        ->default(false)
                        ->label('Publicado'),
                    Forms\Components\DateTimePicker::make('published_at')
                        ->label('Fecha de publicación'),
                    Forms\Components\TextInput::make('read_time')
                        ->numeric()
                        ->suffix('minutos'),
                ])->columns(3),
        ]);
}
```

### 2.4 Agregar relación articles_count al Author

```bash
# Agregar método articlesCount en Author.php
public function getArticlesCountAttribute()
{
    return $this->articles()->count();
}
```

### 2.5 Configurar el ListPage y EditPage

Los recursos generados automáticamente crean páginas de lista y edición. Verificar que todo funcione correctamente.

### 2.6 Registrar recursos en el provider

Los recursos se descubren automáticamente con `discoverResources`. Verificar en `AdminPanelProvider.php`:

```php
->discoverResources(in: app_path('Filament/Resources'), for: 'App\\Filament\\Resources')
```

---

## Verificación

- [ ] Tag Resource funcionando
- [ ] Author Resource funcionando
- [ ] Article Resource con editor Tiptap
- [ ] CRUD completo funcionando

---

## Siguiente Paso
Ver [15-filament-resources-advanced.md](./15-filament-resources-advanced.md) para recursos adicionales.
