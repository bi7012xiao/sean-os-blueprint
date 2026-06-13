#!/bin/zsh
# Pattern: deterministic shell + judgment-only agent.
# A scheduled job that gathers data deterministically, lets an LLM synthesize,
# then delivers — with idempotency, locking, and fallback. SANITIZED SKELETON.
# Real values (chat IDs, keys, paths) live in env/keychain, never in code.
set -e
setopt local_options null_glob
umask 077

AGENT="<your-llm-cli>"                 # e.g. a headless agent CLI
OUT_DIR="$HOME/reports"
LOG="$HOME/Library/Logs/briefing.log"
CHAT="$DELIVER_CHAT_ID"                 # from env, not hardcoded
WEEK=$(date "+%G-W%V"); MARK="$OUT_DIR/.sent-$WEEK"
mkdir -p "$OUT_DIR"
log() { echo "[$(date '+%F %T')] $1" >> "$LOG"; }

# idempotency: one delivery per period unless FORCE=1
[[ -f "$MARK" && "${FORCE:-0}" != "1" ]] && { log "already sent $WEEK"; exit 0; }
# mutex: no concurrent runs
LOCK="/tmp/briefing.lock"; mkdir "$LOCK" 2>/dev/null || { log "locked"; exit 0; }
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

# secret from keychain, never in source
TOKEN=$(security find-generic-password -s "<your-bot-service>" -w 2>/dev/null || true)
[[ -n "$TOKEN" ]] || { log "no token"; exit 1; }

# 1) DETERMINISTIC: gather facts the script can compute reliably
#    (file lists by name not mtime — cloud sync flattens timestamps!)
SOURCES=$(ls "$OUT_DIR"/*.md 2>/dev/null | sort | tail -3)

# 2) JUDGMENT: agent only synthesizes; stdout IS the briefing
BRIEF=$("$AGENT" -p "Summarize the week from: $SOURCES. <=700 chars, surface 3 decisions." \
  --allowed-tools "Read,Grep" 2>>"$LOG") || { log "agent failed"; BRIEF=""; }

# 3) DELIVER with fallback + verify
if [[ -n "$BRIEF" ]]; then
  curl -sS -m 30 "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${CHAT}" --data-urlencode "text=${BRIEF:0:4000}" >/dev/null \
    && touch "$MARK" && log "delivered $WEEK"
else
  log "empty brief — not delivered"
fi
