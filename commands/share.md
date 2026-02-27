---
description: Share note via URL-encoded link (Plannotator-style, no server storage)
argument-hint: [filename] (note to share, e.g., my-note.md)
allowed-tools:
  - Task(*)
---

## Context

- **Current Directory:** `$PWD`
- **Config File:** `.claude/config.local.json` (created by `/kf-claude:setup`)

## Task

Generate a shareable URL for a note using Base64 + deflate-raw compression (plannotator-compatible format).

**Input**: `$ARGUMENTS` (filename with or without .md extension)

## Implementation

**IMPORTANT: Always spawn an agent for this task.**

Use the Task tool with these exact parameters:

```
Task tool call:
  subagent_type: "general-purpose"
  description: "Generate shareable URL"
  prompt: |
    Generate a shareable URL for the note "$ARGUMENTS".

    Steps:
    0. Determine the vault path:
       - Read .claude/config.local.json from the current working directory ($PWD)
       - Extract the "vault_path" value
       - If the config file doesn't exist, fall back to $PWD as the vault path

    1. Read the note file from {vault_path}/$ARGUMENTS
       (add .md extension if missing)

    2. Write the note content to a temp file, then run the Python script.
       IMPORTANT: Use a temp file to avoid shell escaping issues.

    ```bash
    python3 << 'PYTHON_SCRIPT'
    import json, zlib, base64, subprocess, sys, os

    # Read vault config for share URL (optional override)
    SHARE_BASE_URL = "https://sharehub.zorro.hk/share"
    config_path = os.path.join(os.environ.get("PWD", os.getcwd()), ".claude", "config.local.json")
    if os.path.exists(config_path):
        try:
            with open(config_path) as f:
                config = json.load(f)
            if config.get("share_base_url"):
                SHARE_BASE_URL = config["share_base_url"]
        except Exception:
            pass

    # Read content from temp file
    with open('/tmp/share_note.md', 'r') as f:
        content = f.read()

    # Compress and encode using deflate-raw (plannotator-compatible)
    data = {"p": content, "a": []}
    json_str = json.dumps(data, ensure_ascii=False)
    compressor = zlib.compressobj(level=6, wbits=-15)
    compressed = compressor.compress(json_str.encode('utf-8')) + compressor.flush()
    encoded = base64.urlsafe_b64encode(compressed).decode('utf-8').rstrip('=')

    # Generate URL
    url = f"{SHARE_BASE_URL}#{encoded}"
    url_len = len(url)

    print(url)
    print(f"\n--- URL length: {url_len} chars ---", file=sys.stderr)

    if url_len > 8000:
        print(f"WARNING: URL is {url_len} chars. URLs over 8000 chars are often truncated by messaging apps.", file=sys.stderr)
        print("Consider using /publish instead for large notes.", file=sys.stderr)
    elif url_len > 4000:
        print(f"CAUTION: URL is {url_len} chars. Some platforms may truncate this.", file=sys.stderr)
        print("Tip: Share via code block or plain text to avoid truncation.", file=sys.stderr)

    # Copy to clipboard
    subprocess.run(['pbcopy'], input=url.encode(), check=True)

    # Cleanup
    os.unlink('/tmp/share_note.md')
    PYTHON_SCRIPT
    ```

    3. Return the shareable URL and confirm it was copied to clipboard.
       Include the URL length and any warnings from stderr output.

    If the URL is over 4000 chars, warn the user about potential truncation.
    If over 8000 chars, strongly recommend using `/publish` instead.
```

## Features

- **No server storage**: Content lives entirely in the URL
- **Compression**: deflate-raw (identical to plannotator's CompressionStream format)
- **Annotations**: Recipients can add comments and re-share
- **Compatible**: Identical format to Plannotator — URLs are interchangeable

## Examples

```
/kf-claude:share my-note.md
/kf-claude:share paydollar-test-plan
```

## Limitations

- URLs over ~4000 chars may be truncated by messaging apps (Slack, WhatsApp, email)
- URLs over ~8000 chars will almost certainly be truncated - use `/publish` instead
- Always share URLs in code blocks or plain text to minimize truncation risk
