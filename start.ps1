# Agent Team Launcher
# One-click launch 4 PowerShell windows with agents configured

$ErrorActionPreference = "Continue"

# PM Agent instruction
$pmLoop = @'
/loop 5min 你是产品经理，你负责写docs/prd.md，当boss_requirement.md有新的任务，并且没有被标记交付，则你根据需求编写prd，同时紧急检查test_report.md的结果来更新boss_requirement.md里的任务状态
'@

# Dev Agent instruction
$devLoop = @'
/loop 5min 你是主要开发人员，查看docs里的prd，之前的提交记录，docs里面最新的测试报告docs/test_report.md，来修复测试报告里面提到的问题，每次修复提交commit并且把你最新的progress更新在docs/dev_report.md
'@

# Tester Agent instruction
$testerLoop = @'
/loop 5min 你是项目的主要测试人员，请根据rule.md和docs/dev_report.md来审查现在的代码，你可以在sg_router/test文件夹下编写一些测试脚本来测试程序，最终请你把这次审查测试的结果更新在docs/test_report.md
'@

# Deploy Agent instruction
$deployLoop = @'
/loop 5min 你是部署工程师，你需要通过git log和docs里的信息判断版本状态，你的工作目录在sg_router/deploy下面
'@

$agents = @(
    @{ Name = "PM Agent";      Dir = $PWD.Path;                    Loop = $pmLoop },
    @{ Name = "Dev Agent";     Dir = "D:\BaiduNetdiskDownload\sg_router";      Loop = $devLoop },
    @{ Name = "Tester Agent";  Dir = "D:\BaiduNetdiskDownload\sg_router";      Loop = $testerLoop },
    @{ Name = "Deploy Agent";  Dir = "D:\BaiduNetdiskDownload\sg_router\deploy"; Loop = $deployLoop }
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Agent Team Launcher" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$shell = New-Object -ComObject WScript.Shell

foreach ($agent in $agents) {
    Write-Host "[*] Starting $($agent.Name)..." -ForegroundColor Yellow

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoExit -Command `"cd '$($agent.Dir)'; claude --dangerously-skip-permissions`""
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $false
    $psi.WindowStyle = "Normal"

    $proc = [System.Diagnostics.Process]::Start($psi)

    Write-Host "    Waiting for Claude to start..." -ForegroundColor Gray
    Start-Sleep -Seconds 8

    Write-Host "    Sending /loop command..." -ForegroundColor Gray
    $shell.AppActivate($proc.Id)
    Start-Sleep -Milliseconds 500
    $shell.SendKeys($agent.Loop.Trim())
    Start-Sleep -Milliseconds 300
    $shell.SendKeys("{ENTER}")

    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "Done! All 4 agents are running." -ForegroundColor Green
Write-Host ""
Write-Host "Note: If any window missed input, manually paste /loop in that window." -ForegroundColor Gray
