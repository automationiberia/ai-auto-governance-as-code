## Description

<!-- Provide a clear and concise description of your changes -->

## Type of Change

<!-- Check all that apply -->

- [ ] White paper documentation update (`automation-whitepaper/`)
- [ ] Agent skill update or creation (`skills/`)
- [ ] Reference example (`automation-whitepaper/examples/`)
- [ ] Tooling or script improvement
- [ ] CI/CD or pre-commit enhancement
- [ ] Bug fix
- [ ] Breaking change (requires white paper or skill version bump)

## Motivation and Context

<!-- Why is this change needed? What problem does it solve? -->
<!-- Link to related issues: Fixes #123, Relates to #456 -->

## Changes Made

<!-- Describe what you changed in detail -->

- 
- 
- 

## Operating Mode (for skill changes)

<!-- If this affects AI agent skills, indicate which mode(s) -->

- [ ] Mode 1 — The Auditor (retroactive review)
- [ ] Mode 2 — The Architect (proactive creation)
- [ ] Mode 3 — The Librarian (maintenance)
- [ ] Task skill (used within other modes)
- [ ] Not applicable (documentation, tooling, etc.)

## White Paper Alignment

<!-- For skill or example changes: which white paper sections are affected? -->

- White paper reference: `automation-whitepaper/...`
- Skill alignment verified: [ ] Yes [ ] No [ ] N/A

## Testing Performed

<!-- Describe how you tested your changes -->

- [ ] Pre-commit hooks pass (`pre-commit run --all-files`)
- [ ] Ansible syntax check (for examples): `ansible-playbook --syntax-check`
- [ ] YAML validation: `yamllint` and `ansible-lint`
- [ ] Python formatting: `black --check`
- [ ] Manual testing (describe below)

### Manual Testing Details

<!-- Describe manual tests performed -->

```
# Example commands run
make validate
ansible-playbook playbooks/type_<category>.yml --check
```

## AI Agent Validation (for skill changes)

<!-- If you changed skills, test with an AI tool -->

- AI tool tested: [ ] Cursor [ ] Claude [ ] Copilot [ ] Other [ ] N/A
- Prompt used: 
- AI behavior validated: [ ] Yes [ ] No [ ] N/A

## Documentation Updates

<!-- Check all that apply -->

- [ ] Updated relevant white paper markdown
- [ ] Updated or created `SKILL.md` files
- [ ] Updated `skills/README.md` catalog
- [ ] Updated `AGENTS.md` (if bootstrap rules changed)
- [ ] Added or updated examples
- [ ] Updated `CONTRIBUTING.md` or other root docs
- [ ] No documentation changes needed

## Breaking Changes

<!-- Does this PR introduce breaking changes? -->

- [ ] No breaking changes
- [ ] Breaking changes (describe impact below)

### Breaking Change Impact

<!-- If breaking, describe what breaks and migration path -->

## Checklist

<!-- Ensure you've completed these steps before requesting review -->

- [ ] My code follows the style guidelines in `CONTRIBUTING.md`
- [ ] I have performed a self-review of my changes
- [ ] I have commented my code where necessary (sparingly, per guidelines)
- [ ] My changes generate no new warnings or errors
- [ ] I have updated documentation to reflect my changes
- [ ] My changes maintain alignment with the white paper
- [ ] All commits have clear, descriptive messages
- [ ] I have tested my changes locally
- [ ] Pre-commit hooks pass without errors

## Additional Notes

<!-- Any additional context, screenshots, or references -->

---

**For Reviewers:**

- [ ] White paper alignment verified
- [ ] Skill-to-documentation consistency checked
- [ ] Code quality and style compliance confirmed
- [ ] Example completeness validated (if applicable)
- [ ] Breaking changes properly documented (if applicable)
