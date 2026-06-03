#!/usr/bin/env bash
# Blocks the agent from running git commit / git push (and aliases that
# write history or publish to a remote). The user commits and pushes
# manually. Read-only git (status, diff, log, branch, ...) stays allowed.
#
# Cursor sends the shell command as JSON on stdin: { "command": "..." }.
# We deny when any git write verb appears; otherwise allow.
set -euo pipefail

input="$(cat)"

command="$(printf '%s' "$input" | jq -r '.command // empty' 2>/dev/null || true)"

if [[ -z "$command" ]]; then
  echo '{ "permission": "allow" }'
  exit 0
fi

# Match git write operations even inside chained commands (&&, ;, |),
# with optional flags/paths between `git` and the verb. Blocks:
#   commit, push, commit --amend, merge, rebase, reset, revert,
#   cherry-pick, tag, am, apply, format-patch (history/remote writers)
if printf '%s' "$command" \
  | grep -Eiq 'git([[:space:]]+-[^[:space:]]+)*[[:space:]]+(commit|push|merge|rebase|reset|revert|cherry-pick|tag|am|apply|format-patch)\b'; then
  cat <<'JSON'
{
  "permission": "deny",
  "user_message": "Blocked: the AI agent is not allowed to commit or push. Run git commit/push manually.",
  "agent_message": "Git commit/push (and history/remote-writing git commands) are blocked by a project hook. Stop and ask the user to run git manually."
}
JSON
  exit 0
fi

echo '{ "permission": "allow" }'
exit 0
