#!/usr/bin/env bash
#
# GitHub Labels Setup Script for Shongkot Mobile App Development
# 
# This script creates all labels needed for project management:
# - Priority labels (P0-P3)
# - Type labels (feature, bug, etc.)
# - Phase labels (phase-1 through phase-8)
# - Component labels
# - Platform labels
# - Status labels
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

REPO="omar-khaium/shongkot"

echo "════════════════════════════════════════════════════════════════════════════════"
echo "           GitHub Labels Setup for Shongkot Mobile App Development"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ Error: GitHub CLI (gh) is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ GitHub CLI is installed${NC}"

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}✗ Error: Not authenticated with GitHub CLI${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Authenticated with GitHub${NC}"
echo ""

# Function to create a label
create_label() {
    local name="$1"
    local description="$2"
    local color="$3"
    
    # Check if label already exists
    if gh label list --repo "${REPO}" | grep -q "^${name}"; then
        echo -e "${YELLOW}  ⚠ Label already exists: ${name}${NC}"
        return 0
    fi
    
    # Create the label
    if gh label create "${name}" --repo "${REPO}" --description "${description}" --color "${color}" 2>/dev/null; then
        echo -e "${GREEN}  ✓ Created: ${name}${NC}"
    else
        echo -e "${RED}  ✗ Failed: ${name}${NC}"
    fi
}

echo "Creating Priority Labels..."
echo "────────────────────────────────────────────────────────────────────────────────"
create_label "P0: Critical" "Blocks release, must fix immediately" "d73a4a"
create_label "P1: High" "Important for release" "e99695"
create_label "P2: Medium" "Should have, but not blocking" "fbca04"
create_label "P3: Low" "Nice to have, can defer" "d4c5f9"
echo ""

echo "Creating Type Labels..."
echo "────────────────────────────────────────────────────────────────────────────────"
create_label "type: feature" "New feature" "0e8a16"
create_label "type: bug" "Something isn't working" "d73a4a"
create_label "type: enhancement" "Improve existing feature" "a2eeef"
create_label "type: refactor" "Code improvement" "1d76db"
create_label "type: docs" "Documentation" "0075ca"
create_label "type: test" "Testing related" "bfd4f2"
echo ""

echo "Creating Phase Labels..."
echo "────────────────────────────────────────────────────────────────────────────────"
create_label "phase-1: foundation" "Authentication, Location, API Integration" "c5def5"
create_label "phase-2: communication" "Notifications, Messaging, Contacts" "bfdadc"
create_label "phase-3: responders" "Responder discovery and interaction" "d4c5f9"
create_label "phase-4: maps" "Maps and navigation" "c2e0c6"
create_label "phase-5: media" "Photo/video/audio features" "f9d0c4"
create_label "phase-6: advanced" "Smart and social features" "fef2c0"
create_label "phase-7: platform" "iOS, Performance, Accessibility" "d1ecf1"
create_label "phase-8: release" "Testing, Beta, Production" "e1d8f0"
echo ""

echo "Creating Component Labels..."
echo "────────────────────────────────────────────────────────────────────────────────"
create_label "component: auth" "Authentication system" "006b75"
create_label "component: emergency" "Emergency features" "d73a4a"
create_label "component: contacts" "Contacts management" "0366d6"
create_label "component: responders" "Responder features" "5319e7"
create_label "component: maps" "Maps and location" "1d76db"
create_label "component: notifications" "Push notifications" "fbca04"
create_label "component: chat" "Messaging/chat" "d876e3"
create_label "component: media" "Photo/video/audio" "c5def5"
create_label "component: ui" "UI/UX improvements" "bfdadc"
create_label "component: backend-integration" "API integration" "0e8a16"
echo ""

echo "Creating Platform Labels..."
echo "────────────────────────────────────────────────────────────────────────────────"
create_label "platform: both" "Both Android and iOS" "ededed"
create_label "platform: android" "Android only" "a4c639"
create_label "platform: ios" "iOS only" "000000"
echo ""

echo "Creating Status Labels..."
echo "────────────────────────────────────────────────────────────────────────────────"
create_label "status: blocked" "Cannot proceed due to dependency" "b60205"
create_label "status: needs-design" "Needs design input" "d876e3"
create_label "status: needs-api" "Waiting for backend API" "fbca04"
create_label "status: needs-review" "Needs code review" "0e8a16"
create_label "status: needs-triage" "New issue, needs categorization" "d4c5f9"
echo ""

echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ GitHub Labels created successfully!${NC}"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Next Steps:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo "1. Create Milestones (M1-M8)"
echo "2. Generate initial issues: python3 scripts/create_github_issues.py"
echo "3. Configure GitHub Projects with custom fields and views"
echo ""
