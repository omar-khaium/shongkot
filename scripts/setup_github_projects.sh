#!/usr/bin/env bash
#
# GitHub Project Setup Script for Shongkot Mobile App Development
# 
# This script creates 3 GitHub Projects with proper configuration:
# 1. Mobile App Development (Primary)
# 2. Bug Tracking (Secondary)
# 3. Backend Integration (Coordination)
#
# Prerequisites:
# - GitHub CLI (gh) installed
# - Authenticated with GitHub: gh auth login
# - Project scope enabled: gh auth refresh -s project
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get repository owner and name
REPO_OWNER="omar-khaium"
REPO_NAME="shongkot"

echo "════════════════════════════════════════════════════════════════════════════════"
echo "           GitHub Projects Setup for Shongkot Mobile App Development"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ Error: GitHub CLI (gh) is not installed${NC}"
    echo "  Install from: https://cli.github.com/"
    exit 1
fi

echo -e "${GREEN}✓ GitHub CLI is installed${NC}"

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}✗ Error: Not authenticated with GitHub CLI${NC}"
    echo "  Run: gh auth login"
    exit 1
fi

echo -e "${GREEN}✓ Authenticated with GitHub${NC}"

# Check if project scope is available
if ! gh auth status 2>&1 | grep -q "project"; then
    echo -e "${YELLOW}⚠ Warning: 'project' scope may not be enabled${NC}"
    echo "  If project creation fails, run: gh auth refresh -s project"
fi

echo ""
echo "────────────────────────────────────────────────────────────────────────────────"
echo "Creating GitHub Projects..."
echo "────────────────────────────────────────────────────────────────────────────────"
echo ""

# Function to create a project
create_project() {
    local title="$1"
    local description="$2"
    
    echo -e "${BLUE}Creating project: ${title}${NC}"
    
    # Create the project
    PROJECT_URL=$(gh project create \
        --owner "${REPO_OWNER}" \
        --title "${title}" \
        --format json 2>&1 | jq -r '.url' 2>/dev/null || echo "")
    
    if [ -z "$PROJECT_URL" ]; then
        echo -e "${RED}✗ Failed to create project: ${title}${NC}"
        return 1
    fi
    
    # Extract project number from URL
    PROJECT_NUMBER=$(echo "$PROJECT_URL" | grep -oP 'projects/\K[0-9]+')
    
    echo -e "${GREEN}✓ Created: ${title}${NC}"
    echo "  URL: ${PROJECT_URL}"
    echo "  Number: #${PROJECT_NUMBER}"
    
    # Link project to repository
    gh project link "${PROJECT_NUMBER}" --owner "${REPO_OWNER}" --repo "${REPO_NAME}" 2>/dev/null || true
    
    echo ""
    return 0
}

# Project 1: Mobile App Development (Primary Board)
create_project \
    "Mobile App Development" \
    "Primary board for tracking all mobile development work from planning to completion"

# Project 2: Bug Tracking
create_project \
    "Bug Tracking" \
    "Dedicated board for bug reports, triage, and resolution"

# Project 3: Backend Integration
create_project \
    "Backend Integration" \
    "Coordinate backend API development needed for mobile features"

echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ GitHub Projects created successfully!${NC}"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "Next Steps:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo ""
echo "1. Configure Project Boards"
echo "   • Add custom fields (Priority, Phase, Component, Platform, Status)"
echo "   • Set up views (By Phase, By Priority, By Component, By Assignee)"
echo "   • Configure automation workflows"
echo ""
echo "2. Create Labels"
echo "   Run: bash scripts/create_github_labels.sh"
echo ""
echo "3. Create Milestones"
echo "   • M1: MVP+ Foundation (Week 4)"
echo "   • M2: Communication System (Week 7)"
echo "   • M3: Responder Integration (Week 10)"
echo "   • M4: Maps & Navigation (Week 13)"
echo "   • M5: Media System (Week 15)"
echo "   • M6: Advanced Features (Week 18)"
echo "   • M7: Platform Polish (Week 21)"
echo "   • M8: Production Launch (Week 24)"
echo ""
echo "4. Generate Initial Issues"
echo "   Run: python3 scripts/create_github_issues.py"
echo ""
echo "5. Start Development"
echo "   • Review QUICK_START.md"
echo "   • Assign Phase 1 issues to team members"
echo "   • Begin with authentication system"
echo ""
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "For detailed setup instructions, see: GITHUB_PROJECTS_SETUP.md"
echo ""
