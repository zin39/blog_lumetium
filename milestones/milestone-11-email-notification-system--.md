# Milestone 11: Email Notification System  

**Duration:** See main specification
**Status:** 🔴 Not Started  
**Dependencies:** See milestone dependency chart

---

## Full Specification

This milestone has been extracted from the main milestones.md file.
Refer to ../milestones.md for complete details on:

**Duration:** 4-5 days

### Objective
Send transactional emails for key user actions.

### Deliverables
1. **Nodemailer Configuration:**
   - SMTP transport (SendGrid, Mailgun, AWS SES)
   - Test mode with Ethereal (development)

2. **Email Service:**
   - sendWelcomeEmail(user)
   - sendVerificationEmail(user, token)
   - sendPasswordResetEmail(user, token)
   - sendCommentNotification(postAuthor, comment)
   - sendReplyNotification(commentAuthor, reply)
   - sendAccountDeletionConfirmation(user)

3. **Email Queue (Bull + Redis):**
   - Async email sending
   - Retry logic (3 attempts, exponential backoff)
   - Job processing (5 concurrent)
   - Failed job handling

4. **Email Templates (HTML + plain text):**
   - Handlebars/EJS for dynamic content
   - Templates: welcome, verification, password-reset, comment-notification, reply-notification
   - Unsubscribe link in all emails

5. **Email Preferences:**
   - EmailPreference model (per user)
   - Routes: GET/PUT `/api/users/me/email-preferences`
   - Unsubscribe endpoint: GET `/api/unsubscribe/:token`

6. **Email Tracking:**
   - EmailLog model (track sent/failed/bounced)
   - Webhook handlers for delivery status (if provider supports)

7. **Rate Limiting:**
   - 1 verification email per 5 minutes per user
   - 1 password reset per 15 minutes
   - Max 10 notifications per hour per user

### Success Criteria
- ✅ All emails send successfully  
- ✅ HTML formatting works  
- ✅ Failed emails retry automatically  
- ✅ Email queue processes efficiently  
- ✅ Users can manage preferences  
- ✅ Unsubscribe works  
- ✅ Delivery tracked  

---
