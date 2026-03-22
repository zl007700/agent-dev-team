# Agent Team Launcher
# Creates 4 separate agent scripts and launches them

$ErrorActionPreference = "Continue"

$scriptDir = "$PSScriptRoot\agents"

# 创建 agents 子目录
New-Item -ItemType Directory -Force -Path $scriptDir | Out-Null

# PM Agent
@'
cd D:\BaiduNetdiskDownload\agent-dev-team
claude --dangerously-skip-permissions
'@ | Out-File -FilePath "$scriptDir\pm_agent.ps1" -Encoding UTF8

# Dev Agent
@'
cd D:\BaiduNetdiskDownload\sg_router
claude --dangerously-skip-permissions
'@ | Out-File -FilePath "$scriptDir\dev_agent.ps1" -Encoding UTF8

# Tester Agent
@'
cd D:\BaiduNetdiskDownload\sg_router
claude --dangerously-skip-permissions
'@ | Out-File -FilePath "$scriptDir\tester_agent.ps1" -Encoding UTF8

# Deploy Agent
@'
cd D:\BaiduNetdiskDownload\sg_router\deploy
claude --dangerously-skip-permissions
'@ | Out-File -FilePath "$scriptDir\deploy_agent.ps1" -Encoding UTF8

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Agent Team Launcher" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "[*] Launching 4 agent windows..." -ForegroundColor Yellow
Write-Host ""

# 启动4个窗口
Start-Process powershell -ArgumentList "-NoExit -Command & '$scriptDir\pm_agent.ps1'" -WindowStyle Normal
Write-Host "    [1/4] PM Agent started" -ForegroundColor Green

Start-Process powershell -ArgumentList "-NoExit -Command & '$scriptDir\dev_agent.ps1'" -WindowStyle Normal
Write-Host "    [2/4] Dev Agent started" -ForegroundColor Green

Start-Process powershell -ArgumentList "-NoExit -Command & '$scriptDir\tester_agent.ps1'" -WindowStyle Normal
Write-Host "    [3/4] Tester Agent started" -ForegroundColor Green

Start-Process powershell -ArgumentList "-NoExit -Command & '$scriptDir\deploy_agent.ps1'" -WindowStyle Normal
Write-Host "    [4/4] Deploy Agent started" -ForegroundColor Green

Write-Host ""
Write-Host "Done! 4 windows opened." -ForegroundColor Green
Write-Host ""
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "1. Accept trust prompt in each window (first time only)"
Write-Host "2. Type /loop command in each window:"
Write-Host ""
Write-Host "PM Agent:" -ForegroundColor Cyan
Write-Host "/loop 5min 你是产品经理，你负责写docs/prd.md，当boss_requirement.md有新的任务，并且没有被标记交付，则你根据需求编写prd，同时紧急检查test_report.md的结果来更新boss_requirement.md里的任务状态"
Write-Host ""
Write-Host "Dev Agent:" -ForegroundColor Cyan
Write-Host "/loop 5min 你是主要开发人员，查看docs里的prd，之前的提交记录，docs里面最新的测试报告docs/test_report.md，来修复测试报告里面提到的问题，每次修复提交commit并且把你最新的progress更新在docs/dev_report.md"
Write-Host ""
Write-Host "Tester Agent:" -ForegroundColor Cyan
Write-Host "/loop 5min 你是项目的主要测试人员，请根据rule.md和docs/dev_report.md来审查现在的代码，你可以在sg_router/test文件夹下编写一些测试脚本来测试程序，最终请你把这次审查测试的结果更新在docs/test_report.md"
Write-Host ""
Write-Host "Deploy Agent:" -ForegroundColor Cyan
Write-Host "/loop 5min 你是部署工程师，你需要通过git log和docs里的信息判断版本状态，你的工作目录在sg_router/deploy下面"
Write-Host ""
Write-Host "Note: Copy each /loop line and paste into corresponding window." -ForegroundColor Gray
