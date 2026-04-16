# Workitem #25 - Advertisement Banner Component

## Overview
Create a reusable React component for displaying advertisements with image support, error handling, and responsive design. This component will replace all placeholder advertisement divs across the blog.

## Objectives

### 25.1 Create AdvertisementBanner Component
- **File:** `frontend/src/components/AdvertisementBanner.tsx`
- Display single advertisement banner
- Support both image and HTML content
- Implement responsive design for various dimensions
- Add click tracking capability

**Features:**
- Display advertisement image using OptimizedImage component
- Support click-through links with tracking
- Handle missing or broken images gracefully
- Display HTML content for AdSense/custom code
- Responsive design (mobile, tablet, desktop)
- Loading state while fetching

**Acceptance Criteria:**
- [ ] Component accepts Advertisement prop
- [ ] Images render with OptimizedImage
- [ ] HTML content sanitized and rendered
- [ ] Click tracking sends to API
- [ ] Responsive for all screen sizes
- [ ] Error states handled gracefully
- [ ] No TypeScript errors
- [ ] ESLint passes

### 25.2 Implement Image Display
- Use OptimizedImage component from Workitem #23
- Handle missing images with placeholder
- Support alt text generation
- Maintain aspect ratio based on dimensions

**Acceptance Criteria:**
- [ ] Images render correctly
- [ ] Lazy loading applied
- [ ] Error handling works
- [ ] Placeholder shown for missing images
- [ ] Maintains correct aspect ratio

### 25.3 Implement HTML Content Display
- Sanitize HTML to prevent XSS
- Support AdSense code blocks
- Support custom HTML advertisements
- Display as fallback if image not available

**Acceptance Criteria:**
- [ ] HTML sanitized (prevent XSS)
- [ ] AdSense code renders correctly
- [ ] Custom HTML displays properly
- [ ] Styling rules applied safely

### 25.4 Add Click Tracking
- Track ad clicks via API
- Send position and advertisement ID
- Handle tracking errors gracefully

**Acceptance Criteria:**
- [ ] Click event triggers API call
- [ ] Tracking data includes ad ID and position
- [ ] Graceful error handling
- [ ] Link still works if tracking fails

## Technical Details

### Component Props
```typescript
interface AdvertisementBannerProps {
  advertisement: Advertisement;
  position: 'top' | 'bottom' | 'sidebar';
  onError?: () => void;
  onLoadSuccess?: () => void;
}
```

### Component Structure
```
AdvertisementBanner
├── Container (responsive dimensions)
├── Image Display (if advertisement.image)
│   └── OptimizedImage component
├── HTML Content (if advertisement.html_content)
│   └── Sanitized innerHTML
├── Link Wrapper (if advertisement.link)
└── Click Handler (tracking)
```

### Click Tracking Endpoint
- `POST /api/advertisements/{id}/click`
- Data: `{ position: string }`
- Response: `{ success: boolean }`

### Responsive Dimensions Handling
```typescript
function getContainerDimensions(dimensions: string): { width: string; height: string } {
  // Parse "728x90" → { width: "728px", height: "90px" }
  // Support percentages and auto
  // Mobile responsive fallback
}
```

### HTML Sanitization
```typescript
function sanitizeAdHtml(html: string): string {
  // Remove script tags and event handlers
  // Allow safe tags (div, p, img, etc.)
  // Keep style attributes for formatting
}
```

## Design Guidelines

### Layout
- Container respects dimensions from backend
- Fallback to max-width on small screens
- Centered on page
- Maintains aspect ratio

### Styling
- Use Tailwind CSS
- No custom CSS
- Responsive breakpoints: sm, md, lg
- Border and shadow for separation from content

### States
- **Loading:** Pulse animation while fetching image
- **Error:** Placeholder image
- **Success:** Full advertisement displayed
- **Hover:** Slight scale/opacity change for link feedback

## Related Workitems
- **Workitem #24** - Types and Service (must complete first)
- **Workitem #26** - Integration (depends on this)
- **Workitem #23** - OptimizedImage Component (dependency)

## Testing Requirements
- [ ] TypeScript compilation succeeds
- [ ] ESLint passes all checks
- [ ] Component renders without errors
- [ ] Images display correctly
- [ ] HTML content renders safely
- [ ] Click tracking works
- [ ] Responsive on all breakpoints
- [ ] Accessibility: alt text, semantic HTML

## Component Example Usage
```typescript
<AdvertisementBanner
  advertisement={ad}
  position="top"
  onError={() => console.log('Ad failed to load')}
/>
```

## Files to Create/Modify
- **Create:** `frontend/src/components/AdvertisementBanner.tsx`

## Dependencies
- OptimizedImage component (from Workitem #23)
- advertisementService (from Workitem #24)
- DOMPurify or similar for HTML sanitization

## Estimated Effort
- 3-4 hours including testing and refinement
