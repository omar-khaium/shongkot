#!/usr/bin/env bash
#
# Master Setup Script for GitHub Project Infrastructure
# 
# This script runs all setup scripts in the correct order:
# 1. Create GitHub Projects
# 2. Create Labels
# 3. Create Milestones
# 4. Generate Initial Issues
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo "════════════════════════════════════════════════════════════════════════════════"
echo "                   Shongkot Mobile App Development Setup"
echo "                        GitHub Project Infrastructure"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗ Error: GitHub CLI (gh) is not installed${NC}"
    echo ""
    echo "Please install GitHub CLI from: https://cli.github.com/"
    echo ""
    echo "Installation instructions:"
    echo "  macOS:   brew install gh"
    echo "  Linux:   See https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  Windows: See https://github.com/cli/cli/releases"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}✗ Error: Not authenticated with GitHub CLI${NC}"
    echo ""
    echo "Please authenticate with GitHub:"
    echo "  1. Run: gh auth login"
    echo "  2. Follow the prompts to authenticate"
    echo "  3. Enable 'project' scope: gh auth refresh -s project"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ Prerequisites met${NC}"
echo ""

# Function to run a script
run_script() {
    local script_path="$1"
    local script_name=$(basename "$script_path")
    
    echo ""
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│ Running: ${script_name}${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        bash "$script_path"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ ${script_name} completed successfully${NC}"
        else
            echo -e "${RED}✗ ${script_name} failed${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Script not found: ${script_path}${NC}"
        return 1
    fi
}

# Function to ask user if they want to continue
ask_continue() {
    local message="$1"
    echo ""
    echo -e "${YELLOW}${message}${NC}"
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
}

# Main setup flow
echo "Setup Steps:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo "  1. Create 3 GitHub Projects (Development, Bugs, Backend Integration)"
echo "  2. Create Labels (36+ labels for organization)"
echo "  3. Create Milestones (M1-M8 for 8 development phases)"
echo "  4. Generate Initial Issues (10 Phase 1 & 2 issues)"
echo ""

ask_continue "Ready to start setup?"

# Step 1: Create GitHub Projects
run_script "${SCRIPT_DIR}/setup_github_projects.sh"

# Step 2: Create Labels
ask_continue "Projects created. Ready to create labels?"
run_script "${SCRIPT_DIR}/create_github_labels.sh"

# Step 3: Create Milestones
ask_continue "Labels created. Ready to create milestones?"
run_script "${SCRIPT_DIR}/create_github_milestones.sh"

# Step 4: Generate Initial Issues
echo ""
echo -e "${YELLOW}Milestones created. Ready to generate initial issues?${NC}"
echo ""
echo "This will create 10 detailed issues for Phase 1 and Phase 2:"
echo "  Phase 1 (7 issues): Auth, Location, API Client, Emergency System"
echo "  Phase 2 (3 issues): Push Notifications, Messaging, Contacts"
echo ""
read -p "Generate issues now? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -f "${SCRIPT_DIR}/create_github_issues.py" ]; then
        python3 "${SCRIPT_DIR}/create_github_issues.py"
    else
        echo -e "${RED}✗ Issue generation script not found${NC}"
    fi
else
    echo "Skipping issue generation. You can run it later:"
    echo "  python3 scripts/create_github_issues.py"
fi

# Final summary
echo ""
echo "════════════════════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ GitHub Project Infrastructure Setup Complete!${NC}"
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo "What was created:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo "  ✓ 3 GitHub Projects (Development, Bugs, Backend Integration)"
echo "  ✓ 36+ Labels (Priority, Type, Phase, Component, Platform, Status)"
echo "  ✓ 8 Milestones (M1-M8 covering 24 weeks)"
echo "  ✓ 10 Initial Issues (if generated)"
echo ""
echo "Next Steps:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo ""
echo "1. Configure GitHub Projects"
echo "   • Visit: https://github.com/omar-khaium/shongkot/projects"
echo "   • Add custom fields (Priority, Phase, Component, etc.)"
echo "   • Set up views (By Phase, By Priority, By Component, By Assignee)"
echo "   • Configure automation workflows"
echo ""
echo "2. Review Generated Issues"
echo "   • Visit: https://github.com/omar-khaium/shongkot/issues"
echo "   • Verify labels and milestones are correct"
echo "   • Add issues to project boards"
echo "   • Assign issues to team members"
echo ""
echo "3. Start Development"
echo "   • Review: QUICK_START.md"
echo "   • Pick Phase 1 issues from the board"
echo "   • Follow the 6-step workflow"
echo "   • Track progress in GitHub Projects"
echo ""
echo "Documentation:"
echo "────────────────────────────────────────────────────────────────────────────────"
echo "  • MOBILE_APP_DEVELOPMENT_PLAN.md - Complete roadmap"
echo "  • GITHUB_PROJECTS_SETUP.md - Project management guide"
echo "  • QUICK_START.md - Developer quick reference"
echo "  • ROADMAP.md - Visual timeline"
echo ""
echo "════════════════════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}Ready to build a world-class emergency response platform! 🚀${NC}"
echo ""
