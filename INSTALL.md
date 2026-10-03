# Using the orchestration package

This package adds project-scoped agent guidance; it does not install Python dependencies, run analyses, retrain models, or change repository visibility.

Open this repository as the active Codex project and read START_HERE.md. The main model remains your choice. Use GPT-6.1 Sol for routine work; reserve GPT-6 Astra for difficult orchestration if available in your account.

## Layout

- AGENTS.md: project-specific working rules, verified paths, and verification guidance.
- .codex/config.toml: explicit custom-role registrations and delegation defaults.
- .codex/agents/: four role configuration files.
- START_HERE.md: initial assessment procedure.
- CLOUD_FALLBACK_PROMPT.md: fallback when the current surface cannot load custom roles.

## Loading and verification

The role entries use config_file paths relative to .codex/config.toml. Open the trusted local project and start a fresh session if configuration was added during an existing chat. Repository installation and valid TOML alone do not establish runtime role availability. Check the roles exposed by the current client; if unavailable, report that limitation and use the fallback.

The package defaults to Luna with high reasoning for subagents; explicit per-role configuration assigns Sol with medium reasoning to engineering and review. Model availability and client permissions still apply. No authentication, network, or approval-policy overrides are included.

The concurrency limit is three spawned threads, allowing four threads including the lead. Normally use only one or two specialists and only parallelize independent work.

Reference: https://learn.chatgpt.com/docs/config-file/config-reference

## Scope

Keep future work within the user's request. Do not change branches, hosting architecture, repository visibility, datasets, or model artifacts simply because this package is installed. Record the current branch and worktree state before edits; never claim a remote inspection proves a local worktree is clean.
