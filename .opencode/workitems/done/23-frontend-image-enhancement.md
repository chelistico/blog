# 23 - Frontend Image Display Enhancement

## Overview
Ensure frontend properly displays images uploaded through the new physical image upload system. Add image optimization, lazy loading, and proper error handling for missing images.

## Context
Related to Workitem #22 (Image Upload System for Articles & Advertisements). This workitem focuses on the frontend aspects of displaying those images correctly.

---

## Current Frontend Image Handling

### Article Component (`frontend/src/pages/ArticleDetail.tsx`)
- **Line 181-184**: Displays `main_image` with basic img tag
- **Status**: Works but could be optimized
- **Issue**: No lazy loading, no error handling for missing images

### Article Embedded Images (if displayed)
- **Current**: Displayed via `dangerouslySetInnerHTML` from `content` field
- **Status**: Images from markdown are embedded, not controlled separately
- **Issue**: No optimization, no lazy loading

### Advertisement Component (if exists)
- **Location**: Check `frontend/src/components/Advertisement.tsx` or similar
- **Status**: May not be displaying images yet
- **Issue**: Needs to handle both URL and file path formats

---

## Work Items

### 23.1 Optimize Article Main Image Display
- [ ] Update `ArticleDetail.tsx` main_image display:
  - Add `loading="lazy"` attribute for lazy loading
  - Add proper `alt` text from article title
  - Add error handling for missing/broken images
  - Add proper aspect ratio container (or height/width)
  - Verify image paths work (relative: `images/articles/...` or absolute URLs)
- [ ] Test with both relative paths (`images/articles/...`) and absolute URLs

### 23.2 Optimize Embedded Article Images
- [ ] If embedded images are stored separately in DB:
  - Create component to display array of images
  - Add lazy loading per image
  - Add alt text support
  - Add error handling
- [ ] If embedded images are in content markdown:
  - Ensure markdown images use correct paths
  - No changes needed (handled by content rendering)

### 23.3 Display Advertisement Images Correctly
- [ ] Update Advertisement display component (if exists):
  - Handle both relative and absolute image URLs
  - Add lazy loading: `loading="lazy"`
  - Add error handling for missing images
  - Add proper dimensions/aspect ratio
  - Add fallback image or placeholder
- [ ] Verify image paths work in all advertisement placements:
  - Top banner (728x90)
  - Article detail ads (728x90, 300x600)
  - Sidebar ads (if any)

### 23.4 Add Image URL Helper Utility
- [ ] Create `frontend/src/utils/imageUrl.ts`:
  - Function to convert relative paths to absolute URLs if needed
  - Handle both formats: `/storage/images/...` and `images/...`
  - Generate appropriate base URL based on environment
  - Add fallback for missing/broken images

```typescript
// Example utility functions
export function getImageUrl(imagePath: string | null): string {
  if (!imagePath) return getPlaceholderImage();
  
  // Already absolute URL
  if (imagePath.startsWith('http')) return imagePath;
  
  // Relative path - add base URL
  const baseUrl = import.meta.env.VITE_API_BASE_URL.replace('/api', '');
  return `${baseUrl}/storage/${imagePath}`;
}

export function getPlaceholderImage(): string {
  return 'data:image/svg+xml,...'; // placeholder
}
```

### 23.5 Handle Image Loading States
- [ ] Add loading skeleton/placeholder while image loads
- [ ] Add error state if image fails to load
- [ ] Add retry mechanism for failed loads (optional)

### 23.6 Test Image Display
- [ ] Test article with main_image:
  - Image loads correctly
  - Lazy loading works
  - Error handling works (try with invalid path)
  - Responsive on mobile/tablet/desktop
- [ ] Test article with embedded_images:
  - All images load correctly
  - Images are responsive
- [ ] Test advertisement images:
  - Display in all locations
  - Correct sizing
  - Links work (if applicable)

### 23.7 Documentation
- [ ] Document image path format for frontend developers
- [ ] Document how to handle relative vs absolute paths
- [ ] Document fallback behavior for missing images

---

## Implementation Details

### Relative Path Format
```
Database stores: images/articles/article-1-main.jpg
Frontend converts to: https://domain.com/storage/images/articles/article-1-main.jpg
```

### Image Component Example
```tsx
interface ImageProps {
  src: string | null;
  alt: string;
  className?: string;
  width?: number;
  height?: number;
}

export function OptimizedImage({ src, alt, className, width, height }: ImageProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(false);
  
  const imagePath = src ? getImageUrl(src) : getPlaceholderImage();
  
  return (
    <div className={className}>
      {isLoading && <ImageSkeleton />}
      {!error && (
        <img
          src={imagePath}
          alt={alt}
          loading="lazy"
          width={width}
          height={height}
          onLoad={() => setIsLoading(false)}
          onError={() => {
            setError(true);
            setIsLoading(false);
          }}
          className={isLoading ? 'invisible' : 'visible'}
        />
      )}
      {error && <ImagePlaceholder alt={alt} />}
    </div>
  );
}
```

---

## Testing Checklist

- [ ] Images from `/storage/images/articles/` display correctly
- [ ] Images from `/storage/images/advertisements/` display correctly
- [ ] Lazy loading works (images load as user scrolls)
- [ ] Images are responsive on all screen sizes
- [ ] Broken image links show fallback/error state
- [ ] Alt text is properly displayed
- [ ] Performance is good (no memory leaks from lazy loading)

---

## Notes
- Works alongside Workitem #22 (Backend image uploads)
- Can be implemented in parallel with #22
- Frontend already handles URLs well, just needs optimization
- Image utilities can be reused across components

## References
- ArticleDetail Component: `frontend/src/pages/ArticleDetail.tsx`
- Utils Directory: `frontend/src/utils/`
- Utilities Guide: See `AGENTS.md` for code style
