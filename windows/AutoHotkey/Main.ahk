;******************************************************************************
;*    This is a hotkey just for Segon
;******************************************************************************
;When mouse move on to tray icon, show "Just for Segon"
Menu, TRAY, Tip, Just for Segon
;Use trayicon.ico as App's tray icon
if (FileExist("trayicon.ico"))
{
    Menu, TRAY, Icon, trayicon.ico
}

;******************************************************************************
;*  Include
;******************************************************************************
#include Kernel.ahk
#include ReadConfigs.ahk
;#include AutoRun.ahk

;******************************************************************************
;*  全局变量
;******************************************************************************
;ClipboardAll 备份用变量
ClipSaved =

;******************************************************************************
;*  Function
;******************************************************************************
; *****************************************************************************
; * HOTKEY
; *  LButton + RButton
; * DESCRIPTION
; *  很方便的拖动窗口
; * HOW TO USE
; *  在要移动窗口任意位置按住鼠标左键+右键，然后拖动
; *****************************************************************************
~LButton & RButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
	SetTimer, EWD_WatchMouse, off
	return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
	SetTimer, EWD_WatchMouse, off
	WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
	return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return

; *****************************************************************************
; * HOTSTRING
; *  #mem
; * DESCRIPTION
; *  部门成员邮箱
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#mem::
SendInput %DepartmentMembers%
return

; *****************************************************************************
; * HOTSTRING
; *  #lea
; * DESCRIPTION
; *  部门主管邮箱
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#lea::
SendInput %DepartmentLeaders%
return

; *****************************************************************************
; * HOTSTRING
; *  #lea
; * DESCRIPTION
; *  客户经理邮箱
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#khjl::
SendInput %CustomerManagers%
return

; *****************************************************************************
; * HOTSTRING
; *  #rq
; * DESCRIPTION
; *  当前日期
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#rq::
SendInput %A_YYYY%_%A_MM%_%A_DD%
return

; *****************************************************************************
; * HOTSTRING
; *  #dqsj
; * DESCRIPTION
; *  当前时间
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#dqsj::
SendInput %A_Hour%:%A_Min%:%A_Sec%
return

; *****************************************************************************
; * HOTSTRING
; *  #rjh
; * DESCRIPTION
; *  日计划标题
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#rjh::
SendInput DailySchedule_%A_YYYY%-%A_MM%-%A_DD%
return

; *****************************************************************************
; * HOTSTRING
; *  #zjh
; * DESCRIPTION
; *  周计划标题
; * 触发标志
; *  NULL
; *****************************************************************************
;:*:#zjh::
;replaceTimeString(tmpYWeek, "D_YWEEK")
;SendInput WeeklySchedule_%tmpYWeek%
;return

; *****************************************************************************
; * HOTSTRING
; *  #mk
; * DESCRIPTION
; *  make命令
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#mk::
Send make -no_ib dewav
Send {Tab}
Send {BackSpace}{BackSpace}{BackSpace}{BackSpace}{BackSpace}{BackSpace}{BackSpace}{BackSpace}{BackSpace}
Send {Space}gprs{Space}
return

; *****************************************************************************
; * HOTKEY
; *  Ctrl + Alt + R
; * DESCRIPTION
; *  快速发送日报
; * HOW TO USE
; *  写好日报后，选中要粘贴进邮件中的Excel内容，按快捷键
; *****************************************************************************
^!R::
replaceTimeString(dailyReportTitle, dailyReportTitle)

if(getExcelFormattingCopy(ClipSaved))
{
	sendMail(dailyReportAddr, dailyReportCC, dailyReportTitle, "", true, ClipSaved)
}
return

; *****************************************************************************
; * HOTKEY
; *  Ctrl + Alt + Z
; * DESCRIPTION
; *  快速发送周报
; * HOW TO USE
; *  写好周报后，选中要粘贴作为附件发送的周报文件，然后按快捷键
; *****************************************************************************
^!Z::
replaceTimeString(weeklyReportTitle, weeklyReportTitle)

if(getFormattingCopy(ClipSaved))
{
	sendMail(weeklyReportAddr, weeklyReportCC, weeklyReportTitle, weeklyReportBody, true, ClipSaved)
}
return

; *****************************************************************************
; * HOTKEY
; *  RCtrl + RAlt + F
; * DESCRIPTION
; *  运行 Flash_tool.exe
; * HOW TO USE
; *  直接按快捷键
; *****************************************************************************
>^>!F::
Run %flashToolPath%
return

; *****************************************************************************
; * HOTKEY
; *  RCtrl + RAlt + C
; * DESCRIPTION
; *  运行 Catcher.exe
; * HOW TO USE
; *  直接按快捷键
; *****************************************************************************
>^>!C::
Run %catcherPath%
return

; *****************************************************************************
; * HOTKEY
; *  RCtrl + RAlt + G
; * DESCRIPTION
; *  运行 mygold.exe
; * HOW TO USE
; *  直接按快捷键
; *****************************************************************************
>^>!G::
Run D:\Program Files\mygold\mygold.exe
return

; *****************************************************************************
; * HOTKEY
; *  RCtrl + RAlt + T
; * DESCRIPTION
; *  运行 terminal.exe
; * HOW TO USE
; *  直接按快捷键
; *****************************************************************************
>^>!T::
Run D:\Program Files\HY Trader\terminal.exe
return

; *****************************************************************************
; * HOTKEY
; *  RCtrl + RAlt + K
; * DESCRIPTION
; *  运行 KeePass.exe
; * HOW TO USE
; *  直接按快捷键
; *****************************************************************************
>^>!K::
Run D:\Program Files\KeePass Password Safe 2\KeePass.exe
return


; *****************************************************************************
; * HOTSTRING
; *  #sfzh
; * DESCRIPTION
; *  身份证号
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#sfzh::
SendInput 120224198504270318
return

; *****************************************************************************
; * HOTSTRING
; *  #sjhm
; * DESCRIPTION
; *  手机号码
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#sjhm::
SendInput 15821177690
return

; *****************************************************************************
; * HOTSTRING
; *  #zjh
; * DESCRIPTION
; *  座机号码
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#zjhm::
SendInput 021-58820022-492
return

; *****************************************************************************
; * HOTSTRING
; *  #yxdz
; * DESCRIPTION
; *  邮箱地址
; * 触发标志
; *  NULL
; *****************************************************************************
:*:#yxdz::
SendInput segon.xing@dewav.com
return
