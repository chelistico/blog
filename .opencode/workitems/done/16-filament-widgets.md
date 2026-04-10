# Workitem: 16-filament-widgets

## Fase 4: Dashboard y Widgets

### Objetivo
Crear un dashboard con estadísticas y widgets útiles para el panel admin.

---

## Tasks

### 4.1 Widget: StatsOverview

Reemplazar el widget por defecto con estadísticas del blog:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-widget StatsOverview --panels
```

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Article;
use App\Models\Author;
use App\Models\Tag;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverviewWidget extends BaseWidget
{
    protected function getStats(): array
    {
        $totalArticles = Article::count();
        $publishedArticles = Article::where('is_published', true)->count();
        $totalAuthors = Author::count();
        $totalTags = Tag::count();
        $totalViews = Article::sum('views');
        
        return [
            Stat::make('Artículos Totales', $totalArticles)
                ->description('Total en el sistema')
                ->descriptionIcon('heroicon-m-document-text')
                ->color('info'),
            
            Stat::make('Artículos Publicados', $publishedArticles)
                ->description('Visibles en el frontend')
                ->descriptionIcon('heroicon-m-check-circle')
                ->color('success'),
            
            Stat::make('Autores', $totalAuthors)
                ->description('Colaboradores activos')
                ->descriptionIcon('heroicon-m-user-group')
                ->color('warning'),
            
            Stat::make('Tags', $totalTags)
                ->description('Categorías disponibles')
                ->descriptionIcon('heroicon-m-tag')
                ->color('primary'),
            
            Stat::make('Vistas Totales', number_format($totalViews))
                ->description('En todos los artículos')
                ->descriptionIcon('heroicon-m-eye')
                ->color('gray'),
        ];
    }
}
```

### 4.2 Widget: LatestArticles

Mostrar los últimos artículos publicados:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-widget LatestArticles --panels
```

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Article;
use Filament\Tables;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;

class LatestArticlesWidget extends BaseWidget
{
    protected int | string | array $columnSpan = 'full';
    
    protected function getTableColumns(): array
    {
        return [
            Tables\Columns\TextColumn::make('title')
                ->searchable()
                ->limit(40),
            Tables\Columns\TextColumn::make('author.name'),
            Tables\Columns\IconColumn::make('is_published')
                ->boolean()
                ->label('Publicado'),
            Tables\Columns\TextColumn::make('views')
                ->numeric(),
            Tables\Columns\TextColumn::make('published_at')
                ->dateTime(),
        ];
    }
    
    protected function getTableQuery(): \Illuminate\Database\Eloquent\Builder
    {
        return Article::query()
            ->with('author')
            ->latest()
            ->limit(10);
    }
}
```

### 4.3 Widget: PopularArticlesChart

Gráfico de artículos más populares:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-widget PopularArticlesChart --panels --chart
```

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Article;
use Filament\Widgets\ChartWidget;

class PopularArticlesChart extends ChartWidget
{
    protected int | string | array $columnSpan = 6;
    
    protected function getData(): array
    {
        $articles = Article::orderByDesc('views')
            ->limit(5)
            ->get();
        
        return [
            'datasets' => [
                [
                    'label' => 'Vistas',
                    'data' => $articles->pluck('views')->toArray(),
                    'backgroundColor' => [
                        '#f59e0b',
                        '#3b82f6',
                        '#10b981',
                        '#6366f1',
                        '#ec4899',
                    ],
                ],
            ],
            'labels' => $articles->pluck('title')->map(fn ($t) => substr($t, 0, 20) . '...')->toArray(),
        ];
    }
    
    protected function getType(): string
    {
        return 'bar';
    }
}
```

### 4.4 Widget: ArticlesByStatus

Widget circular:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-widget ArticlesByStatus --panels --chart
```

```php
<?php

namespace App\Filament\Widgets;

use App\Models\Article;
use Filament\Widgets\ChartWidget;

class ArticlesByStatusChart extends ChartWidget
{
    protected int | string | array $columnSpan = 6;
    
    protected function getData(): array
    {
        $published = Article::where('is_published', true)->count();
        $drafts = Article::where('is_published', false)->count();
        
        return [
            'datasets' => [
                [
                    'data' => [$published, $drafts],
                    'backgroundColor' => ['#10b981', '#f59e0b'],
                ],
            ],
            'labels' => ['Publicados', 'Borradores'],
        ];
    }
    
    protected function getType(): string
    {
        return 'doughnut';
    }
}
```

### 4.5 Configurar widgets en el panel

En `AdminPanelProvider.php`:

```php
public function panel(Panel $panel): Panel
{
    return $panel
        // ...
        ->widgets([
            Widgets\FilamentAccountWidget::class,
            Widgets\StatsOverviewWidget::class,
            Widgets\LatestArticlesWidget::class,
            Widgets\PopularArticlesChart::class,
            Widgets\ArticlesByStatusChart::class,
        ]);
}
```

### 4.6 Personalizar el header del dashboard

Crear una página de dashboard custom:

```bash
docker exec -w /var/www/html/blog/backend docker_php84 php artisan make:filament-page Dashboard --resource=File
```

Modificar `app/Filament/Pages/Dashboard.php`:

```php
<?php

namespace App\Filament\Pages;

use Filament\Pages\Page;

class Dashboard extends Page
{
    protected static ?string $navigationIcon = 'heroicon-m-squares-2x2';
    
    protected static string $view = 'filament.pages.dashboard';
}
```

Crear la vista en `resources/views/filament/pages/dashboard.blade.php`.

---

## Verificación

- [ ] StatsOverviewWidget mostrando estadísticas
- [ ] LatestArticlesWidget con últimos artículos
- [ ] Gráficos funcionando
- [ ] Dashboard completo

---

## Siguiente Paso
Ver [17-filament-customization.md](./17-filament-customization.md) para personalización visual.
