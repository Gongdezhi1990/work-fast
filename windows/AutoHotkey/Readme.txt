/******************************************
 * 
 *  热键
 *
 ******************************************/
 
鼠标左键+右键 :
    同时按，可以移动当前窗口（非最大化）

RCtrl + RAlt + C :
    运行Catcher，路径从Config.ini中"CatcherPath"字段获得
    
RCtrl + RAlt + F :
    运行FlashTool，路径从Config.ini中"FlashToolPath"字段获得  

RCtrl + RAlt + G :
    运行 Mygold        

RCtrl + RAlt + K :
    运行 KeePass

Ctrl + Alt + R :
    快速发送日报, 写好日报后，选中要粘贴进邮件中的Excel内容，按快捷键
    收件人地址从Config.ini中"DailyReportAddr"字段获得
    抄送地址从Config.ini中"DailyReportCC"字段获得
    标题从Config.ini中"DailyReportTitle"字段获得

RCtrl + RAlt + T :
    运行 HY Trader
    
Ctrl + Alt + Z :
	快速发送周报, 写好周报后，选中要粘贴作为附件发送的周报文件，然后按快捷键  
    收件人地址从Config.ini中"WeeklyReportAddr"字段获得
    抄送地址从Config.ini中"WeeklyReportCC"字段获得
    标题从Config.ini中"WeeklyReportTitle"字段获得	
    邮件正文从Config.ini中"WeeklyReportBody"字段获得
      	  
/******************************************
 * 
 *  热字串
 *
 ******************************************/
 
#mem :
    从Config.ini读取"DepartmentMembers" 字段的内容
    
#lea :
    从Config.ini读取"DepartmentLeaders" 字段的内容    

#rq :
    当前日期，格式参考:  2013_03_18
    
#sj :   
    当前时间，格式参考:  11：33：21
    
#rjh :
    日计划标题， 格式参考: DailySchedule_2013-03-18       
    
#zjh :
    周计划标题， 格式参考: WeeklySchedule_1312
    
    