#!/bin/sh
# Pull the local LLM into the Ollama sidecar (Dev Spaces postStart).
# Logs to .devfile/ollama-pull.log when PROJECT_SOURCE is set.
set -u

OLLAMA_MODEL="${OLLAMA_MODEL:-qwen2.5-coder:7b}"
OLLAMA_API="${OLLAMA_API:-http://127.0.0.1:11434}"
LOG="${PROJECT_SOURCE:-.}/.devfile/ollama-pull.log"

mkdir -p "$(dirname "${LOG}")"
: >"${LOG}"

log() {
  echo "$*" | tee -a "${LOG}"
}

log "==> Ollama model pull: ${OLLAMA_MODEL}"
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
  log "==> Retry: sh .devfile/ollama-pull.sh (from ollama container)"
  exit 0
fi

if ollama list 2>/dev/null | grep -q "${OLLAMA_MODEL}"; then
  log "==> Model ${OLLAMA_MODEL} already present"
  exit 0
fi

log "==> Pulling ${OLLAMA_MODEL} (first start may take several minutes, ~4.5 GiB)..."
if ollama pull "${OLLAMA_MODEL}" >>"${LOG}" 2>&1; then
  log "==> Model ${OLLAMA_MODEL} ready"
else
  log "ERROR: ollama pull failed (network, quota, or memory)"
fi

exit 0
