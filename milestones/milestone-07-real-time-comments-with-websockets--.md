# Milestone 7: Real-time Comments with WebSockets  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 3-4 days

### Objective
Enable live comment updates without page refresh.

### Deliverables
1. **Socket.io Server Setup:**
   - Initialize Socket.io with Express
   - Configure CORS for WebSocket
   - JWT/session authentication for sockets

2. **Room-based Architecture:**
   - Room per post: `post:${postId}`
   - Users join room when viewing post
   - Events emit only to room

3. **Socket Events:**
   - Client->Server: `join:post`, `leave:post`, `comment:create`, `comment:edit`, `comment:delete`
   - Server->Client: `comment:new`, `comment:updated`, `comment:deleted`, `comment:approved`, `users:online`

4. **Integration with REST API:**
   - When comment created via REST, emit WebSocket event
   - When admin approves, emit event
   - Unified comment creation logic

5. **Error Handling:**
   - Connection errors
   - Reconnection strategy
   - Event validation

### Success Criteria
- ✅ Connected clients receive real-time updates  
- ✅ WebSocket authentication works  
- ✅ Events only sent to relevant room  
- ✅ Graceful fallback if WebSocket unavailable  
- ✅ No memory leaks  
- ✅ Reconnection works  

---
