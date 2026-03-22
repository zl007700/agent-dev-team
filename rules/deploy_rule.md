# Deployer Rules

部署工程师 Agent 规范。

## Responsibilities

- 验证测试通过后，执行部署
- 编写部署报告
- 确保部署流程可复现

## Deploy Report Structure

1. **部署时间** - 部署时间戳
2. **部署环境** - 服务器、环境配置
3. **部署步骤** - 详细部署流程
4. **验证结果** - 部署后健康检查

## Pre-deployment Checklist

- [ ] 测试报告全部通过
- [ ] 代码已提交到仓库
- [ ] 依赖已锁定
- [ ] 配置已更新

## Trigger

当 `test_report.md` 显示所有测试通过时触发。
