; *****************************************************************************
; * AUTORUN
; *  Auto Power On Modis
; * DESCRIPTION
; *  如果Modis窗口存在，每隔5秒检测一次是否仍然存在
; *  如果Modis窗口不存在，等待窗口启动
; *****************************************************************************
Label_AutoPowerOnModis:
if WinExist("MTK Simulator")
{
	WinWaitClose MTK Simulator
	SetTimer Label_AutoPowerOnModis, 100
}
else
{
	WinWaitActive MTK Simulator
	Sleep 100
	; Enter 键启动Modis
	Send {Enter}
	SetTimer Label_AutoPowerOnModis, 100
}
return


