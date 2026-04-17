# Workitem #24 - Advertisement Type Definitions and API Service

## Overview
Create the TypeScript type definitions and API service layer for advertisements in the frontend. This is the foundation for displaying advertisement images and content across the blog.

## Objectives

### 24.1 Create Advertisement Type Definitions
- **File:** `frontend/src/types/advertisement.ts`
- Define interfaces for:
  - Advertisement (main model)
  - AdvertisementsResponse (API response)
  - PaginationMeta (for paginated responses)
- Support both image and HTML/AdSense code advertisements
- Include dimensions, position, status, and scheduling fields
- Add optional fields for link and CSS class

**Acceptance Criteria:**
- [ ] TypeScript interfaces defined and exported
- [ ] Matches backend AdvertisementResource structure
- [ ] Supports image URLs and HTML content
- [ ] Position enum defined (top, bottom, sidebar)
- [ ] No TypeScript errors

### 24.2 Create Advertisement Service Layer
- **File:** `frontend/src/services/advertisementService.ts`
- Create AdvertisementService class with:
  - `getAdvertisementsByPosition(position: string)` - Fetch ads for specific position
  - `getAllAdvertisements()` - Fetch all active advertisements
  - `getAdvertisementById(id: number)` - Fetch single advertisement
  - Implement error handling and retry logic
  - Add caching layer for advertisements (5 minute TTL)

**Acceptance Criteria:**
- [ ] Service class created with all methods
- [ ] Error handling implemented
- [ ] Network retry logic works
- [ ] Caching prevents excessive API calls
- [ ] TypeScript strict mode compliant
- [ ] Service exported and ready for use

### 24.3 Add Caching Mechanism
- Implement in-memory cache with TTL
- Track cached advertisements by position
- Invalidate cache on manual refresh
- Provide cache invalidation method

**Acceptance Criteria:**
- [ ] Cache stores advertisements by position
- [ ] TTL enforces 5-minute expiry
- [ ] Manual invalidation works
- [ ] Multiple positions cached independently

## Technical Details

### Advertisement Type Structure
```typescript
export interface Advertisement {
  id: number;
  title: string;
  image?: string;           // Full URL from API
  html_content?: string;    // For AdSense/custom HTML
  link?: string;            // Click-through URL
  dimensions: string;       // e.g., "728x90", "300x600"
  position: 'top' | 'bottom' | 'sidebar';
  is_active: boolean;
  clicks: number;
  impressions: number;
  scheduled_start?: string; // ISO date
  scheduled_end?: string;   // ISO date
  created_at: string;
  updated_at: string;
}

export interface AdvertisementsResponse {
  success: boolean;
  data: Advertisement[];
  message?: string;
}
```

### API Endpoints
- `GET /api/advertisements?position=top` - Get ads for specific position
- `GET /api/advertisements` - Get all advertisements

### Service Implementation Pattern
```typescript
class AdvertisementService {
  private cache = new Map<string, CacheEntry>();
  
  async getAdvertisementsByPosition(position: string): Promise<Advertisement[]>
  async getAllAdvertisements(): Promise<Advertisement[]>
  private getCached(key: string): Advertisement[] | null
  private setCached(key: string, ads: Advertisement[]): void
  clearCache(): void
}

export const advertisementService = new AdvertisementService();
```

## Related Workitems
- **Workitem #25** - AdvertisementBanner Component (depends on this)
- **Workitem #26** - Integrate Advertisements (depends on this)
- **Workitem #22** - Image Upload System (backend, completed)
- **Workitem #23** - Frontend Image Enhancement (completed)

## Testing Requirements
- [ ] TypeScript compilation succeeds
- [ ] ESLint passes all checks
- [ ] Service fetches ads correctly
- [ ] Caching works as expected
- [ ] Error handling tested
- [ ] All types are strict-mode compliant

## Completion Checklist
- [ ] Type definitions created and exported
- [ ] Service class implemented with all methods
- [ ] Caching mechanism working
- [ ] Error handling in place
- [ ] Documentation added
- [ ] Tests pass (TypeScript, ESLint)
- [ ] Ready for component integration

## Notes
- Advertisements are optional (frontend should handle missing ads gracefully)
- Images already come as absolute URLs from backend
- Cache should be cleared when admin uploads new advertisements
- Support both image and HTML content types (HTML for AdSense/custom code)

## Files to Create/Modify
- **Create:** `frontend/src/types/advertisement.ts`
- **Create:** `frontend/src/services/advertisementService.ts`

## Estimated Effort
- 2-3 hours including testing and documentation
