#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk

myExpect := new expect()

; TODO Methods - TBD which are actually unit-testable
; CLICK_HELPER
; CHECK_TEXT_ON_SCREEN
; GET_SCREEN_TEXT
; EXECUTE_SEQUENCE_STEP
; GET_PREVIOUS_STEP_ORDINAL
; EXECUTE_SEQUENCE_UNTIL_CAP
; HANDLE_GLOBAL_INTERRUPT_SINGLE
; HANDLE_GLOBAL_INTERRUPT_ALL
; LOAD_SEQUENCE_DATA_FROM_JSON_STRING

;;;;; CHECK_TEXT_ON_SCREEN ;;;;;
myExpect.label("CHECK_TEXT_ON_SCREEN windows time in bottom right")
myTextCheck = new TextCheck()
myTextCheck.setBottomRightX(1864)
myTextCheck.setBottomRightY(1060)
myTextCheck.setSearchText("AM|PM")
myTextCheck.setTopLeftX(1801)
myTextCheck.setTopLeftY(1041)
myExpect.true(CHECK_TEXT_ON_SCREEN(myTextCheck.getSearchText(), 1, 1, myTextCheck))



myExpect.fullReport()