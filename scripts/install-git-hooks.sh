#!/usr/bin/env bash
# Install git hooks for the Shongkot project

set -euo pipefail

echo "🔧 Installing git hooks..."

# Method 1: Use git config to point to our custom hooks directory
git config core.hooksPath .githooks

echo "✅ Git hooks installed successfully!"
echo ""
echo "The following hooks are now active:"
echo "  - pre-commit: Checks Dart code formatting before commit"
echo ""
echo "To disable hooks temporarily, use: git commit --no-verify"
echo "To uninstall hooks, run: git config --unset core.hooksPath"
