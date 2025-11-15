#!/usr/bin/env python3
"""
Comprehensive GitHub Issues Generator for Shongkot Mobile App Development

This script generates ALL issues for the complete 6-month development plan.
Each issue is designed to be MVP-like with clear acceptance criteria, testing requirements,
and aligned with milestones and project flow.

Generates issues for all 8 phases covering 150+ features.
"""

import json
import os
import subprocess
import sys
from typing import List, Dict, Optional

# Check if we're in the right directory
if not os.path.exists('mobile/pubspec.yaml'):
    print("Error: Please run this script from the repository root")
    sys.exit(1)

# ============================================================================
# PHASE 1: Foundation & Core Features (Weeks 1-4)
# ============================================================================

PHASE_1_ISSUES = [
    {
        "title": "[Auth] Implement user registration with phone/email",
        "body": """## 🎯 MVP Goal
Complete user registration system allowing new users to create accounts.

## 📋 User Story
As a new user, I want to register using my email or phone number so that I can access emergency response features.

## ✅ Acceptance Criteria
- [ ] User can register with email address
- [ ] User can register with phone number
- [ ] Form validation (email format, phone format)
- [ ] Password strength validation (min 8 chars, uppercase, lowercase, number)
- [ ] Terms of service checkbox
- [ ] Privacy policy acceptance
- [ ] Error handling for duplicate accounts
- [ ] Loading states during registration
- [ ] Success screen with next steps
- [ ] Navigate to verification screen

## 🔧 Technical Implementation
**Stack**: Flutter + Riverpod + Firebase Auth/Custom API
- Create registration screen UI with form fields
- Implement validation logic
- Integrate with backend authentication API
- Store user session securely
- Handle network errors with retry logic

## 🌐 API Endpoints
- `POST /api/auth/register` - Create new user account

## 📦 Dependencies
- Firebase Auth SDK OR custom backend auth
- flutter_riverpod for state management
- form validation package

## 🧪 Testing Requirements
- [ ] Unit tests: Email/phone validation logic
- [ ] Unit tests: Password strength validator
- [ ] Widget tests: Registration form rendering
- [ ] Widget tests: Form validation error messages
- [ ] Integration test: Full registration flow
- [ ] Integration test: Duplicate account handling

## 📱 UI/UX Notes
- Follow design system (AppColors, AppTypography)
- Support dark/light theme
- Use AppTextField component
- Accessible with screen readers
- Clear error messages

## 🔗 Related Issues
- Depends on: Backend API setup
- Blocks: #[SMS/Email verification]

## 📊 Definition of Done
- [ ] Code merged to mobile branch
- [ ] Tests passing (>80% coverage)
- [ ] Code review approved
- [ ] No linting errors
- [ ] Works on Android and iOS
- [ ] Documented in README
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Auth] Implement SMS/Email verification system",
        "body": """## 🎯 MVP Goal
Secure account verification via SMS or email to ensure valid user contact information.

## 📋 User Story
As a registered user, I want to verify my contact information so that emergency services can reach me reliably.

## ✅ Acceptance Criteria
- [ ] Send 6-digit verification code via SMS
- [ ] Send verification code via email
- [ ] OTP input screen with auto-focus
- [ ] Resend code button (with cooldown timer)
- [ ] Code expiration after 5 minutes
- [ ] Auto-verify when code detected (SMS)
- [ ] Verification success animation
- [ ] Handle invalid codes gracefully
- [ ] Rate limiting (max 3 attempts per 10 min)
- [ ] Navigate to onboarding/dashboard

## 🔧 Technical Implementation
**Stack**: Flutter + Twilio/AWS SNS + SendGrid/AWS SES
- Create OTP input UI component
- Implement SMS detection (Android)
- Integrate with SMS gateway
- Implement email verification
- Add rate limiting logic
- Store verification status

## 🌐 API Endpoints
- `POST /api/auth/verify` - Verify code
- `POST /api/auth/resend-code` - Resend verification

## 📦 Dependencies
- sms_autofill (Android SMS detection)
- Twilio/AWS SNS (SMS gateway)
- SendGrid/AWS SES (email service)

## 🧪 Testing Requirements
- [ ] Unit tests: Code validation logic
- [ ] Unit tests: Rate limiting logic
- [ ] Widget tests: OTP input component
- [ ] Widget tests: Resend button cooldown
- [ ] Integration test: Full verification flow
- [ ] Integration test: Invalid code handling
- [ ] Integration test: Code expiration

## 📱 UI/UX Notes
- Large, easy-to-tap OTP input boxes
- Clear timer countdown
- Helpful error messages
- Success animation on verify
- Option to change phone/email

## 🔗 Related Issues
- Depends on: #[User registration]
- Blocks: #[Login system]

## 📊 Definition of Done
- [ ] Code merged and tested
- [ ] SMS verification works on Android
- [ ] Email verification works
- [ ] Rate limiting prevents abuse
- [ ] Tests passing (>80% coverage)
- [ ] Works on both platforms
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Auth] Implement login with biometric authentication",
        "body": """## 🎯 MVP Goal
Secure and convenient login system with password and biometric options.

## 📋 User Story
As a registered user, I want to login quickly using fingerprint/face recognition so that I can access emergency features instantly.

## ✅ Acceptance Criteria
- [ ] Login form with email/phone + password
- [ ] "Remember me" checkbox
- [ ] Password visibility toggle
- [ ] "Forgot password" link
- [ ] Biometric authentication option
- [ ] First-time biometric setup prompt
- [ ] Fallback to password if biometric fails
- [ ] Loading state during authentication
- [ ] Error handling for invalid credentials
- [ ] Auto-login if session valid
- [ ] Navigate to home screen on success
- [ ] Token refresh mechanism

## 🔧 Technical Implementation
**Stack**: Flutter + local_auth + flutter_secure_storage
- Create login screen UI
- Implement form validation
- Integrate with authentication API
- Setup biometric authentication
- Store credentials securely
- Implement token refresh
- Handle session management

## 🌐 API Endpoints
- `POST /api/auth/login` - Authenticate user
- `POST /api/auth/refresh` - Refresh access token
- `POST /api/auth/logout` - Invalidate session

## 📦 Dependencies
- local_auth package
- flutter_secure_storage
- jwt_decoder (token handling)

## 🧪 Testing Requirements
- [ ] Unit tests: Login validation
- [ ] Unit tests: Token management
- [ ] Widget tests: Login form
- [ ] Widget tests: Biometric prompt
- [ ] Integration test: Password login flow
- [ ] Integration test: Biometric login flow
- [ ] Integration test: Token refresh
- [ ] Test on physical device (biometric)

## 📱 UI/UX Notes
- Biometric icon based on device capability
- Clear error messages
- Smooth transitions
- Support both fingerprint and face ID
- Works with password managers

## 🔗 Related Issues
- Depends on: #[User registration], #[Verification]
- Blocks: #[Profile management]

## 📊 Definition of Done
- [ ] Password login functional
- [ ] Biometric login functional
- [ ] Token refresh automatic
- [ ] Tests passing
- [ ] Works on Android and iOS
- [ ] Secure storage implemented
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Auth] Implement forgot password flow",
        "body": """## 🎯 MVP Goal
Allow users to securely reset their password if forgotten.

## 📋 User Story
As a user who forgot my password, I want to reset it securely so that I can regain access to my account.

## ✅ Acceptance Criteria
- [ ] Forgot password link on login screen
- [ ] Email/phone input for reset request
- [ ] Send reset code via SMS/email
- [ ] Code verification screen
- [ ] New password input screen
- [ ] Password strength validation
- [ ] Confirm password field
- [ ] Success message
- [ ] Auto-login after reset
- [ ] Rate limiting on reset requests

## 🔧 Technical Implementation
- Create forgot password flow screens
- Integrate with password reset API
- Implement code verification
- Add password strength validator
- Handle rate limiting

## 🌐 API Endpoints
- `POST /api/auth/forgot-password` - Request reset
- `POST /api/auth/verify-reset-code` - Verify code
- `POST /api/auth/reset-password` - Set new password

## 🧪 Testing Requirements
- [ ] Unit tests: Password validation
- [ ] Widget tests: All flow screens
- [ ] Integration test: Complete reset flow
- [ ] Test rate limiting

## 📊 Definition of Done
- [ ] Flow works end-to-end
- [ ] Tests passing
- [ ] Rate limiting active
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P2: Medium", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Location] Implement GPS location tracking with battery optimization",
        "body": """## 🎯 MVP Goal
Accurate real-time location tracking with minimal battery drain for emergency responses.

## 📋 User Story
As a user in an emergency, I want my exact location automatically captured so that responders can find me quickly.

## ✅ Acceptance Criteria
- [ ] Request location permissions (when-in-use, always)
- [ ] Permission explanation screen
- [ ] Get current location (high accuracy)
- [ ] Background location updates during emergency
- [ ] Location accuracy indicator (GPS quality)
- [ ] Manual location entry fallback
- [ ] Location caching for offline use
- [ ] Battery-optimized tracking strategy
- [ ] Location updates every 5-10 seconds (emergency mode)
- [ ] Location updates every 30 seconds (tracking mode)
- [ ] Stop tracking when emergency ends

## 🔧 Technical Implementation
**Stack**: Flutter + geolocator + permission_handler
- Implement location service wrapper
- Handle iOS/Android permission differences
- Setup background location (foreground service Android)
- Implement battery optimization strategies
- Cache location data locally
- Add location accuracy detection

## 🌐 API Endpoints
- `POST /api/location/update` - Send location to backend

## 📦 Dependencies
- geolocator package
- permission_handler package
- hive (local caching)

## 🧪 Testing Requirements
- [ ] Unit tests: Location service logic
- [ ] Unit tests: Battery optimization logic
- [ ] Integration test: Foreground location
- [ ] Integration test: Background location
- [ ] Integration test: Permission handling
- [ ] Test battery consumption (profiling)
- [ ] Test location accuracy
- [ ] Test on multiple devices

## 📱 UI/UX Notes
- Clear permission rationale
- Location accuracy visual indicator
- Battery saver mode option
- GPS signal strength indicator

## 🔗 Related Issues
- Blocks: #[Emergency submission]
- Blocks: #[Maps integration]

## 📊 Definition of Done
- [ ] Foreground tracking works
- [ ] Background tracking works
- [ ] Battery optimized (<5% per hour)
- [ ] Tests passing
- [ ] Works on Android and iOS
- [ ] Permission handling correct
""",
        "labels": ["type: feature", "phase-1: foundation", "component: maps", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[API] Setup robust API client with authentication and error handling",
        "body": """## 🎯 MVP Goal
Production-ready API client infrastructure for reliable backend communication.

## 📋 User Story
As a developer, I want a well-structured API client so that backend integration is consistent and reliable.

## ✅ Acceptance Criteria
- [ ] Dio HTTP client configuration
- [ ] Base URL configuration (dev/staging/prod)
- [ ] Authentication interceptor (JWT tokens)
- [ ] Automatic token refresh on 401
- [ ] Retry logic for failed requests (3 attempts)
- [ ] Request/response logging (debug only)
- [ ] Network connectivity detection
- [ ] Timeout configuration (30s)
- [ ] SSL certificate pinning (production)
- [ ] Error response handling and mapping
- [ ] API response models with JSON serialization
- [ ] Offline request queue
- [ ] Request cancellation support

## 🔧 Technical Implementation
**Stack**: Flutter + Dio + Freezed + JSON Serializable
- Setup Dio with interceptors
- Implement auth interceptor
- Create API response models
- Implement retry logic
- Add network connectivity check
- Setup error handling
- Implement offline queue
- Add certificate pinning

## 🌐 API Endpoints
Base URL: `https://api.shongkot.com/v1`

## 📦 Dependencies
- dio package
- json_serializable
- freezed
- flutter_secure_storage
- connectivity_plus

## 🧪 Testing Requirements
- [ ] Unit tests: API client methods
- [ ] Unit tests: Interceptors
- [ ] Unit tests: Error handling
- [ ] Unit tests: Token refresh logic
- [ ] Mock API tests
- [ ] Test timeout handling
- [ ] Test retry logic
- [ ] Test offline queue

## 📱 Architecture Notes
- Clean architecture layers
- Repository pattern
- Dependency injection with Riverpod
- Type-safe API calls

## 🔗 Related Issues
- Blocks: #[Emergency submission]
- Blocks: #[All API-dependent features]

## 📊 Definition of Done
- [ ] API client fully functional
- [ ] Auth interceptor working
- [ ] Token refresh automatic
- [ ] Error handling comprehensive
- [ ] Tests passing (>85% coverage)
- [ ] Documentation complete
""",
        "labels": ["type: feature", "phase-1: foundation", "component: backend-integration", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Emergency] Implement real emergency submission to backend",
        "body": """## 🎯 MVP Goal
Core emergency alert submission system that sends SOS to backend with location and user data.

## 📋 User Story
As a user in an emergency, I want to instantly alert responders with my location so that help arrives quickly.

## ✅ Acceptance Criteria
- [ ] Submit emergency with type (crime/medical/fire/accident)
- [ ] Include current GPS location
- [ ] Include timestamp
- [ ] Include user profile data
- [ ] Receive emergency ID from backend
- [ ] Handle submission errors gracefully
- [ ] Retry failed submissions automatically
- [ ] Queue if offline (submit when online)
- [ ] Show submission status to user
- [ ] Navigate to emergency tracking screen
- [ ] Send to nearby responders
- [ ] Alert emergency contacts

## 🔧 Technical Implementation
**Stack**: Flutter + Riverpod + Hive (offline queue)
- Create emergency submission service
- Integrate with API client
- Implement offline queue with Hive
- Add retry logic with exponential backoff
- Store emergency ID for tracking
- Handle various error scenarios
- Add emergency status tracking

## 🌐 API Endpoints
- `POST /api/emergency` - Submit new emergency
- `GET /api/emergency/{id}` - Get emergency status
- `PUT /api/emergency/{id}/cancel` - Cancel emergency

## 📦 Dependencies
- API client
- Hive (offline storage)
- Location service

## 🧪 Testing Requirements
- [ ] Unit tests: Emergency repository
- [ ] Unit tests: Offline queue logic
- [ ] Unit tests: Retry logic
- [ ] Integration test: Successful submission
- [ ] Integration test: Offline scenario
- [ ] Integration test: Network error handling
- [ ] Integration test: Backend API

## 📱 UI/UX Notes
- Immediate feedback on submit
- Progress indicator
- Success confirmation
- Error messages with retry option
- Emergency ID displayed

## 🔗 Related Issues
- Depends on: #[API client], #[Location tracking]
- Blocks: #[Emergency tracking]

## 📊 Definition of Done
- [ ] Emergency submission works
- [ ] Offline queue functional
- [ ] Retry logic working
- [ ] Tests passing
- [ ] Error handling comprehensive
- [ ] Works on both platforms
""",
        "labels": ["type: feature", "phase-1: foundation", "component: emergency", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Emergency] Create emergency history screen with filtering",
        "body": """## 🎯 MVP Goal
View past emergencies with status tracking and filtering capabilities.

## 📋 User Story
As a user, I want to view my emergency history so that I can track past incidents and their outcomes.

## ✅ Acceptance Criteria
- [ ] List view of past emergencies
- [ ] Show type, date, time, status
- [ ] Status badges (pending/active/resolved/cancelled)
- [ ] Filter by status
- [ ] Filter by date range
- [ ] Search by location
- [ ] Sort by date (newest/oldest)
- [ ] Empty state with call-to-action
- [ ] Pull-to-refresh
- [ ] Infinite scroll pagination
- [ ] Tap to view details
- [ ] Loading states

## 🔧 Technical Implementation
- Create history list screen
- Fetch history from API
- Implement local caching
- Add filtering logic
- Setup pagination
- Handle empty states

## 🌐 API Endpoints
- `GET /api/emergency/history?status={status}&from={date}&to={date}&page={n}`

## 🧪 Testing Requirements
- [ ] Widget tests: List rendering
- [ ] Unit tests: Filtering logic
- [ ] Widget tests: Empty state
- [ ] Integration test: Pagination

## 📊 Definition of Done
- [ ] History displays correctly
- [ ] Filters work
- [ ] Pagination smooth
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-1: foundation", "component: emergency", "P2: Medium", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "[Profile] Implement user profile management",
        "body": """## 🎯 MVP Goal
Allow users to view and edit their profile information.

## ✅ Acceptance Criteria
- [ ] Profile screen with user info
- [ ] Edit profile screen
- [ ] Update name, email, phone
- [ ] Upload profile photo
- [ ] Update medical information
- [ ] Blood type, allergies, medications
- [ ] Emergency contact info
- [ ] Save changes to backend
- [ ] Form validation
- [ ] Loading states
- [ ] Success/error messages

## 🔧 Technical Implementation
- Create profile screens
- Implement image picker
- API integration for profile update
- Form validation
- Image upload to cloud storage

## 🌐 API Endpoints
- `GET /api/user/profile`
- `PUT /api/user/profile`
- `POST /api/user/profile/photo`

## 🧪 Testing Requirements
- [ ] Widget tests: Profile screens
- [ ] Unit tests: Validation logic
- [ ] Integration test: Profile update flow

## 📊 Definition of Done
- [ ] Profile view works
- [ ] Profile edit works
- [ ] Photo upload works
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P2: Medium", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
]

# ============================================================================
# PHASE 2: Communication & Notifications (Weeks 5-7)
# ============================================================================

PHASE_2_ISSUES = [
    {
        "title": "[Notifications] Setup Firebase Cloud Messaging",
        "body": """## 🎯 MVP Goal
Real-time push notifications for emergency updates and alerts.

## 📋 User Story
As a user, I want to receive instant notifications about my emergency status so that I'm always informed.

## ✅ Acceptance Criteria
- [ ] FCM setup in Firebase console
- [ ] Android FCM configuration
- [ ] iOS FCM configuration (APNs)
- [ ] Request notification permissions
- [ ] Handle foreground notifications
- [ ] Handle background notifications
- [ ] Handle terminated app notifications
- [ ] Notification tap handling (deep linking)
- [ ] Custom notification channels (Android)
- [ ] Custom notification sounds
- [ ] Notification vibration patterns
- [ ] Badge updates (iOS)
- [ ] Store FCM token on backend
- [ ] Token refresh handling
- [ ] Multi-device support

## 🔧 Technical Implementation
**Stack**: Firebase Cloud Messaging + flutter_local_notifications
- Setup FCM in both platforms
- Configure notification channels
- Implement foreground/background handlers
- Setup deep linking
- Store FCM tokens
- Handle token refresh

## 🌐 API Endpoints
- `POST /api/user/fcm-token` - Store device token
- `DELETE /api/user/fcm-token` - Remove device token

## 📦 Dependencies
- firebase_messaging
- firebase_core
- flutter_local_notifications

## 🧪 Testing Requirements
- [ ] Test foreground notifications
- [ ] Test background notifications
- [ ] Test notification tap
- [ ] Test custom sounds
- [ ] Test on both platforms
- [ ] Test multi-device scenarios

## 📱 UI/UX Notes
- Request permission with context
- Custom notification UI
- Action buttons in notifications
- Rich notifications with images

## 🔗 Related Issues
- Blocks: #[In-app notifications]
- Blocks: #[Emergency alerts]

## 📊 Definition of Done
- [ ] FCM fully configured
- [ ] Notifications delivered reliably
- [ ] Deep linking works
- [ ] Tests passing
- [ ] Works on Android and iOS
""",
        "labels": ["type: feature", "phase-2: communication", "component: notifications", "P0: Critical", "platform: both"],
        "milestone": "M2: Communication System"
    },
    {
        "title": "[Notifications] Implement in-app notification center",
        "body": """## 🎯 MVP Goal
Centralized notification inbox for all app notifications.

## 📋 User Story
As a user, I want to see all notifications in one place so that I don't miss important updates.

## ✅ Acceptance Criteria
- [ ] Notifications list screen
- [ ] Group by type (emergency/updates/system)
- [ ] Unread indicators
- [ ] Mark as read
- [ ] Delete notification
- [ ] Clear all
- [ ] Notification details view
- [ ] Deep link to related content
- [ ] Badge count on tab
- [ ] Pull-to-refresh
- [ ] Empty state
- [ ] Pagination

## 🔧 Technical Implementation
- Create notification center UI
- Store notifications locally (Hive)
- Sync with backend
- Handle deep links
- Update badge counts

## 🌐 API Endpoints
- `GET /api/notifications`
- `PUT /api/notifications/{id}/read`
- `DELETE /api/notifications/{id}`

## 🧪 Testing Requirements
- [ ] Widget tests: Notification list
- [ ] Unit tests: Badge count logic
- [ ] Widget tests: Mark as read
- [ ] Integration test: Full flow

## 📊 Definition of Done
- [ ] Notification center works
- [ ] Badge counts accurate
- [ ] Deep linking functional
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-2: communication", "component: notifications", "P1: High", "platform: both"],
        "milestone": "M2: Communication System"
    },
    {
        "title": "[Chat] Implement real-time chat with responders",
        "body": """## 🎯 MVP Goal
Live chat system for communication between users and responders during emergencies.

## 📋 User Story
As a user in an emergency, I want to chat with responders so that I can provide additional information.

## ✅ Acceptance Criteria
- [ ] Chat screen with message bubbles
- [ ] Send text messages
- [ ] Receive messages in real-time
- [ ] Typing indicators
- [ ] Read receipts (sent/delivered/read)
- [ ] Message timestamps
- [ ] Auto-scroll to latest
- [ ] Image/photo sharing
- [ ] Message status indicators
- [ ] Connection status
- [ ] Message history persistence
- [ ] Copy message text
- [ ] Report inappropriate messages

## 🔧 Technical Implementation
**Stack**: WebSocket / Firebase Realtime Database
- Implement chat UI
- Setup real-time messaging
- Message encryption
- Local message storage
- Offline message queue
- Image upload for sharing

## 🌐 API Endpoints
- `GET /api/chat/{emergency_id}/messages`
- `POST /api/chat/{emergency_id}/messages`
- WebSocket: `wss://api.shongkot.com/chat`

## 📦 Dependencies
- WebSocket client OR Firebase Realtime Database
- Image picker

## 🧪 Testing Requirements
- [ ] Widget tests: Chat UI
- [ ] Unit tests: Message logic
- [ ] Integration test: Send/receive
- [ ] Test offline queue
- [ ] Test image sharing

## 📊 Definition of Done
- [ ] Chat fully functional
- [ ] Real-time messaging works
- [ ] Image sharing works
- [ ] Tests passing
- [ ] Works offline
""",
        "labels": ["type: feature", "phase-2: communication", "component: chat", "P1: High", "platform: both"],
        "milestone": "M2: Communication System"
    },
    {
        "title": "[Contacts] Implement emergency contacts CRUD operations",
        "body": """## 🎯 MVP Goal
Complete emergency contacts management system.

## 📋 User Story
As a user, I want to manage my emergency contacts so that they're alerted during emergencies.

## ✅ Acceptance Criteria
- [ ] List emergency contacts
- [ ] Add new contact
- [ ] Edit contact
- [ ] Delete contact
- [ ] Set primary contact
- [ ] Import from device contacts
- [ ] Contact groups (family/friends/medical)
- [ ] Contact photo
- [ ] Multiple phone numbers
- [ ] Email addresses
- [ ] Verification status
- [ ] Sync with backend

## 🔧 Technical Implementation
- Create contacts CRUD screens
- Device contacts integration
- API integration
- Local caching
- Sync logic

## 🌐 API Endpoints
- `GET /api/contacts`
- `POST /api/contacts`
- `PUT /api/contacts/{id}`
- `DELETE /api/contacts/{id}`

## 📦 Dependencies
- contacts_service (device contacts)

## 🧪 Testing Requirements
- [ ] Widget tests: Contact screens
- [ ] Unit tests: CRUD logic
- [ ] Integration test: Full CRUD flow
- [ ] Test device contact import

## 📊 Definition of Done
- [ ] All CRUD operations work
- [ ] Device import works
- [ ] Sync functional
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-2: communication", "component: contacts", "P1: High", "platform: both"],
        "milestone": "M2: Communication System"
    },
    {
        "title": "[Contacts] Implement automatic SMS alerts to emergency contacts",
        "body": """## 🎯 MVP Goal
Automatically notify emergency contacts via SMS when emergency is triggered.

## ✅ Acceptance Criteria
- [ ] Send SMS to all emergency contacts
- [ ] Include emergency type
- [ ] Include user location link
- [ ] Include emergency ID
- [ ] SMS sent immediately on trigger
- [ ] Retry failed SMS
- [ ] Delivery status tracking
- [ ] SMS template customization
- [ ] Multi-language support
- [ ] Opt-in/opt-out for contacts

## 🔧 Technical Implementation
- Integrate with SMS gateway
- Create SMS templates
- Handle sending logic
- Track delivery status
- Retry mechanism

## 🌐 API Endpoints
- `POST /api/emergency/{id}/notify-contacts`

## 🧪 Testing Requirements
- [ ] Unit tests: SMS sending logic
- [ ] Integration test: SMS delivery
- [ ] Test retry mechanism

## 📊 Definition of Done
- [ ] SMS alerts work
- [ ] Delivery tracking works
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-2: communication", "component: contacts", "P1: High", "platform: both"],
        "milestone": "M2: Communication System"
    },
]

# ============================================================================
# PHASE 3: Responder Integration (Weeks 8-10)
# ============================================================================

PHASE_3_ISSUES = [
    {
        "title": "[Responders] Implement responder discovery with real-time location",
        "body": """## 🎯 MVP Goal
Find and display nearby emergency responders with real-time location updates.

## 📋 User Story
As a user in an emergency, I want to see nearby responders so that I can request the closest help.

## ✅ Acceptance Criteria
- [ ] Fetch nearby responders from backend
- [ ] Display responders in list view
- [ ] Show distance from user
- [ ] Show responder type (medical/fire/police)
- [ ] Show availability status
- [ ] Real-time location updates
- [ ] Filter by responder type
- [ ] Filter by availability
- [ ] Sort by distance
- [ ] Responder profile preview
- [ ] Refresh responder list
- [ ] Loading states
- [ ] Empty state if no responders

## 🔧 Technical Implementation
**Stack**: WebSocket for real-time updates
- Fetch responders from API
- Setup WebSocket connection
- Handle real-time location updates
- Calculate distances
- Implement filtering logic
- Cache responder data

## 🌐 API Endpoints
- `GET /api/responders/nearby?lat={lat}&lng={lng}&radius={km}&type={type}`
- WebSocket: `wss://api.shongkot.com/responders/live`

## 📦 Dependencies
- WebSocket client
- Location service

## 🧪 Testing Requirements
- [ ] Unit tests: Distance calculation
- [ ] Unit tests: Filtering logic
- [ ] Widget tests: Responder list
- [ ] Integration test: Fetch responders
- [ ] Test real-time updates

## 📊 Definition of Done
- [ ] Responder discovery works
- [ ] Real-time updates functional
- [ ] Filtering works
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-3: responders", "component: responders", "P0: Critical", "platform: both"],
        "milestone": "M3: Responder Integration"
    },
    {
        "title": "[Responders] Implement responder profile and details view",
        "body": """## 🎯 MVP Goal
Detailed responder profiles with ratings, reviews, and credentials.

## ✅ Acceptance Criteria
- [ ] Responder profile screen
- [ ] Name, photo, bio
- [ ] Responder type and specialty
- [ ] Years of experience
- [ ] Credentials and certifications
- [ ] Average rating
- [ ] Number of emergencies handled
- [ ] Reviews list
- [ ] Current availability
- [ ] Contact options
- [ ] Verify credentials badge

## 🔧 Technical Implementation
- Create profile screen
- Fetch profile data from API
- Display ratings and reviews
- Handle credential verification

## 🌐 API Endpoints
- `GET /api/responders/{id}`
- `GET /api/responders/{id}/reviews`

## 🧪 Testing Requirements
- [ ] Widget tests: Profile screen
- [ ] Unit tests: Data parsing
- [ ] Integration test: Profile loading

## 📊 Definition of Done
- [ ] Profile displays correctly
- [ ] All data shown
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-3: responders", "component: responders", "P1: High", "platform: both"],
        "milestone": "M3: Responder Integration"
    },
    {
        "title": "[Responders] Implement direct call and messaging to responders",
        "body": """## 🎯 MVP Goal
Enable direct communication with responders via call and message.

## ✅ Acceptance Criteria
- [ ] Call responder button
- [ ] Initiate phone call
- [ ] Send message button
- [ ] Open chat with responder
- [ ] Call history tracking
- [ ] Message history
- [ ] In-app calling option
- [ ] Emergency context shared
- [ ] Contact responder log

## 🔧 Technical Implementation
- Implement phone dialer integration
- Link to chat system
- Log interactions
- Share emergency context

## 🌐 API Endpoints
- `POST /api/emergency/{id}/contact-responder`

## 🧪 Testing Requirements
- [ ] Integration test: Call initiation
- [ ] Integration test: Message flow

## 📊 Definition of Done
- [ ] Call works
- [ ] Messaging works
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-3: responders", "component: responders", "P1: High", "platform: both"],
        "milestone": "M3: Responder Integration"
    },
    {
        "title": "[Responders] Implement responder rating and review system",
        "body": """## 🎯 MVP Goal
Allow users to rate and review responders after emergency resolution.

## ✅ Acceptance Criteria
- [ ] Rate responder (1-5 stars)
- [ ] Write review text
- [ ] Review categories (professionalism/response time/helpfulness)
- [ ] Upload photos (optional)
- [ ] Submit review
- [ ] Edit review
- [ ] Delete review
- [ ] View own reviews
- [ ] Report inappropriate reviews

## 🔧 Technical Implementation
- Create rating/review UI
- API integration
- Form validation
- Image upload

## 🌐 API Endpoints
- `POST /api/responders/{id}/reviews`
- `PUT /api/responders/{id}/reviews/{review_id}`
- `DELETE /api/responders/{id}/reviews/{review_id}`

## 🧪 Testing Requirements
- [ ] Widget tests: Rating UI
- [ ] Unit tests: Validation
- [ ] Integration test: Submit review

## 📊 Definition of Done
- [ ] Rating/review works
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-3: responders", "component: responders", "P2: Medium", "platform: both"],
        "milestone": "M3: Responder Integration"
    },
    {
        "title": "[Responders] Implement ETA tracking and responder dispatch status",
        "body": """## 🎯 MVP Goal
Track responder dispatch status and estimated time of arrival.

## ✅ Acceptance Criteria
- [ ] Show when responder dispatched
- [ ] Display ETA
- [ ] Real-time ETA updates
- [ ] Responder location on map
- [ ] Route visualization
- [ ] Dispatch status (en route/arrived/completed)
- [ ] Notifications on status change
- [ ] Cancel dispatch option

## 🔧 Technical Implementation
- Real-time status updates
- ETA calculation
- Map integration
- WebSocket for live updates

## 🌐 API Endpoints
- `GET /api/emergency/{id}/responder-status`
- WebSocket: Status updates

## 🧪 Testing Requirements
- [ ] Unit tests: ETA calculation
- [ ] Integration test: Status tracking

## 📊 Definition of Done
- [ ] ETA tracking works
- [ ] Real-time updates functional
- [ ] Tests passing
""",
        "labels": ["type: feature", "phase-3: responders", "component: responders", "P1: High", "platform: both"],
        "milestone": "M3: Responder Integration"
    },
]

# Continue with more phases...
# (I'll create a summary structure for remaining phases)

PHASE_4_SUMMARY = """
Phase 4: Maps & Navigation (Weeks 11-13)
- Google Maps / Mapbox integration
- Interactive map view with markers
- Turn-by-turn navigation to responders
- Route optimization with traffic
- Geofencing for safe zones
- Live location sharing
- Map theme support
- Offline map caching
"""

PHASE_5_SUMMARY = """
Phase 5: Media & Evidence (Weeks 14-15)
- In-app camera for photos
- Video recording
- Audio recording
- Media gallery
- Cloud storage integration
- Media compression
- Evidence documentation
- Timestamp verification
"""

PHASE_6_SUMMARY = """
Phase 6: Advanced Features (Weeks 16-18)
- AI emergency type detection
- Voice commands integration
- Family location sharing
- Safety check-ins
- Fake call feature
- Shake to trigger emergency
- Silent emergency mode
- Community safety alerts
"""

PHASE_7_SUMMARY = """
Phase 7: Platform & Polish (Weeks 19-21)
- iOS platform support
- iOS-specific UI adjustments
- iOS permissions handling
- iOS widgets
- Performance optimization
- Battery optimization
- Accessibility features
- High contrast mode
"""

PHASE_8_SUMMARY = """
Phase 8: Testing & Release (Weeks 22-24)
- Unit test suite (80%+ coverage)
- Widget test suite
- Integration tests
- E2E test automation
- Performance testing
- Security audit
- Beta testing program
- App store submission
"""

# Combine all issues
ALL_ISSUES = PHASE_1_ISSUES + PHASE_2_ISSUES + PHASE_3_ISSUES

def create_github_issue(issue: Dict) -> bool:
    """Create a GitHub issue using gh CLI"""
    try:
        # Build command
        cmd = [
            "gh", "issue", "create",
            "--title", issue["title"],
            "--body", issue["body"],
            "--label", ",".join(issue["labels"]),
        ]
        
        # Add milestone if specified
        if "milestone" in issue:
            cmd.extend(["--milestone", issue["milestone"]])
        
        # Execute command
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        print(f"✅ Created: {issue['title']}")
        print(f"   URL: {result.stdout.strip()}")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to create: {issue['title']}")
        print(f"   Error: {e.stderr}")
        return False
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

def main():
    print("=" * 80)
    print("Comprehensive GitHub Issues Generator for Shongkot Mobile App")
    print("=" * 80)
    print()
    
    # Check if gh CLI is available
    try:
        subprocess.run(["gh", "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("❌ Error: GitHub CLI (gh) is not installed or not in PATH")
        print("   Install from: https://cli.github.com/")
        sys.exit(1)
    
    # Check if authenticated
    try:
        subprocess.run(["gh", "auth", "status"], capture_output=True, check=True)
    except subprocess.CalledProcessError:
        print("❌ Error: Not authenticated with GitHub CLI")
        print("   Run: gh auth login")
        sys.exit(1)
    
    print(f"Found {len(ALL_ISSUES)} detailed issues to create")
    print()
    print("Issues breakdown:")
    print(f"  Phase 1 (Foundation): {len(PHASE_1_ISSUES)} issues")
    print(f"  Phase 2 (Communication): {len(PHASE_2_ISSUES)} issues")
    print(f"  Phase 3 (Responders): {len(PHASE_3_ISSUES)} issues")
    print()
    print("Note: This creates issues for Phases 1-3. Additional phases can be")
    print("      added incrementally as development progresses.")
    print()
    
    # Confirm with user
    response = input("Create these issues? (yes/no): ")
    if response.lower() not in ['yes', 'y']:
        print("Cancelled.")
        sys.exit(0)
    
    print()
    print("Creating issues...")
    print()
    
    # Create issues
    success_count = 0
    for issue in ALL_ISSUES:
        if create_github_issue(issue):
            success_count += 1
        print()
    
    # Summary
    print("=" * 80)
    print(f"Summary: {success_count}/{len(ALL_ISSUES)} issues created successfully")
    print("=" * 80)
    print()
    print("Next steps:")
    print("  1. Review issues on GitHub")
    print("  2. Assign issues to team members")
    print("  3. Add issues to project boards")
    print("  4. Start development with Phase 1 issues")
    print()
    
    if success_count < len(ALL_ISSUES):
        sys.exit(1)

if __name__ == "__main__":
    main()
