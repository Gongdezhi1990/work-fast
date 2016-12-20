;******************************************************************************
;*  此AHK用来读取配置文件
;******************************************************************************
; 判断INI文件是否存在
if (FileExist("Config.ini") = "")
{
	MsgBox Can't find the Config.ini!
	return
}

; 读取部门成员
IniRead departmentMembers, %A_WorkingDir%\Config.ini, CONFIG, DepartmentMembers
; 读取部门主管
IniRead departmentLeaders, %A_WorkingDir%\Config.ini, CONFIG, DepartmentLeaders
; 读取客户经理
IniRead customerManagers, %A_WorkingDir%\Config.ini, CONFIG, CustomerManagers

; 读取日报收件人
IniRead dailyReportAddr, %A_WorkingDir%\Config.ini, CONFIG, DailyReportAddr
; 读取日报抄送
IniRead dailyReportCC, %A_WorkingDir%\Config.ini, CONFIG, DailyReportCC
; 读取日报标题
IniRead dailyReportTitle, %A_WorkingDir%\Config.ini, CONFIG, DailyReportTitle

; 读取周报收件人
IniRead weeklyReportAddr, %A_WorkingDir%\Config.ini, CONFIG, WeeklyReportAddr
; 读取周报抄送
IniRead weeklyReportCC, %A_WorkingDir%\Config.ini, CONFIG, WeeklyReportCC
; 读取周报标题
IniRead weeklyReportTitle, %A_WorkingDir%\Config.ini, CONFIG, WeeklyReportTitle
; 读取周报正文
IniRead weeklyReportBody, %A_WorkingDir%\Config.ini, CONFIG, WeeklyReportBody

; Catcher 路径
IniRead catcherPath, %A_WorkingDir%\Config.ini, CONFIG, CatcherPath
; Flash tool 路径
IniRead flashToolPath, %A_WorkingDir%\Config.ini, CONFIG, FlashToolPath
