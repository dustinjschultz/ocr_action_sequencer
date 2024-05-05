#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk

myExpect := new expect()
TEST_CHECK_TEXT_ON_SCREEN_BASIC_TEST(myExpect)
myExpect.fullReport()

; TODO Methods - TBD which are actually unit-testable
; CLICK_HELPER - TODO: put into semi-automated tests
; CHECK_TEXT_ON_SCREEN - done
; GET_SCREEN_TEXT - done
; EXECUTE_SEQUENCE_STEP - TODO: put into semi-automated tests
; GET_PREVIOUS_STEP_ORDINAL - done
; EXECUTE_SEQUENCE_UNTIL_CAP - TODO: put into semi-automated tests
; HANDLE_GLOBAL_INTERRUPT_SINGLE - TODO: put into semi-automated tests
; HANDLE_GLOBAL_INTERRUPT_ALL - TODO: put into semi-automated tests
; LOAD_SEQUENCE_DATA_FROM_JSON_STRING - done

;;;;; CHECK_TEXT_ON_SCREEN ;;;;;
TEST_CHECK_TEXT_ON_SCREEN_BASIC_TEST(theExpect){
	theExpect.label("CHECK_TEXT_ON_SCREEN windows time in bottom right")
	myTextCheck = new TextCheck()
	myTextCheck.setBottomRightX(1864)
	myTextCheck.setBottomRightY(1060)
	myTextCheck.setSearchText("AM|PM")
	myTextCheck.setTopLeftX(1801)
	myTextCheck.setTopLeftY(1041)
	theExpect.true(CHECK_TEXT_ON_SCREEN(myTextCheck.getSearchText(), 1, 1, myTextCheck))
}

; TODO: put the rest of these into functions then call them above

;;;;; GET_SCREEN_TEXT ;;;;;
myExpect.label("GET_SCREEN_TEXT windows time in bottom right")
myResult := GET_SCREEN_TEXT(1801, 1041, 1864, 1060)
myExpect.true(DOES_TEXT_CONTAIN(myResult, "AM|PM"))


;;;;; GET_PREVIOUS_STEP_ORDINAL ;;;;;
myExpect.label("GET_PREVIOUS_STEP_ORDINAL before step 9 of 10 is 8")
myExpect.equal(8, GET_PREVIOUS_STEP_ORDINAL(9, 10)) ; the step before 9 (a non-edge value) is 8

myExpect.label("GET_PREVIOUS_STEP_ORDINAL before step 1 of 10 is 10 (wrap-around edge case test)")
myExpect.equal(10, GET_PREVIOUS_STEP_ORDINAL(1, 10)) ; the step before 1 (the first) is the 10 (the last)


;;;;; LOAD_SEQUENCE_DATA_FROM_JSON_STRING ;;;;;
myExpect.label("LOAD_SEQUENCE_DATA_FROM_JSON_STRING basic test")
myFilePath := A_ScriptDir . "\Tests\Test Files\"
myJsonString := READ_FILE_CONTENTS("MinimizeSciTE4AutoHotkeyPlusSequenceData.txt", myFilePath)
myTestSequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(myJsonString)
myExpect.equal(1, myTestSequenceData.getSequenceLoopLimit())
myExpect.equal(1, myTestSequenceData.getStepList().Length())
myTestStep := myTestSequenceData.getStepList()[1]
myExpect.equal("SciTE4AutoHotkey title bar", myTestStep.getElementName())
myExpect.equal(4, myTestStep.getCheckExistsTryLimitIntervalList().Length())
myExpect.equal(1, myTestStep.getCheckExistsTryLimitIntervalList()[1])
myExpect.equal(10, myTestStep.getCheckExistsTryLimitIntervalList()[2])
myExpect.equal(10, myTestStep.getCheckExistsTryLimitIntervalList()[3])
myExpect.equal(1, myTestStep.getCheckExistsTryLimitIntervalList()[4])
myExpect.equal(100, myTestStep.getMillisecondsBetweenRetries())
myExpect.equal(".*SciTE4AutoHotkey.*", myTestStep.getTextCheck().getSearchText())
myExpect.equal(20, myTestStep.getTextCheck().getTopLeftX())
myExpect.equal(0, myTestStep.getTextCheck().getTopLeftY())
myExpect.equal(900, myTestStep.getTextCheck().getBottomRightX())
myExpect.equal(20, myTestStep.getTextCheck().getBottomRightY())
myExpect.equal(1806, myTestStep.getTapX())
myExpect.equal(3, myTestStep.getTapY())
myExpect.equal(500, myTestStep.getMillisecondsWaitAfter())


