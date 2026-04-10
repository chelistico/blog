# Workitem: 07-authentication

## Fase 7: Sistema de Autenticación

### Objetivo
Implementar autenticación con Laravel Sanctum para el panel de administración.

---

## Tasks

### 7.1 Configurar Sanctum
```bash
php artisan install:api
```

### 7.2 Crear Modelo User
```php
// app/Models/User.php

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    
    protected $fillable = [
        'name', 'email', 'password', 'role'
    ];
    
    protected $hidden = [
        'password', 'remember_token',
    ];
    
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
    
    public function isAdmin(): bool
    {
        return $this->role === 'admin';
    }
    
    public function isEditor(): bool
    {
        return in_array($this->role, ['admin', 'editor']);
    }
}
```

### 7.3 Migración para Users
```php
// database/migrations/xxxx_add_role_to_users_table.php

Schema::table('users', function (Blueprint $table) {
    $table->enum('role', ['admin', 'editor', 'author'])->default('author')->after('email');
});
```

### 7.4 Crear AuthController
```php
// app/Http/Controllers/Api/AuthController.php

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users',
            'password' => 'required|min:8|confirmed',
        ]);
        
        $user = User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'password' => $validated['password'],
            'role' => 'author'
        ]);
        
        $token = $user->createToken('auth_token')->plainTextToken;
        
        return response()->json([
            'success' => true,
            'data' => [
                'user' => new UserResource($user),
                'token' => $token
            ]
        ], 201);
    }
    
    public function login(Request $request)
    {
        $validated = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);
        
        if (!Auth::attempt($validated)) {
            return response()->json([
                'success' => false,
                'error' => ['code' => 'INVALID_CREDENTIALS', 'message' => 'Credenciales inválidas']
            ], 401);
        }
        
        $user = Auth::user();
        $token = $user->createToken('auth_token')->plainTextToken;
        
        return response()->json([
            'success' => true,
            'data' => [
                'user' => new UserResource($user),
                'token' => $token
            ]
        ]);
    }
    
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Sesión cerrada'
        ]);
    }
    
    public function me(Request $request)
    {
        return response()->json([
            'success' => true,
            'data' => new UserResource($request->user())
        ]);
    }
}
```

### 7.5 UserResource
```php
// app/Http/Resources/UserResource.php

class UserResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'role' => $this->role,
            'created_at' => $this->created_at->toIso8601String(),
        ];
    }
}
```

### 7.6 Agregar Rutas de Autenticación
```php
// routes/api.php

Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
    
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);
    });
});
```

### 7.7 Middleware para Admin
```php
// app/Http/Middleware/EnsureUserIsAdmin.php

class EnsureUserIsAdmin
{
    public function handle(Request $request, Closure $next)
    {
        if (!$request->user() || !$request->user()->isAdmin()) {
            return response()->json([
                'success' => false,
                'error' => ['code' => 'FORBIDDEN', 'message' => 'Acceso denegado']
            ], 403);
        }
        
        return $next($request);
    }
}
```

### 7.8 Registrar Middleware
```php
// bootstrap/app.php o Kernel.php

$middleware->alias([
    'admin' => \App\Http\Middleware\EnsureUserIsAdmin::class,
]);
```

---

## Rutas de Autenticación

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | /api/auth/register | Registro |
| POST | /api/auth/login | Login |
| POST | /api/auth/logout | Logout |
| GET | /api/auth/me | Usuario actual |

---

## Roles de Usuario

| Rol | Permisos |
|-----|----------|
| admin | Todo |
| editor | CRUD artículos, gestión de tags |
| author | Crear/editar propios artículos |

---

## Verificación
- [ ] Sanctum instalado
- [ ] AuthController creado
- [ ] Rutas de auth funcionando
- [ ] Middleware de admin creado
- [ ] Probar login/logout con Postman

---

## Siguiente Paso
Ver [08-content-management.md](./08-content-management.md) para la gestión de contenido (CRUD completo).
