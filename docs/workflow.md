# Workflow Configuration

## Loop Setup

```
/loop 5m
```

## State Machine

```
boss_requirement.md exists
        │
        ▼
   [PM Agent]
        │
        ▼ prd.md written
   [Dev Agent]
        │
        ▼ dev_report.md written
   [Tester Agent]
        │
        ▼ test_report.md (PASS/FAIL)
        │
   ┌────┴────┐
   │         │
  PASS      FAIL ──► [Dev Agent] (fix)
   │
   ▼
[Deploy Agent]
```

## Trigger Conditions

| Agent | Trigger | Input | Output |
|-------|---------|-------|--------|
| PM | `boss_requirement.md` exists | `boss_requirement.md` | `prd.md` |
| Dev | `prd.md` updated OR `test_report.md` shows FAIL | `prd.md`, `rules/rule.md` | `dev_report.md`, code |
| Tester | `dev_report.md` updated | `prd.md`, `dev_report.md`, `rules/test_rule.md` | `test_report.md` |
| Deploy | `test_report.md` all PASS | `test_report.md`, `rules/deploy_rule.md` | `deploy_report.md` |

## Agent Prompts

### PM Agent
```
Role: Product Manager
Task: Read docs/boss_requirement.md, write a complete PRD to docs/prd.md
Rules: Follow rules/pm_rule.md
```

### Dev Agent
```
Role: Developer
Task: Read docs/prd.md and rules/rule.md, implement features, write docs/dev_report.md
Rules: Follow rules/rule.md
Output: Update docs/dev_report.md with implementation status
```

### Tester Agent
```
Role: Tester
Task: Read docs/prd.md and docs/dev_report.md, run tests, write docs/test_report.md
Rules: Follow rules/test_rule.md
Output: Update docs/test_report.md with test results [OK] or [FAIL]
```

### Deploy Agent
```
Role: Deployer
Task: Read docs/test_report.md, if all PASS then deploy and write docs/deploy_report.md
Rules: Follow rules/deploy_rule.md
```
