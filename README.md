# KnowledgeFactory for Claude Code for Claude Code

> **AI-powered knowledge management plugin for Obsidian vaults using Claude Code**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/ZorroCheng-MC/kf-claude-plugin)](https://github.com/ZorroCheng-MC/kf-claude-plugin/releases)
[![GitHub Actions](https://github.com/ZorroCheng-MC/kf-claude-plugin/workflows/Release/badge.svg)](https://github.com/ZorroCheng-MC/kf-claude-plugin/actions)

## What This Plugin Does

This plugin supercharges your Obsidian vault with AI-powered automation through Claude Code:

- 📝 **Universal Content Capture** - Save YouTube videos, GitHub repos, web articles, and quick ideas with a single command
- 🏷️ **AI Auto-Tagging** - Automatically categorize notes using smart tags (no manual tagging needed)
- 📚 **Study Guide Generation** - Turn any content into structured learning materials
- 🔍 **Semantic Search** - Find notes by meaning, not just keywords
- 🌐 **GitHub Pages Publishing** - Publish notes to the web with password protection
- 🔗 **Note Sharing** - Share notes via URL-encoded links without server storage
- 🎯 **Smart Templates** - Pre-built templates for videos, articles, ideas, and repositories

**[See Full Feature List & Examples →](https://zorrocheng-mc.github.io/sharehub/documents/kf-claude-plugin/PLUGIN_FEATURES.html)**

---

## Complete Setup Guide

For the **complete end-to-end setup** of the entire KnowledgeFactory system (Claude Code, Obsidian, Docker MCP, this plugin, and publishing), see:

**📘 [KnowledgeFactory Quick Setup Cheatsheet](https://zorrocheng-mc.github.io/sharehub/documents/KnowledgeFactory/KnowledgeFactory-Quick-Setup-Cheatsheet.html)**

The cheatsheet provides a holistic view including:
- All prerequisite installations (Claude Pro/Max, Docker Desktop, Obsidian, Claude Code)
- Complete Obsidian plugin setup (MCP Tools, Terminal, Smart Connections, Templater)
- Docker MCP server configuration with API keys
- GitHub Pages publishing setup
- Three-tier publishing model (Private, Trusted Circle, Public)


This README focuses specifically on **plugin installation and commands**.

---

## Requirements (Install These First!)

Before installing this plugin, you need:

### 1. Claude Pro or Max Subscription

- **Required**: Claude Pro ($20/mo) or Claude Max ($50/mo)
- **Sign up**: [claude.ai/upgrade](https://claude.ai/upgrade)
- Provides access to Claude Code and advanced AI capabilities

### 2. Desktop Applications

**Claude Code**
- Download from [claude.ai/code](https://claude.ai/code)
- Install and sign in with Claude Pro/Max account

**Obsidian**
- Download from [obsidian.md/download](https://obsidian.md/download)
- Install, launch once, create or open your vault

**Docker Desktop**
- Download from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)
- Install and start Docker Desktop
- Verify: `docker --version`

### 3. Required Obsidian Plugins

Install these in **Obsidian → Settings → Community plugins** (turn off Safe Mode first):

1. **MCP Tools** - Core MCP integration (click "Install Server" button after enabling)
2. **Local REST API** - Auto-installed by MCP Tools, verify it's enabled
3. **Terminal** - Integrated terminal in Obsidian (by polyipseity)
4. **Smart Connections** - Semantic search (required for `/semantic-search` command)
5. **Templater** - Advanced templates (required for advanced `/capture` templates)

**CRITICAL**: After installing MCP Tools + Local REST API:
- Go to **Settings → Community plugins → Local REST API → Copy API Key**
- Save this key - you'll need it for Docker MCP Obsidian server configuration

### 4. Docker MCP Servers

Install via **Docker Desktop → MCP Toolkit → Catalog**:

**Required (3):**
- **GitHub Official** (needs API key from [github.com/settings/tokens](https://github.com/settings/tokens))
- **YouTube Transcripts** (no API key needed)
- **Obsidian** (needs Local REST API key from step 3)

**Recommended (3):**
- **Firecrawl** (needs API key from [firecrawl.dev](https://firecrawl.dev), 1000 free/month)
- **Context7** (no API key needed)
- **Fetch (Reference)** (no API key needed)

**Optional (2):**
- **Memory (Reference)** (no API key needed)
- **Perplexity** (needs API key from [perplexity.ai/settings/api](https://perplexity.ai/settings/api))

**After installing servers:**
1. Configure API keys in **Docker Desktop → MCP Toolkit → My servers** (click server → add keys → save & restart)
2. Connect to Claude Code: **MCP Toolkit → Clients → Claude Code → Connect**
3. Verify all servers show green status

### 5. System Tools

Required for `/publish` command:

```bash
# macOS
brew install git jq

# Linux
sudo apt install git jq

# Windows
choco install git jq
```

**For detailed setup with screenshots and troubleshooting**, see the [KnowledgeFactory Quick Setup Cheatsheet](https://zorrocheng-mc.github.io/sharehub/documents/KnowledgeFactory/KnowledgeFactory-Quick-Setup-Cheatsheet.html).

---

## Installation

### Step 1: Add Plugin Marketplace

In your terminal, start Claude Code and add this plugin's marketplace:

```bash
# Navigate to your Obsidian vault
cd ~/Documents/Obsidian/YourVault

# Start Claude Code
claude

# Add plugin marketplace
/plugin marketplace add ZorroCheng-MC/kf-claude
```

### Step 2: Install the Plugin

**Option A: Browse and Install (Recommended)**

```bash
# Browse available plugins interactively
/plugin
```

This opens an interactive menu where you can:
- See all available plugins from configured marketplaces
- Read plugin descriptions
- See installation status
- Install with one selection

**Option B: Direct Install**

```bash
# Install directly by specifying marketplace
/plugin install kf-claude@ZorroCheng-MC/kf-claude
```

### Step 3: Verify Installation

```bash
# List installed plugins
/plugin list
```

You should see `kf-claude` in the list.

---

## Quick Start

### 1️⃣ Navigate to Your Vault

```bash
# Go to your Obsidian vault directory
cd ~/Documents/Obsidian/YourVault

# Start Claude Code
claude
```

### 2️⃣ Run Setup Wizard

```bash
# Inside Claude Code, run:
/setup
```

The setup wizard will:
- ✅ Detect your vault path automatically
- ✅ Check for required dependencies (git, jq)
- ✅ Prompt for sharehub path (if using `/publish` command)
- ✅ Generate configuration files (`.claude/settings.local.json`, `.claude/config.sh`)
- ✅ Validate everything works

### 3️⃣ Start Using Commands!

```bash
# Capture a YouTube video
/youtube-note https://youtube.com/watch?v=abc123

# Analyze a GitHub repository
/gitingest https://github.com/user/repo

# Quick idea capture
/idea Use AI to automatically organize my notes

# Publish a note to GitHub Pages
/publish my-note.md
```

**That's it!** You're ready to use the plugin.

---

## Available Commands

| Command | Description | Example |
|---------|-------------|---------|
| `/setup` | Interactive setup wizard | `/setup` |
| `/capture` | Universal content capture (YouTube, GitHub, articles, ideas) | `/capture https://youtube.com/watch?v=abc` |
| `/youtube-note` | Capture YouTube video with transcript | `/youtube-note https://youtube.com/watch?v=abc` |
| `/gitingest` | Analyze GitHub repository | `/gitingest https://github.com/user/repo` |
| `/idea` | Quick idea capture with AI tagging | `/idea Use AI to organize notes` |
| `/study-guide` | Generate study guide from content | `/study-guide my-note.md` |
| `/semantic-search` | Find notes by meaning | `/semantic-search "productivity tips"` |
| `/bulk-auto-tag` | Bulk AI tagging for existing notes | `/bulk-auto-tag "*.md"` |
| `/publish` | Publish note to GitHub Pages | `/publish my-note.md` |
| `/share` | Share note via URL-encoded link (no server storage) | `/share my-note.md` |

**[See detailed command documentation with examples →](https://zorrocheng-mc.github.io/sharehub/documents/kf-claude-plugin/PLUGIN_FEATURES.html)**

---

## Basic Usage

### Capture Content

**Capture anything with one command:**

```bash
# YouTube video
/youtube-note https://youtube.com/watch?v=abc123

# GitHub repository
/gitingest https://github.com/user/repo

# Quick idea
/idea Use AI to automatically organize my notes
```

The plugin will:
1. Analyze the content type
2. Fetch the content (transcript, code, article text)
3. Generate a formatted note with frontmatter
4. Apply AI-powered tags automatically
5. Save to your vault

### Publish to Web

```bash
# Publish a note to GitHub Pages
/publish my-article.md

# Publish with password protection
# (Just add "access: private" to frontmatter)
```

### Generate Study Guides

```bash
# Create a study guide from a note
/study-guide my-note.md

# Or from a URL
/study-guide https://example.com/article
```

### Semantic Search

```bash
# Find notes by meaning (requires Smart Connections plugin)
/semantic-search "notes about productivity workflows"
```

**[See More Examples & Command Details →](https://zorrocheng-mc.github.io/sharehub/documents/kf-claude-plugin/PLUGIN_FEATURES.html)**

---

## How It Works

This plugin adds **slash commands** to Claude Code that work inside your Obsidian vault:

```
Your Vault/
├── .claude/
│   ├── settings.local.json  ← Plugin configuration (auto-generated by /setup)
│   └── config.sh            ← Script settings (auto-generated by /setup)
└── your-notes.md
```

When you run `/capture`, `/youtube-note`, or other commands, Claude Code:
1. Uses AI to understand the content
2. Fetches data via MCP servers (transcripts, code, articles)
3. Applies smart templates
4. Tags automatically using predefined taxonomy
5. Saves to your vault in markdown format

**No manual work needed** - just run the command and get organized notes!

---

## Troubleshooting

### Plugin not found

```bash
# Verify marketplace was added
/plugin marketplace list

# Should show: ZorroCheng-MC/kf-claude-plugin

# If not, add it again
/plugin marketplace add ZorroCheng-MC/kf-claude-plugin
```

### Commands not working

```bash
# Run setup wizard again
cd /path/to/vault
claude
/setup

# Verify MCP servers are connected
# Check Docker Desktop → MCP Toolkit → My servers (all should be green)
```

### MCP Servers Not Connected

1. Open **Docker Desktop → MCP Toolkit → Clients**
2. Find **Claude Code** → Click **Disconnect** then **Connect**
3. Go to **My servers** tab → verify all servers show green status
4. Restart Claude Code

### Need help?

- **Complete Setup Guide**: [KnowledgeFactory Quick Setup Cheatsheet](https://zorrocheng-mc.github.io/sharehub/documents/KnowledgeFactory/KnowledgeFactory-Quick-Setup-Cheatsheet.html)
- **Command Documentation**: [PLUGIN_FEATURES.html](https://zorrocheng-mc.github.io/sharehub/documents/kf-claude-plugin/PLUGIN_FEATURES.html)
- **Developer Guide**: [DEVELOPER.md](DEVELOPER.md)
- **Open an Issue**: [github.com/ZorroCheng-MC/kf-claude-plugin/issues](https://github.com/ZorroCheng-MC/kf-claude-plugin/issues)

---

## For Plugin Developers

This repository serves as a **reference implementation** for building Claude Code plugins. It demonstrates:

- ✅ Automated releases with GitHub Actions (no manual publishing)
- ✅ Configuration patterns for cross-platform compatibility
- ✅ Interactive setup wizards for great UX
- ✅ Conversational development approach
- ✅ MCP server integration patterns

**Want to build your own plugin?** See [DEVELOPER.md](DEVELOPER.md) for the complete technical guide.

---

## Contributing & Support

**Found a bug?** [Open an issue](https://github.com/ZorroCheng-MC/kf-claude-plugin/issues)

**Want to contribute?** PRs welcome! See [CONTRIBUTING.md](CONTRIBUTING.md)

**Need help?** Check the [KnowledgeFactory Quick Setup Cheatsheet](https://zorrocheng-mc.github.io/sharehub/documents/KnowledgeFactory/KnowledgeFactory-Quick-Setup-Cheatsheet.html) for comprehensive documentation.

---

## License & Credits

**License:** [MIT License](LICENSE) - Free to use and modify

**Created by:** [Zorro Cheng](https://github.com/ZorroCheng-MC)

**Built with:**
- [Claude Code](https://claude.ai/code) - AI-powered development
- [GitHub Actions](https://github.com/features/actions) - Automated releases
- [MCP (Model Context Protocol)](https://modelcontextprotocol.io/) - Tool integration

---

**⭐ If this plugin helps you, consider starring the repo!**
