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
  echo "==> Linking Cursor skills (optional)"
  "${AUTOMATION_HOME}/skills/scripts/link-cursor-skills.sh" || true
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
