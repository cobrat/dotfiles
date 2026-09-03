# Global Instructions

* Keep responses concise and technical.
* Inspect relevant code before making changes.
* Prefer minimal, scoped changes. Do not modify unrelated files.
* Preserve existing conventions and architecture unless the task requires otherwise.
* Never discard or overwrite existing user changes without explicit instruction.
* Do not commit, push, rewrite Git history, or perform destructive Git operations unless explicitly requested.
* Prefer existing local CLI tools over adding dependencies or MCP integrations when they are sufficient.
* Use repository-local documentation and code as the primary source of truth.
* Use web access only when current or external information is required.
* Run focused validation after code changes; use broader checks only when justified.
* Review the final diff before completing a coding task.
* Do not bypass runtime safety restrictions.

## Herdr

* Herdr is the outer orchestration layer for panes, processes, workspaces, and multiple Pi instances.
* Do not introduce nested subagent or orchestration frameworks unless explicitly requested.
* Use additional Pi instances through Herdr only when the work can be split into genuinely independent tasks.
* The primary Pi instance is responsible for integrating and validating delegated work.
