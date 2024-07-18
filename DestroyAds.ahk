#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
DetectHiddenText, On
DetectHiddenWindows, On
SetTitleMatchMode, 2




GLOBAL ThreadToggle := "0"

GLOBAL ConfigFileTitle := "adShredder.cfg" ;; remove the X on the end!
GLOBAL config_path := A_ScriptDir . "\" . ConfigFileTitle


Sleep, 500
ConfigFileHandler()
Sleep, 500

; GLOBAL AppTitleRoot := "Youtube Ad-Shredder"
GLOBAL AppTitleRoot := AppHeader

; If (UACelevate = "1")
If (UACelevate = "1" or LockInputDuringClick = "1")  ;;; this admin is probably needed to lock mouse...
{
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try ; leads to having the script re-launching itself as administrator
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}
}

t1:=A_TickCount, Text:=X:=Y:=""



;;;;; TRAY MENU STRUCT
Menu, Tray, NoStandard
Menu, Tray, Add, Settings, SettingsBTN  ; Creates a new menu item.
Menu, Tray, Add, Open Container, OpenDirectoryRootBTN  ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
; Menu, Tray, Add, Halt Root Threads, clampRootThreadCalls   ; Creates a new menu item.
Menu, Tray, Add, Start Ad-Shredding, reRunHotSpotSThreadCall   ; Creates a new menu item.
Menu, Tray, Add, Stop Ad-Shredding, clampHotSpotSThreadCall   ; Creates a new menu item.
Menu, Tray, Add, Toggle All Threads, ToggleAllThreads   ; Creates a new menu item.
; Menu, Tray, Add, Stop Auto-Server, clampServerThreadCalls   ; Creates a new menu item.
; Menu, Tray, Add, Start Auto-Server, reRunServerThreadCalls   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Refresh String Table, RefreshGlobalStrControl   ; Creates a new menu item.
Menu, Tray, Add  ; Creates a separator line.
Menu, Tray, Add, Reboot Engine, ReloadBTN   ; Creates a new menu item.
Menu, Tray, Add, Exit, ExitBTN   ; Creates a new menu item.


Menu, Tray, Tip, %AppTitleRoot%

SetTimer, DismissAdsViaFindText, %DismissAdvertTiming%

If(CheckForBrowserWindow="1")
{
SetTimer, DetermineIfWebBrowserWindowExists, %VerifyWindowTiming%
}

If(PollSettings="1")
{
SetTimer, bPollConfigSettings, %PollSettingsTime%
}

Return




Return
DismissAdsViaFindText:
;;;; this is a version of the text with the cursor hovering over the video pane at the time of capture
; if (ok:=FindText(X, Y, 2459-150000, 1131-150000, 2459+150000, 1131+150000, 0, 0, BText))
if (ok:=FindText(X, Y, TextAinput01, TextAinput02, TextAinput03, TextAinput04, 0, 0, AText))
{
    MouseGetPos, xRestorePosition, yRestorePosition
    If(LockInputDuringClick="1")
    {
    BlockInput, On
    }
    FindText().Click(X, Y, "L")
    BlockInput, Off
    If(RestoreMousePosAfterClick="1")
    {
    MouseMove, xRestorePosition, yRestorePosition
    }
}
Sleep, %AdvertTimerAtoB%
;;;; this is another version of the above
; if (ok:=FindText(X, Y, 2459-150000, 1131-150000, 2459+150000, 1131+150000, 0, 0, AText))
if (ok:=FindText(X, Y, TextBinput01, TextBinput02, TextBinput03, TextBinput04, 0, 0, BText))
{
    MouseGetPos, xRestorePosition, yRestorePosition
    If(LockInputDuringClick="1")
    {
    BlockInput, On
    }
    FindText().Click(X, Y, "L")
    BlockInput, Off
    If(RestoreMousePosAfterClick="1")
    {
    MouseMove, xRestorePosition, yRestorePosition
    }
}
Sleep, %AdvertTimerBtoC%
;;;; a version of the idling skip button here, but without the skip button being idle long enough to grey out
; if (ok:=FindText(X, Y, 2461-150000, 1130-150000, 2461+150000, 1130+150000, 0, 0, CText))
if (ok:=FindText(X, Y, TextCinput01, TextCinput02, TextCinput03, TextCinput04, 0, 0, CText))
{
    MouseGetPos, xRestorePosition, yRestorePosition
    If(LockInputDuringClick="1")
    {
    BlockInput, On
    }
    FindText().Click(X, Y, "L")
    BlockInput, Off
    If(RestoreMousePosAfterClick="1")
    {
    MouseMove, xRestorePosition, yRestorePosition
    }
}
Sleep, %AdvertTimerCtoD%
;;;; this is the text of the skip button when it is idling and greyed out
; if (ok:=FindText(X, Y, 2459-150000, 1131-150000, 2459+150000, 1131+150000, 0, 0, DText))
if (ok:=FindText(X, Y, TextDinput01, TextDinput02, TextDinput03, TextDinput04, 0, 0, DText))
{
    MouseGetPos, xRestorePosition, yRestorePosition
    If(LockInputDuringClick="1")
    {
    BlockInput, On
    }
    FindText().Click(X, Y, "L")
    BlockInput, Off
    If(RestoreMousePosAfterClick="1")
    {
    MouseMove, xRestorePosition, yRestorePosition
    }
}
Return



Return
DetermineIfWebBrowserWindowExists:
; if not WinExist(" - Opera")
if not WinExist(BrowserTitle)
    {
    ; MsgBox, , OPERA DOESN'T EXIST!, OPERA WINDOW DOES NOT EXIST!, 15
    ExitApp
    }

Return





Return
bPollConfigSettings:

ConfigFileHandler()

Return













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


OpenDirectoryRootBTN:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {OpenDirectoryRootBTN} label executed during TrayMenu call., %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
Run, explorer.exe ""%A_ScriptDir%""
Return



RefreshGlobalStrControl:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {RefreshGlobalStrControl} label executed during TrayMenu call., %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
ConfigFileHandler()
Return



ReloadBTN:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {ReloadBTN} label executed during TrayMenu call.--Preparing to re-execute the engine subsystem..., %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
Reload
Return



SettingsBTN:
; Run, "notepad.exe" %A_MyDocuments%\HotSpots\autohotspot_handler.cfg
; Run, "notepad.exe" %A_MyDocuments%\HotSpots\%ConfigFileTitle%
Run, "notepad.exe" %config_path%
    ; If(ShowDebugMessages="4")
    ; {
    ;     MsgBox,, [ChainOverflow]: Settings Control Event, Executing partially hard-coded directory,
    ; }
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {SettingsBTN} label executed during TrayMenu call., %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
return



ToggleAllThreads:
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {ToggleAllThreads} label executed during TrayMenu call., %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
ConfigFileHandler()
If(ThreadToggle="0")
{
    GLOBAL ThreadToggle := "1"
    ; MsgBox,,, Toggle State A
    SetTimer, DismissAdsViaFindText, Off
    SetTimer, bPollConfigSettings, Off
    SetTimer, DetermineIfWebBrowserWindowExists, Off
    Return
}
If(ThreadToggle="1")
{
    GLOBAL ThreadToggle := "0"
    ; MsgBox,,, Toggle State B

SetTimer, DismissAdsViaFindText, %DismissAdvertTiming%

If(CheckForBrowserWindow="1")
{
SetTimer, DetermineIfWebBrowserWindowExists, %VerifyWindowTiming%
}

If(PollSettings="1")
{
SetTimer, bPollConfigSettings, %PollSettingsTime%
}

}
Return




clampHotSpotSThreadCall:
ConfigFileHandler()
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {clampRunHotSpotsThread} label executed during TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
SetTimer, DismissAdsViaFindText, Off
return




reRunHotSpotSThreadCall:
ConfigFileHandler()
;;;;;;;
;;;;;;; DEBUGGER LEVEL 02
; IniRead, aDevDebugger, %config_path%, DEBUG, Debugger, 0
; GLOBAL DevDebugger := aDevDebugger
; IniRead, aDevDebuggerLevel, %config_path%, DEBUG, DebuggerLevel, 1
; GLOBAL DevDebuggerLevel := aDevDebuggerLevel
; If(DevDebugger="1")
; {
;     If(DevDebuggerLevel="2")
;     {
;      MsgBox, 4096, %DbgTitle0x02%, {reRunHotSpotsThread} label executed during TrayMenu call.`n`n -AutoHotspot Setting: %HotspotSwitch%`n -AutoConnect Setting: %AutoConnect%, %DbgGlobalTimeout%
;     }
; }
;;;;;;;
;;;;;;;
;;;;;;;
SetTimer, DismissAdsViaFindText, %DismissAdvertTiming%
return






Return
ExitBTN:
ExitApp
Return









#Include, FindTextConfigLibrary.toolkit
#Include, FindTextLibrary.toolkit




; MsgBox, 4096, Tip, % "Found:`t" (IsObject(ok)?ok.Length():ok)
;   . "`n`nTime:`t" (A_TickCount-t1) " ms"
;   . "`n`nPos:`t" X ", " Y
;   . "`n`nResult:`t<" (IsObject(ok)?ok[1].id:"") ">"

; Try For i,v in ok  ; ok value can be get from ok:=FindText().ok
;   if (i<=2)
;     FindText().MouseTip(ok[i].x, ok[i].y)







