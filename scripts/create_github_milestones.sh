#!/usr/bin/env bash
#
# GitHub Milestones Setup Script for Shongkot Mobile App Development
# 
# This script creates 8 milestones corresponding to development phases
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
echo "         GitHub Milestones Setup for Shongkot Mobile App Development"
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

# Calculate due dates (relative to today)
TODAY=$(date +%Y-%m-%d)
WEEK_4=$(date -d "+4 weeks" +%Y-%m-%d 2>/dev/null || date -v+4w +%Y-%m-%d 2>/dev/null)
WEEK_7=$(date -d "+7 weeks" +%Y-%m-%d 2>/dev/null || date -v+7w +%Y-%m-%d 2>/dev/null)
WEEK_10=$(date -d "+10 weeks" +%Y-%m-%d 2>/dev/null || date -v+10w +%Y-%m-%d 2>/dev/null)
WEEK_13=$(date -d "+13 weeks" +%Y-%m-%d 2>/dev/null || date -v+13w +%Y-%m-%d 2>/dev/null)
WEEK_15=$(date -d "+15 weeks" +%Y-%m-%d 2>/dev/null || date -v+15w +%Y-%m-%d 2>/dev/null)
WEEK_18=$(date -d "+18 weeks" +%Y-%m-%d 2>/dev/null || date -v+18w +%Y-%m-%d 2>/dev/null)
WEEK_21=$(date -d "+21 weeks" +%Y-%m-%d 2>/dev/null || date -v+21w +%Y-%m-%d 2>/dev/null)
WEEK_24=$(date -d "+24 weeks" +%Y-%m-%d 2>/dev/null || date -v+24w +%Y-%m-%d 2>/dev/null)

# Function to create a milestone
create_milestone() {
    local title="$1"
    local description="$2"
    local due_date="$3"
    
    echo -e "${BLUE}Creating milestone: ${title}${NC}"
    
    # Check if milestone already exists
    if gh api repos/${REPO}/milestones 2>/dev/null | jq -r '.[].title' | grep -q "^${title}$"; then
        echo -e "${YELLOW}  ⚠ Milestone already exists: ${title}${NC}"
        echo ""
        return 0
    fi
    
    # Create the milestone
    if gh api repos/${REPO}/milestones -X POST \
        -f title="${title}" \
        -f description="${description}" \
        -f due_on="${due_date}T23:59:59Z" \
        -f state="open" &>/dev/null; then
        echo -e "${GREEN}  ✓ Created: ${title}${NC}"
        echo "    Due: ${due_date}"
    else
        echo -e "${RED}  ✗ Failed: ${title}${NC}"
    fi
    echo ""
}

echo "Creating Milestones..."
echo "────────────────────────────────────────────────────────────────────────────────"
echo ""

create_milestone \
    "M1: MVP+ Foundation" \
    "Core emergency features with backend integration: Authentication, Location Services, API Client, Emergency Submission & History. Deliverables: User auth, real location tracking, emergency submission, contact management, offline support." \
    "${WEEK_4}"

create_milestone \
    "M2: Communication System" \
    "Real-time communication features: Push Notifications, In-App Messaging, Emergency Contacts CRUD, Auto-alerts to contacts. Deliverables: FCM integration, chat system, contact sync, automated notifications." \
    "${WEEK_7}"

create_milestone \
    "M3: Responder Integration" \
    "Complete responder system: Discovery, Real-time Tracking, Rating & Reviews, Direct Communication. Deliverables: Responder finder, live tracking, interaction features, feedback system." \
    "${WEEK_10}"

create_milestone \
    "M4: Maps & Navigation" \
    "Interactive maps and navigation: Google Maps/Mapbox Integration, Turn-by-turn Navigation, Geofencing, Live Location Sharing. Deliverables: Map view, navigation, safe zones, location sharing." \
    "${WEEK_13}"

create_milestone \
    "M5: Media System" \
    "Media capture and management: Photo/Video Capture, Audio Recording, Cloud Storage, Evidence Documentation. Deliverables: Camera integration, media storage, gallery, evidence packaging." \
    "${WEEK_15}"

create_milestone \
    "M6: Advanced Features" \
    "Smart and social features: AI Emergency Detection, Voice Commands, Family Sharing, Safety Features (fake call, SOS timer). Deliverables: AI integration, voice control, social features, advanced safety tools." \
    "${WEEK_18}"

create_milestone \
    "M7: Platform Polish" \
    "iOS support and optimizations: iOS Implementation, Performance Optimization, Accessibility Features, Platform-specific Polish. Deliverables: iOS app, performance tuning, accessibility compliance, platform optimizations." \
    "${WEEK_21}"

create_milestone \
    "M8: Production Launch" \
    "Testing, beta, and release: Comprehensive Testing (80%+ coverage), Beta Program, App Store Submissions, Production Launch, Post-launch Monitoring. Deliverables: Tested app, beta feedback incorporated, store approvals, public launch." \
    "${WEEK_24}"

echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ GitHub Milestones created successfully!${NC}"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Milestone Schedule:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo "  M1: MVP+ Foundation          Due: ${WEEK_4}"
echo "  M2: Communication System     Due: ${WEEK_7}"
echo "  M3: Responder Integration    Due: ${WEEK_10}"
echo "  M4: Maps & Navigation        Due: ${WEEK_13}"
echo "  M5: Media System             Due: ${WEEK_15}"
echo "  M6: Advanced Features        Due: ${WEEK_18}"
echo "  M7: Platform Polish          Due: ${WEEK_21}"
echo "  M8: Production Launch        Due: ${WEEK_24}"
echo ""
echo "Next Steps:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo "1. Generate initial issues: python3 scripts/create_github_issues.py"
echo "2. Configure GitHub Projects with custom fields and views"
echo "3. Start Phase 1 development"
echo ""
