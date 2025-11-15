# Scripts Directory

This directory contains automation scripts for setting up and managing the Shongkot mobile app development infrastructure.

## Available Scripts

### 🚀 Master Setup Script

**`setup_all.sh`** - Run all setup scripts in order
```bash
bash scripts/setup_all.sh
```

This master script will:
1. Create 3 GitHub Projects
2. Create 36+ labels
3. Create 8 milestones
4. Generate 10 initial issues

**Prerequisites:**
- GitHub CLI (`gh`) installed
- Authenticated: `gh auth login`
- Project scope enabled: `gh auth refresh -s project`

---

### Individual Setup Scripts

#### **`setup_github_projects.sh`** - Create GitHub Projects
```bash
bash scripts/setup_github_projects.sh
```

Creates 3 GitHub Projects:
- **Mobile App Development** - Primary board for tracking all mobile development work
- **Bug Tracking** - Dedicated board for bug reports and fixes
- **Backend Integration** - Coordinate backend API development

#### **`create_github_labels.sh`** - Create Labels
```bash
bash scripts/create_github_labels.sh
```

Creates 36+ labels in 6 categories:
- **Priority:** P0 (Critical) → P3 (Low)
- **Type:** feature, bug, enhancement, refactor, docs, test
- **Phase:** phase-1 through phase-8
- **Component:** auth, emergency, contacts, responders, maps, notifications, chat, media, ui, backend-integration
- **Platform:** android, ios, both
- **Status:** blocked, needs-design, needs-api, needs-review, needs-triage

#### **`create_github_milestones.sh`** - Create Milestones
```bash
bash scripts/create_github_milestones.sh
```

Creates 8 milestones for development phases:
- M1: MVP+ Foundation (Week 4)
- M2: Communication System (Week 7)
- M3: Responder Integration (Week 10)
- M4: Maps & Navigation (Week 13)
- M5: Media System (Week 15)
- M6: Advanced Features (Week 18)
- M7: Platform Polish (Week 21)
- M8: Production Launch (Week 24)

#### **`create_github_issues.py`** - Generate Issues
```bash
python3 scripts/create_github_issues.py
```

Generates 10 detailed issues for Phase 1 and Phase 2:
- **Phase 1 (7 issues):**
  - User registration with phone/email
  - SMS/Email verification
  - Login with biometric support
  - GPS location tracking integration
  - API client setup with Dio
  - Real emergency submission to backend
  - Emergency history screen

- **Phase 2 (3 issues):**
  - Firebase Cloud Messaging setup
  - In-app notification center
  - Chat interface with responders

Each issue includes:
- Detailed description and user story
- Acceptance criteria checklist
- Technical implementation notes
- API endpoints required
- Dependencies
- Testing requirements
- Proper labels and milestone assignment

---

## Prerequisites

### Install GitHub CLI

**macOS:**
```bash
brew install gh
```

**Linux (Debian/Ubuntu):**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

**Windows:**
- Download from: https://github.com/cli/cli/releases

### Authenticate with GitHub

```bash
# Login to GitHub
gh auth login

# Enable project scope (required for creating projects)
gh auth refresh -s project

# Verify authentication
gh auth status
```

---

## Usage

### Quick Setup (Recommended)

Run the master setup script to create everything:

```bash
cd /path/to/shongkot
bash scripts/setup_all.sh
```

This will:
1. Check prerequisites
2. Create GitHub Projects
3. Create Labels
4. Create Milestones
5. Generate Initial Issues (optional)

### Manual Setup

If you prefer to run scripts individually:

```bash
# 1. Create Projects
bash scripts/setup_github_projects.sh

# 2. Create Labels
bash scripts/create_github_labels.sh

# 3. Create Milestones
bash scripts/create_github_milestones.sh

# 4. Generate Issues
python3 scripts/create_github_issues.py
```

---

## What Gets Created

### GitHub Projects (3)

| Project | Purpose | Columns |
|---------|---------|---------|
| Mobile App Development | Primary tracking | Backlog → Ready → In Progress → In Review → Done |
| Bug Tracking | Bug lifecycle | New → Triaged → In Progress → Fixed → Verified |
| Backend Integration | API coordination | API Needed → Backend Dev → API Ready → Integrated |

### Labels (36+)

| Category | Count | Examples |
|----------|-------|----------|
| Priority | 4 | P0: Critical, P1: High, P2: Medium, P3: Low |
| Type | 6 | type: feature, type: bug, type: enhancement |
| Phase | 8 | phase-1: foundation, phase-2: communication |
| Component | 10 | component: auth, component: emergency |
| Platform | 3 | platform: both, platform: android, platform: ios |
| Status | 5 | status: blocked, status: needs-api |

### Milestones (8)

| Milestone | Timeline | Focus |
|-----------|----------|-------|
| M1: MVP+ Foundation | Week 4 | Auth, Location, API |
| M2: Communication System | Week 7 | Notifications, Messaging |
| M3: Responder Integration | Week 10 | Discovery, Tracking |
| M4: Maps & Navigation | Week 13 | Maps, Navigation |
| M5: Media System | Week 15 | Photo/Video/Audio |
| M6: Advanced Features | Week 18 | AI, Social, Safety |
| M7: Platform Polish | Week 21 | iOS, Performance |
| M8: Production Launch | Week 24 | Testing, Beta, Launch |

### Initial Issues (10)

Phase 1 and Phase 2 issues with:
- ✅ Detailed descriptions
- ✅ User stories
- ✅ Acceptance criteria
- ✅ Technical notes
- ✅ Testing requirements
- ✅ Proper labels and milestones

---

## Troubleshooting

### Error: GitHub CLI not installed
```
✗ Error: GitHub CLI (gh) is not installed
```
**Solution:** Install gh CLI following the instructions above.

### Error: Not authenticated
```
✗ Error: Not authenticated with GitHub CLI
```
**Solution:** Run `gh auth login` and follow the prompts.

### Error: 'project' scope not enabled
```
⚠ Warning: 'project' scope may not be enabled
```
**Solution:** Run `gh auth refresh -s project` to enable the project scope.

### Error: Label already exists
```
⚠ Label already exists: P0: Critical
```
**Note:** This is not an error. The script skips existing labels.

### Error: Milestone already exists
```
⚠ Milestone already exists: M1: MVP+ Foundation
```
**Note:** This is not an error. The script skips existing milestones.

---

## After Running Scripts

### 1. Configure GitHub Projects

Visit: https://github.com/omar-khaium/shongkot/projects

For each project:
- Add custom fields (Priority, Phase, Component, Platform, Status)
- Create views:
  - By Phase (group by Phase label)
  - By Priority (group by Priority label)
  - By Component (group by Component label)
  - By Assignee (group by assignee)
- Set up automation:
  - Auto-add new issues to Backlog
  - Move to "In Progress" when assigned
  - Move to "In Review" when PR opened
  - Move to "Done" when PR merged

### 2. Review Issues

Visit: https://github.com/omar-khaium/shongkot/issues

- Verify labels are correct
- Check milestones are assigned
- Add issues to project boards
- Assign issues to team members

### 3. Start Development

- Review: **QUICK_START.md**
- Pick Phase 1 issues
- Follow 6-step workflow
- Track progress in GitHub Projects

---

## Additional Resources

- **MOBILE_APP_DEVELOPMENT_PLAN.md** - Complete 6-month roadmap
- **GITHUB_PROJECTS_SETUP.md** - Project management guide
- **QUICK_START.md** - Developer quick reference
- **ROADMAP.md** - Visual timeline

---

## Support

For issues with these scripts:
1. Check prerequisites are met
2. Verify authentication: `gh auth status`
3. Check script permissions: `chmod +x scripts/*.sh`
4. Review error messages carefully
5. Open an issue if problems persist

---

**Last Updated:** November 2025
