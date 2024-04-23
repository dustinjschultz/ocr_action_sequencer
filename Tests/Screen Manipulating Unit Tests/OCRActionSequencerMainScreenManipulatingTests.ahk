#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk

myExpect := new expect()

; TODO Methods
; CLICK_HELPER - DONE
; EXECUTE_SEQUENCE_STEP - test the different parameter combos
; EXECUTE_SEQUENCE_UNTIL_CAP
; HANDLE_GLOBAL_INTERRUPT_SINGLE
; HANDLE_GLOBAL_INTERRUPT_ALL

;;;;; CLICK_HELPER ;;;;;
myExpect.label("CLICK_HELPER used to minimize SciTE4AutoHotkey")
MsgBox, This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via a raw click
SetTitleMatchMode, 2 ; partial matches
WinMaximize, ahk_class SciTEWindow

MsgBox, 4,, "Did SciTE4AutoHotkey maximize?" ; 4 = Yes/No
myMaximizePromptResult := false
IfMsgBox Yes
	myMaximizePromptResult := true
else
	myMaximizePromptResult := false

myMinimizePromptResult := false

if (myMaximizePromptResult) {
	CLICK_HELPER(1804, 12)

	MsgBox, 4,, "Did SciTE4AutoHotkey minimize?" ; 4 = Yes/No
	IfMsgBox Yes
		myMinimizePromptResult := true
	else
		myMinimizePromptResult := false
}

myExpect.true(myMinimizePromptResult)


;;;;; EXECUTE_SEQUENCE_STEP ;;;;;
myExpect.label("EXECUTE_SEQUENCE_STEP - minimize SciTE4AutoHotkey sequence")
MsgBox, This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via a Sequence
SetTitleMatchMode, 2 ; partial matches
WinMaximize, ahk_class SciTEWindow

MsgBox, 4,, "Did SciTE4AutoHotkey maximize?" ; 4 = Yes/No
myMaximizePromptResult := false
IfMsgBox Yes
	myMaximizePromptResult := true
else
	myMaximizePromptResult := false

myActionSequenceMinimizePromptResult := false

if(myMaximizePromptResult){
	myJsonString := READ_FILE_CONTENTS("MinimizeSciTE4AutoHotkeyPlusSequenceData.txt", myFilePath)
	myTestSequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(myJsonString)
	EXECUTE_SEQUENCE_STEP(myTestSequenceData.getStepList(), 1, true)

	MsgBox, 4,, "Did SciTE4AutoHotkey minimize?" ; 4 = Yes/No
	IfMsgBox Yes
		myActionSequenceMinimizePromptResult := true
	else
		myActionSequenceMinimizePromptResult := false
}

myExpect.true(myActionSequenceMinimizePromptResult)

myExpect.fullReport()