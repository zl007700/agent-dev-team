# Agent Dev Team

A document-driven multi-agent collaboration framework. Agents coordinate through shared docs — each role reads specific documents, produces outputs, and triggers the next agent in the pipeline.

## Quick Start

```bash
# 1. Clone template
git clone https://github.com/zl007700/agent-dev-team.git your-project
cd your-project

# 2. One-click launch all agents
.\start.bat

# 3. Edit your requirements
vim docs/boss_requirement.md
```

## How It Works

Each Claude Code instance acts as one agent. Use `/loop` to poll document state:

| Condition | Agent | Task |
|-----------|-------|------|
| `boss_requirement.md` exists | PM Agent | Write PRD |
| `prd.md` updated | Dev Agent | Implement + dev_report |
| `dev_report.md` updated | Tester Agent | Test + test_report |
| `test_report.md` all PASS | Deploy Agent | Deploy + deploy_report |

## Workflow Config

See `docs/workflow.md` for detailed state machine logic.

## Project Structure

```
docs/
├── boss_requirement.md   # Original requirements
├── prd.md                 # Product spec (PM output)
├── dev_report.md          # Development report (Dev output)
├── test_report.md         # Test report (Tester output)
├── deploy_report.md       # Deploy report (Deployer output)
└── workflow.md            # Loop trigger logic

rules/
├── rule.md                # Coding standards
├── pm_rule.md             # PM rules
├── test_rule.md           # Test rules
└── deploy_rule.md         # Deploy rules

agents/
├── product_manager.yaml
├── developer.yaml
├── tester.yaml
└── deployer.yaml

Launcher:
├── start.bat   # One-click launch (auto-installs AutoHotkey)
└── start.ahk   # AutoHotkey script (Unicode-safe input)
```

## License

MIT
