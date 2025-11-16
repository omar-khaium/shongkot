# GitHub Projects Setup Guide

This guide explains how to set up and use GitHub Projects for managing the Shongkot mobile app development.

## Table of Contents
- [Overview](#overview)
- [Quick Start](#quick-start)
- [Project Board Structure](#project-board-structure)
- [Creating Issues](#creating-issues)
- [Labels and Organization](#labels-and-organization)
- [Workflow](#workflow)
- [Milestones](#milestones)

## Overview

We use **GitHub Projects (Beta)** to track and manage all mobile app development work. The project board provides a visual way to see progress, prioritize work, and coordinate across features and phases.

### Benefits
- **Visual Progress Tracking**: See what's in progress, what's done, and what's next
- **Better Prioritization**: Organize work by priority, phase, and component
- **Team Coordination**: Everyone knows what others are working on
- **Automated Workflows**: Issues automatically move between columns based on status

## Quick Start

### 1. Access the Project Board

Navigate to the GitHub repository and click on the **Projects** tab, or go directly to:
- [Mobile App Development Board](https://github.com/omar-khaium/shongkot/projects)

### 2. Create Issues Using Templates

We have two issue templates:
- **🚀 Feature Request**: For new features (uses `.github/ISSUE_TEMPLATE/feature_request.yml`)
- **🐛 Bug Report**: For bugs (uses `.github/ISSUE_TEMPLATE/bug_report.yml`)

To create an issue:
1. Go to the [Issues tab](https://github.com/omar-khaium/shongkot/issues)
2. Click "New Issue"
3. Select a template
4. Fill out the form
5. Submit

### 3. Auto-Generate Phase 1 & 2 Issues

We've created a Python script to automatically generate issues for Phase 1 and Phase 2:

```bash
# From repository root
python3 scripts/create_github_issues.py
```

This will create 10 detailed issues with:
- Proper labels
- Milestones
- Acceptance criteria
- Technical notes
- Testing requirements

## Project Board Structure

### Board 1: Mobile App Development (Primary)

**Purpose**: Track all mobile development work from planning to completion.

#### Columns

| Column | Description | Automation |
|--------|-------------|------------|
| 📋 **Backlog** | All planned features and tasks not yet started | Issues created → auto-added here |
| 📝 **Ready for Development** | Prioritized, fully specified, ready to start | Manual move when ready |
| 🚧 **In Progress** | Currently being worked on | Auto-move when PR opened or assigned |
| 👀 **In Review** | Pull request open, needs code review | Auto-move when PR created |
| ✅ **Done** | Completed and merged to main branch | Auto-move when PR merged |

#### Views

1. **Board View** (Default)
   - Kanban-style columns
   - Drag and drop between columns
   - Quick status overview

2. **By Phase**
   - Group by: `phase-1: foundation`, `phase-2: communication`, etc.
   - See progress within each development phase
   - Identify phase bottlenecks

3. **By Priority**
   - Group by: `P0: Critical` → `P3: Low`
   - Focus on high-priority items first
   - Ensure critical issues are addressed

4. **By Component**
   - Group by: `component: auth`, `component: emergency`, etc.
   - See work distribution across components
   - Identify component-specific issues

5. **By Assignee**
   - Group by: Team member
   - Track individual workload
   - Balance work distribution

### Board 2: Bug Tracking (Secondary)

**Purpose**: Dedicated space for bug reports and fixes.

#### Columns

| Column | Description |
|--------|-------------|
| 🐛 **New** | Newly reported bugs, need triage |
| 🔍 **Triaged** | Validated, prioritized, assigned severity |
| 🔧 **In Progress** | Being actively fixed |
| ✅ **Fixed** | Fix merged, pending verification |
| ☑️ **Verified** | Confirmed fixed in testing/production |

### Board 3: Backend Integration (Coordination)

**Purpose**: Track backend API development needed for mobile features.

#### Columns

| Column | Description |
|--------|-------------|
| 📋 **API Needed** | Mobile team needs this API endpoint |
| 🚧 **Backend Dev** | Backend team is working on it |
| ✅ **API Ready** | API is deployed and documented |
| 🔗 **Integrated** | Mobile has integrated and tested the API |

## Creating Issues

### Using Issue Templates (Recommended)

1. Navigate to [Issues](https://github.com/omar-khaium/shongkot/issues)
2. Click **New Issue**
3. Choose a template:
   - **🚀 Feature Request** - For new features
   - **🐛 Bug Report** - For bugs
4. Fill out all required fields
5. Submit

### Using the Script (Bulk Creation)

For creating multiple issues at once (e.g., Phase 1 features):

```bash
# Make sure you're authenticated with gh CLI
gh auth status

# Run the script
cd /path/to/shongkot
python3 scripts/create_github_issues.py
```

The script will:
- ✅ Check authentication
- ✅ List all issues to be created
- ✅ Ask for confirmation
- ✅ Create issues with proper labels and milestones
- ✅ Provide URLs for created issues

### Manual Creation (Not Recommended)

If creating manually:
1. Include a clear, descriptive title
2. Use the format from templates
3. Add appropriate labels (see below)
4. Set milestone if applicable
5. Provide acceptance criteria
6. Include technical notes

## Labels and Organization

### Label Categories

#### Priority (Required for all issues)
- `P0: Critical` - Blocks release, must fix immediately
- `P1: High` - Important for release
- `P2: Medium` - Should have, but not blocking
- `P3: Low` - Nice to have, can defer

#### Type (Required)
- `type: feature` - New feature
- `type: bug` - Something isn't working
- `type: enhancement` - Improve existing feature
- `type: refactor` - Code improvement
- `type: docs` - Documentation
- `type: test` - Testing related

#### Phase (For features)
- `phase-1: foundation` - Authentication, Location, API
- `phase-2: communication` - Notifications, Messaging, Contacts
- `phase-3: responders` - Responder discovery and interaction
- `phase-4: maps` - Maps and navigation
- `phase-5: media` - Photo/video/audio features
- `phase-6: advanced` - Smart and social features
- `phase-7: platform` - iOS, Performance, Accessibility
- `phase-8: release` - Testing, Beta, Production

#### Component (Required)
- `component: auth` - Authentication system
- `component: emergency` - Emergency features
- `component: contacts` - Contacts management
- `component: responders` - Responder features
- `component: maps` - Maps and location
- `component: notifications` - Push notifications
- `component: chat` - Messaging/chat
- `component: media` - Photo/video/audio
- `component: ui` - UI/UX improvements
- `component: backend-integration` - API integration

#### Platform (Required for features)
- `platform: both` - Both Android and iOS
- `platform: android` - Android only
- `platform: ios` - iOS only

#### Status (As needed)
- `status: blocked` - Cannot proceed due to dependency
- `status: needs-design` - Needs design input before implementation
- `status: needs-api` - Waiting for backend API
- `status: needs-review` - Needs code review
- `status: needs-triage` - New issue, needs categorization

### Example Label Combinations

**High-priority authentication feature for both platforms:**
```
P1: High
type: feature
phase-1: foundation
component: auth
platform: both
```

**Critical emergency system bug on Android:**
```
P0: Critical
type: bug
component: emergency
platform: android
```

**Medium-priority UI enhancement:**
```
P2: Medium
type: enhancement
component: ui
platform: both
```

## Workflow

### 1. Planning Phase
- Create issues using templates or scripts
- Add to **Backlog** column
- Apply proper labels and milestones
- Prioritize based on development phase

### 2. Ready for Development
- Review issue details
- Ensure all acceptance criteria are clear
- Check for dependencies (APIs, design, etc.)
- Move to **Ready for Development**

### 3. Development
- Assign issue to yourself
- Move to **In Progress**
- Create feature branch: `feature/short-description`
- Implement feature with tests
- Commit regularly with clear messages

### 4. Code Review
- Open pull request referencing issue
- Issue automatically moves to **In Review**
- Request review from team member
- Address review comments
- Get approval

### 5. Completion
- Merge PR to `mobile` branch
- Issue automatically moves to **Done**
- Delete feature branch
- Update project board if needed

### 6. Release
- Mobile branch merged to `main` for release
- Close milestone when all issues complete
- Create release notes

## Milestones

We use milestones to track progress toward major goals:

### M1: MVP+ Foundation (Week 4)
**Goal**: Core emergency features with backend integration
- User authentication
- Real location tracking
- Emergency submission
- Contact management
- Offline support

**Issues**: ~7-10 issues

### M2: Communication System (Week 7)
**Goal**: Real-time communication features
- Push notifications
- In-app messaging
- Emergency contacts CRUD
- Auto-alerts to contacts

**Issues**: ~5-8 issues

### M3: Responder Integration (Week 10)
**Goal**: Complete responder system
- Responder discovery
- Real-time responder tracking
- Rating and reviews
- Direct communication

**Issues**: ~6-9 issues

### M4: Maps & Navigation (Week 13)
**Goal**: Interactive maps and navigation
- Google Maps integration
- Turn-by-turn navigation
- Geofencing and safe zones
- Live location sharing

**Issues**: ~6-8 issues

### M5: Media System (Week 15)
**Goal**: Media capture and management
- Photo/video capture
- Audio recording
- Cloud storage
- Evidence documentation

**Issues**: ~4-6 issues

### M6: Advanced Features (Week 18)
**Goal**: Smart and social features
- AI-powered detection
- Voice commands
- Family sharing
- Safety features

**Issues**: ~8-10 issues

### M7: Platform Polish (Week 21)
**Goal**: iOS support and optimizations
- iOS implementation
- Performance optimization
- Accessibility features
- Platform-specific polish

**Issues**: ~10-12 issues

### M8: Production Launch (Week 24)
**Goal**: Testing, beta, and release
- Comprehensive testing
- Beta program
- Store submissions
- Launch marketing

**Issues**: ~6-8 issues

## Best Practices

### For Issue Creators
1. ✅ Use issue templates
2. ✅ Provide clear acceptance criteria
3. ✅ Include technical notes and dependencies
4. ✅ Add relevant labels and milestone
5. ✅ Link related issues
6. ✅ Attach mockups or references if available

### For Developers
1. ✅ Review issue thoroughly before starting
2. ✅ Ask questions if anything is unclear
3. ✅ Update issue status regularly
4. ✅ Link PRs to issues
5. ✅ Check off acceptance criteria as completed
6. ✅ Add comments with progress updates

### For Reviewers
1. ✅ Review PRs within 24 hours
2. ✅ Test functionality thoroughly
3. ✅ Check acceptance criteria met
4. ✅ Verify tests are included
5. ✅ Provide constructive feedback
6. ✅ Approve or request changes clearly

## Automation

We use GitHub Actions for automation:

### Auto-Label PRs
- PRs automatically labeled based on files changed
- Android/iOS specific changes get platform labels

### Auto-Link Issues
- Mention issue number in PR description: `Fixes #123`
- Issue automatically closes when PR merges

### Auto-Move Cards
- Issues move to "In Review" when PR opened
- Issues move to "Done" when PR merged

### Status Checks
- All tests must pass before merge
- Code coverage threshold enforced
- Linting checks required

## Tips and Tricks

### Filtering Issues
```
# High priority auth issues
is:open label:"P1: High" label:"component: auth"

# Phase 1 features not started
is:open label:"phase-1: foundation" label:"type: feature" no:assignee

# Blocked issues
is:open label:"status: blocked"

# My assigned issues
is:open assignee:@me

# Issues in current milestone
is:open milestone:"M1: MVP+ Foundation"
```

### Keyboard Shortcuts
- `C` - Create new issue
- `G` + `I` - Go to Issues
- `G` + `P` - Go to Pull Requests
- `/` - Focus search bar

### Quick Actions
- Reference issues in commits: `git commit -m "Add login screen (#123)"`
- Close issues from PRs: "Fixes #123, Closes #124" in PR description
- Link related issues: "Related to #123" in issue body

## Getting Help

### Questions?
- Open a [Discussion](https://github.com/omar-khaium/shongkot/discussions)
- Ask in PR comments
- Check [MOBILE_APP_DEVELOPMENT_PLAN.md](../MOBILE_APP_DEVELOPMENT_PLAN.md)

### Need a New Label or Milestone?
- Open an issue with `type: docs` label
- Suggest the new label/milestone
- Provide use case and examples

### Reporting Process Issues?
- Create issue with `component: backend-integration` or `type: docs`
- Describe the problem
- Suggest improvements

---

**Last Updated**: November 2025  
**Version**: 1.0  
**Maintainer**: Omar Khaium (@omar-khaium)
