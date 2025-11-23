# Milestone 10: Full-Text Search Implementation  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Fast, relevant search across posts with ranking.

### Deliverables
1. **PostgreSQL Full-Text Search:**
   - Add tsvector column to Post table
   - Create GIN index on tsvector
   - Database trigger to auto-update search index on post save
   - Weight title higher than content (setweight A vs B)

2. **Search Routes:**
   - GET `/api/search?q=query&page=1&limit=10` - Search posts
   - GET `/api/search/suggestions?q=partial` - Autocomplete
   - GET `/api/search/popular` - Popular searches

3. **Search Service:**
   - Full-text query building (handle AND, OR, NOT, phrases)
   - Relevance ranking (ts_rank)
   - Highlight matching snippets (ts_headline)
   - Filters: author, date range
   - Sort: relevance, date, popularity
   - Pagination

4. **Caching:**
   - Cache search results in Redis (15-min TTL)
   - Key: hash of query + filters
   - Invalidate on new post published

5. **Search Analytics:**
   - Log search queries
   - Track popular searches

### Success Criteria
- ✅ Search returns results <100ms  
- ✅ Results ranked by relevance  
- ✅ Partial matches work  
- ✅ Boolean operators work  
- ✅ Search index auto-updates  
- ✅ Cache improves performance  
- ✅ Filters work correctly  

---
