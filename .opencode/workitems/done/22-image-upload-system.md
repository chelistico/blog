# 22 - Image Upload System for Articles & Advertisements

## Overview
Implement physical image upload functionality through Filament admin for Articles and Advertisements, replacing hardcoded URL text inputs with proper file upload components.

## Current State Analysis

### Database & Models
- **Article Model** (`app/Models/Article.php`):
  - `main_image` (string) - currently stores image URLs
  - `embedded_images` (json array) - currently stores array of image URLs
  
- **Advertisement Model** (`app/Models/Advertisement.php`):
  - `image` (string, nullable) - currently stores image URLs

### Filament Forms (NEED UPDATE)
- **Article Form** (`app/Filament/Resources/Articles/Schemas/ArticleForm.php`):
  - Line 85: `main_image` uses `TextInput::make()` with URL validation
  - Line 143: `embedded_images` uses `KeyValue::make()` (not suitable for file uploads)

- **Advertisement Form** (`app/Filament/Resources/Advertisements/Schemas/AdvertisementForm.php`):
  - Line 68: `image` uses `TextInput::make()` with URL validation

### Existing Infrastructure (READY TO USE)
- ✓ **UploadController** (`app/Http/Controllers/Api/UploadController.php`):
  - `POST /api/upload/image` - File upload endpoint
  - Stores to: `storage/app/public/images/{folder}/`
  - Validates: jpg, jpeg, png, gif, webp, svg+xml (max 10MB)
  - Supported folders: articles, advertisements, avatars, settings, banners, misc

- ✓ **Filament 4.0+**: FileUpload component available and proven to work

### Storage Configuration (NEEDS INITIALIZATION)
- **Filesystem Config**: `config/filesystems.php` - ready
- **Missing**:
  - Symbolic link: `public/storage` (needs `php artisan storage:link`)
  - Subdirectories: `storage/app/public/images/articles/`, `storage/app/public/images/advertisements/`

### Factories (NEED UPDATES)
- **ArticleFactory** (`database/factories/ArticleFactory.php`):
  - Generates fake URLs instead of file paths
  
- **AdvertisementFactory** (`database/factories/AdvertisementFactory.php`):
  - Generates fake URLs instead of file paths

---

## Work Items

### 22.1 Initialize Storage Structure
- [ ] Create `storage/app/public/images/` directory structure
  - `images/articles/` (for article main images)
  - `images/articles/embedded/` (for embedded article images)
  - `images/advertisements/` (for advertisement images)
- [ ] Run `php artisan storage:link` to create public symlink
- [ ] Verify `public/storage` symlink exists
- [ ] Test that uploaded files are publicly accessible via `/storage/images/...`

### 22.2 Update Article Filament Form - Main Image
- [ ] Replace `main_image` TextInput with `FileUpload` component
- [ ] Configure FileUpload:
  - Directory: `images/articles`
  - Disk: `public`
  - Accept: jpg, jpeg, png, gif, webp, svg
  - Max size: 10MB
  - Preserve file names
  - Show upload progress
  - Cleanup on delete

### 22.3 Update Article Filament Form - Embedded Images
- [ ] Replace `embedded_images` KeyValue with `Repeater` component
- [ ] Each repeater item has:
  - FileUpload field (alt text optional)
  - Directory: `images/articles/embedded`
  - Max 20 images
- [ ] Store as JSON array: `[{file: "path"}, {file: "path"}, ...]`

### 22.4 Update Advertisement Filament Form - Image
- [ ] Replace `image` TextInput with `FileUpload` component
- [ ] Configure FileUpload:
  - Directory: `images/advertisements`
  - Disk: `public`
  - Accept: jpg, jpeg, png, gif, webp, svg
  - Max size: 10MB
  - Preserve file names
  - Cleanup on delete

### 22.5 Update Article Factory
- [ ] Generate realistic image file paths for `main_image`
  - Format: `images/articles/article-{id}-{random}.jpg`
- [ ] Generate array of embedded image paths for `embedded_images`
  - Format: `images/articles/embedded/article-{id}-embed-{random}.jpg`
  - Generate 1-3 random images per article
- [ ] Use Faker to generate placeholder image paths (no actual files needed for seeding)

### 22.6 Update Advertisement Factory
- [ ] Generate realistic image file path for `image`
  - Format: `images/advertisements/advert-{id}-{random}.jpg`
- [ ] Use Faker to generate placeholder image path

### 22.7 Update API Resources (Optional - Ensure Correct URLs)
- [ ] Review `ArticleResource.php` - verify images return full URLs
- [ ] Review `AdvertisementResource.php` - verify images return full URLs
- [ ] If needed, add accessor methods to Article & Advertisement models:
  - `main_image_url` - returns full URL if path is relative
  - `image_url` - returns full URL if path is relative

### 22.8 Data Migration Plan (Handle Existing Data)
- [ ] Create migration to handle existing URL data:
  - Backup old URLs (in case needed for rollback)
  - Option 1: Keep existing URLs as-is (will work if they're absolute URLs)
  - Option 2: Convert URLs to file paths (if URLs follow a pattern)
  - Option 3: Clear fields and require re-upload (fresh start)
- [ ] Document decision in comments

### 22.9 Testing & Validation
- [ ] Test in Filament:
  - Upload image for article main_image
  - Upload multiple images for article embedded_images
  - Upload image for advertisement
  - Verify images are stored correctly in storage/app/public/images/
  - Verify files are publicly accessible
- [ ] Test in Frontend:
  - Articles display main_image correctly
  - Articles display embedded_images correctly
  - Advertisements display image correctly
  - Image paths work from both backend and frontend

### 22.10 Documentation & Cleanup
- [ ] Document file upload process for admins
- [ ] Update any developer documentation
- [ ] Verify no broken code or unused imports
- [ ] Remove any temporary test files

---

## Implementation Order
1. **22.1** - Initialize storage directories (foundation)
2. **22.2** - Update Article form for main_image (most visible)
3. **22.3** - Update Article form for embedded_images (feature complete)
4. **22.4** - Update Advertisement form (parallel to 22.2-22.3)
5. **22.5-22.6** - Update factories (supporting)
6. **22.7** - Update API resources (ensure data integrity)
7. **22.8** - Handle existing data (data migration)
8. **22.9** - Testing & validation
9. **22.10** - Documentation & cleanup

---

## Technical Details

### FileUpload Component Configuration (Filament 4)
```php
FileUpload::make('main_image')
    ->directory('images/articles')
    ->disk('public')
    ->acceptedFileTypes(['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'])
    ->maxSize(10240) // 10MB in KB
    ->preserveFilenames()
    ->uploadProgressIndicatorPosition('right')
    ->deleteUploadedFileUsing(function ($file) {
        // Cleanup logic
    })
```

### Repeater Component for Embedded Images
```php
Repeater::make('embedded_images')
    ->schema([
        FileUpload::make('file')
            ->directory('images/articles/embedded')
            ->disk('public')
            ->acceptedFileTypes(['image/jpeg', 'image/png', 'image/gif', 'image/webp'])
            ->maxSize(10240)
    ])
    ->maxItems(20)
```

### Storage Directory Structure
```
storage/
  app/
    public/
      images/
        articles/
          ├── article-1-main.jpg
          ├── article-2-main.png
          └── embedded/
              ├── article-1-embed-1.jpg
              └── article-1-embed-2.jpg
        advertisements/
          ├── advert-1.jpg
          └── advert-2.png
```

### URL Access Pattern
- Files accessible at: `/storage/images/articles/article-1-main.jpg`
- Full URL: `https://domain.com/storage/images/articles/article-1-main.jpg`
- Stored in DB as: `images/articles/article-1-main.jpg`

---

## Notes
- Upload infrastructure (UploadController) already exists and is proven to work
- Filament 4.0 FileUpload component is stable and widely used
- Image validation and sizing handled by FileUpload component
- Storage disk already configured in `config/filesystems.php`
- All file cleanup handled automatically by Filament
- Frontend compatibility maintained (URLs work for both relative and absolute paths)

## References
- UploadController: `app/Http/Controllers/Api/UploadController.php`
- Article Filament Form: `app/Filament/Resources/Articles/Schemas/ArticleForm.php`
- Advertisement Filament Form: `app/Filament/Resources/Advertisements/Schemas/AdvertisementForm.php`
- Filament FileUpload Docs: https://filamentphp.com/docs/3.x/forms/fields/file-upload
