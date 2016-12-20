; *****************************************************************************
; * FUNCTION
; *  getFormattingCopy
; * DESCRIPTION
; *  得到带格式的拷贝，将内容保存在dest中
; * PARAMETERS
; *  dest: 用于保存 ClipboardAll 数据的变量
; * RETURNS
; *  Success: true    Fail: flase
; *****************************************************************************
getFormattingCopy(ByRef dest)
{
    ;----------------------------------------------------------------
    ; Variables                                                
    ;----------------------------------------------------------------

    ;----------------------------------------------------------------
    ; Code Body                                                
    ;----------------------------------------------------------------	
    clipboard =
    ;执行复制
    Send ^c
    ;最多等待10秒，1代表任意类型数据均可，如果1忽略，那么只等待文本或文件的出现	
    ClipWait, 10, 1 

    if ErrorLevel
    {
        MsgBox Line %A_LineNumber%`nError: ClipWait failed
        return false
    }

    ; ClipboardAll 保存了所有数据，包括图片和格式，Clipboard只保存了可以以文本形式表现的内容
    dest = %ClipboardAll%  
    if(dest = "")
    {
        MsgBox Line %A_LineNumber%`nError: dest empty
        return false
    }	
	
    return true	
}

; *****************************************************************************
; * FUNCTION
; *  getExcelFormattingCopy
; * DESCRIPTION
; *  在Excel界面得到带格式的拷贝，将内容保存在dest中
; * PARAMETERS
; *  dest: 用于保存 ClipboardAll 数据的变量
; * RETURNS
; *  Success: true    Fail: false
; *****************************************************************************
getExcelFormattingCopy(ByRef dest)
{
    ;----------------------------------------------------------------
    ; Variables                                                
    ;----------------------------------------------------------------

    ;----------------------------------------------------------------
    ; Code Body                                                
    ;----------------------------------------------------------------
    ;当前界面如果不是在Excel界面，则退出	
    IfWinNotActive ahk_class XLMAIN
    {
        MsgBox Line %A_LineNumber%`nError: Not in Excel        
        return false
    }
    
    return getFormattingCopy(dest)	
}


; *****************************************************************************
; * FUNCTION
; *  sendMail
; * DESCRIPTION
; *  创建邮件
; * PARAMETERS
; *  addr    : 收件人地址
; *  cclist  : 抄送地址
; *  title   : 标题
; *  body    : 邮件内容
; *  needCopy: 是否需要进行拷贝动作
; *  src     : 拷贝数据源
; * RETURNS
; *  Success: true    Fail: false
; *****************************************************************************
sendMail(addr, cclist, title, body, needCopy, src)
{
    ;----------------------------------------------------------------
    ; Variables                                                
    ;----------------------------------------------------------------
    
    ;----------------------------------------------------------------
    ; Code Body                                                
    ;----------------------------------------------------------------    
    if(addr = ""){
        MsgBox Empty mail address
        return false
    }
    
    if(title = ""){
        MsgBox Empty mail subject
        return false
    }	
	
    ;判断 CC 列表是否为空，执行不同的Mailto
    if(cclist = ""){
        Run mailto: %addr%?subject=%title%&body=%body%
    }
    else{
        Run mailto: %addr%?subject=%title%&cc=%cclist%&body=%body%
    }
	
    ;等待 mail 窗口激活
    GroupAdd OutLookGroup, ahk_class rctrl_renwnd32
    GroupAdd OutLookGroup, ahk_class OpusApp
    WinWaitActive, ahk_group OutLookGroup, , 120
	
	;等待失败
    if (ErrorLevel){
        MsgBox Line %A_LineNumber%`nError: WinWaitActive failed
        return false
	}

    if(needCopy){
        if(src = ""){
            MsgBox Line %A_LineNumber%`nError: ClipSaved is empty
            return false
        }

        ;恢复一下剪切板，将需要拷贝的东东复制到邮件中
        Sleep 1000
        clipboard = %src%
        Send ^v	
    }
    
    return true    
}

; *****************************************************************************
; * FUNCTION
; *  ReplaceTimeString
; * DESCRIPTION
; *  将字串中的特定字符串替换成当前的日期或时间
; *  D_YYYY -> 年
; *  D_MM   -> 月
; *  D_DD   -> 日
; *  T_HH   -> 小时
; *  T_MM   -> 分钟
; *  T_SS   -> 秒
; * PARAMETERS
; *  outTimeString : 输出
; *  inTimeString : 需要处理的字串
; * RETURNS
; *  NULl
; *****************************************************************************
replaceTimeString(ByRef outTimeString, inTimeString)
{
    ;----------------------------------------------------------------
    ; Variables                                                
    ;----------------------------------------------------------------
    
    ;----------------------------------------------------------------
    ; Code Body                                                
    ;----------------------------------------------------------------
    StringRight, yWeek, A_YWeek, 4  ; A_YWeek is 200405, I just want 0405
    nextYWeek := yWeek + 1
    
    ;Date
    StringReplace inTimeString, inTimeString, D_YYYY, %A_YYYY%, all
    StringReplace inTimeString, inTimeString, D_MM, %A_MM%, all
    StringReplace inTimeString, inTimeString, D_DD, %A_DD%, all
    
    ;Week
    StringReplace inTimeString, inTimeString, D_YWEEK, %yWeek%, all
    StringReplace inTimeString, inTimeString, D_NEXTYWEEK, %nextYWeek%, all
    
    ;Time
    StringReplace inTimeString, inTimeString, T_HH, %A_Hour%, all
    StringReplace inTimeString, inTimeString, T_MM, %A_Min%, all
    StringReplace inTimeString, inTimeString, T_SS, %A_Sec%, all
    
    outTimeString = %inTimeString%
}