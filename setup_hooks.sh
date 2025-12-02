#!/bin/bash
# Setup Git hooks for automatic documentation updates

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_DIR="$REPO_ROOT/.githooks"
GIT_HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "🔧 Setting up Git hooks..."

# Create .git/hooks if it doesn't exist
mkdir -p "$GIT_HOOKS_DIR"

# Copy hooks
cp "$HOOKS_DIR/post-commit" "$GIT_HOOKS_DIR/post-commit"
cp "$HOOKS_DIR/pre-push" "$GIT_HOOKS_DIR/pre-push"

# Make executable
chmod +x "$GIT_HOOKS_DIR/post-commit"
chmod +x "$GIT_HOOKS_DIR/pre-push"

# Configure Git to use custom hooks directory
git config core.hooksPath .githooks

echo "✅ Git hooks installed successfully"
echo ""
echo "Hooks configured:"
echo "  - post-commit: Updates documentation after each commit"
echo "  - pre-push: Verifies documentation before pushing"
echo ""
echo "To manually run documentation update:"
echo "  python3 update_docs.py"
