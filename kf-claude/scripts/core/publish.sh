#!/bin/bash
# Publish Obsidian note to GitHub Pages (sharehub)
# Handles image copying and path conversion
# Usage: ./publish.sh NOTE_FILE [VAULT_PATH]

set -e  # Exit on error

NOTE_FILE="$1"
VAULT_PATH="${2:-$(pwd)}"

# Read config from vault
CONFIG_FILE="$VAULT_PATH/.claude/config.local.json"

if [[ -f "$CONFIG_FILE" ]]; then
    # Read paths from config
    SHAREHUB_PATH=$(jq -r '.sharehub_repo // empty' "$CONFIG_FILE" | sed "s|^~|$HOME|")
    SHAREHUB_URL=$(jq -r '.sharehub_url // empty' "$CONFIG_FILE")

    if [[ -z "$SHAREHUB_PATH" || "$SHAREHUB_PATH" == "null" ]]; then
        echo "❌ sharehub_repo not configured in .claude/config.local.json"
        echo "   Run /kf-claude:setup to configure"
        exit 1
    fi
else
    echo "❌ Config not found: $CONFIG_FILE"
    echo "   Run /kf-claude:setup first"
    exit 1
fi

# Default URL if not in config
SHAREHUB_URL="${SHAREHUB_URL:-https://sharehub.zorro.hk}"

# Check if using custom domain (no path prefix needed) or GitHub Pages subdirectory
if [[ "$SHAREHUB_URL" =~ github\.io/([^/]+) ]]; then
    # GitHub Pages: extract repo name for path prefix
    REPO_NAME="${BASH_REMATCH[1]}"
    IMAGE_PREFIX="/$REPO_NAME"
else
    # Custom domain: images at root
    REPO_NAME=""
    IMAGE_PREFIX=""
fi

echo "📂 Vault: $VAULT_PATH"
echo "📤 Sharehub: $SHAREHUB_PATH"
echo "🌐 URL: $SHAREHUB_URL"
echo ""

# Add .md extension if not provided
if [[ ! "$NOTE_FILE" =~ \.md$ ]]; then
    NOTE_FILE="${NOTE_FILE}.md"
fi

# Check if file exists in vault
if [[ ! -f "$VAULT_PATH/$NOTE_FILE" ]]; then
    echo "❌ Error: File not found: $NOTE_FILE"
    echo "Looking in: $VAULT_PATH/"
    exit 1
fi

# Check if sharehub exists
if [[ ! -d "$SHAREHUB_PATH" ]]; then
    echo "❌ Sharehub repo not found at: $SHAREHUB_PATH"
    echo "   Clone it first or update .claude/config.local.json"
    exit 1
fi

echo "✅ Found note: $NOTE_FILE"
echo ""

# Extract and copy referenced images
cd "$VAULT_PATH"

# Find all image references (macOS compatible)
IMAGE_PATHS=$(grep -o '!\[[^]]*\]([^)]*\.\(jpg\|jpeg\|png\|gif\|svg\|webp\))' "$NOTE_FILE" | sed 's/.*(\(.*\))/\1/' || true)

if [[ -n "$IMAGE_PATHS" ]]; then
    echo "📸 Found images to copy:"
    echo "$IMAGE_PATHS"
    echo ""

    # Copy each image to sharehub
    while IFS= read -r IMG_PATH; do
        # Skip if empty or URL (http/https)
        if [[ -z "$IMG_PATH" ]] || [[ "$IMG_PATH" =~ ^https?:// ]]; then
            continue
        fi

        # Normalize path (remove leading ./)
        CLEAN_PATH="${IMG_PATH#./}"

        # Source path in vault
        SRC="$VAULT_PATH/$CLEAN_PATH"

        # Destination path in sharehub (preserve directory structure)
        DEST="$SHAREHUB_PATH/$CLEAN_PATH"
        DEST_DIR=$(dirname "$DEST")

        if [[ -f "$SRC" ]]; then
            # Create destination directory if needed
            mkdir -p "$DEST_DIR"

            # Copy image
            cp "$SRC" "$DEST"
            echo "  ✅ Copied: $CLEAN_PATH"
        else
            echo "  ⚠️  Not found: $SRC"
        fi
    done <<< "$IMAGE_PATHS"
    echo ""
else
    echo "ℹ️  No local images found in note"
    echo ""
fi

# Read note content
NOTE_CONTENT=$(cat "$NOTE_FILE")

# Convert image paths for GitHub Pages using Python for reliable regex
# Custom domain: ./images/file.jpg → /images/file.jpg
# GitHub Pages: ./images/file.jpg → /repo/images/file.jpg
CONVERT_SCRIPT=$(mktemp)
cat > "$CONVERT_SCRIPT" << 'PYEOF'
import sys, re

content = sys.stdin.read()
image_prefix = sys.argv[1] if len(sys.argv) > 1 else ''
exts = r'\.(jpg|jpeg|png|gif|svg|webp)'

def convert_img(m):
    alt = m.group(1)
    path = m.group(2)
    # Skip URLs and already-absolute paths
    if path.startswith('http://') or path.startswith('https://') or path.startswith('/'):
        return m.group(0)
    # Strip leading ./
    if path.startswith('./'):
        path = path[2:]
    return f'![{alt}]({image_prefix}/{path})'

content = re.sub(r'!\[([^\]]*)\]\(([^)]+' + exts + r')\)', convert_img, content, flags=re.IGNORECASE)
print(content, end='')
PYEOF
CONVERTED_CONTENT=$(echo "$NOTE_CONTENT" | python3 "$CONVERT_SCRIPT" "$IMAGE_PREFIX")
rm -f "$CONVERT_SCRIPT"

echo "📝 Image path conversion complete"
echo ""

# Write converted content to sharehub
DEST_NOTE="$SHAREHUB_PATH/documents/$NOTE_FILE"
DEST_DIR=$(dirname "$DEST_NOTE")
mkdir -p "$DEST_DIR"
echo "$CONVERTED_CONTENT" > "$DEST_NOTE"

echo "✅ Copied note to: documents/$NOTE_FILE"
echo ""

# Git operations
cd "$SHAREHUB_PATH"

echo "📋 Git status:"
git status --short
echo ""

# Add all changes (document + images)
git add "documents/$NOTE_FILE"
git add images/ 2>/dev/null || true

# Get note title from frontmatter for commit message
NOTE_TITLE=$(grep -m1 '^title:' "documents/$NOTE_FILE" | sed 's/title: *["'"'"']*//;s/["'"'"']*$//' || echo "$NOTE_FILE")

# Commit
git commit -m "Publish: $NOTE_TITLE

- Published documents/$NOTE_FILE
- Copied associated images
- Converted image paths for GitHub Pages

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "⏳ Waiting for GitHub Pages deployment..."

# Build the published URL
PUBLISHED_URL="$SHAREHUB_URL/documents/${NOTE_FILE%.md}.html"

# Verify page is reachable (retry up to 18 times = 90 seconds)
MAX_RETRIES=18
RETRY_DELAY=5
RETRY_COUNT=0

while [[ $RETRY_COUNT -lt $MAX_RETRIES ]]; do
    RETRY_COUNT=$((RETRY_COUNT + 1))

    # Check if page is reachable (HTTP 200)
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$PUBLISHED_URL" 2>/dev/null || echo "000")

    if [[ "$HTTP_STATUS" == "200" ]]; then
        echo ""
        echo "✅ Published successfully!"
        echo ""
        echo "📄 URL: $PUBLISHED_URL"
        echo ""
        
        # Run post-publish verification
        VERIFY_SCRIPT="$(dirname "$0")/verify-publish.sh"
        if [[ -f "$VERIFY_SCRIPT" ]]; then
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            bash "$VERIFY_SCRIPT" "$NOTE_FILE" "$VAULT_PATH"
        fi
        
        exit 0
    fi

    echo "  Attempt $RETRY_COUNT/$MAX_RETRIES - Status: $HTTP_STATUS (waiting ${RETRY_DELAY}s...)"
    sleep $RETRY_DELAY
done

# If we get here, page wasn't reachable after all retries
echo ""
echo "⚠️  Published but page not yet reachable (GitHub Pages may still be deploying)"
echo ""
echo "📄 URL: $PUBLISHED_URL"
echo "⏱️  Check again in a minute"
echo ""

exit 0
