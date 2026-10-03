# Start here: Safety risk analysis

Read AGENTS.md and inspect .codex/config.toml. Confirm the current repository, branch, HEAD, and local worktree state. The package was prepared for Safety-Analysis; do not silently switch away from the user's active branch.

Check whether the current client exposes these registered roles:
- safety_explorer
- safety_worker
- safety_engineer
- safety_reviewer

Report installed definitions separately from verified runtime recognition. If custom roles are unavailable, use CLOUD_FALLBACK_PROMPT.md; do not pretend role loading succeeded.

Use safety_explorer for a targeted map of the entry points, dependencies, data flow, outputs, and verification relevant to the user's task. Compare the current source to AGENTS.md. Keep exploration read-only and avoid executing analyses or network integrations.

Return a concise assessment and prioritized implementation plan. Preserve the existing project until changes are requested. Do not treat this startup assessment as authorization for broad refactoring, data regeneration, retraining, or deployment changes.
