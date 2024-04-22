#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk

myExpect := new expect()

; TODO Methods
; CLICK_HELPER
; EXECUTE_SEQUENCE_STEP
; EXECUTE_SEQUENCE_UNTIL_CAP
; HANDLE_GLOBAL_INTERRUPT_SINGLE
; HANDLE_GLOBAL_INTERRUPT_ALL

;;;;; CLICK_HELPER ;;;;;
myExpect.label("CLICK_HELPER used to minimize SciTE4AutoHotkey")
MsgBox, This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button
SetTitleMatchMode, 2 ; partial matches
WinMaximize, ahk_class SciTEWindow

MsgBox, 4,, "Did SciTE4AutoHotkey maximize?" ; 4 = Yes/No
myMaximizePromptResult = false
IfMsgBox Yes
	myMaximizePromptResult = true
else
	myMaximizePromptResult = false

CLICK_HELPER(1804, 12)

MsgBox, 4,, "Did SciTE4AutoHotkey close?" ; 4 = Yes/No
myMinimizePromptResult = false
IfMsgBox Yes
	myMinimizePromptResult = true
else
	myMinimizePromptResult = false

myExpect.true(myMinimizePromptResult)