#!/usr/bin/env bash
# Link skills/ into .cursor/skills/ for Cursor IDE discovery.
# Run from <automation-home>: ./skills/scripts/link-cursor-skills.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"   # <automation-home>
SKILLS_SRC="${ROOT}/skills"
CURSOR_SKILLS="${ROOT}/.cursor/skills"

mkdir -p "${CURSOR_SKILLS}"

for skill_dir in "${SKILLS_SRC}"/automation-*/; do
  [[ -d "${skill_dir}" ]] || continue
  name="$(basename "${skill_dir}")"
  target="${CURSOR_SKILLS}/${name}"
  rm -f "${target}"
  ln -sf "../../skills/${name}" "${target}"
  echo "Linked ${name} -> .cursor/skills/${name}"
done

echo "Done. Cursor skills point to ${SKILLS_SRC}/automation-*"
