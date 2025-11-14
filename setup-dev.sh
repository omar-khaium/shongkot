#!/bin/bash
# Setup script for Shongkot development environment
# This script configures git hooks and other development tools

set -e

echo "🚀 Setting up Shongkot development environment..."
echo ""

# Configure git hooks path
echo "📌 Configuring git hooks..."
git config core.hooksPath .githooks

echo "✅ Git hooks configured to use .githooks directory"
echo ""

# Make sure the pre-commit hook is executable
if [ -f ".githooks/pre-commit" ]; then
    chmod +x .githooks/pre-commit
    echo "✅ Pre-commit hook is executable"
else
    echo "⚠️  Pre-commit hook not found in .githooks/"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "The pre-commit hook will now:"
echo "  • Check code formatting (Dart/C#)"
echo "  • Run lint checks"
echo "  • Prevent commits with code quality issues"
echo ""
echo "To manually run checks before committing:"
echo "  • Flutter/Dart: cd mobile && dart format . && flutter analyze"
echo "  • C#: cd backend && dotnet format"
echo ""
echo "Happy coding! 🚀"
