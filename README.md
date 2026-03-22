# Agent Dev Team

A document-driven multi-agent collaboration framework. Agents coordinate through shared docs — each role reads specific documents, produces outputs, and triggers the next agent in the pipeline.

## Quick Start

```bash
# 1. Create your project docs
cp -r docs/ /your-new-project/
cp -r rules/ /your-new-project/
cp -r agents/ /your-new-project/

# 2. Edit the documents for your project
vim docs/boss_requirement.md    # Your requirements
vim rules/rule.md               # Your coding rules

# 3. Run agents in sequence
python scripts/run_agent.py --agent product_manager
python scripts/run_agent.py --agent developer
python scripts/run_agent.py --agent tester
python scripts/run_agent.py --agent deployer
```

## Architecture

```
docs/
├── boss_requirement.md   # Original requirements (input)
├── prd.md                 # Product spec (PM output)
├── dev_report.md          # Development report (Dev output)
├── test_report.md         # Test report (Tester output)
└── deploy_report.md       # Deploy report (Deployer output)

rules/
├── rule.md                # Development rules (coding standards)
├── pm_rule.md             # Product manager rules
├── test_rule.md           # Tester rules
└── deploy_rule.md         # Deployer rules

agents/
├── product_manager.yaml   # PM agent config
├── developer.yaml         # Developer agent config
├── tester.yaml            # Tester agent config
└── deployer.yaml          # Deployer agent config
```

## Agent Roles

| Agent | Reads | Produces |
|-------|-------|----------|
| Product Manager | `boss_requirement.md` | `prd.md` |
| Developer | `prd.md`, `test_report.md`, `rule.md` | `dev_report.md`, code |
| Tester | `prd.md`, `dev_report.md`, `rule.md` | `test_report.md` |
| Deployer | `test_report.md` | `deploy_report.md` |

## Agent Config

Each agent is configured via YAML:

```yaml
name: developer
role: 开发工程师
description: Reads PRD and rules, produces code and dev_report

inputs:
  - docs/prd.md
  - docs/test_report.md
  - rules/rule.md

outputs:
  - docs/dev_report.md

trigger: "When docs/prd.md is updated and docs/test_report.md shows FAILED or PENDING"

actions:
  - read_prd
  - check_coding_rules
  - implement_feature
  - write_dev_report
  - git_commit
```

## License

MIT
