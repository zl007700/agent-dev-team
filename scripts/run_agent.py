#!/usr/bin/env python3
"""
Agent Runner - 运行指定角色的 Agent

Usage:
    python scripts/run_agent.py --agent product_manager
    python scripts/run_agent.py --agent developer
    python scripts/run_agent.py --agent tester
    python scripts/run_agent.py --agent deployer
    python scripts/run_agent.py --agent all
"""

import argparse
import sys
from pathlib import Path
import yaml

# Add project root to path
PROJECT_ROOT = Path(__file__).parent.parent.resolve()
sys.path.append(str(PROJECT_ROOT))


def load_agent_config(agent_name: str) -> dict:
    """加载 Agent 配置"""
    config_path = PROJECT_ROOT / "agents" / f"{agent_name}.yaml"
    if not config_path.exists():
        raise FileNotFoundError(f"Agent config not found: {config_path}")

    with open(config_path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def read_file(file_path: str) -> str:
    """读取文档"""
    path = PROJECT_ROOT / file_path
    if not path.exists():
        return ""
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def write_file(file_path: str, content: str):
    """写入文档"""
    path = PROJECT_ROOT / file_path
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)


def check_trigger(config: dict) -> bool:
    """检查触发条件是否满足"""
    trigger = config.get("trigger", "")
    if not trigger:
        return True

    # 简单触发逻辑：检查输入文件是否存在
    inputs = config.get("inputs", [])
    for inp in inputs:
        path = PROJECT_ROOT / inp
        if not path.exists():
            print(f"  [SKIP] {inp} not found")
            return False
    return True


def run_agent(agent_name: str):
    """运行指定 Agent"""
    print(f"\n{'='*60}")
    print(f"Running Agent: {agent_name}")
    print(f"{'='*60}\n")

    config = load_agent_config(agent_name)

    # 检查触发条件
    if not check_trigger(config):
        print(f"[INFO] Trigger conditions not met, skipping {agent_name}")
        return

    # 加载输入文档
    print("[1] Loading input documents...")
    context = {}
    for inp in config.get("inputs", []):
        content = read_file(inp)
        context[inp] = content
        print(f"  - {inp}: {len(content)} chars")

    # 加载规则
    print("\n[2] Loading rules...")
    rules = []
    for rule in config.get("rules", []):
        content = read_file(rule)
        rules.append(content)
        print(f"  - {rule}")

    # 构建提示词
    print("\n[3] Building prompt...")
    prompt = build_prompt(config, context, rules)

    # 输出提示词供 Claude 使用
    print("\n[4] Agent prompt (copy to Claude Code):")
    print("-" * 60)
    print(prompt[:2000] + "..." if len(prompt) > 2000 else prompt)
    print("-" * 60)

    # 写入临时文件供 Claude Code 使用
    prompt_file = PROJECT_ROOT / ".agent_prompt.md"
    with open(prompt_file, "w", encoding="utf-8") as f:
        f.write(prompt)
    print(f"\n[INFO] Full prompt saved to: {prompt_file}")

    print(f"\n[INFO] Agent {agent_name} prepared. Ready for execution.")


def build_prompt(config: dict, context: dict, rules: list) -> str:
    """构建 Agent 执行提示词"""
    role = config.get("role", "")
    description = config.get("description", "")
    actions = config.get("actions", [])

    prompt = f"""# {config.get("name", "").replace("_", " ").title()} Agent

## Role
{role}

## Description
{description}

## Your Task
你需要执行以下 actions:
{chr(10).join(f"- {a}" for a in actions)}

## Input Documents
"""
    for inp, content in context.items():
        prompt += f"\n### {inp}\n\n{content}\n"

    if rules:
        prompt += "\n## Rules\n"
        for rule in rules:
            prompt += f"\n{rule}\n"

    prompt += f"""
## Output
完成上述任务后，请更新以下文档：
{chr(10).join(f"- {o}" for o in config.get("outputs", []))}

## Important
1. 严格按照 rules/ 中的规范执行
2. 确保输出文档格式正确
3. 如有问题，在输出文档中注明
"""

    return prompt


def list_agents():
    """列出所有可用 Agent"""
    agents_dir = PROJECT_ROOT / "agents"
    if not agents_dir.exists():
        return []
    return [f.stem for f in agents_dir.glob("*.yaml")]


def main():
    parser = argparse.ArgumentParser(description="Run Agent")
    parser.add_argument("--agent", type=str, required=True,
                        help="Agent name (e.g., product_manager, developer, tester, deployer)")
    args = parser.parse_args()

    if args.agent == "all":
        agents = list_agents()
        for agent in agents:
            run_agent(agent)
    else:
        run_agent(args.agent)


if __name__ == "__main__":
    main()
