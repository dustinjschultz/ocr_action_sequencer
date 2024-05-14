#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk
#Include %A_ScriptDir%\Tests\Test Helpers\Misc Test Helpers.ahk

myExpect := new expect()
TEST_CHECK_TEXT_ON_SCREEN_BASIC_TEST(myExpect)
TEST_GET_SCREEN_TEXT_BASIC_TEST(myExpect)
TEST_GET_PREVIOUS_STEP_ORDINAL_BASIC_TEST(myExpect)
TEST_GET_PREVIOUS_STEP_ORDINAL_WRAP_AROUND(myExpect)
TEST_LOAD_SEQUENCE_DATA_FROM_JSON_STRING_BASIC_TEST(myExpect)
myExpect.fullReport()


;;;;; CHECK_TEXT_ON_SCREEN ;;;;;
TEST_CHECK_TEXT_ON_SCREEN_BASIC_TEST(theExpect){
	theExpect.label("CHECK_TEXT_ON_SCREEN windows time in bottom right")
	myTextCheck = TEST_HELPER_BUILD_WINDOWS_TIME_TEXT_CHECK()
	theExpect.true(CHECK_TEXT_ON_SCREEN(myTextCheck.getSearchText(), 1, 1, myTextCheck))
}

;;;;; GET_SCREEN_TEXT ;;;;;
TEST_GET_SCREEN_TEXT_BASIC_TEST(theExpect){
	theExpect.label("GET_SCREEN_TEXT windows time in bottom right")
	myResult := GET_SCREEN_TEXT(1801, 1041, 1864, 1060)
	theExpect.true(DOES_TEXT_CONTAIN(myResult, "AM|PM"))
}


;;;;; GET_PREVIOUS_STEP_ORDINAL ;;;;;
TEST_GET_PREVIOUS_STEP_ORDINAL_BASIC_TEST(theExpect){
	theExpect.label("GET_PREVIOUS_STEP_ORDINAL before step 9 of 10 is 8")
	theExpect.equal(8, GET_PREVIOUS_STEP_ORDINAL(9, 10)) ; the step before 9 (a non-edge value) is 8
}

TEST_GET_PREVIOUS_STEP_ORDINAL_WRAP_AROUND(theExpect){
	theExpect.label("GET_PREVIOUS_STEP_ORDINAL before step 1 of 10 is 10 (wrap-around edge case test)")
	theExpect.equal(10, GET_PREVIOUS_STEP_ORDINAL(1, 10)) ; the step before 1 (the first) is the 10 (the last)
}


;;;;; LOAD_SEQUENCE_DATA_FROM_JSON_STRING ;;;;;
TEST_LOAD_SEQUENCE_DATA_FROM_JSON_STRING_BASIC_TEST(theExpect){
	theExpect.label("LOAD_SEQUENCE_DATA_FROM_JSON_STRING basic test")
	myFilePath := A_ScriptDir . "\Tests\Test Files\"
	myJsonString := READ_FILE_CONTENTS("MinimizeSciTE4AutoHotkeyPlusSequenceData.txt", myFilePath)
	myTestSequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(myJsonString)
	theExpect.equal(1, myTestSequenceData.getSequenceLoopLimit())
	theExpect.equal(1, myTestSequenceData.getStepList().Length())
	myTestStep := myTestSequenceData.getStepList()[1]
	theExpect.equal("SciTE4AutoHotkey title bar", myTestStep.getElementName())
	theExpect.equal(4, myTestStep.getCheckExistsTryLimitIntervalList().Length())
	theExpect.equal(1, myTestStep.getCheckExistsTryLimitIntervalList()[1])
	theExpect.equal(10, myTestStep.getCheckExistsTryLimitIntervalList()[2])
	theExpect.equal(10, myTestStep.getCheckExistsTryLimitIntervalList()[3])
	theExpect.equal(1, myTestStep.getCheckExistsTryLimitIntervalList()[4])
	theExpect.equal(100, myTestStep.getMillisecondsBetweenRetries())
	theExpect.equal(".*SciTE4AutoHotkey.*", myTestStep.getTextCheck().getSearchText())
	theExpect.equal(20, myTestStep.getTextCheck().getTopLeftX())
	theExpect.equal(0, myTestStep.getTextCheck().getTopLeftY())
	theExpect.equal(900, myTestStep.getTextCheck().getBottomRightX())
	theExpect.equal(20, myTestStep.getTextCheck().getBottomRightY())
	theExpect.equal(1806, myTestStep.getTapX())
	theExpect.equal(3, myTestStep.getTapY())
	theExpect.equal(500, myTestStep.getMillisecondsWaitAfter())
}


