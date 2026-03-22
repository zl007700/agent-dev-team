; Agent Team Launcher
; AutoHotkey script - run with: ahk.exe start.ahk

#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; Agent configurations (PM, Dev, Tester, Deploy)
agents := []
agents[1, "name"] := "PM Agent"
agents[1, "dir"] := "D:\BaiduNetdiskDownload\agent-dev-team"
agents[1, "loop"] := "/loop 5min 你是产品经理，你负责写docs/prd.md，当boss_requirement.md有新的任务，并且没有被标记交付，则你根据需求编写prd，同时紧急检查test_report.md的结果来更新boss_requirement.md里的任务状态"

agents[2, "name"] := "Dev Agent"
agents[2, "dir"] := "D:\BaiduNetdiskDownload\sg_router"
agents[2, "loop"] := "/loop 5min 你是主要开发人员，查看docs里的prd，之前的提交记录，docs里面最新的测试报告docs/test_report.md，来修复测试报告里面提到的问题，每次修复提交commit并且把你最新的progress更新在docs/dev_report.md"

agents[3, "name"] := "Tester Agent"
agents[3, "dir"] := "D:\BaiduNetdiskDownload\sg_router"
agents[3, "loop"] := "/loop 5min 你是项目的主要测试人员，请根据rule.md和docs/dev_report.md来审查现在的代码，你可以在sg_router/test文件夹下编写一些测试脚本来测试程序，最终请你把这次审查测试的结果更新在docs/test_report.md"

agents[4, "name"] := "Deploy Agent"
agents[4, "dir"] := "D:\BaiduNetdiskDownload\sg_router\deploy"
agents[4, "loop"] := "/loop 5min 你是部署工程师，你需要通过git log和docs里的信息判断版本状态，你的工作目录在sg_router/deploy下面"

; Save loop commands to a file for reference
FileEncoding, UTF-8
LoopCmdFile := A_ScriptDir . "\loop_commands.txt"
FileDelete, %LoopCmdFile%

Loop % agents.MaxIndex() {
    idx := A_Index
    FileAppend, [%idx%] % agents[idx, "name"] % ": " % agents[idx, "loop"] "`n`n", %LoopCmdFile%
}

; Launch each agent
Loop % agents.MaxIndex() {
    idx := A_Index
    name := agents[idx, "name"]
    dir := agents[idx, "dir"]
    loop_cmd := agents[idx, "loop"]

    ; Build PowerShell command
    ps_cmd := "cd '" . dir . "'; claude --dangerously-skip-permissions"

    ; Launch PowerShell window
    Run, powershell.exe -NoExit -Command %ps_cmd%, , , pid

    ; Wait for window to be active
    Sleep, 8000

    ; Activate window by title (partial match)
    WinActivate, %name%
    Sleep, 500

    ; Copy loop command to clipboard
    Clipboard := loop_cmd
    Sleep, 200

    ; Send Ctrl+V to paste
    Send, ^v
    Sleep, 300

    ; Send Enter
    Send, {Enter}
    Sleep, 1000

    ToolTip, [%idx%/4] %name% configured
}

; Clean up tooltip after 3 seconds
Sleep, 3000
ToolTip
MsgBox, 4096, Done, All 4 agents launched successfully!`n`nNote: Check loop_commands.txt if any window missed input.
