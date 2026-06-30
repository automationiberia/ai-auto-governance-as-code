#!/bin/sh
# Pull qwen2.5-coder:7b via Ollama HTTP API (run from automation-tools; same pod as ollama sidecar).
set -u

OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5-coder:7b}"
OLLAMA_API="${OLLAMA_API:-http://127.0.0.1:11434}"
LOG="${AUTOMATION_HOME:-${PROJECT_SOURCE:-.}}/.devfile/ollama-pull.log"

mkdir -p "$(dirname "${LOG}")"
: >"${LOG}"

log() {
  echo "$*" | tee -a "${LOG}"
}

log "==> Ollama model pull (API): ${OLLAMA_MODEL}"
log "==> API: ${OLLAMA_API}"

log "==> Waiting for Ollama API (up to 5 min)..."
_ready=0
_i=1
while [ "${_i}" -le 60 ]; do
  if curl -sf "${OLLAMA_API}/api/tags" >/dev/null 2>&1; then
    _ready=1
    break
  fi
  sleep 5
  _i=$((_i + 1))
done

if [ "${_ready}" -ne 1 ]; then
  log "ERROR: Ollama API not reachable at ${OLLAMA_API}"
  log "==> Is the ollama sidecar running? Retry: bash .devfile/ollama-pull.sh"
  exit 0
fi

if curl -sf "${OLLAMA_API}/api/tags" 2>/dev/null | grep -q "${OLLAMA_MODEL}"; then
  log "==> Model ${OLLAMA_MODEL} already present"
  exit 0
fi

log "==> Pulling ${OLLAMA_MODEL} (first run ~4.5 GiB; may take several minutes)..."
if curl -sf "${OLLAMA_API}/api/pull" -d "{\"name\":\"${OLLAMA_MODEL}\"}" >>"${LOG}" 2>&1; then
  log "==> Model ${OLLAMA_MODEL} ready"
else
  log "ERROR: Ollama API pull failed (network, memory, or storage)"
fi

exit 0
