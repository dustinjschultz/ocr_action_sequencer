#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk

; We need this file so that the actual main file doesn't contain hotkeys so that we #Include it in our tests.
; Otherwise the #Include usages start acting funky.

\::
	ADD_GLOBAL_INTERRUPT_VIA_PATH("PGo Auto Trader\Desktop_SP20Tablet_APowerMirrorResumeSequenceData.txt")
	ADD_GLOBAL_INTERRUPT_VIA_PATH("PGo Auto Trader\Desktop_SP20Tablet_PGoNewSizeRecordPopupSequenceData.txt")
	EXECUTE_SEQUENCE_UNTIL_CAP_VIA_PATH("PGo Auto Trader\Desktop_SP20Tablet_PGoAutoTradeSequenceData.txt")
return

0::
	; random debug stuff

	;myTemp := GET_NEW_RECORD_CONFIG_OBJECT()
	;DISPLAY_MESSAGE(myTemp.stepList[1].elementName)
	;EXECUTE_SEQUENCE_STEP(myTemp.stepList, 1, true)
	;EXECUTE_SEQUENCE_STEP(myTemp.stepList, 2, true)
	;EXECUTE_SEQUENCE_STEP(myTemp.stepList, 3, true)
	;EXECUTE_SEQUENCE_STEP(myTemp.stepList, 4, true)
	;EXECUTE_SEQUENCE_STEP(myTemp.stepList, 5, true)

	;myCoordinateObject := myTemp.stepList[5].textCheckObject
	;myResult := GET_SCREEN_TEXT(myCoordinateObject.topLeftX, myCoordinateObject.topLeftY, myCoordinateObject.bottomRightX, myCoordinateObject.bottomRightY)

	;HANDLE_APOWERMIRROR_TIMEOUTS()
	;HANDLE_NEW_RECORD()

	;myDebugFileContents := READ_FILE_CONTENTS("TestTextFile.txt")
	;DISPLAY_MESSAGE(myDebugFileContents)

	;myDebugFileContents := READ_FILE_CONTENTS("Test\MinimizeSciTE4AutoHotkeyPlusSequenceData.txt", "C:\git\temp OCR Action Sequencer\Sequence Data\")
	;myTemp := JSON.Load(myDebugFileContents)
	;EXECUTE_SEQUENCE_STEP(myTemp.stepList, 1, true)

	;HANDLE_GLOBAL_INTERRUPT_SINGLE("PGo Auto Trader\Desktop_SP20Tablet_APowerMirrorResumeSequenceData.txt")
	;HANDLE_GLOBAL_INTERRUPT_ALL()

	;LOAD_SEQUENCE_DATA_FROM_JSON_STRING(READ_FILE_CONTENTS("PGo Auto Trader\Laptop_PGoAutoTradeSequenceData.txt"))

	EXECUTE_SEQUENCE_UNTIL_CAP_VIA_PATH("Test\MinimizeSciTE4AutoHotkeyPlusSequenceData.txt")

	;INCLUDE_FILE("test")
return
