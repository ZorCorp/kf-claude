---
description: Create comprehensive articles/blog posts with auto-generated hero images
argument-hint: [topic or content]
allowed-tools:
  - Bash(date)
  - Write
  - Read
  - Task(*)
  - Skill(*)
  - mcp__MCP_DOCKER__obsidian_*
  - mcp__github-oauth-mcp__generateImage
---

## Task

Create a comprehensive article with auto-generated hero image.

**Input**: `$ARGUMENTS` (topic, outline, or existing content)
**Operation**: Article creation with hero image
**Today's Date**: Run `date "+%Y-%m-%d"` to get current date

**⚠️ You MUST call `mcp__MCP_DOCKER__obsidian_append_content` to save the file!**

## Process

### 1. Generate Hero Image (MANDATORY)

**Always generate a hero image first** using the `mcp__github-oauth-mcp__generateImage` tool:

- Craft a descriptive prompt based on the article topic
- The image should be modern, professional, and visually compelling
- Avoid text/words in the image
- Suitable for a blog/article header (wide, cinematic)
- Save result path as `images/{slug}-hero.jpg` in the vault

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

Read template first:
```bash
cat ~/.claude/plugins/marketplaces/kf-claude/kf-claude/templates/article-template.md
```

Use the template with:
- `{{TITLE}}` - Article title
- `{{DATE}}` - Current date (YYYY-MM-DD format)
- `{{SLUG}}` - Kebab-case filename slug
- `{{HERO_PATH}}` - Path to generated hero image (e.g. `images/{slug}-hero.jpg`)
- `{{CONTENT}}` - Flexible article body
- `{{TAGS}}` - Auto-generated tags based on content
- `{{SUMMARY}}` - 1-2 sentence summary

### 4. Save to Obsidian Vault

Use `mcp__MCP_DOCKER__obsidian_append_content` to save the file.

**Filename format:** `YYYY-MM-DD-{slug}.md`
**Location:** vault root

## Output Format

Markdown article with:
- ✅ Hero image embedded at top
- ✅ Flexible content structure
- ✅ Proper metadata (frontmatter)
- ✅ Relevant tags
- ✅ Date-prefixed filename

## Tag Taxonomy Reference

**Topics:** AI, productivity, knowledge-management, development, learning, research, writing, tools, business, design, automation, data-science, web-development, personal-growth, finance
**Status:** inbox (default for new articles)
**Metadata:** actionable, conceptual, inspiration, deep-dive, tutorial

## Examples

```bash
/kf-claude:article Building a scambaiting AI strategy
→ Generates hero: images/building-scambaiting-ai-strategy-hero.jpg
→ Creates: 2026-02-07-building-scambaiting-ai-strategy.md

/kf-claude:article How to use Developer Knowledge API
→ Generates hero: images/developer-knowledge-api-hero.jpg
→ Creates: 2026-02-07-how-to-use-developer-knowledge-api.md
```

## Important

- **Hero image is MANDATORY** - always generate before article
- **Flexible structure** - adapt to content, not forced sections
- **Auto-tag intelligently** - analyze content for relevant tags
