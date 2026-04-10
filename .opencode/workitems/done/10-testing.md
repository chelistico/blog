# Workitem: 10-testing

## Fase 10: Testing

### Objetivo
Crear tests para asegurar el correcto funcionamiento del backend.

---

## Tasks

### 10.1 Configurar PHPUnit
```bash
php artisan test
```

### 10.2 Tests de Feature - Articles

```php
// tests/Feature/ArticleApiTest.php

class ArticleApiTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_can_list_published_articles(): void
    {
        Article::factory()->count(3)->create(['is_published' => true]);
        Article::factory()->create(['is_published' => false]);
        
        $response = $this->getJson('/api/articles');
        
        $response->assertStatus(200)
            ->assertJsonStructure([
                'success',
                'data' => [
                    'data' => [
                        '*' => ['id', 'title', 'slug', 'summary', 'author', 'tags']
                    ],
                    'pagination' => ['current_page', 'last_page', 'per_page', 'total']
                ]
            ])
            ->assertJsonCount(3, 'data.data');
    }
    
    public function test_can_show_single_article(): void
    {
        $article = Article::factory()->create([
            'is_published' => true,
            'title' => 'Test Article'
        ]);
        
        $response = $this->getJson("/api/articles/{$article->slug}");
        
        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Test Article')
            ->assertJsonPath('data.slug', $article->slug);
    }
    
    public function test_increments_views_on_show(): void
    {
        $article = Article::factory()->create(['is_published' => true, 'views' => 10]);
        
        $this->getJson("/api/articles/{$article->slug}");
        
        $this->assertEquals(11, $article->fresh()->views);
    }
    
    public function test_can_search_articles(): void
    {
        Article::factory()->create(['title' => 'Laravel Tutorial', 'is_published' => true]);
        Article::factory()->create(['title' => 'React Guide', 'is_published' => true]);
        
        $response = $this->getJson('/api/articles/search?q=Laravel');
        
        $response->assertStatus(200)
            ->assertJsonCount(1, 'data.data')
            ->assertJsonPath('data.data.0.title', 'Laravel Tutorial');
    }
    
    public function test_can_filter_articles_by_tag(): void
    {
        $tag = Tag::factory()->create(['slug' => 'php']);
        $article1 = Article::factory()->create(['is_published' => true]);
        $article2 = Article::factory()->create(['is_published' => true]);
        
        $article1->tags()->attach($tag);
        
        $response = $this->getJson('/api/articles/by-tag/php');
        
        $response->assertStatus(200)
            ->assertJsonCount(1, 'data.data');
    }
    
    public function test_draft_articles_not_visible(): void
    {
        $article = Article::factory()->create(['is_published' => false]);
        
        $response = $this->getJson("/api/articles/{$article->slug}");
        
        $response->assertStatus(404);
    }
}
```

### 10.3 Tests de Feature - Admin Articles

```php
// tests/Feature/AdminArticleTest.php

class AdminArticleTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_admin_can_create_article(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $author = Author::factory()->create();
        $tag = Tag::factory()->create();
        
        $response = $this->actingAs($admin)->postJson('/api/admin/articles', [
            'title' => 'New Article',
            'summary' => 'Article summary',
            'content' => '<p>Content here</p>',
            'author_id' => $author->id,
            'tags' => [$tag->id],
            'is_published' => true,
        ]);
        
        $response->assertStatus(201)
            ->assertJsonPath('data.title', 'New Article')
            ->assertJsonPath('data.slug', 'new-article');
        
        $this->assertDatabaseHas('articles', ['title' => 'New Article']);
    }
    
    public function test_non_admin_cannot_access_admin_routes(): void
    {
        $user = User::factory()->create(['role' => 'author']);
        
        $response = $this->actingAs($user)->getJson('/api/admin/articles');
        
        $response->assertStatus(403);
    }
    
    public function test_can_update_article(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $article = Article::factory()->create();
        
        $response = $this->actingAs($admin)->putJson("/api/admin/articles/{$article->id}", [
            'title' => 'Updated Title',
            'summary' => $article->summary,
            'content' => $article->content,
        ]);
        
        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Updated Title');
    }
    
    public function test_can_delete_article(): void
    {
        $admin = User::factory()->create(['role' => 'admin']);
        $article = Article::factory()->create();
        
        $response = $this->actingAs($admin)->deleteJson("/api/admin/articles/{$article->id}");
        
        $response->assertStatus(200);
        $this->assertDatabaseMissing('articles', ['id' => $article->id]);
    }
}
```

### 10.4 Tests de Feature - Authentication

```php
// tests/Feature/AuthTest.php

class AuthTest extends TestCase
{
    use RefreshDatabase;
    
    public function test_user_can_register(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);
        
        $response->assertStatus(201)
            ->assertJsonStructure([
                'success',
                'data' => ['user', 'token']
            ]);
        
        $this->assertDatabaseHas('users', ['email' => 'test@example.com']);
    }
    
    public function test_user_can_login(): void
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => bcrypt('password123'),
        ]);
        
        $response = $this->postJson('/api/auth/login', [
            'email' => 'test@example.com',
            'password' => 'password123',
        ]);
        
        $response->assertStatus(200)
            ->assertJsonStructure(['success', 'data' => ['user', 'token']]);
    }
    
    public function test_invalid_login_returns_401(): void
    {
        $response = $this->postJson('/api/auth/login', [
            'email' => 'wrong@example.com',
            'password' => 'wrongpassword',
        ]);
        
        $response->assertStatus(401);
    }
    
    public function test_authenticated_user_can_logout(): void
    {
        $user = User::factory()->create();
        
        $response = $this->actingAs($user)->postJson('/api/auth/logout');
        
        $response->assertStatus(200);
    }
}
```

### 10.5 Tests de Unit

```php
// tests/Unit/AdvertisementTest.php

class AdvertisementTest extends TestCase
{
    public function test_active_scope_excludes_inactive(): void
    {
        Advertisement::factory()->create(['is_active' => true]);
        Advertisement::factory()->create(['is_active' => false]);
        
        $this->assertEquals(1, Advertisement::active()->count());
    }
    
    public function test_active_scope_excludes_expired(): void
    {
        Advertisement::factory()->create([
            'is_active' => true,
            'end_date' => now()->subDay(),
        ]);
        
        Advertisement::factory()->create([
            'is_active' => true,
            'end_date' => now()->addDay(),
        ]);
        
        $this->assertEquals(1, Advertisement::active()->count());
    }
}

// tests/Unit/ArticleReadTimeTest.php

class ArticleReadTimeTest extends TestCase
{
    public function test_calculates_read_time_correctly(): void
    {
        $article = new Article([
            'content' => str_repeat('<p>Palabra uno dos tres cuatro cinco.</p>', 100)
        ]);
        
        $readTime = calculateReadTime($article->content);
        
        $this->assertGreaterThanOrEqual(5, $readTime);
    }
}
```

### 10.6 Model Factories

```php
// database/factories/ArticleFactory.php

class ArticleFactory extends Factory
{
    public function definition(): array
    {
        return [
            'title' => fake()->sentence(),
            'slug' => fake()->unique()->slug(),
            'summary' => fake()->paragraph(),
            'content' => '<p>' . fake()->paragraphs(5, true) . '</p>',
            'main_image' => fake()->imageUrl(1200, 630),
            'embedded_images' => [fake()->imageUrl(800, 600)],
            'video_url' => null,
            'author_id' => Author::factory(),
            'published_at' => fake()->dateTimeBetween('-1 year', 'now'),
            'read_time' => fake()->numberBetween(3, 20),
            'views' => fake()->numberBetween(0, 10000),
            'is_published' => true,
        ];
    }
    
    public function draft(): static
    {
        return $this->state(fn(array $attributes) => [
            'is_published' => false,
            'published_at' => null,
        ]);
    }
}
```

### 10.7 Coverage Script

```bash
# scripts/test-coverage.sh
#!/bin/bash

php artisan test --coverage-html coverage-report

# Para ver en terminal
php artisan test --coverage-text
```

---

## Verificación
- [ ] Tests de Articles API
- [ ] Tests de Admin Articles
- [ ] Tests de Authentication
- [ ] Tests de Unit (Advertisement, etc)
- [ ] Factories creadas
- [ ] Coverage script funcional

---

## Siguiente Paso
Ver [11-deployment-checklist.md](./11-deployment-checklist.md) para la checklist de deployment.
