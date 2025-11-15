#!/usr/bin/env python3
"""
GitHub Issues Generator for Shongkot Mobile App Development

This script generates GitHub issues for all features in the development plan.
It organizes issues by phase, component, and priority.
"""

import os
import subprocess
import sys
from typing import Dict

# Check if we're in the right directory
if not os.path.exists('mobile/pubspec.yaml'):
    print("Error: Please run this script from the repository root")
    sys.exit(1)

# Phase 1: Foundation & Core Features
PHASE_1_ISSUES = [
    {
        "title": "Implement user registration with phone/email",
        "body": """## Description
Implement complete user registration flow with email and phone number support.

## User Story
As a new user, I want to register for an account using my email or phone number so that I can access the emergency response features.

## Acceptance Criteria
- [ ] User can register with email address
- [ ] User can register with phone number
- [ ] Form validation for email/phone format
- [ ] Password strength requirements (min 8 chars, uppercase, lowercase, number)
- [ ] Terms of service and privacy policy acceptance
- [ ] Error handling for duplicate accounts
- [ ] Success screen after registration
- [ ] Navigate to verification screen after successful registration

## Technical Notes
- Use Firebase Auth or custom backend API
- Implement form validation with proper error messages
- Store user data securely
- Handle network errors gracefully

## API Endpoints Required
- `POST /api/auth/register`

## Dependencies
- Firebase Auth SDK (or custom auth implementation)
- Form validation library

## Testing
- [ ] Unit tests for validation logic
- [ ] Widget tests for registration form
- [ ] Integration test for full registration flow
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P1: High", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "Implement SMS/Email verification",
        "body": """## Description
Implement verification system for email and phone number after registration.

## User Story
As a registered user, I want to verify my email/phone number so that I can secure my account and ensure I can be contacted in emergencies.

## Acceptance Criteria
- [ ] Send verification code via SMS for phone registration
- [ ] Send verification email for email registration
- [ ] OTP input screen with 6-digit code
- [ ] Resend verification code option
- [ ] Code expiration (5 minutes)
- [ ] Verification success confirmation
- [ ] Navigate to login or onboarding after verification
- [ ] Handle invalid/expired codes gracefully

## Technical Notes
- Use SMS gateway service (Twilio/AWS SNS)
- Email service (SendGrid/AWS SES)
- Implement rate limiting to prevent abuse
- Store verification status in user profile

## API Endpoints Required
- `POST /api/auth/verify`
- `POST /api/auth/resend-code`

## Dependencies
- SMS gateway integration
- Email service integration

## Testing
- [ ] Unit tests for code validation
- [ ] Widget tests for OTP input
- [ ] Integration test for verification flow
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P1: High", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "Implement login with biometric support",
        "body": """## Description
Create login screen with email/phone and password authentication, plus biometric login support.

## User Story
As a registered user, I want to login quickly using my fingerprint or face recognition so that I can access emergency features without typing my password.

## Acceptance Criteria
- [ ] Login form with email/phone and password
- [ ] "Remember me" option
- [ ] Biometric authentication option (fingerprint/face)
- [ ] Password visibility toggle
- [ ] Forgot password link
- [ ] Loading state during authentication
- [ ] Error handling for invalid credentials
- [ ] Navigate to home screen after successful login
- [ ] Biometric prompt with custom message
- [ ] Fallback to password if biometric fails

## Technical Notes
- Use local_auth package for biometric support
- Store credentials securely (Flutter Secure Storage)
- Implement token refresh mechanism
- Handle biometric availability check

## API Endpoints Required
- `POST /api/auth/login`
- `POST /api/auth/refresh`

## Dependencies
- local_auth package
- flutter_secure_storage package

## Testing
- [ ] Unit tests for login logic
- [ ] Widget tests for login form
- [ ] Integration test for login flow
- [ ] Test biometric authentication on physical device
""",
        "labels": ["type: feature", "phase-1: foundation", "component: auth", "P1: High", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "Implement GPS location tracking integration",
        "body": """## Description
Integrate real GPS location services for accurate location tracking during emergencies.

## User Story
As a user in an emergency, I want my exact location to be automatically captured and sent to responders so that they can find me quickly.

## Acceptance Criteria
- [ ] Request location permissions (when-in-use and always)
- [ ] Get current location with high accuracy
- [ ] Background location updates during emergency
- [ ] Location permission handling and educational screens
- [ ] Battery-optimized location tracking
- [ ] Location accuracy indicator (high/medium/low)
- [ ] Manual location entry fallback
- [ ] Location updates with configurable intervals
- [ ] Location caching for offline scenarios

## Technical Notes
- Use geolocator package
- Implement battery-efficient location strategy
- Handle location permissions properly for both platforms
- Different strategies for foreground/background tracking
- Comply with platform location policies

## Dependencies
- geolocator package
- permission_handler package

## Testing
- [ ] Unit tests for location service
- [ ] Integration test on physical device with GPS
- [ ] Test in various permission states
- [ ] Test battery consumption
- [ ] Test location accuracy
""",
        "labels": ["type: feature", "phase-1: foundation", "component: maps", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "Setup API client with Dio and authentication",
        "body": """## Description
Create robust API client infrastructure with proper authentication, error handling, and retry logic.

## User Story
As a developer, I want a well-structured API client so that I can easily integrate backend APIs and handle network operations reliably.

## Acceptance Criteria
- [ ] Setup Dio HTTP client with base configuration
- [ ] Authentication interceptor for token management
- [ ] Automatic token refresh on 401
- [ ] Retry logic for failed requests
- [ ] Request/response logging (debug mode only)
- [ ] Network connectivity detection
- [ ] Timeout configuration
- [ ] SSL certificate pinning (production)
- [ ] API response models with JSON serialization
- [ ] Error response handling and mapping

## Technical Notes
- Use Dio for HTTP client
- Implement interceptors for auth and logging
- Use freezed/json_serializable for models
- Store tokens in secure storage
- Handle different error scenarios (network, server, parsing)

## Dependencies
- dio package
- json_serializable
- freezed
- flutter_secure_storage

## Testing
- [ ] Unit tests for API client
- [ ] Unit tests for interceptors
- [ ] Mock API tests
- [ ] Test token refresh flow
- [ ] Test error handling
""",
        "labels": ["type: feature", "phase-1: foundation", "component: backend-integration", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "Implement real emergency submission to backend",
        "body": """## Description
Replace fake emergency repository with real API integration for emergency submission.

## User Story
As a user triggering an emergency, I want my emergency request to be sent to the backend server so that responders can receive and act on my alert.

## Acceptance Criteria
- [ ] Submit emergency with location to backend API
- [ ] Include emergency type and priority
- [ ] Attach location coordinates
- [ ] Receive emergency ID from backend
- [ ] Handle submission errors gracefully
- [ ] Retry failed submissions
- [ ] Queue emergency if offline (submit when online)
- [ ] Show submission status to user
- [ ] Navigate to emergency tracking screen after submission

## Technical Notes
- Use API client from previous task
- Implement offline queue with Hive
- Handle various error scenarios
- Store emergency ID for tracking

## API Endpoints Required
- `POST /api/emergency`

## Dependencies
- API client
- Hive for offline queue

## Testing
- [ ] Unit tests for emergency repository
- [ ] Integration test with backend
- [ ] Test offline scenario
- [ ] Test retry logic
- [ ] Test error handling
""",
        "labels": ["type: feature", "phase-1: foundation", "component: emergency", "P0: Critical", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
    {
        "title": "Create emergency history screen with filtering",
        "body": """## Description
Display user's past emergencies with status tracking and filtering options.

## User Story
As a user, I want to see my emergency history so that I can track past incidents and their resolution status.

## Acceptance Criteria
- [ ] List view of past emergencies
- [ ] Show emergency type, date, and status
- [ ] Status indicators (pending/active/resolved/cancelled)
- [ ] Filter by status
- [ ] Filter by date range
- [ ] Search by location or type
- [ ] Sort by date (newest/oldest)
- [ ] Empty state when no emergencies
- [ ] Pull-to-refresh
- [ ] Pagination for large lists
- [ ] Tap to view emergency details

## Technical Notes
- Fetch emergency history from backend
- Implement local caching for offline viewing
- Use Riverpod for state management
- Lazy loading for performance

## API Endpoints Required
- `GET /api/emergency/history?status={status}&from={date}&to={date}`

## Dependencies
- API client
- Hive for caching

## Testing
- [ ] Widget tests for list view
- [ ] Unit tests for filtering logic
- [ ] Test empty state
- [ ] Test pagination
""",
        "labels": ["type: feature", "phase-1: foundation", "component: emergency", "P2: Medium", "platform: both"],
        "milestone": "M1: MVP+ Foundation"
    },
]

# Phase 2: Communication & Notifications
PHASE_2_ISSUES = [
    {
        "title": "Setup Firebase Cloud Messaging for push notifications",
        "body": """## Description
Integrate Firebase Cloud Messaging to receive push notifications on both Android and iOS.

## User Story
As a user, I want to receive real-time notifications about my emergency status and responder updates so that I'm always informed.

## Acceptance Criteria
- [ ] Setup FCM in Firebase console
- [ ] Configure Android and iOS for FCM
- [ ] Request notification permissions
- [ ] Handle foreground notifications
- [ ] Handle background notifications
- [ ] Handle notification taps (deep linking)
- [ ] Custom notification channels (Android)
- [ ] Notification sounds and vibrations
- [ ] Badge updates (iOS)
- [ ] Store FCM token on backend
- [ ] Token refresh handling

## Technical Notes
- Use firebase_messaging package
- Setup notification channels for different types
- Handle iOS notification permissions
- Implement notification payload handling
- Test on both platforms

## Dependencies
- firebase_messaging package
- firebase_core package

## Testing
- [ ] Test notification delivery (foreground/background)
- [ ] Test notification tap handling
- [ ] Test custom sounds
- [ ] Test on both platforms
""",
        "labels": ["type: feature", "phase-2: communication", "component: notifications", "P0: Critical", "platform: both"],
        "milestone": "M2: Communication System"
    },
    {
        "title": "Implement in-app notification center",
        "body": """## Description
Create an in-app notification center to view and manage all notifications.

## User Story
As a user, I want to see all my notifications in one place so that I don't miss important updates about my emergencies.

## Acceptance Criteria
- [ ] Notifications list screen
- [ ] Group notifications by type (emergency/updates/system)
- [ ] Unread notification indicators
- [ ] Mark as read functionality
- [ ] Delete notification option
- [ ] Clear all notifications
- [ ] Notification details view
- [ ] Deep link to related content
- [ ] Badge count on tab bar
- [ ] Pull-to-refresh
- [ ] Empty state

## Technical Notes
- Store notifications locally in Hive
- Sync with backend notifications
- Update badge counts
- Handle notification interactions

## API Endpoints Required
- `GET /api/notifications`
- `PUT /api/notifications/{id}/read`
- `DELETE /api/notifications/{id}`

## Dependencies
- Hive for local storage

## Testing
- [ ] Widget tests for notification list
- [ ] Test mark as read
- [ ] Test delete functionality
- [ ] Test badge updates
""",
        "labels": ["type: feature", "phase-2: communication", "component: notifications", "P1: High", "platform: both"],
        "milestone": "M2: Communication System"
    },
    {
        "title": "Implement chat interface with responders",
        "body": """## Description
Create real-time chat interface for communication between users and responders during emergencies.

## User Story
As a user in an emergency, I want to chat with the responder so that I can provide additional information and coordinate the response.

## Acceptance Criteria
- [ ] Chat screen with message bubbles
- [ ] Send text messages
- [ ] Receive messages in real-time
- [ ] Typing indicators
- [ ] Read receipts (sent/delivered/read)
- [ ] Message timestamps
- [ ] Auto-scroll to latest message
- [ ] Image/photo sharing
- [ ] Message status indicators
- [ ] Connection status indicator
- [ ] Message history persistence
- [ ] Copy message text
- [ ] Report inappropriate messages

## Technical Notes
- Use WebSocket or Firebase Realtime Database for real-time messaging
- Implement message encryption
- Store chat history locally
- Handle offline messages with queue
- Optimize for performance with large message lists

## API Endpoints Required
- `GET /api/chat/{emergency_id}/messages`
- `POST /api/chat/{emergency_id}/messages`
- WebSocket endpoint for real-time updates

## Dependencies
- WebSocket client or Firebase Realtime Database

## Testing
- [ ] Widget tests for chat UI
- [ ] Test message sending
- [ ] Test real-time message reception
- [ ] Test offline queue
""",
        "labels": ["type: feature", "phase-2: communication", "component: chat", "P1: High", "platform: both"],
        "milestone": "M2: Communication System"
    },
]

# Define all issues
ALL_ISSUES = PHASE_1_ISSUES + PHASE_2_ISSUES

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
    print("GitHub Issues Generator for Shongkot Mobile App Development")
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
    
    print(f"Found {len(ALL_ISSUES)} issues to create")
    print()
    
    # Confirm with user
    response = input("Do you want to create these issues? (yes/no): ")
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
    
    if success_count < len(ALL_ISSUES):
        sys.exit(1)

if __name__ == "__main__":
    main()
