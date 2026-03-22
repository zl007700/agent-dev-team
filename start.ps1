# Agent Team Launcher
# 一键启动4个PowerShell窗口并配置好Agent

$ErrorActionPreference = "Continue"

# Agent配置
$agents = @(
@{
    Name = "PM Agent"
    Dir = $PWD.Path
    Loop = '/loop 5min 你是产品经理，你负责写docs/prd.md，当boss_requirement.md有新的任务，并且没有被标记交付，则你根据需求编写prd，同时紧急检查test_report.md的结果来更新boss_requirement.md里的任务状态'
},
@{
    Name = "Dev Agent"
    Dir = "D:\BaiduNetdiskDownload\sg_router"
    Loop = '/loop 5min 你是主要开发人员，查看docs里的prd，之前的提交记录，docs里面最新的测试报告docs/test_report.md，来修复测试报告里面提到的问题，每次修复提交commit并且把你最新的progress更新在docs/dev_report.md'
},
@{
    Name = "Tester Agent"
    Dir = "D:\BaiduNetdiskDownload\sg_router"
    Loop = '/loop 5min 你是项目的主要测试人员，请根据rule.md和docs/dev_report.md来审查现在的代码，你可以在sg_router/test文件夹下编写一些测试脚本来测试程序，最终请你把这次审查测试的结果更新在docs/test_report.md'
},
@{
    Name = "Deploy Agent"
    Dir = "D:\BaiduNetdiskDownload\sg_router\deploy"
    Loop = '/loop 5min 你是部署工程师，你需要通过git log和docs里的信息判断版本状态，你的工作目录在sg_router/deploy下面'
}
)

# 启动所有Agent窗口
$shell = New-Object -ComObject WScript.Shell
$processes = @()

Write-Host "Starting Agent Team..." -ForegroundColor Cyan
Write-Host ""

foreach ($agent in $agents) {
    Write-Host "[*] Starting $($agent.Name)..." -ForegroundColor Yellow

    # 启动新的PowerShell窗口
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoExit -Command `"cd '$($agent.Dir)'; claude --dangerously-skip-permissions`""
    $psi.UseShellExecute = $false
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.CreateNoWindow = $false
    $psi.WindowStyle = "Normal"

    $proc = [System.Diagnostics.Process]::Start($psi)
    $processes += @{ Name = $agent.Name; Process = $proc; Loop = $agent.Loop }

    # 等待窗口激活
    Start-Sleep -Seconds 3

    # 聚焦到新窗口 (Alt+Tab方式不够可靠，改用等待)
    Write-Host "    Waiting for $($agent.Name) to initialize..." -ForegroundColor Gray
    Start-Sleep -Seconds 5

    # 发送 claude 启动命令（如果还没启动完成）
    $shell.AppActivate($proc.Id)
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "All windows launched. Waiting for Claude to start..." -ForegroundColor Cyan
Start-Sleep -Seconds 10

# 发送 /loop 命令到每个窗口
Write-Host ""
Write-Host "Sending /loop commands..." -ForegroundColor Cyan

foreach ($item in $processes) {
    Write-Host "[*] $($item.Name): sending /loop command..." -ForegroundColor Yellow

    # 聚焦窗口
    $shell.AppActivate($item.Process.Id)
    Start-Sleep -Milliseconds 500

    # 发送 /loop 命令
    $shell.SendKeys($item.Loop)
    Start-Sleep -Milliseconds 200
    $shell.SendKeys("{ENTER}")

    Start-Sleep -Seconds 1
}

Write-Host ""
Write-Host "Done! All 4 agents are running with /loop configured." -ForegroundColor Green
Write-Host ""
Write-Host "Note: If any window missed input, manually type in that window." -ForegroundColor Gray
Read-Host "Press Enter to close this launcher"
