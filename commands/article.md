---
description: Create comprehensive articles/blog posts with auto-generated hero images
argument-hint: [topic or content]
allowed-tools:
  - Bash(date)
  - WriteFile
  - ReadFile
  - SlashCommand(/generate-image)
  - sessions_spawn
---

## Task

Create a comprehensive article with auto-generated hero image.

**Input**: `$ARGUMENTS` (topic, outline, or existing content)

## Process

### 1. Generate Hero Image (MANDATORY)

**Spawn a background subagent to generate the hero image using the Task tool.**

**CRITICAL: Use `mode: "bypassPermissions"` — background agents cannot get interactive Bash approval.**

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Generate hero image"
  mode: "bypassPermissions"
  run_in_background: true
  prompt: |
    Generate a hero image for an article titled: [TITLE]
    Topic: [BRIEF TOPIC DESCRIPTION]

    Run this command:
    GEMINI_API_KEY="$GEMINI_API_KEY" /Users/zorro/.claude/skills/gemini-image-generator/scripts/venv/bin/python3 \
      /Users/zorro/.claude/skills/gemini-image-generator/scripts/generate.py \
      --prompt "[DESCRIPTIVE IMAGE PROMPT - no text/words, modern, professional, vibrant]" \
      --output "/Users/zorro/Documents/Obsidian/Claudecode/images/{slug}-hero.jpg" \
      --size 2K

    If GEMINI_API_KEY is not in env, read it from ~/.openclaw/openclaw.json under env.GEMINI_API_KEY.
    Return the saved image path.
```

**Image prompt strategy:**
- Focus on visual metaphors and concepts
- Use descriptive, evocative language
- Specify professional/modern aesthetic
- Include relevant objects, scenes, or abstract concepts
- Example: "A futuristic drone with 360° camera hovering above a bustling city plaza at golden hour, cinematic lighting, professional photography"

**Wait for image generation to complete before proceeding.**

### 2. Structure Content

Analyze input and organize into natural sections:

**Common patterns (adapt as needed):**
- Introduction / Overview
- Core concepts / Main content
- Examples / Case studies
- Implementation / How-to (if applicable)
- Implications / Analysis
- Conclusion / Takeaways

**DO NOT force rigid structure** - let content dictate organization.

### 3. Apply Template

Use `article-template.md` with:
- `{{TITLE}}` - Article title
- `{{DATE}}` - Current date (YYYY-MM-DD format)
- `{{SLUG}}` - Kebab-case filename slug
- `{{HERO_PATH}}` - Path to generated hero image
- `{{CONTENT}}` - Flexible article body
- `{{TAGS}}` - Auto-generated tags based on content
- `{{SUMMARY}}` - 1-2 sentence summary

### 4. Save to Obsidian Vault

**Filename format:** `YYYY-MM-DD-{slug}.md`
**Location:** `~/Documents/Obsidian/Claudecode/`

## Output Format

Markdown article with:
- ✅ Hero image embedded at top
- ✅ Flexible content structure
- ✅ Proper metadata (frontmatter)
- ✅ Relevant tags
- ✅ Date-prefixed filename

## Examples

```bash
/kf-claude:article Building a scambaiting AI strategy
→ Generates hero: scambaiting-ai-strategy-hero.jpg
→ Creates: 2026-02-07-building-scambaiting-ai-strategy.md

/kf-claude:article How to use Developer Knowledge API
→ Generates hero: developer-knowledge-api-hero.jpg
→ Creates: 2026-02-07-how-to-use-developer-knowledge-api.md
```

## Important

- **Hero image is MANDATORY** - always generate before article
- **Flexible structure** - adapt to content, not forced sections
- **Auto-tag intelligently** - analyze content for relevant tags
- **Use subagent for image** - always spawn with `mode: "bypassPermissions"` to avoid background permission denial
