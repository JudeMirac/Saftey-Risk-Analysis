# Safety risk analysis: Codex working instructions

## Scope

Maintain the Python and SQLite safety analytics pipeline with correct joins, denominators, and provenance.

The user's current request takes precedence. This package authorizes no project changes by itself. Preserve the existing analytical intent and do not invent metrics, source data, successful tests, or model results.

## Repository baseline

Repository: JudeMirac/Saftey-Risk-Analysis
Inspected branch: Safety-Analysis
Inspected commit: 683d063e44bc817a746254023049197e7c58301a
This is a remote source assessment, not proof of a clean local worktree. Recheck branch, current HEAD, existing changes, and any nested instructions before implementation.

- Run_Pipeline.py orchestrates SQL against database/Safety.db.
- database_scripts/load_raw_*.py load raw sources; sql/staging/, integration/, context/, and features/ define transformations.
- notebooks/ holds analysis and health checks; docs/ includes architecture, setup, and data dictionary guidance.
- Data/ contains dimensions, exposure, hours-worked and event sources; Data/created_files/ contains derived outputs.

## Multi-agent workflow

Keep the lead focused on planning, integration, ambiguous decisions, and final review.

- safety_explorer: Read-only repository mapping, dependency tracing, data-flow inspection, and targeted investigation. Model: gpt-6-luna; reasoning: high.
- safety_worker: Small, clearly scoped code, notebook, documentation, and configuration changes. Model: gpt-6-luna; reasoning: high.
- safety_engineer: Complex implementation, cross-file debugging, data-pipeline failures, and integration decisions. Model: gpt-6.1-sol; reasoning: medium.
- safety_reviewer: Independent review for correctness, regressions, data leakage, reproducibility, and missed requirements. Model: gpt-6.1-sol; reasoning: medium.

Use one or two specialists for ordinary work. Delegate only bounded work with a clear output. Parallelize independent tasks and never give concurrent writers overlapping files. Ask the engineer to handle hard failures rather than repeatedly widening a routine worker's scope. Use independent review for meaningful analytical or functional changes. Do tiny tasks directly.

Read the relevant source before editing. Preserve unrelated user changes and established names. Review the final diff, perform proportionate verification, fix introduced regressions, and report changed paths, checks actually run, and limitations. Do not run expensive training, notebook execution, dataset regeneration, downloads, or external services merely for package validation.

## Project-specific rules

- Preserve the repository's existing Saftey spelling and Safety-Analysis branch unless a rename is explicitly requested.
- Pipeline execution writes database/Safety.db. Do not run it as a harmless read check; use a disposable database copy for authorized verification.
- Review join keys, fiscal-week mapping, grain, zero/missing exposure handling, and 200,000-hour rates.
- Different category totals can describe different source populations; do not force them to match or add them together without evidence.
- Maintain synthetic/demo provenance in technical documentation and avoid disclosure of workplace-sensitive data.
- sqlite3 is included with Python; do not add it as a pip dependency.

## Verification

- Parse edited Python loaders and Run_Pipeline.py with ast without importing or executing them.
- Review changed SQL against the documented schema and use a disposable database for authorized integration checks.
- Only execute python Run_Pipeline.py when database writes are within the task scope.
- No automated test suite was identified.

Do not install dependencies or regenerate artifacts for documentation-only edits. For code changes, choose the smallest relevant check and distinguish syntax validation from runtime or analytical validation. Preserve train/test boundaries where applicable. Stop broadening checks once the relevant risks are covered.

## Assessment limitations

- The database, dataset contents, live pipeline, and notebook outputs were not validated.

Do not infer a deployment from another repository. Major redesign, destructive data changes, repository visibility changes, and deployment-architecture changes require explicit user authorization unless already part of the current request.
