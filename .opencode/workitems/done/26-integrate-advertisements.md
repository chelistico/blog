# Workitem #26 - Integrate Advertisements into Frontend Pages

## Overview
Integrate the AdvertisementBanner component across the frontend application, replacing all placeholder advertisement divs with real advertisements fetched from the backend API.

## Objectives

### 26.1 Update Layout Component
- **File:** `frontend/src/components/Layout.tsx`
- Remove 1 placeholder advertisement div
- Add AdvertisementBanner component in appropriate location
- Currently has: "Advertisement Space - 300x600" in sidebar

**Current Implementation:**
```jsx
<div className="mx-6 sm:mx-8 mb-8 bg-gray-100 rounded-lg p-6 text-center 
                border-2 border-dashed border-gray-300">
  <div className="text-sm text-gray-500">Advertisement Space - 300x600</div>
</div>
```

**Task:**
- Fetch advertisements for 'sidebar' position
- Display AdvertisementBanner component
- Handle loading and error states
- Implement graceful fallback if no ads available

**Acceptance Criteria:**
- [ ] Placeholder removed
- [ ] Advertisements fetched for 'sidebar' position
- [ ] AdvertisementBanner component renders
- [ ] Loading state handled
- [ ] Error state handled
- [ ] Fallback to placeholder if no ads
- [ ] Responsive on all screen sizes

### 26.2 Update Home Page
- **File:** `frontend/src/pages/Home.tsx`
- Remove 2 placeholder advertisement divs
- Add AdvertisementBanner components
- Currently has: "Advertisement Space - 728x90" top and bottom

**Current Implementation:**
- Top placeholder: Above article list
- Bottom placeholder: Below article list

**Task:**
- Fetch advertisements for 'top' and 'bottom' positions
- Display AdvertisementBanner components in correct positions
- Implement loading and error states
- Handle no-ads scenario gracefully

**Acceptance Criteria:**
- [ ] Top placeholder removed and replaced
- [ ] Bottom placeholder removed and replaced
- [ ] Both position ads fetched correctly
- [ ] Loading states during fetch
- [ ] Error handling implemented
- [ ] Responsive design maintained
- [ ] Page layout preserved

### 26.3 Update Article Detail Page
- **File:** `frontend/src/pages/ArticleDetail.tsx`
- Remove 3 placeholder advertisement divs
- Add AdvertisementBanner components
- Currently has: 3 "Advertisement Space - 728x90" divs

**Current Implementation:**
- Between article metadata and main image
- Between article content and tags
- Between tags and end of article

**Task:**
- Fetch advertisements for 'top' and 'bottom' positions (or article-specific)
- Display AdvertisementBanner components in each location
- Implement proper loading and error states
- Ensure advertisements don't clutter article readability

**Acceptance Criteria:**
- [ ] All 3 placeholders removed
- [ ] Advertisements fetched correctly
- [ ] AdvertisementBanner components render
- [ ] Article layout preserved
- [ ] Reading experience not compromised
- [ ] Responsive on all breakpoints

### 26.4 Implement Fallback Behavior
- If no advertisements available:
  - Hide ad sections completely (or show minimal placeholder)
  - Don't create layout shifts
  - Gracefully degrade
- If advertisement fails to load:
  - Show error message or remove from DOM
  - Don't break page layout
  - Log error for monitoring

**Acceptance Criteria:**
- [ ] Missing ads handled gracefully
- [ ] No layout shift when ad fails
- [ ] Error states don't break page
- [ ] User experience not degraded

### 26.5 Add Loading States
- Show loading skeleton while fetching advertisements
- Match existing loading pattern from ArticleDetail
- Provide visual feedback to user

**Acceptance Criteria:**
- [ ] Loading skeleton shown
- [ ] Matches existing loading patterns
- [ ] Skeleton dimensions match final ad
- [ ] Smooth transition to final state

## Implementation Details

### Advertisement Fetching Pattern
```typescript
useEffect(() => {
  const loadAds = async () => {
    try {
      const ads = await advertisementService.getAdvertisementsByPosition('top');
      setTopAds(ads);
    } catch (error) {
      console.error('Failed to load advertisements:', error);
      setAdError(true);
    } finally {
      setAdLoading(false);
    }
  };
  loadAds();
}, []);
```

### Component Integration Pattern
```jsx
{adLoading && <AdLoadingSkeleton />}
{topAds.length > 0 && !adLoading && (
  <AdvertisementBanner
    advertisement={topAds[0]}
    position="top"
    onError={handleAdError}
  />
)}
```

### Advertisement Positions
- **'top'** - Above main content (728x90)
- **'bottom'** - Below main content (728x90)
- **'sidebar'** - Right sidebar (300x600)
- **'article'** - Within article content (customizable)

## Layout Changes Required

### Home.tsx
- **Before:** 2 placeholder divs (top and bottom)
- **After:** 2 AdvertisementBanner components with loading states

### ArticleDetail.tsx
- **Before:** 3 placeholder divs
- **After:** 3 AdvertisementBanner components (or 2, depending on position)

### Layout.tsx
- **Before:** 1 placeholder div in sidebar
- **After:** 1 AdvertisementBanner component with loading state

## Related Workitems
- **Workitem #24** - Types and Service (prerequisite)
- **Workitem #25** - AdvertisementBanner Component (prerequisite)
- **Workitem #23** - OptimizedImage Component (dependency)

## Testing Requirements
- [ ] TypeScript compilation succeeds
- [ ] ESLint passes all checks
- [ ] All pages render without errors
- [ ] Advertisements display correctly
- [ ] Loading states visible
- [ ] Error states handled
- [ ] No layout shifts
- [ ] Responsive on all breakpoints
- [ ] Performance: ads load asynchronously without blocking page

## Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Mobile responsive
- No deprecated APIs

## Testing Checklist
- [ ] Home page displays top and bottom ads
- [ ] Article detail displays ads in correct positions
- [ ] Layout component shows sidebar ads
- [ ] Loading states visible briefly
- [ ] Error handling works (no console errors)
- [ ] Fallback when no ads available
- [ ] Responsive design maintained
- [ ] Performance not degraded
- [ ] Click tracking works from ads
- [ ] Images lazy load correctly

## Performance Considerations
- Advertisements fetched asynchronously
- Caching prevents excessive API calls
- OptimizedImage handles lazy loading
- No blocking of page rendering
- No cumulative layout shift (CLS)

## Files to Modify
- **Modify:** `frontend/src/pages/Home.tsx` - 2 placeholders → 2 ad sections
- **Modify:** `frontend/src/pages/ArticleDetail.tsx` - 3 placeholders → ad sections
- **Modify:** `frontend/src/components/Layout.tsx` - 1 placeholder → ad section

## Estimated Effort
- 3-4 hours including testing and layout refinement

## Rollback Plan
- If ads cause performance issues, keep placeholder infrastructure
- Can be disabled via environment variable
- Cache can be cleared server-side if needed
