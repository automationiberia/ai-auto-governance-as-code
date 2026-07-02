#!/usr/bin/env bash
# Post-start setup for OpenShift Dev Spaces / Dev Spaces workspaces.
# Logs: .devfile/setup-workspace.log (in the cloned repo)
#
# Designed for postStart hooks: no "set -u", no process-substitution tee,
# always exit 0 when invoked from the devfile (see .devfile.yaml).
set -o pipefail

_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_repo_root="$(dirname "${_script_dir}")"

# Devfile env may be literal ${PROJECT_SOURCE} during early postStart (before DWO expands it).
_automation_home_env="${AUTOMATION_HOME:-}"
_project_source="${PROJECT_SOURCE:-}"
AUTOMATION_HOME="${_repo_root}"
for _candidate in "${_automation_home_env}" "${_project_source}" "${_repo_root}"; do
  if [[ -n "${_candidate}" && "${_candidate}" != *'${'* \
    && -f "${_candidate}/.devfile/setup-workspace.sh" ]]; then
    AUTOMATION_HOME="${_candidate}"
    break
  fi
done
export AUTOMATION_HOME

if [[ -z "${AUTOMATION_REPO:-}" || "${AUTOMATION_REPO}" == *'${'* ]]; then
  AUTOMATION_REPO="${AUTOMATION_HOME}/deliveries/automation"
fi
export AUTOMATION_REPO
_HOME="${HOME:-/home/user}"

mkdir -p "${AUTOMATION_HOME}/.devfile"
LOG="${AUTOMATION_HOME}/.devfile/setup-workspace.log"

_errors=0
_fail() {
  echo "ERROR: $*"
  _errors=$((_errors + 1))
}

_run_setup() {
  cd "${AUTOMATION_HOME}" || {
    _fail "cannot cd to AUTOMATION_HOME=${AUTOMATION_HOME}"
    echo "See log: ${LOG}"
    return 0
  }

  echo "==> AUTOMATION_HOME=${AUTOMATION_HOME}"
  echo "==> AUTOMATION_REPO=${AUTOMATION_REPO}"
  echo "==> Log file: ${LOG}"

  _copilot_vsix_dir="${AUTOMATION_HOME}/.devfile/extensions"
  _copilot_vsix="${_copilot_vsix_dir}/redhat.devspaces-copilot-chat-integration-0.36.2.vsix"
  _copilot_vsix_url="https://open-vsx.org/api/redhat/devspaces-copilot-chat-integration/0.36.2/file/redhat.devspaces-copilot-chat-integration-0.36.2.vsix"

  echo "==> Ensuring Dev Spaces Copilot Chat Integration VSIX (0.36.2)"
  mkdir -p "${_copilot_vsix_dir}"
  if [[ -f "${_copilot_vsix}" ]]; then
    echo "==> Copilot VSIX already present"
  elif curl -fsSL "${_copilot_vsix_url}" -o "${_copilot_vsix}"; then
    echo "==> Copilot VSIX downloaded"
  else
    rm -f "${_copilot_vsix}"
    _fail "Copilot VSIX download failed (Open VSX egress or cluster registry — install manually from VSIX)"
  fi

  echo "==> Initializing Git submodules"
  if git submodule sync --recursive && git submodule update --init --recursive; then
    echo "==> Submodules OK"
  else
    _fail "git submodule update failed (configure Git/SSH in Dev Spaces User Preferences)"
  fi

  echo "==> Installing Python dev dependencies (.venv)"
  _venv="${AUTOMATION_HOME}/.venv"
  if [[ ! -d "${_venv}" ]]; then
    if ! python3 -m venv "${_venv}"; then
      _fail "python3 -m venv failed (install python3-virtualenv in image?)"
    fi
  fi
  if [[ -f "${_venv}/bin/activate" ]]; then
    # shellcheck source=/dev/null
    source "${_venv}/bin/activate"
    if pip install --upgrade pip \
      && pip install -r "${AUTOMATION_HOME}/requirements-dev.txt"; then
      echo "==> Python venv OK (${_venv})"
      echo "==> pre-commit: $(command -v pre-commit || echo missing)"
      echo "==> ansible-lint: $(command -v ansible-lint || echo missing)"
    else
      _fail "pip install into .venv failed (network or requirements-dev.txt)"
    fi
  else
    _fail "venv activate script missing at ${_venv}/bin/activate"
  fi

  echo "==> Installing pre-commit hooks (monorepo)"
  if [[ -f "${AUTOMATION_HOME}/.pre-commit-config.yaml" && -x "${_venv}/bin/pre-commit" ]]; then
    "${_venv}/bin/pre-commit" install -c "${AUTOMATION_HOME}/.pre-commit-config.yaml" || true
  fi

  echo "==> Installing pre-commit hooks (delivery collection)"
  if [[ -f "${AUTOMATION_REPO}/.pre-commit-config.yaml" && -x "${_venv}/bin/pre-commit" ]]; then
    (cd "${AUTOMATION_REPO}" && "${_venv}/bin/pre-commit" install) || true
  fi

  if [[ -x "${AUTOMATION_HOME}/skills/scripts/link-cursor-skills.sh" ]]; then
    echo "==> Linking Cursor skills (optional — see skills/TOOL-SETUP.md for Claude/Copilot/other)"
    "${AUTOMATION_HOME}/skills/scripts/link-cursor-skills.sh" || true
  fi

  _continue_home="${_HOME}/.continue"
  if [[ -d "${AUTOMATION_HOME}/.continue" ]]; then
    echo "==> Installing Continue config to ${_continue_home} (Ollama qwen2.5-coder:7b)"
    mkdir -p "${_continue_home}/mcpServers" || true
    cp -r "${AUTOMATION_HOME}/.continue/"* "${_continue_home}/" 2>/dev/null || true
    if [[ -n "${CONTEXT7_API_KEY:-}" && -f "${_continue_home}/mcpServers/mcp.json" ]]; then
      awk -v c7="${CONTEXT7_API_KEY}" '
        BEGIN { gsub(/\\/, "\\\\", c7); gsub(/"/, "\\\"", c7) }
        { gsub(/\$\{CONTEXT7_API_KEY\}/, c7); print }
      ' "${AUTOMATION_HOME}/.continue/mcpServers/mcp.json" >"${_continue_home}/mcpServers/mcp.json" || true
      echo "==> Context7 MCP key applied from workspace env"
    fi
    echo "==> Continue config OK"
  fi

  for rc in "${_HOME}/.bashrc" "${_HOME}/.zshrc"; do
    if [[ -f "${rc}" ]]; then
      if ! grep -q 'AUTOMATION_HOME=' "${rc}" 2>/dev/null; then
        {
          echo "export AUTOMATION_HOME=${AUTOMATION_HOME}"
          echo "export AUTOMATION_REPO=${AUTOMATION_REPO}"
        } >>"${rc}" || true
      fi
      if ! grep -q "${AUTOMATION_HOME}/.venv/bin" "${rc}" 2>/dev/null; then
        echo "export PATH=\"${AUTOMATION_HOME}/.venv/bin:\${PATH}\"" >>"${rc}" || true
      fi
    fi
  done

  if [[ "${_errors}" -gt 0 ]]; then
    echo "==> Setup finished with ${_errors} error(s). Log: ${LOG}"
    echo "==> Re-run after fixing: bash .devfile/setup-workspace.sh"
  else
    echo "==> Workspace ready"
  fi

  _trigger_ollama_pull || true
}

_trigger_ollama_pull() {
  _model="qwen2.5-coder:7b"
  _api="http://127.0.0.1:11434"
  _pull_log="${AUTOMATION_HOME}/.devfile/ollama-pull.log"

  echo "==> Ensuring Ollama model ${_model} (sidecar API)"
  _ready=0
  _i=1
  while [[ "${_i}" -le 36 ]]; do
    if curl -sf "${_api}/api/tags" >/dev/null 2>&1; then
      _ready=1
      break
    fi
    sleep 5
    _i=$((_i + 1))
  done

  if [[ "${_ready}" -ne 1 ]]; then
    echo "WARN: Ollama API not reachable — run Command Palette → Pull Ollama model later"
    return 0
  fi

  if curl -sf "${_api}/api/tags" 2>/dev/null | grep -q "${_model}"; then
    echo "==> Ollama model ${_model} already present"
    return 0
  fi

  echo "==> Pulling ${_model} via Ollama API (background, log: ${_pull_log})"
  mkdir -p "$(dirname "${_pull_log}")"
  nohup env AUTOMATION_HOME="${AUTOMATION_HOME}" bash "${_script_dir}/ollama-pull.sh" >>"${_pull_log}" 2>&1 &
}

: >"${LOG}"
if [[ -t 1 ]]; then
  _run_setup 2>&1 | tee -a "${LOG}"
else
  _run_setup >>"${LOG}" 2>&1
fi

# Do not block workspace start; fix issues from the IDE terminal.
exit 0
