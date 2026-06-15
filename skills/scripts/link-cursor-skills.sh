#!/usr/bin/env bash
# Optional — Cursor IDE only. Symlink skills/ into .cursor/skills/ for discovery.
# Other tools: see skills/TOOL-SETUP.md (Claude, Copilot, generic — no script required).
# Run from repo root: ./skills/scripts/link-cursor-skills.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"   # <automation-home>
SKILLS_SRC="${ROOT}/skills"
CURSOR_SKILLS="${ROOT}/.cursor/skills"

mkdir -p "${CURSOR_SKILLS}"

# Remove stale symlinks (e.g. deprecated automation-architect)
for existing in "${CURSOR_SKILLS}"/automation-*; do
  [[ -e "${existing}" ]] || continue
  name="$(basename "${existing}")"
  if [[ ! -d "${SKILLS_SRC}/${name}" ]]; then
    rm -f "${existing}"
    echo "Removed stale ${name}"
  fi
done

for skill_dir in "${SKILLS_SRC}"/automation-*/; do
  [[ -d "${skill_dir}" ]] || continue
  name="$(basename "${skill_dir}")"
  target="${CURSOR_SKILLS}/${name}"
  rm -f "${target}"
  ln -sf "../../skills/${name}" "${target}"
  echo "Linked ${name} -> .cursor/skills/${name}"
done

echo "Done. Cursor skills point to ${SKILLS_SRC}/automation-*"
