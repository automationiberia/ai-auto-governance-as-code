#!/usr/bin/env bash
# Optional — Cursor IDE only. Symlink skills/ into .cursor/skills/ for discovery.
# Other tools: see skills/TOOL-SETUP.md (Claude, Copilot, generic — no script required).
# Run from repo root: ./skills/scripts/link-cursor-skills.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"   # <automation-home>
SKILLS_SRC="${ROOT}/skills"
CURSOR_SKILLS="${ROOT}/.cursor/skills"

mkdir -p "${CURSOR_SKILLS}"

link_skill() {
  local rel_path="$1"
  local name="$2"
  local target="${CURSOR_SKILLS}/${name}"
  rm -f "${target}"
  ln -sf "../../skills/${rel_path}" "${target}"
  echo "Linked ${name} -> .cursor/skills/${name}"
}

# Remove stale automation-* symlinks
for existing in "${CURSOR_SKILLS}"/automation-*; do
  [[ -e "${existing}" ]] || continue
  name="$(basename "${existing}")"
  if [[ ! -d "${SKILLS_SRC}/${name}" ]]; then
    rm -f "${existing}"
    echo "Removed stale ${name}"
  fi
done

# Remove stale aap-* symlinks
for existing in "${CURSOR_SKILLS}"/aap-*; do
  [[ -e "${existing}" ]] || continue
  name="$(basename "${existing}")"
  if [[ ! -d "${SKILLS_SRC}/platform/${name}" ]]; then
    rm -f "${existing}"
    echo "Removed stale ${name}"
  fi
done

for skill_dir in "${SKILLS_SRC}"/automation-*/; do
  [[ -d "${skill_dir}" ]] || continue
  name="$(basename "${skill_dir}")"
  link_skill "${name}" "${name}"
done

for skill_dir in "${SKILLS_SRC}"/platform/aap-*/; do
  [[ -d "${skill_dir}" ]] || continue
  name="$(basename "${skill_dir}")"
  link_skill "platform/${name}" "${name}"
done

echo "Done. Cursor skills: automation-* and platform aap-*"
