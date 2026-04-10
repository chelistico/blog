# Workitem: 02-models-migrations

## Fase 2: Modelos y Migraciones

### Objetivo
Crear todos los modelos Eloquent y sus migraciones correspondientes.

---

## Tasks

### 2.1 Migración: Authors
```php
// database/migrations/xxxx_create_authors_table.php
Schema::create('authors', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->string('slug')->unique();
    $table->string('avatar')->nullable();
    $table->text('bio')->nullable();
    $table->string('email')->unique();
    $table->json('social_links')->nullable(); // {twitter, linkedin, github, website}
    $table->boolean('is_active')->default(true);
    $table->timestamps();
});
```

### 2.2 Migración: Tags
```php
// database/migrations/xxxx_create_tags_table.php
Schema::create('tags', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->string('slug')->unique();
    $table->string('description')->nullable();
    $table->timestamps();
});
```

### 2.3 Migración: Articles
```php
// database/migrations/xxxx_create_articles_table.php
Schema::create('articles', function (Blueprint $table) {
    $table->id();
    $table->string('title');
    $table->string('slug')->unique();
    $table->text('summary'); // Subtitle/description corta
    $table->longText('content'); // HTML con código soportado
    $table->string('main_image')->nullable();
    $table->json('embedded_images')->nullable(); // Array de URLs
    $table->string('video_url')->nullable();
    $table->foreignId('author_id')->constrained()->onDelete('cascade');
    $table->dateTime('published_at')->nullable();
    $table->unsignedTinyInteger('read_time')->default(5); // minutos
    $table->unsignedBigInteger('views')->default(0);
    $table->boolean('is_published')->default(false);
    $table->timestamps();
    
    $table->index(['is_published', 'published_at']);
    $table->index('slug');
});
```

### 2.4 Migración: Article_Tag (Pivot)
```php
// database/migrations/xxxx_create_article_tag_table.php
Schema::create('article_tag', function (Blueprint $table) {
    $table->foreignId('article_id')->constrained()->onDelete('cascade');
    $table->foreignId('tag_id')->constrained()->onDelete('cascade');
    $table->primary(['article_id', 'tag_id']);
});
```

### 2.5 Migración: SiteSettings
```php
// database/migrations/xxxx_create_site_settings_table.php
Schema::create('site_settings', function (Blueprint $table) {
    $table->id();
    $table->string('key')->unique();
    $table->text('value')->nullable();
    $table->enum('type', ['text', 'textarea', 'image', 'json', 'boolean'])->default('text');
    $table->string('group'); // branding, seo, social, general
    $table->string('description')->nullable();
    $table->timestamps();
});
```

### 2.6 Migración: Advertisements
```php
// database/migrations/xxxx_create_advertisements_table.php
Schema::create('advertisements', function (Blueprint $table) {
    $table->id();
    $table->string('name');
    $table->enum('position', ['top', 'sidebar', 'inline', 'bottom', 'mobile']);
    $table->string('image')->nullable();
    $table->string('link')->nullable();
    $table->longText('code')->nullable(); // Custom HTML (Google AdSense)
    $table->string('dimensions')->nullable(); // ej: "728x90"
    $table->boolean('is_active')->default(true);
    $table->dateTime('start_date')->nullable();
    $table->dateTime('end_date')->nullable();
    $table->integer('order')->default(0);
    $table->timestamps();
});
```

### 2.7 Migración: Footer
```php
// database/migrations/xxxx_create_footer_items_table.php
Schema::create('footer_items', function (Blueprint $table) {
    $table->id();
    $table->string('section'); // ej: "categories", "legal", "social"
    $table->string('title');
    $table->text('content')->nullable();
    $table->string('link_url')->nullable();
    $table->integer('order')->default(0);
    $table->boolean('is_active')->default(true);
    $table->timestamps();
});
```

### 2.8 Modelos Eloquent

#### Author.php
```php
class Author extends Model
{
    protected $fillable = ['name', 'slug', 'avatar', 'bio', 'email', 'social_links', 'is_active'];
    protected $casts = ['social_links' => 'array'];
    
    public function articles(): HasMany
    {
        return $this->hasMany(Article::class);
    }
    
    // Sluggable
    public function getRouteKeyName(): string { return 'slug'; }
}
```

#### Tag.php
```php
class Tag extends Model
{
    protected $fillable = ['name', 'slug', 'description'];
    
    public function articles(): BelongsToMany
    {
        return $this->belongsToMany(Article::class);
    }
    
    public function getRouteKeyName(): string { return 'slug'; }
}
```

#### Article.php
```php
class Article extends Model
{
    protected $fillable = [
        'title', 'slug', 'summary', 'content', 'main_image', 
        'embedded_images', 'video_url', 'author_id', 'published_at',
        'read_time', 'views', 'is_published'
    ];
    protected $casts = ['embedded_images' => 'array', 'published_at' => 'datetime'];
    
    public function author(): BelongsTo { return $this->belongsTo(Author::class); }
    public function tags(): BelongsToMany { return $this->belongsToMany(Tag::class); }
    
    public function scopePublished($query) { return $query->where('is_published', true); }
    public function scopeScheduled($query) { return $query->where('published_at', '>', now()); }
}
```

#### SiteSetting.php
```php
class SiteSetting extends Model
{
    protected $fillable = ['key', 'value', 'type', 'group', 'description'];
    
    public static function getValue(string $key, $default = null)
    {
        return static::where('key', $key)->value('value') ?? $default;
    }
}
```

#### Advertisement.php
```php
class Advertisement extends Model
{
    protected $fillable = [
        'name', 'position', 'image', 'link', 'code', 
        'dimensions', 'is_active', 'start_date', 'end_date', 'order'
    ];
    protected $casts = ['start_date' => 'datetime', 'end_date' => 'datetime'];
    
    public function scopeActive($query)
    {
        return $query->where('is_active', true)
            ->where(function ($q) {
                $q->whereNull('start_date')->orWhere('start_date', '<=', now());
            })
            ->where(function ($q) {
                $q->whereNull('end_date')->orWhere('end_date', '>=', now());
            });
    }
}
```

#### FooterItem.php
```php
class FooterItem extends Model
{
    protected $fillable = ['section', 'title', 'content', 'link_url', 'order', 'is_active'];
    
    public function scopeActive($query) { return $query->where('is_active', true); }
}
```

---

## Seeders Necesarios
Crear seeder para SiteSettings con valores por defecto:
- site_name: "TechDaily"
- site_title: "TechDaily - Noticias de Tecnología"
- favicon: "/images/default-favicon.ico"
- logo: "/images/logo.png"
- seo_description: "Tu fuente diaria de noticias sobre tecnología..."
- social_links: JSON con redes sociales

---

## Verificación
- [ ] Migraciones creadas y ejecutadas
- [ ] Modelos creados con relaciones
- [ ] Seeders ejecutados
- [ ] Verificar en DB: `php artisan migrate:status`

---

## Siguiente Paso
Ver [03-api-controllers.md](./03-api-controllers.md) para crear los controladores API.
