
Menu, TRAY, Tip, QSML V0.3`nCtrl+Alt+C: Quick send Modification Log

;******************************************************************************
;*  Include
;******************************************************************************
#include Function.ahk

;******************************************************************************
;*  全局变量
;******************************************************************************
MailBody = .

; *****************************************************************************
; * HOTKEY
; *  Ctrl + Alt + B
; * DESCRIPTION
; *  快速发送Bug走读记录
; * HOW TO USE
; *  写好Bug走读记录后，选中要粘贴进邮件中的Excel内容，按快捷键。相关配置可以
; *  在QSML_config.ini 中进行修改
; *****************************************************************************
^!C::

if(A_YYYY > 2013)
{
	if (showDebugInfo)
	{
	    MsgBox Line %A_LineNumber%`nError: Runtime
	}
    return
}

; 判断当前是否在Excel中
IfWinNotActive ahk_class XLMAIN
{
	if (showDebugInfo)
	{
	    MsgBox Line %A_LineNumber%`nError: Not in Excel
	}	
	return
}

; Variable
BugId = 
AutherName = 

; 判断INI文件是否存在
if (FileExist("QSML_config.ini") = "")
{
	MsgBox Can't find the configuration file!
	Goto ClearVal
}

; 读取设置
IniRead MailAddr, %A_WorkingDir%\QSML_config.ini, CONFIG, MailAddressList
if(MailAddr == "ERROR")
{
	MsgBox MailAddress error, please modify it in QSML_config.ini!
	Goto ClearVal
}
else
{
	StringReplace MailAddr, MailAddr, %A_space%, , all
	StringReplace MailAddr, MailAddr, %A_Tab%, , all
	if(MailAddr = "")
	{
		MsgBox MailAddress error, please modify it in QSML_config.ini!
		Goto ClearVal
	}
}
IniRead MailCC,   %A_WorkingDir%\QSML_config.ini, CONFIG, MailCCList
IniRead AutherName,   %A_WorkingDir%\QSML_config.ini, CONFIG, Auther_Name
if(AutherName == "ERROR")
{
	MsgBox AutherName error, please modify it in QSML_config.ini!
	Goto ClearVal
}
else
{
	StringReplace AutherName, AutherName, %A_space%, , all
	StringReplace AutherName, AutherName, %A_Tab%, , all
	if(AutherName = "")
	{
		MsgBox AutherName error, please modify it in QSML_config.ini!
		Goto ClearVal
	}
}

; 复制并读取EXCEL内容
if(ExcelGetFormattingCopy(ClipSaved))
{
	;得到BugID
	if (0)
	{
		BugId := SubStr(clipboard, (InStr(clipboard, "BugID", false, 1) + StrLen("BugID")), (InStr(clipboard, "日期",  false, 1) - InStr(clipboard, "BugID", false, 1) - StrLen("BugID")))  
		if (BugId = "")
		{
			MsgBox BugId is empty, please write it!
			Goto ClearVal
		}	
	}
	
	;邮件标题
	MailSubject = Modification Log(ID = , Author = %AutherName%)	
	
	SendMailWithFormattingCopy(MailAddr, MailCC, MailSubject, MailBody, ClipSaved)
}

;清空数据
ClearVal:
MailAddr =
MailCC =
MailSubject =
MailBody = .
BugId = 
AutherName = 
ClipSaved =
return
