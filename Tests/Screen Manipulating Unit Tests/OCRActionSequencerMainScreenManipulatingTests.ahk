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
	;myJsonString := READ_FILE_CONTENTS("MinimizeSciTE4AutoHotkeyPlusSequenceData.txt", myFilePath)
	;myTestSequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(myJsonString)
	myTestSequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1, 10, 10, 1])
	EXECUTE_SEQUENCE_STEP(myTestSequenceData.getStepList(), 1, true)

	MsgBox, 4,, "Did SciTE4AutoHotkey minimize?" ; 4 = Yes/No
	IfMsgBox Yes
		myActionSequenceMinimizePromptResult := true
	else
		myActionSequenceMinimizePromptResult := false
}

myExpect.true(myActionSequenceMinimizePromptResult)


myExpect.label("EXECUTE_SEQUENCE_STEP - theIsOriginalTryFlag = false to override checkExistsIntervalList")
; So this test is interesting. We don't have a perfect way to detect whether the intended behavior is happening.
; When theIsOriginalTryFlag = false, we expect checkExistsIntervalList to be overriden to just [1].
; We'll take advantage of the fact that checkExistsIntervalList controls a loop with some other waits.
; So first we'll do a call without it overriden, then a follow-up call that we expect to take significantly
; less time because of less iterations. However we can't be 100% confident in the timing, since along the way
; it calls to an external dependency (the image OCR part) which takes a variable amount of time.

myMultipleAttemptsTestSequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([5])
mySingleAttemptTestSequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1])
mySingleAttemptTestSequenceData.getStepList()[1].getTextCheck().setSearchText("this will never be found")
myMultipleAttemptsTestSequenceData.getStepList()[1].getTextCheck().setSearchText("this will never be found")

; don't put breakpoints in these chunks since A_TickCount would count those as processing time
myMultipleAttemptsStartTime := A_TickCount
EXECUTE_SEQUENCE_STEP(myMultipleAttemptsTestSequenceData.getStepList(), 1, true)
myMultipleAttemptsEndTime := A_TickCount
myMultipleAttemptsDuration := myMultipleAttemptsEndTime - myMultipleAttemptsStartTime

mySingleAttemptsStartTime := A_TickCount
EXECUTE_SEQUENCE_STEP(mySingleAttemptTestSequenceData.getStepList(), 1, true)
mySingleAttemptsEndTime := A_TickCount
mySingleAttemptsDuration := mySingleAttemptsEndTime - mySingleAttemptsStartTime

myExpect.true(mySingleAttemptsDuration * 4 < myMultipleAttemptsDuration) ; multiply by one less than the actual attempts to absorb the variance of a single call




myExpect.fullReport()




TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE(theCheckExistsTryLimitIntervalList){
	; AHK gets confused when you reuse variable names sometimes that are allegedly global, so we gotta make them unique here in the tests
	myTestMinimizeSciteSequenceData := new SequenceData()
	myTestMinimizeSciteSequenceData.setSequenceLoopLimit(1)
	myTestMinimizeSciteSequenceData.setStepList([])
	myTestMinimizeSciteStep := new Step()
	myTestMinimizeSciteStep.setCheckExistsTryLimitIntervalList(theCheckExistsTryLimitIntervalList)
	myTestMinimizeSciteStep.setElementName("SciTE4AutoHotkey title bar")
	myTestMinimizeSciteStep.setMillisecondsBetweenRetries(100)
	myTestMinimizeSciteStep.setMillisecondsWaitAfter(500)
	myTestMinimizeSciteStep.setTapX(1806)
	myTestMinimizeSciteStep.setTapY(3)
	myTestTextCheck := new TextCheck()
	myTestTextCheck.setBottomRightX(900)
	myTestTextCheck.setBottomRightY(20)
	myTestTextCheck.setSearchText(".*SciTE4AutoHotkey.*|.*SCiTE4AutoHotkey.*") ; c capitalization difference is needed
	myTestTextCheck.setTopLeftX(20)
	myTestTextCheck.settopLeftY(0)
	myTestMinimizeSciteStep.setTextCheck(myTestTextCheck)
	myTestMinimizeSciteSequenceData.getStepList().push(myTestMinimizeSciteStep)
	return myTestMinimizeSciteSequenceData
}
