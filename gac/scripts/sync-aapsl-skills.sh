#!/usr/bin/env bash
# Librarian helper — compare vendor/aap-skills-library with gac/module/skills/aap-*.
# Does not overwrite enterprise adaptations automatically.
# Usage:
#   ./gac/scripts/sync-aapsl-skills.sh --diff
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VENDOR="${ROOT}/skills/vendor/aap-skills-library/skills"
PLATFORM="${ROOT}/gac/module/skills"
MODE="diff"

for arg in "$@"; do
  case "${arg}" in
    --diff) MODE="diff" ;;
    -h|--help)
      echo "Usage: $0 [--diff]"
      echo "Compare upstream AAPSL skills (vendor submodule) with enterprise platform skills."
      exit 0
      ;;
    *)
      echo "Unknown option: ${arg}" >&2
      exit 1
      ;;
  esac
done

if [[ ! -d "${VENDOR}" ]]; then
  echo "Vendor skills not found. Run: git submodule update --init skills/vendor/aap-skills-library" >&2
  exit 1
fi

echo "AAPSL upstream: ${VENDOR}"
echo "Enterprise platform: ${PLATFORM}"
echo ""

found=0
for vendor_skill in "${VENDOR}"/aap-*/SKILL.md; do
  [[ -f "${vendor_skill}" ]] || continue
  name="$(basename "$(dirname "${vendor_skill}")")"
  platform_skill="${PLATFORM}/${name}/SKILL.md"
  found=$((found + 1))

  if [[ ! -f "${platform_skill}" ]]; then
    echo "[MISSING] ${name} — in vendor, not yet in gac/module/skills/"
    continue
  fi

  if diff -q "${vendor_skill}" "${platform_skill}" >/dev/null 2>&1; then
    echo "[SAME]    ${name}"
  else
    echo "[DIFF]    ${name}"
    if [[ "${MODE}" == "diff" ]]; then
      diff -u "${platform_skill}" "${vendor_skill}" | head -n 40 || true
      echo "  ... (truncated; run: diff -u ${platform_skill} ${vendor_skill})"
    fi
  fi
  echo ""
done

if [[ "${found}" -eq 0 ]]; then
  echo "No aap-* skills found under vendor." >&2
  exit 1
fi

echo "Done. Librarian merges vendor changes into gac/module/skills/aap-* after white book review."
