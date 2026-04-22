# 🔬 REFERENCIA TÉCNICA: HTTP 403 en Livewire

**Documento:** Análisis técnico profundo para developers  
**Audiencia:** Backend developers, DevOps, Architects  
**Nivel:** ⭐⭐⭐ Intermedio-Avanzado

---

## 📖 Tabla de Contenidos

1. [Causas Técnicas](#causas-técnicas)
2. [Flujo de Request Livewire](#flujo-de-request)
3. [CSRF Token en Livewire](#csrf-en-livewire)
4. [Configuración de Sesiones](#configuración-sesiones)
5. [Debug Avanzado](#debug-avanzado)
6. [Soluciones por Escenario](#soluciones-escenario)

---

## 🔍 Causas Técnicas

### 1. Session Domain Mismatch

**Problema:**
```
.env.production:
SESSION_DOMAIN=.chelistico.ar

Request A: https://chelistico.ar/admin
→ Cookie domain: .chelistico.ar ✅ MATCH

Request B: https://api.chelistico.ar/admin
→ Cookie domain: .chelistico.ar ⚠️ Wildcard cookie
→ Pero verificación CSRF: Domain específico api.chelistico.ar ❌ MISMATCH
```

**Root Cause:**
- Laravel session cookie con dominio wildcard `.chelistico.ar`
- Pero Livewire verifica origen exacto: `api.chelistico.ar`
- Middleware `PreventRequestForgery` rechaza

**Technical Flow:**
```php
// En PreventRequestForgery middleware:
if ($request->getHost() !== config('session.domain')) {
    // Domain no coincide exactamente
    throw new TokenMismatchException();
}
```

---

### 2. Same-Site Cookie Restrictions

**RFC 6265bis-05: SameSite Cookie Attribute**

```
Same-Site Cookie modes:

- Strict:  Cookie SOLO si same-site request
           Sub-domain request? ❌ Rechazado
           
- Lax:     Cookie si GET same-site
           POST cross-site? ⚠️ Riesgo según navegador
           
- None:    Cookie siempre (requiere Secure)
           ⚠️ Requiere HTTPS y flag Secure=true
```

**En nuestro proyecto:**
```env
SESSION_SAME_SITE=lax
SESSION_SECURE_COOKIE=true
```

**Problema potencial:**
- SameSite=lax + HTTPS/3
- Algunos navegadores (Chrome 119+) pueden ser más restrictivos
- Especialmente en subdominios

**Solución:**
```env
SESSION_SAME_SITE=none
SESSION_SECURE_COOKIE=true  # ← Obligatorio con SameSite=none
```

---

### 3. CSRF Token State Management

**Token Flow en Livewire:**

```
Step 1: Frontend Request
POST /livewire/update
Headers: {
    "X-CSRF-Token": "eyJpdiI6IjJjbzBb...",
    "X-Requested-With": "XMLHttpRequest"
}
Body: {
    "components": {...},
    "serverMemo": {...}
}

Step 2: Backend Validation
→ Middleware PreventRequestForgery::class
→ Método: request()->validate(csrf_token)
→ Obtiene token de: header OR body
→ Compara con: session token

Step 3: Resultado
✅ Match → Procesa request
❌ Mismatch → HTTP 403 Forbidden
```

**Dónde vive el token CSRF en sesión:**
```
session['_token'] = 'eyJpdiI6IjJjbzBb...'  // Generado en StartSession
```

**Dónde el frontend obtiene el token:**
```html
<!-- En blade/HTML -->
<meta name="csrf-token" content="{{ csrf_token() }}">

<!-- En Livewire componentes -->
@livewire('component-name')
→ Livewire.js obtiene token de meta tag
→ Incluye en cada request
```

---

## 🔄 Flujo de Request Livewire

### Flujo Normal (Funciona ✅)

```
1. GET /admin/articles/create
   ├─ Middleware: StartSession → Crea session
   ├─ Middleware: DispatchServingFilamentEvent
   ├─ CreateArticle Component renderizado
   ├─ Session contiene: _token=abc123
   └─ Response: HTML con <meta csrf-token="abc123">

2. Usuario completa form y hace submit

3. POST /livewire/update
   ├─ Headers: X-CSRF-Token=abc123
   ├─ Cookie: techdaily-session=xyz789
   ├─ Middleware: PreventRequestForgery
   │  ├─ Obtiene token de X-CSRF-Token header
   │  ├─ Obtiene session de cookie
   │  ├─ Compara: session['_token'] === header_token
   │  └─ ✅ Match → Permite pasar
   ├─ Livewire::handle() procesa request
   ├─ Filament::create() ejecuta
   ├─ Article guardada en BD
   └─ Response: 200 OK + updated component

4. GET /admin/articles
   ├─ Renderiza lista con nuevo artículo
   └─ ✅ Éxito total
```

### Flujo Con Error (Falla ❌)

```
1. GET /admin/articles/create
   ├─ Session domain: .chelistico.ar (wildcard)
   ├─ Request origin: api.chelistico.ar
   ├─ Cookie creamdo pero sin match exacto
   └─ Session['_token']: abc123 (guardado pero...)

2. Usuario completa form y hace submit

3. POST /livewire/update
   ├─ Headers: X-CSRF-Token=abc123
   ├─ Cookie: techdaily-session=xyz789
   │  └─ ⚠️ Domain: .chelistico.ar (no match exacto)
   ├─ Middleware: PreventRequestForgery
   │  ├─ Obtiene token de X-CSRF-Token header → abc123
   │  ├─ Obtiene session de cookie
   │  │  └─ ❌ Session no se carga correctamente
   │  │     (domain mismatch)
   │  ├─ Intenta: session['_token'] === header_token
   │  │  └─ ❌ No puede comparar (sin session token)
   │  └─ Lanza: TokenMismatchException
   ├─ Exception handler
   └─ Response: 403 Forbidden

4. Frontend recibe 403
   └─ ❌ Error: "El artículo no se creó"
```

---

## 🔐 CSRF en Livewire

### Cómo Livewire gestiona CSRF

**En JavaScript (livewire.js):**

```javascript
// Livewire obtiene token al inicializar
const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

// Cada request POST incluye:
fetch('/livewire/update', {
    method: 'POST',
    headers: {
        'X-CSRF-Token': csrfToken,
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({...})
});
```

**En Laravel (PreventRequestForgery middleware):**

```php
// Extrae token de múltiples fuentes
protected function tokensMatch($request)
{
    $token = $request->input('_token') ?: 
             $request->header('X-CSRF-TOKEN') ?:
             $request->header('X-CSRF-Token');

    return hash_equals(
        (string) $request->session()->token(),
        (string) $token
    );
}

// Llama session()->token() que obtiene de:
$request->session()->get('_token')
// que fue puesto en session en StartSession middleware
```

**En Filament:**

```php
// Filament automáticamente incluye token en forms
@livewire('create-article', [...])
// Livewire.js automáticamente obtiene y envía token
```

---

## ⚙️ Configuración de Sesiones

### SESSION_DOMAIN Explicado

```ini
# Tipo 1: Wildcard (múltiples subdominios)
SESSION_DOMAIN=.chelistico.ar
Valores válidos: ✅ chelistico.ar, ✅ api.chelistico.ar, ✅ www.chelistico.ar
Problema: No es estrictamente específico

# Tipo 2: Específico (un subdominio)
SESSION_DOMAIN=api.chelistico.ar
Valores válidos: ✅ api.chelistico.ar
Rechazados: ❌ chelistico.ar, ❌ www.chelistico.ar

# Tipo 3: Vacío (mismo dominio actual)
SESSION_DOMAIN=
Valores válidos: ✅ Solo el dominio actual
```

### SESSION_SAME_SITE Explicado

```ini
# Lax (Default)
SESSION_SAME_SITE=lax
- GET requests entre subdominios: ✅ Cookie se envía
- POST requests entre subdominios: ⚠️ Puede rechazarse según navegador
- Riesgo CSRF: Bajo-Medio

# Strict
SESSION_SAME_SITE=strict
- Cualquier cross-site request: ❌ Cookie NO se envía
- Riesgo CSRF: Muy bajo
- Pero puede romper funcionalidad cross-site

# None (Inseguro, requiere HTTPS)
SESSION_SAME_SITE=none
- Todos los requests: ✅ Cookie se envía
- Requiere: HTTPS + Secure flag
- Riesgo CSRF: Alto (pero mitigado por CSRF token)
```

---

## 🐛 Debug Avanzado

### 1. Inspect Session Storage

**En servidor:**

```php
// app/Http/Controllers/DebugController.php
public function sessionDebug()
{
    dd([
        'session_driver' => config('session.driver'),
        'session_domain' => config('session.domain'),
        'session_path' => config('session.path'),
        'session_lifetime' => config('session.lifetime'),
        'csrf_token' => request()->session()->token(),
        'session_id' => request()->session()->getId(),
        'session_data' => request()->session()->all(),
    ]);
}
```

**En BD:**

```sql
SELECT * FROM sessions WHERE user_id = 1;
```

**Output esperado:**

```
id: abc123def456
user_id: 1
ip_address: 203.0.113.45
user_agent: Mozilla/5.0...
payload: serialized_session_data (incluye _token)
last_activity: 1713696000
```

---

### 2. Inspect CSRF Token

**En navegador (Console):**

```javascript
// Obtener token
document.querySelector('meta[name="csrf-token"]').content

// Verificar que se envía
fetch('/livewire/update', {...}).then(r => {
    console.log('Request Headers:', r.request.headers);
    console.log('Response Status:', r.status);
});
```

**En servidor (Log):**

```php
// En PreventRequestForgery o custom middleware
Log::debug('CSRF Debug', [
    'expected_token' => request()->session()->token(),
    'received_token' => request()->header('X-CSRF-Token'),
    'tokens_match' => hash_equals(...),
    'request_origin' => request()->getHost(),
    'session_domain' => config('session.domain'),
]);
```

---

### 3. Inspect Cookies

**En navegador:**

```javascript
// Ver todas las cookies
console.log(document.cookie);

// Parsear
document.cookie.split('; ').forEach(c => {
    const [name, value] = c.split('=');
    console.log(`${name}: ${decodeURIComponent(value)}`);
});
```

**En Network tab:**

```
POST /livewire/update

Request Headers:
- Cookie: techdaily-session=xyz789; other_cookie=value

Response Headers:
- Set-Cookie: techdaily-session=...; Domain=.chelistico.ar; Path=/; ...
- Set-Cookie: XSRF-TOKEN=...; (Sanctum token)
```

---

## 🛠️ Soluciones por Escenario

### Escenario 1: Filament en Subdominio Específico

**Setup:**
```
- Frontend: https://chelistico.ar (públicolor)
- Admin: https://api.chelistico.ar/admin (Filament)
- API: https://api.chelistico.ar/api (REST endpoints)
```

**Configuración:**

```env
# .env.production
SESSION_DOMAIN=api.chelistico.ar
SANCTUM_STATEFUL_DOMAINS=api.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar,https://api.chelistico.ar
```

**Razón:**
- Admin requests solo vienen de `api.chelistico.ar`
- Session debe ser específica para ese dominio
- CORS permite requests desde frontend

---

### Escenario 2: Filament en Dominio Raíz

**Setup:**
```
- Admin: https://chelistico.ar/admin (Filament)
- API: https://chelistico.ar/api (REST endpoints)
- Public: https://chelistico.ar (Frontend)
```

**Configuración:**

```env
# .env.production
SESSION_DOMAIN=chelistico.ar
SANCTUM_STATEFUL_DOMAINS=chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar
```

---

### Escenario 3: Multi-Tenant

**Setup:**
```
- Tenant 1: https://tenant1.chelistico.ar/admin
- Tenant 2: https://tenant2.chelistico.ar/admin
- API: https://api.chelistico.ar/api
```

**Configuración:**

```env
# .env.production
SESSION_DOMAIN=.chelistico.ar  # Wildcard
SANCTUM_STATEFUL_DOMAINS=chelistico.ar,*.chelistico.ar
CORS_ALLOWED_ORIGINS=https://chelistico.ar,https://*.chelistico.ar
```

**Nota:** Requiere manejar SameSite=lax o implementar custom middleware

---

## 📊 Decisión Matrix

| Situación | SESSION_DOMAIN | SESSION_SAME_SITE | Recomendación |
|-----------|---|---|---|
| Filament en `api.example.com` | `api.example.com` | `lax` | ⭐⭐⭐⭐⭐ |
| Filament en `example.com` | `example.com` | `lax` | ⭐⭐⭐⭐⭐ |
| Múltiples subdominios | `.example.com` | `none` | ⭐⭐⭐⭐ (requiere HTTPS) |
| Development local | `localhost` | `lax` | ⭐⭐⭐⭐ (siempre funciona) |
| Wildcard (menos seguro) | `.example.com` | `lax` | ⭐⭐⭐ (posibles issues) |

---

## 🔬 Tests de Validación

### Test 1: Session Persistence

```bash
#!/bin/bash
# test_session_persistence.sh

API="https://api.chelistico.ar"
COOKIE_JAR="/tmp/cookies.txt"

# Step 1: GET admin page (crea session)
curl -b $COOKIE_JAR -c $COOKIE_JAR "$API/admin" -o /dev/null

# Step 2: Verificar que cookie se guardó
if grep -q "techdaily-session" $COOKIE_JAR; then
    echo "✅ Session cookie created"
else
    echo "❌ Session cookie NOT created"
    exit 1
fi

# Step 3: POST con mismo cookie
CSRF_TOKEN=$(curl -b $COOKIE_JAR "$API/admin/articles/create" | \
             grep -oP 'csrf-token.*?content="\K[^"]+')

curl -b $COOKIE_JAR \
     -H "X-CSRF-Token: $CSRF_TOKEN" \
     -X POST \
     "$API/livewire/update" \
     -d '...' 

echo "✅ Session persistence test completed"
```

### Test 2: Domain Validation

```bash
#!/bin/bash
# test_domain_match.sh

DOMAIN=$(php artisan config:show session.domain)
CURRENT_HOST=$1

if [[ "$DOMAIN" == "$CURRENT_HOST" ]] || \
   [[ "$DOMAIN" == ".${CURRENT_HOST#*.}" ]]; then
    echo "✅ Domain matches"
else
    echo "❌ Domain mismatch"
    echo "   Expected: $DOMAIN"
    echo "   Got: $CURRENT_HOST"
    exit 1
fi
```

---

## 📚 Referencias

- [RFC 6265 - HTTP State Management Mechanism](https://tools.ietf.org/html/rfc6265)
- [RFC 6265bis - Cookies: HTTP State Management Mechanism](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis)
- [Laravel Sessions Documentation](https://laravel.com/docs/11.x/session)
- [Laravel CSRF Protection](https://laravel.com/docs/11.x/csrf)
- [Livewire Documentation](https://livewire.laravel.com/)
- [Filament PHP Documentation](https://filamentphp.com/)
- [MDN: SameSite Cookie Attribute](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite)

---

**Documento Preparado Por:** Dev Fullstack  
**Nivel Técnico:** ⭐⭐⭐ Intermedio-Avanzado  
**Fecha:** 21 de Abril de 2026
