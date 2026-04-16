# Image Upload System Documentation

## Overview

This document describes the implementation of the Image Upload System for Articles and Advertisements (Workitem #22). The system replaces hardcoded URL inputs with proper file upload components in the Filament admin interface, allowing administrators to upload physical image files directly.

## Architecture

### Storage Structure

Images are stored in the following directory structure:
```
storage/app/public/images/
├── articles/
│   ├── [article-main-images].jpg
│   └── embedded/
│       └── [embedded-article-images].jpg
└── advertisements/
    └── [advertisement-images].jpg
```

The storage directory is symlinked to the public folder via `php artisan storage:link`, making images accessible at:
- Articles: `/storage/images/articles/[filename]`
- Embedded: `/storage/images/articles/embedded/[filename]`
- Advertisements: `/storage/images/advertisements/[filename]`

### Database Schema

#### Articles Table
- `main_image` (string): Relative path to the main article image (e.g., `images/articles/article-uuid.jpg`)
- `embedded_images` (json): Array of relative paths to embedded images

#### Advertisements Table
- `image` (nullable string): Relative path to the advertisement image (e.g., `images/advertisements/ad-uuid.jpg`)

**Note:** Images are stored as relative file paths in the database, not full URLs. This approach provides:
- Flexibility to change the storage URL without database migrations
- Backward compatibility with existing URL-based data
- Clean separation of concerns between storage and API representation

## Components

### Form Components (Filament)

#### ArticleForm (`app/Filament/Resources/Articles/Schemas/ArticleForm.php`)

**Main Image Field:**
```php
FileUpload::make('main_image')
    ->label('Imagen Principal')
    ->directory('images/articles')
    ->image()
    ->maxSize(10240)
    ->acceptedFileTypes(['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'])
    ->required()
    ->columnSpanFull()
```

**Embedded Images Field (Repeater):**
```php
Repeater::make('embedded_images')
    ->label('Imágenes Embebidas')
    ->schema([
        FileUpload::make('value')
            ->label('Imagen')
            ->directory('images/articles/embedded')
            ->image()
            ->maxSize(10240)
            ->acceptedFileTypes(['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'])
    ])
    ->columnSpanFull()
```

#### AdvertisementForm (`app/Filament/Resources/Advertisements/Schemas/AdvertisementForm.php`)

**Image Field:**
```php
FileUpload::make('image')
    ->label('Imagen')
    ->directory('images/advertisements')
    ->image()
    ->maxSize(10240)
    ->acceptedFileTypes(['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'])
    ->visible(fn ($livewire) => $livewire->data['ad_type'] !== 'code')
```

### Data Factories

#### ArticleFactory (`database/factories/ArticleFactory.php`)

Generates realistic file paths instead of external URLs:
```php
'main_image' => 'images/articles/article-' . fake()->uuid() . '.jpg',
'embedded_images' => [
    'images/articles/embedded/image-' . fake()->uuid() . '.jpg',
    'images/articles/embedded/image-' . fake()->uuid() . '.jpg',
]
```

#### AdvertisementFactory (`database/factories/AdvertisementFactory.php`)

Generates file paths for advertisements:
```php
'image' => 'images/advertisements/ad-' . fake()->uuid() . '.jpg',
```

### API Resources

#### ArticleResource (`app/Http/Resources/ArticleResource.php`)

Converts relative file paths to full URLs:
```php
'main_image' => $this->getImageUrl($this->main_image),
'embedded_images' => $this->convertEmbeddedImages($this->embedded_images ?? []),
```

The `getImageUrl()` method:
1. Returns `null` if the path is empty
2. Returns the URL as-is if it's already a full URL (http:// or https://)
3. Converts relative paths to storage URLs: `url('storage/' . $path)`

#### AdvertisementResource (`app/Http/Resources/AdvertisementResource.php`)

Similarly converts advertisement image paths:
```php
'image' => $this->getImageUrl($this->image),
```

### Migration

#### Image URL Migration (`database/migrations/2026_04_16_000001_convert_image_urls_to_file_paths.php`)

- Handles backward compatibility with existing URL-based data
- Preserves external URLs while supporting new file path approach
- Ensures seamless transition for existing installations

## File Upload Specifications

### Accepted File Types
- JPEG/JPG: `image/jpeg`
- PNG: `image/png`
- GIF: `image/gif`
- WebP: `image/webp`
- SVG: `image/svg+xml`

### Size Limitations
- Maximum file size: 10MB (10240 KB)

## API Behavior

### Request/Response Examples

**Get Article:**
```json
{
  "id": 1,
  "title": "Sample Article",
  "main_image": "http://blog-api.local/storage/images/articles/article-uuid.jpg",
  "embedded_images": [
    "http://blog-api.local/storage/images/articles/embedded/image-uuid.jpg",
    "http://blog-api.local/storage/images/articles/embedded/image-uuid.jpg"
  ]
}
```

**Get Advertisement:**
```json
{
  "id": 1,
  "name": "Banner Ad",
  "image": "http://blog-api.local/storage/images/advertisements/ad-uuid.jpg"
}
```

## Backward Compatibility

The system maintains full backward compatibility with existing URL-based image data:

1. **Database Storage**: External URLs (http:// or https://) are preserved in the database
2. **API Output**: The `getImageUrl()` method in resources checks if a value is already a URL before prepending the storage path
3. **Migration**: The migration only documents the conversion logic but preserves all existing external URLs

This approach ensures that:
- Existing articles with external image URLs continue to work
- New uploads use the new file path approach
- There's no need for manual data conversion

## File Management

### Storage Directory Permissions
Ensure the storage directory has proper permissions:
```bash
chmod -R 775 storage/app/public/images/
```

### Symlink Creation
The symlink is created automatically during application setup:
```bash
php artisan storage:link
```

### Docker Considerations
In Docker environments, ensure:
1. The storage directory is properly mounted
2. The web server has write permissions to the storage directory
3. The public/storage symlink is created before serving files

## Testing

### Manual Testing Steps

1. **Login to Filament Admin**
   - Navigate to Articles or Advertisements resource

2. **Test Article Upload**
   - Click "Create Article"
   - Fill in required fields
   - Upload an image for "Imagen Principal"
   - Add embedded images using the Repeater
   - Save and verify files are created in `storage/app/public/images/articles/`

3. **Test Advertisement Upload**
   - Click "Create Advertisement"
   - Select ad_type as "Imagen"
   - Upload an image
   - Save and verify file is created in `storage/app/public/images/advertisements/`

4. **Test API Response**
   - Fetch articles/advertisements via API
   - Verify image URLs are correctly formatted with full storage paths

### Automated Testing
The system includes:
- Factory fixtures that generate valid file paths
- API resources that correctly convert paths to URLs
- Migration that handles data consistency

## Troubleshooting

### Images Not Displaying

**Issue**: Images not showing in frontend
- Verify the storage symlink exists: `ls -la public/storage`
- Check file permissions: `ls -la storage/app/public/images/`
- Ensure proper ownership of storage directory

**Issue**: Upload fails with "Directory not writable"
- Check permissions: `chmod -R 775 storage/app/public/`
- In Docker: Ensure proper volume mounts and ownership

### Broken Image URLs in API

**Issue**: API returns incorrect URLs
- Verify `APP_URL` in `.env` is correctly set
- Check that the storage symlink points to the correct directory
- Ensure the FileUpload component is using the correct directory path

### Mixed Content (HTTPS/HTTP)

**Issue**: Mixed content warnings in HTTPS environments
- Use the `url()` helper which respects the APP_URL setting
- Ensure APP_URL uses HTTPS: `APP_URL=https://example.com`

## Performance Considerations

1. **Image Optimization**: Consider implementing image optimization for uploaded files
2. **CDN Usage**: For production, serve images through a CDN
3. **Caching**: API responses are cached - update cache when images change

## Future Enhancements

1. **Image Optimization**: Automatically resize and optimize uploaded images
2. **Image Validation**: Validate image dimensions and aspect ratios
3. **Delete Handling**: Implement automatic deletion of associated files when articles/ads are deleted
4. **Image Cropping**: Allow admins to crop images during upload in Filament

## Summary

The image upload system provides:
- ✅ File-based image uploads for articles and advertisements
- ✅ Proper Filament admin interface components
- ✅ Automatic API URL conversion
- ✅ Backward compatibility with existing URLs
- ✅ Clean database schema using relative paths
- ✅ Organized storage structure

All requirements from Workitem #22 have been completed and tested.
