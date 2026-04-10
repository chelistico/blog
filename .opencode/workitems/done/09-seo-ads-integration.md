# Workitem: 09-seo-ads-integration

## Fase 9: SEO y Configuración de Publicidades

### Objetivo
Implementar funcionalidades avanzadas de SEO y sistema de publicidades configurable.

---

## Tasks

### 9.1 SiteSettings - Configuraciones de SEO

#### Seed de Configuraciones SEO
```php
// database/seeders/SiteSettingSeeder.php

public function run()
{
    $settings = [
        // Branding
        ['key' => 'site_name', 'value' => 'TechDaily', 'type' => 'text', 'group' => 'branding', 'description' => 'Nombre del sitio'],
        ['key' => 'site_title', 'value' => 'TechDaily - Noticias de Tecnología', 'type' => 'text', 'group' => 'branding', 'description' => 'Título completo'],
        ['key' => 'logo', 'value' => null, 'type' => 'image', 'group' => 'branding', 'description' => 'Logo principal'],
        ['key' => 'logo_light', 'value' => null, 'type' => 'image', 'group' => 'branding', 'description' => 'Logo versión clara'],
        ['key' => 'favicon', 'value' => null, 'type' => 'image', 'group' => 'branding', 'description' => 'Favicon'],
        
        // SEO
        ['key' => 'seo_title', 'value' => null, 'type' => 'text', 'group' => 'seo', 'description' => 'Título SEO (meta title)'],
        ['key' => 'seo_description', 'value' => 'Tu fuente diaria de noticias sobre tecnología, programación y desarrollo de sistemas.', 'type' => 'textarea', 'group' => 'seo', 'description' => 'Descripción meta'],
        ['key' => 'seo_keywords', 'value' => 'tecnología, programación, desarrollo, software, noticias tech', 'type' => 'text', 'group' => 'seo', 'description' => 'Palabras clave'],
        ['key' => 'og_image', 'value' => null, 'type' => 'image', 'group' => 'seo', 'description' => 'Imagen Open Graph por defecto'],
        
        // Social
        ['key' => 'social_twitter', 'value' => null, 'type' => 'text', 'group' => 'social', 'description' => 'Twitter/X'],
        ['key' => 'social_facebook', 'value' => null, 'type' => 'text', 'group' => 'social', 'description' => 'Facebook'],
        ['key' => 'social_linkedin', 'value' => null, 'type' => 'text', 'group' => 'social', 'description' => 'LinkedIn'],
        ['key' => 'social_github', 'value' => null, 'type' => 'text', 'group' => 'social', 'description' => 'GitHub'],
        
        // Analytics
        ['key' => 'analytics_google', 'value' => null, 'type' => 'text', 'group' => 'analytics', 'description' => 'Google Analytics ID'],
        ['key' => 'analytics_google_tag', 'value' => null, 'type' => 'text', 'group' => 'analytics', 'description' => 'Google Tag Manager ID'],
        
        // Ads
        ['key' => 'ads_adsense_client', 'value' => null, 'type' => 'text', 'group' => 'ads', 'description' => 'AdSense Client ID'],
        ['key' => 'ads_top_slot', 'value' => null, 'type' => 'text', 'group' => 'ads', 'description' => 'AdSense Slot - Banner Top'],
        ['key' => 'ads_sidebar_slot', 'value' => null, 'type' => 'text', 'group' => 'ads', 'description' => 'AdSense Slot - Sidebar'],
        ['key' => 'ads_inline_slot', 'value' => null, 'type' => 'text', 'group' => 'ads', 'description' => 'AdSense Slot - Inline'],
    ];
    
    foreach ($settings as $setting) {
        SiteSetting::updateOrCreate(['key' => $setting['key']], $setting);
    }
}
```

### 9.2 Helper para SEO
```php
// app/Helpers/SeoHelper.php

class SeoHelper
{
    public static function getMetaTags(string $page = 'home', ?Article $article = null): array
    {
        $settings = SiteSetting::all()->mapWithKeys(fn($s) => [$s->key => $s->value]);
        
        if ($article) {
            return [
                'title' => $article->title . ' | ' . $settings['site_name'],
                'description' => $article->summary,
                'keywords' => $article->tags->pluck('name')->implode(', '),
                'image' => $article->main_image,
                'url' => url("/article/{$article->slug}"),
                'type' => 'article',
                'article:published_time' => $article->published_at?->toIso8601String(),
                'article:author' => $article->author->name,
                'article:tag' => $article->tags->pluck('name')->toArray(),
            ];
        }
        
        return [
            'title' => $settings['seo_title'] ?? $settings['site_title'],
            'description' => $settings['seo_description'],
            'keywords' => $settings['seo_keywords'],
            'image' => $settings['og_image'] ?? null,
            'url' => url()->current(),
            'type' => 'website',
        ];
    }
    
    public static function generateStructuredData(string $type, $data = null): array
    {
        return match($type) {
            'article' => self::articleSchema($data),
            'website' => self::websiteSchema(),
            'organization' => self::organizationSchema(),
            default => []
        };
    }
    
    private static function organizationSchema(): array
    {
        $settings = SiteSetting::all()->mapWithKeys(fn($s) => [$s->key => $s->value]);
        
        return [
            '@context' => 'https://schema.org',
            '@type' => 'Organization',
            'name' => $settings['site_name'],
            'url' => config('app.url'),
            'logo' => $settings['logo'] ? url($settings['logo']) : null,
            'sameAs' => array_filter([
                $settings['social_twitter'],
                $settings['social_facebook'],
                $settings['social_linkedin'],
                $settings['social_github'],
            ])
        ];
    }
    
    private static function websiteSchema(): array
    {
        return [
            '@context' => 'https://schema.org',
            '@type' => 'WebSite',
            'name' => SiteSetting::getValue('site_name'),
            'url' => config('app.url'),
            'potentialAction' => [
                '@type' => 'SearchAction',
                'target' => url('/search?q={search_term_string}'),
                'query-input' => 'required name=search_term_string'
            ]
        ];
    }
    
    private static function articleSchema(Article $article): array
    {
        return [
            '@context' => 'https://schema.org',
            '@type' => 'Article',
            'headline' => $article->title,
            'description' => $article->summary,
            'image' => $article->main_image ? url($article->main_image) : null,
            'datePublished' => $article->published_at?->toIso8601String(),
            'dateModified' => $article->updated_at->toIso8601String(),
            'author' => [
                '@type' => 'Person',
                'name' => $article->author->name
            ],
            'publisher' => [
                '@type' => 'Organization',
                'name' => SiteSetting::getValue('site_name'),
                'logo' => [
                    '@type' => 'ImageObject',
                    'url' => SiteSetting::getValue('logo') ? url(SiteSetting::getValue('logo')) : null
                ]
            ],
            'mainEntityOfPage' => [
                '@type' => 'WebPage',
                '@id' => url("/article/{$article->slug}")
            ]
        ];
    }
}
```

### 9.3 Sistema de Publicidades

#### Advertisement Model - Métodos Adicionales
```php
// app/Models/Advertisement.php

public function toAdSenseArray(): array
{
    if (!$this->code) {
        return [
            'type' => 'image',
            'image' => $this->image,
            'link' => $this->link,
            'dimensions' => $this->dimensions,
        ];
    }
    
    return [
        'type' => 'code',
        'code' => $this->code,
        'dimensions' => $this->dimensions,
    ];
}
```

#### AdvertisementService
```php
// app/Services/AdvertisementService.php

class AdvertisementService
{
    public function getActiveByPosition(string $position): Collection
    {
        return Advertisement::active()
            ->where('position', $position)
            ->orderBy('order')
            ->get();
    }
    
    public function getForPage(string $page): array
    {
        $positions = match($page) {
            'article' => ['top', 'inline', 'sidebar', 'bottom'],
            'home' => ['top', 'sidebar'],
            default => ['top']
        };
        
        $ads = [];
        foreach ($positions as $position) {
            $ads[$position] = $this->getActiveByPosition($position);
        }
        
        return $ads;
    }
    
    public function generateAdSenseCode(string $slot, array $dimensions): string
    {
        $client = SiteSetting::getValue('ads_adsense_client');
        
        if (!$client) {
            return '';
        }
        
        $style = "display: block";
        
        return <<<HTML
<ins class="adsbygoogle"
     style="{$style}"
     data-ad-client="{$client}"
     data-ad-slot="{$slot}"
     data-ad-format="auto"
     data-full-width-responsive="true">
</ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>
HTML;
    }
}
```

### 9.4 Endpoints de Analytics

```php
// app/Http/Controllers/Api/AnalyticsController.php

class AnalyticsController extends Controller
{
    public function trackView(Request $request)
    {
        $request->validate([
            'type' => 'required|in:pageview,article_view,search,tag_click',
            'data' => 'nullable|array',
        ]);
        
        // Registrar en analytics (puede ser propio, GA4, etc.)
        $data = $request->data ?? [];
        $data['timestamp'] = now()->toIso8601String();
        $data['ip'] = $request->ip();
        $data['user_agent'] = $request->userAgent();
        
        // Para demo, solo incrementar contador
        if ($request->type === 'article_view' && isset($data['article_id'])) {
            Article::where('id', $data['article_id'])->increment('views');
        }
        
        return response()->json(['success' => true]);
    }
    
    public function dashboard(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => [
                'total_articles' => Article::count(),
                'published_articles' => Article::where('is_published', true)->count(),
                'total_views' => Article::sum('views'),
                'total_authors' => Author::count(),
                'total_tags' => Tag::count(),
                'recent_articles' => Article::with('author')
                    ->orderByDesc('created_at')
                    ->limit(5)
                    ->get(),
                'popular_articles' => Article::with('author')
                    ->orderByDesc('views')
                    ->limit(5)
                    ->get(),
            ]
        ]);
    }
}
```

### 9.5 Agregar Rutas de Analytics
```php
// routes/api.php

Route::post('/analytics/track', [AnalyticsController::class, 'trackView']);

// Admin routes
Route::middleware(['auth:sanctum', 'admin'])->group(function () {
    Route::get('/admin/analytics/dashboard', [AnalyticsController::class, 'dashboard']);
});
```

---

## Verificación
- [ ] SiteSettings con valores de SEO
- [ ] SeoHelper funcionando
- [ ] Structured data generándose correctamente
- [ ] AdvertisementService implementado
- [ ] Endpoint de tracking de analytics
- [ ] Dashboard de analytics en admin

---

## Siguiente Paso
Ver [10-testing.md](./10-testing.md) para la fase de testing.
