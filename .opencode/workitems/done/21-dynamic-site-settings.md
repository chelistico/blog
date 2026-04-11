# 21 - Dynamic Site Settings Integration

## Overview
Replacing hardcoded values in frontend with dynamic values from site_settings table (managed via Filament admin).

## Context

### Site Settings Available (from database)
The following settings are already defined in `SiteSettingSeeder.php`:

**Branding:**
- `site_name` (default: "TechDaily")
- `site_title` (default: "TechDaily - Noticias de Tecnología")
- `logo` (image URL)
- `logo_light` (image URL)  
- `favicon` (image URL)

**SEO:**
- `seo_title` (meta title)
- `seo_description` (meta description)
- `seo_keywords` (keywords)
- `og_image` (OG image)

**Social:**
- `social_twitter`, `social_facebook`, `social_linkedin`, `social_github`

**Analytics/Ads:**
- `analytics_google`, `analytics_google_tag`, `ads_adsense_client`

### Hardcoded Values Found in Frontend

| File | Line | Hardcoded Value | Setting Key |
|------|------|-----------------|--------------|
| Layout.tsx | 30 | `TechDaily` | `site_name` |
| Layout.tsx | 100 | `TechDaily` | `site_name` |
| Layout.tsx | 128 | `2025 TechDaily` | `site_name` + year |
| Layout.tsx | 31 | `Noticias de tecnología` | NEW: `site_tagline` |
| Layout.tsx | 103 | `Tu fuente diaria...` | `seo_description` |
| App.tsx | 23 | `TechDaily - Noticias...` | `site_title` |
| ArticleDetail.tsx | 25 | `${title} \| TechDaily` | `site_name` |
| seo.ts | 84 | `TechDaily` | `site_name` |

---

## Work Items

### 21.1 Add API endpoint to fetch site settings
- [ ] **Backend**: Add new API endpoint `GET /api/settings` to return all site settings
- [ ] Create `app/Http/Controllers/Api/SiteSettingsController.php` or extend existing controller
- [ ] Return settings as key-value object

### 21.2 Create frontend settings service
- [ ] Create `frontend/src/services/settingsService.ts`
- [ ] Add function to fetch settings from API
- [ ] Implement caching with localStorage for performance

### 21.3 Create TypeScript types for settings
- [ ] Create `frontend/src/types/settings.ts`
- [ ] Define `SiteSettings` interface with all settings keys
- [ ] Export type for use in components

### 21.4 Update Layout.tsx component
- [ ] Import settings service and types
- [ ] Fetch settings on mount
- [ ] Replace hardcoded values:
  - Line 30: `TechDaily` → `{siteSettings.site_name}`
  - Line 31: `Noticias de tecnología` → `{siteSettings.site_tagline}`
  - Line 100: `TechDaily` → `{siteSettings.site_name}`
  - Line 103: Description → `{siteSettings.seo_description}`
  - Line 128: Year + site name → dynamic

### 21.5 Update App.tsx
- [ ] Replace line 23: `site_title` → use setting `site_title`

### 21.6 Update ArticleDetail.tsx
- [ ] Replace line 25: Use setting `site_name` in document title

### 21.7 Update seo.ts utility
- [ ] Import settings service
- [ ] Replace hardcoded `TechDaily` with setting value
- [ ] Use `seo_title`, `seo_description`, `seo_keywords`, `og_image`

### 21.8 Add site_tagline to database (optional new setting)
- [ ] Add new seed for `site_tagline` = "Noticias de tecnología"

---

## Implementation Order
1. Backend: API endpoint
2. Frontend: Types and service
3. Frontend: Update Layout.tsx (most visible)
4. Frontend: Update App.tsx, ArticleDetail.tsx, seo.ts

## Notes
- Ensure fallback values if API fails (use defaults)
- Consider loading state for settings
- Cache settings in localStorage to avoid repeated API calls
- Settings don't change frequently, can use longer cache duration