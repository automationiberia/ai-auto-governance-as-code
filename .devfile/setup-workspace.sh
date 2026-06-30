#!/usr/bin/env bash
# Post-start setup for OpenShift Dev Spaces / Dev Spaces workspaces.
# Logs: .devfile/setup-workspace.log (in the cloned repo)
set -uo pipefail

_script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_HOME="${AUTOMATION_HOME:-${PROJECT_SOURCE:-$(dirname "${_script_dir}")}}"
export AUTOMATION_HOME
export AUTOMATION_REPO="${AUTOMATION_REPO:-${AUTOMATION_HOME}/deliveries/automation}"

mkdir -p "${AUTOMATION_HOME}/.devfile"
LOG="${AUTOMATION_HOME}/.devfile/setup-workspace.log"
: >"${LOG}"
exec > >(tee -a "${LOG}") 2>&1

_errors=0
_fail() {
  echo "ERROR: $*"
  _errors=$((_errors + 1))
}

cd "${AUTOMATION_HOME}" || {
  _fail "cannot cd to AUTOMATION_HOME=${AUTOMATION_HOME}"
  echo "See log: ${LOG}"
  exit 0
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

echo "==> Installing Python dev dependencies (user)"
if python3 -m pip install --user --upgrade pip \
  && python3 -m pip install --user -r "${AUTOMATION_HOME}/requirements-dev.txt"; then
  echo "==> Python dependencies OK"
else
  _fail "pip install failed (network or requirements-dev.txt)"
fi

echo "==> Installing pre-commit hooks (monorepo)"
if [[ -f "${AUTOMATION_HOME}/.pre-commit-config.yaml" ]]; then
  pre-commit install -c "${AUTOMATION_HOME}/.pre-commit-config.yaml" || true
fi

echo "==> Installing pre-commit hooks (delivery collection)"
if [[ -f "${AUTOMATION_REPO}/.pre-commit-config.yaml" ]]; then
  (cd "${AUTOMATION_REPO}" && pre-commit install) || true
fi

if [[ -x "${AUTOMATION_HOME}/skills/scripts/link-cursor-skills.sh" ]]; then
  echo "==> Linking Cursor skills (optional — see skills/TOOL-SETUP.md for Claude/Copilot/other)"
  "${AUTOMATION_HOME}/skills/scripts/link-cursor-skills.sh" || true
fi

_continue_home="/home/user/.continue"
if [[ -d "${AUTOMATION_HOME}/.continue" ]]; then
  echo "==> Installing Continue config to ${_continue_home} (Ollama qwen2.5-coder:7b)"
  mkdir -p "${_continue_home}/mcpServers"
  cp -r "${AUTOMATION_HOME}/.continue/"* "${_continue_home}/"
  if [[ -n "${CONTEXT7_API_KEY:-}" && -f "${_continue_home}/mcpServers/mcp.json" ]]; then
    awk -v c7="${CONTEXT7_API_KEY}" '
      BEGIN { gsub(/\\/, "\\\\", c7); gsub(/"/, "\\\"", c7) }
      { gsub(/\$\{CONTEXT7_API_KEY\}/, c7); print }
    ' "${AUTOMATION_HOME}/.continue/mcpServers/mcp.json" >"${_continue_home}/mcpServers/mcp.json"
    echo "==> Context7 MCP key applied from workspace env"
  fi
  echo "==> Continue config OK"
fi

for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
  if [[ -f "${rc}" ]]; then
    grep -q 'AUTOMATION_HOME=' "${rc}" 2>/dev/null && continue
    {
      echo "export AUTOMATION_HOME=${AUTOMATION_HOME}"
      echo "export AUTOMATION_REPO=${AUTOMATION_REPO}"
    } >>"${rc}"
  fi
done

if [[ "${_errors}" -gt 0 ]]; then
  echo "==> Setup finished with ${_errors} error(s). Log: ${LOG}"
  echo "==> Re-run after fixing: bash .devfile/setup-workspace.sh"
else
  echo "==> Workspace ready"
fi

# Do not block workspace start; fix issues from the IDE terminal.
exit 0
