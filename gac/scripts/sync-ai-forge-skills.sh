#!/usr/bin/env bash
# Inspection tool — compare vendor/ai-forge skills with gac/gac-*/module/skills/ enterprise adaptations.
# Run by a human engineer to review upstream changes after a submodule bump.
# Does not overwrite enterprise adaptations automatically.
# Usage:
#   ./gac/scripts/sync-ai-forge-skills.sh [--diff] [--module <name>]
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VENDOR="${ROOT}/skills/vendor/ai-forge"
ENTERPRISE_GLOB="${ROOT}/gac/gac-*/module/skills"
MODE="diff"
FILTER_MODULE=""

for arg in "$@"; do
  case "${arg}" in
    --diff) MODE="diff" ;;
    --module)
      shift
      FILTER_MODULE="${1:-}"
      ;;
    -h|--help)
      echo "Usage: $0 [--diff] [--module <module-name>]"
      echo "Compare upstream ai-forge skills (vendor submodule) with enterprise skill adaptations."
      echo ""
      echo "Options:"
      echo "  --diff              Show unified diff for changed skills (default)"
      echo "  --module <name>     Only check skills under a specific ai-forge module"
      echo ""
      echo "Modules: ansible-collection-sdlc, ansible-collection-standards,"
      echo "         ansible-role, ansible-content-development, ansible-documentation"
      exit 0
      ;;
    *)
      echo "Unknown option: ${arg}" >&2
      exit 1
      ;;
  esac
  shift 2>/dev/null || true
done

if [[ ! -d "${VENDOR}" ]]; then
  echo "AI Forge vendor submodule not found. Run: git submodule update --init skills/vendor/ai-forge" >&2
  exit 1
fi

echo "AI Forge upstream : ${VENDOR}"
echo "Enterprise skills : ${ROOT}/gac/gac-*/module/skills/"
echo "Pinned commit     : $(cd "${VENDOR}" && git rev-parse --short HEAD)"
echo ""

found=0
new_upstream=0
overridden=0
identical=0

for module_dir in "${VENDOR}"/*/; do
  [[ -d "${module_dir}" ]] || continue
  module_name="$(basename "${module_dir}")"

  # Skip non-module directories (ai-forge uses <module>/module/skills/ layout)
  [[ -d "${module_dir}/module/skills" ]] || continue

  if [[ -n "${FILTER_MODULE}" && "${module_name}" != "${FILTER_MODULE}" ]]; then
    continue
  fi

  echo "=== Module: ${module_name} ==="
  echo ""

  for vendor_skill in "${module_dir}"/module/skills/*/SKILL.md; do
    [[ -f "${vendor_skill}" ]] || continue
    name="$(basename "$(dirname "${vendor_skill}")")"
    # Search across all categorized enterprise modules
    enterprise_skill=""
    for edir in ${ENTERPRISE_GLOB}; do
      if [[ -f "${edir}/${name}/SKILL.md" ]]; then
        enterprise_skill="${edir}/${name}/SKILL.md"
        break
      fi
    done
    found=$((found + 1))

    if [[ -z "${enterprise_skill}" ]]; then
      echo "[UPSTREAM] ${name} — in ai-forge, no enterprise adaptation"
      new_upstream=$((new_upstream + 1))
      continue
    fi

    if diff -q "${vendor_skill}" "${enterprise_skill}" >/dev/null 2>&1; then
      echo "[SAME]     ${name}"
      identical=$((identical + 1))
    else
      echo "[DIFF]     ${name}"
      overridden=$((overridden + 1))
      if [[ "${MODE}" == "diff" ]]; then
        diff -u "${enterprise_skill}" "${vendor_skill}" | head -n 40 || true
        echo "  ... (truncated; run: diff -u ${enterprise_skill} ${vendor_skill})"
      fi
    fi
    echo ""
  done
done

if [[ "${found}" -eq 0 ]]; then
  echo "No skills found under ai-forge vendor submodule." >&2
  exit 1
fi

echo "---"
echo "Summary: ${found} skills found | ${identical} identical | ${overridden} overridden | ${new_upstream} upstream-only"
echo "Done. Review output and merge relevant vendor changes into gac/gac-*/module/skills/ following white book rules."
