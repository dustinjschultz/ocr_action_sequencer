#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk

myExpect := new expect()

; TODO Methods
; CLICK_HELPER - DONE
; EXECUTE_SEQUENCE_STEP - DONE
; EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT - DONE
; HANDLE_GLOBAL_INTERRUPT_SINGLE
; HANDLE_GLOBAL_INTERRUPT_ALL

; TODO: after the other files have their tests tucked into methods, come back and un-verbose-ify these awful variable names

; Write the tests in their own methods then call them here because
; 1. to easily tell their start and end
; 2. so their varaibles aren't global
TEST_CLICK_HELPER_BASIC_TEST(myExpect)
TEST_EXECUTE_SEQUENCE_STEP_BASIC_TEST(myExpect)
TEST_EXECUTE_SEQUENCE_STEP_ORIGINAL_TRY_FALSE(myExpect)
TEST_EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT_USES_LOOP_LIMIT(myExpect)
myExpect.fullReport()


;;;;; CLICK_HELPER ;;;;;
TEST_CLICK_HELPER_BASIC_TEST(theExpect){
	theExpect.label("CLICK_HELPER used to minimize SciTE4AutoHotkey")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via a raw click")

	myMaximizePromptResultForClickHelper := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey maximize?")
	if (myMaximizePromptResultForClickHelper) {
		CLICK_HELPER(1804, 12)
		myMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey minimize?")
	}

	theExpect.true(myMinimizePromptResult)
}


;;;;; EXECUTE_SEQUENCE_STEP ;;;;;
TEST_EXECUTE_SEQUENCE_STEP_BASIC_TEST(theExpect){
	theExpect.label("EXECUTE_SEQUENCE_STEP - minimize SciTE4AutoHotkey sequence")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via a Sequence")

	myActionSequenceMinimizePromptResult := false
	myMaximizePromptResultForExecuteStepSequence := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey maximize?")

	if(myMaximizePromptResultForExecuteStepSequence){
		myTestSequenceDataForExecuteStepSequence := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1, 10, 10, 1])
		EXECUTE_SEQUENCE_STEP(myTestSequenceDataForExecuteStepSequence.getStepList(), 1, true)
		myActionSequenceMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey minimize?")
	}

	theExpect.true(myActionSequenceMinimizePromptResult)
}

TEST_EXECUTE_SEQUENCE_STEP_ORIGINAL_TRY_FALSE(theExpect){
	theExpect.label("EXECUTE_SEQUENCE_STEP - theIsOriginalTryFlag = false to override checkExistsIntervalList")
	; So this test is interesting. We don't have a perfect way to detect whether the intended behavior is happening.
	; When theIsOriginalTryFlag = false, we expect checkExistsIntervalList to be overriden to just [1].
	; We'll take advantage of the fact that checkExistsIntervalList controls a loop with some other waits.
	; So first we'll do a call without it overriden, then a follow-up call that we expect to take significantly
	; less time because of less iterations. However we can't be 100% confident in the timing, since along the way
	; it calls to an external dependency (the image OCR part) which takes a variable amount of time.
	; *** This test will looks it's just sitting there spinning. That's expected. ***

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

	theExpect.true(mySingleAttemptsDuration * 4 < myMultipleAttemptsDuration) ; multiply by one less than the actual attempts to absorb the variance of a single call
}


;;;;; EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT ;;;;;
TEST_EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT_USES_LOOP_LIMIT(theExpect){
	theExpect.label("EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT - minimize then maximize twice via sequenceLoopLimit")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button then maximize via a Sequence twice")

	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey maximize?")

	myActionSequenceTwiceMinimizePromptResult := false

	if(myMaximizePromptResult){
		; Time to get creative again. Since all we have (at time of writing) is text-based conditionals,
		; we really don't have a reliable way to set up a loop-able test scenario. So we'll have the sequence
		; itself perform its own setup by having it maximize itself after minimizing. The hard part is we don't
		; have a great way to maximize via click, since we don't know exactly where the SciTE4AutoHotkey's
		; icon will be in the task bar because of how many things may be open... This test will assume it's
		; the 7th because that's typically where it is with all my pins.
		myTestSequenceDataForLoopLimit := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1, 10, 10, 1])
		myWindowsTimeTextCheck := TEST_HELPER_BUILD_WINDOWS_TIME_TEXT_CHECK()
		myWindowsTimeStep := TEST_HELPER_BUILD_STEP([5], "SciTE4AutoHotkey icon in task bar probably", 100, 100, 700, 1050, myWindowsTimeTextCheck)
		myTestSequenceDataForLoopLimit.getStepList().push(myWindowsTimeStep)
		myTestSequenceDataForLoopLimit.setSEquenceLoopLimit(2)
		EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT(myTestSequenceDataForLoopLimit)
	}

	myMultipleMaximizeMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey minimize, maximize, minimize, maximize?")
	theExpect.true(myMultipleMaximizeMinimizePromptResult)
}





TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE(theCheckExistsTryLimitIntervalList){
	; AHK gets confused when you reuse variable names sometimes that are allegedly global, so we gotta make them unique here in the tests
	myTestMinimizeSciteSequenceData := new SequenceData()
	myTestMinimizeSciteSequenceData.setSequenceLoopLimit(1)
	myTestMinimizeSciteSequenceData.setStepList([])
	myTestTextCheck := TEST_HELPER_BUILD_TEXT_CHECK(900, 20, ".*SciTE4AutoHotkey.*|.*SCiTE4AutoHotkey.*", 20, 0)
	myTestMinimizeSciteStep := TEST_HELPER_BUILD_STEP(theCheckExistsTryLimitIntervalList, "SciTE4AutoHotkey title bar", 100, 500, 1806, 3, myTestTextCheck)
	myTestMinimizeSciteSequenceData.getStepList().push(myTestMinimizeSciteStep)
	return myTestMinimizeSciteSequenceData
}

TEST_HELPER_BUILD_WINDOWS_TIME_TEXT_CHECK(){
	return TEST_HELPER_BUILD_TEXT_CHECK(1864, 1060, "AM|PM", 1801, 1041)
}

; TODO: move these helpers somewhere common, OCRActionSequencerMainTests could use them too
TEST_HELPER_BUILD_STEP(theCheckExistsTryLimitIntervalList, theElementName, theMillisecondsBetweenRetries, theMillisecondsWaitAfter, theTapX, theTapY, theTextCheck){
	myReturnStep := new Step()
	myReturnStep.setCheckExistsTryLimitIntervalList(theCheckExistsTryLimitIntervalList)
	myReturnStep.setElementName(theElementName)
	myReturnStep.setMillisecondsBetweenRetries(theMillisecondsBetweenRetries)
	myReturnStep.setMillisecondsWaitAfter(theMillisecondsWaitAfter)
	myReturnStep.setTapX(theTapX)
	myReturnStep.setTapY(theTapY)
	myReturnStep.setTextCheck(theTextCheck)
	return myReturnStep
}

TEST_HELPER_BUILD_TEXT_CHECK(theBottomRightX, theBottomRightY, theSearchText, theTopLeftX, theTopLeftY){
	myReturnTextCheck := new TextCheck()
	myReturnTextCheck.setBottomRightX(theBottomRightX)
	myReturnTextCheck.setBottomRightY(theBottomRightY)
	myReturnTextCheck.setSearchText(theSearchText)
	myReturnTextCheck.setTopLeftX(theTopLeftX)
	myReturnTextCheck.settopLeftY(theTopLeftY)
	return myReturnTextCheck
}

TEST_HELPER_DO_YES_NO_PROMPT(thePromptString){
	; https://www.autohotkey.com/docs/v1/lib/MsgBox.htm#Group_1_Buttons
	; The syntax for this isn't great, so hide it in our helper here
	MsgBox, 4,, %thePromptString% ; 4 = Yes/No
	myReturn := false
	IfMsgBox Yes
		myReturn := true
	else
		myReturn := false
	return myReturn
}

TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY(theTestInfoForUserString){
	MsgBox, %theTestInfoForUserString%
	SetTitleMatchMode, 2 ; partial matches
	WinMaximize, ahk_class SciTEWindow
}