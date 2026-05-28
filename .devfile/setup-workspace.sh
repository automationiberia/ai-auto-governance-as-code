#!/usr/bin/env bash
# Post-start setup for OpenShift Dev Spaces / Dev Spaces workspaces.
set -euo pipefail

AUTOMATION_HOME="${AUTOMATION_HOME:-${PROJECT_SOURCE:-$(cd "$(dirname "$0")/.." && pwd)}}"
export AUTOMATION_HOME
export AUTOMATION_REPO="${AUTOMATION_REPO:-${AUTOMATION_HOME}/deliveries/automation}"

cd "${AUTOMATION_HOME}"

echo "==> AUTOMATION_HOME=${AUTOMATION_HOME}"
echo "==> AUTOMATION_REPO=${AUTOMATION_REPO}"

echo "==> Initializing Git submodules"
git submodule sync --recursive
git submodule update --init --recursive

echo "==> Installing Python dev dependencies (user)"
python3 -m pip install --user --upgrade pip
python3 -m pip install --user -r "${AUTOMATION_HOME}/requirements-dev.txt"

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

# Persist env for interactive shells
for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
  if [[ -f "${rc}" ]]; then
    grep -q 'AUTOMATION_HOME=' "${rc}" 2>/dev/null && continue
    {
      echo "export AUTOMATION_HOME=${AUTOMATION_HOME}"
      echo "export AUTOMATION_REPO=${AUTOMATION_REPO}"
    } >> "${rc}"
  fi
done

echo "==> Workspace ready"
