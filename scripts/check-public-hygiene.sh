#!/usr/bin/env bash
# Public-repository hygiene check for Conjure Board.
#
# This repository is public and generated (pushed from the maintainers'
# private ops repository). Everything here is visible forever: files,
# commit messages, author emails. This script blocks what must never be
# published so that history never needs rewriting.
#
# Usage:
#   scripts/check-public-hygiene.sh                 # all commits reachable from HEAD + all tracked files
#   scripts/check-public-hygiene.sh --commit-msg F  # a commit message file + current user.email
#
# Runs in CI on every push (.github/workflows/hygiene.yml). The publisher in
# the ops repository should run the same check before pushing here.
set -u

# Personal mailboxes must not appear as author or committer. Use the GitHub
# noreply address (<id>+<login>@users.noreply.github.com) or a tool's noreply.
PERSONAL_EMAIL_RE='@(gmail|googlemail|yahoo|hotmail|outlook|live|icloud|me|protonmail|proton|aol)\.'

# Words and links that must not appear in commit messages or tracked files:
# tool session links and tracking trailers, file paths inside the private
# ops repository, personal account names, working-log phrasing. (The ops
# repository's name itself appears in every publish commit since the first
# one and is not blocked; its contents are.)
FORBIDDEN_RE='claude\.ai/code/session|Claude-Session:|strategy/parity|strategy/|ops/|purankutonacount|the user explicitly|the user'"'"'s request|following the user'"'"'s'

# Content the generator once published by mistake and must not publish again:
# ops-only commands and workflows, links to files that are not in this
# repository, internal to-do notes in the spec. If one of these comes back,
# fix the generator in the ops repository, not the file here.
FORBIDDEN_RE="$FORBIDDEN_RE"'|npm run ingest|ingest-issue\.yml|npm run yt|PERSONA-01\.md|商標は要確認'

# Credential shapes.
SECRET_RE='sk-[A-Za-z0-9_-]{20,}|sk-ant-[A-Za-z0-9_-]{20,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{35}|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{22,}|xox[abp]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY|[A-Za-z0-9_]*(SECRET|TOKEN|PASSWORD|API_KEY)[A-Za-z0-9_]*\s*[:=]\s*["'"'"'][A-Za-z0-9_/+=-]{16,}'

# Files that are credentials by nature.
CREDENTIAL_FILE_RE='(^|/)\.env(\..*)?$|\.(pem|p12|pfx|key|jks|keystore)$|service[-_]?account.*\.json$|(^|/)credentials\.json$'
CREDENTIAL_FILE_ALLOW_RE='(^|/)\.env\.example$'

# Stream reports must not carry contact details. Session logs are read from
# the issue, never stored here.
REPORT_PII_RE='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}|"session_log"'

# Commits up to and including this one predate the check and are not scanned
# (one carries a tool trailer; rewriting public history is exactly what this
# check exists to avoid). Everything after it is.
HISTORY_BASELINE='57c7e1bd856881359c1e16cb28a55fce22bf52a3'

# Files exempt from the content scan (they contain the patterns on purpose).
EXEMPT=(':!scripts/check-public-hygiene.sh')

fail=0
err() { printf 'hygiene: %s\n' "$*" >&2; fail=1; }

check_email() {
  local e="$1" where="$2"
  if printf '%s' "$e" | grep -qiE "$PERSONAL_EMAIL_RE"; then
    err "$where uses a personal email ($e). Use your GitHub noreply address: git config user.email '<id>+<login>@users.noreply.github.com'"
  fi
}

check_message() {
  local text="$1" where="$2" hit
  hit=$(printf '%s' "$text" | grep -iE "$FORBIDDEN_RE" | head -1 || true)
  if [ -n "$hit" ]; then
    err "$where message contains a blocked reference: $hit"
  fi
}

if [ "${1:-}" = "--commit-msg" ]; then
  [ -n "${2:-}" ] && [ -f "$2" ] || { err "--commit-msg needs a message file"; exit 1; }
  check_message "$(grep -v '^#' "$2")" "commit"
  check_email "$(git config user.email || true)" "git config user.email"
  exit $fail
fi

# --- every commit after the baseline ----------------------------------------
if git cat-file -e "${HISTORY_BASELINE}^{commit}" 2>/dev/null; then
  range="${HISTORY_BASELINE}..HEAD"
else
  range="HEAD"
fi
while IFS=$'\t' read -r sha ae ce an cn; do
  check_email "$ae" "commit ${sha:0:7} author"
  check_email "$ce" "commit ${sha:0:7} committer"
  check_message "$an"$'\n'"$cn"$'\n'"$(git log -1 --format=%B "$sha")" "commit ${sha:0:7}"
done < <(git log --format='%H%x09%ae%x09%ce%x09%an%x09%cn' "$range")

# --- tracked files -----------------------------------------------------------
while read -r f; do
  err "credential-looking file is tracked: $f"
done < <(git ls-files | grep -iE "$CREDENTIAL_FILE_RE" | grep -viE "$CREDENTIAL_FILE_ALLOW_RE" || true)

if out=$(git grep -n -I -E "$SECRET_RE" -- . "${EXEMPT[@]}" 2>/dev/null) && [ -n "$out" ]; then
  err "possible secret in tracked files:"; printf '%s\n' "$out" >&2
fi

if out=$(git grep -n -i -I -E "$FORBIDDEN_RE" -- . "${EXEMPT[@]}" 2>/dev/null) && [ -n "$out" ]; then
  err "blocked reference in tracked files:"; printf '%s\n' "$out" >&2
fi

if out=$(git grep -n -I -E "$REPORT_PII_RE" -- 'data/reports/*.json' 'board.json' 2>/dev/null) && [ -n "$out" ]; then
  err "email address or session log inside published report data:"; printf '%s\n' "$out" >&2
fi

if [ $fail -eq 0 ]; then
  echo "hygiene: ok ($(git rev-list --count HEAD) commits, $(git ls-files | wc -l | tr -d ' ') files)"
fi
exit $fail
