#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\OCR Action Sequencer Main.ahk
#Include %A_ScriptDir%\Tests\Test Helpers\Misc Test Helpers.ahk

CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT := "Did SciTE4AutoHotkey maximize?"
CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT := "Did SciTE4AutoHotkey minimize?"


myExpect := new expect()

; Write the tests in their own methods then call them here because
; 1. to easily tell their start and end
; 2. so their varaibles aren't global
TEST_CLICK_HELPER_BASIC_TEST(myExpect)
TEST_EXECUTE_SEQUENCE_STEP_BASIC_TEST(myExpect)
TEST_EXECUTE_SEQUENCE_STEP_ORIGINAL_TRY_FALSE(myExpect)
TEST_EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT_USES_LOOP_LIMIT(myExpect)
TEST_HANDLE_GLOBAL_INTERRUPT_TEST_INTEGRATED_IN_MAIN(myExpect)
TEST_HANDLE_GLOBAL_INTERRUPT_SINGLE_BASIC_TEST(myExpect)
TEST_HANDLE_GLOBAL_INTERRUPT_ALL_BASIC_TEST(myExpect)
myExpect.fullReport()


;;;;; CLICK_HELPER ;;;;;
TEST_CLICK_HELPER_BASIC_TEST(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	theExpect.label("CLICK_HELPER - minimize SciTE4AutoHotkey")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via a raw click")

	myMinimizePromptResult := false ; declare outside the conditional so it has a result for the assertion
	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT)
	if (myMaximizePromptResult) {
		CLICK_HELPER(1804, 12)
		myMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT)
	}

	theExpect.true(myMinimizePromptResult)
}


;;;;; EXECUTE_SEQUENCE_STEP ;;;;;
TEST_EXECUTE_SEQUENCE_STEP_BASIC_TEST(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	theExpect.label("EXECUTE_SEQUENCE_STEP - minimize SciTE4AutoHotkey sequence")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via a Sequence")

	myMinimizePromptResult := false ; declare outside the conditional so it has a result for the assertion
	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT)
	if (myMaximizePromptResult) {
		myStepSequence := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1, 10, 10, 1])
		EXECUTE_SEQUENCE_STEP(myStepSequence.getStepList(), 1, true)
		myMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT)
	}

	theExpect.true(myMinimizePromptResult)
}

TEST_EXECUTE_SEQUENCE_STEP_ORIGINAL_TRY_FALSE(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	theExpect.label("EXECUTE_SEQUENCE_STEP - theIsOriginalTryFlag = false to override checkExistsIntervalList")
	; So this test is interesting. We don't have a perfect way to detect whether the intended behavior is happening.
	; When theIsOriginalTryFlag = false, we expect checkExistsIntervalList to be overriden to just [1].
	; We'll take advantage of the fact that checkExistsIntervalList controls a loop with some other waits.
	; So first we'll do a call without it overriden, then a follow-up call that we expect to take significantly
	; less time because of less iterations. However we can't be 100% confident in the timing, since along the way
	; it calls to an external dependency (the image OCR part) which takes a variable amount of time.
	; *** This test will looks it's just sitting there spinning. That's expected. ***

	myMultipleAttemptsSequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([5])
	mySingleAttemptSequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1])
	mySingleAttemptSequenceData.getStepList()[1].getTextCheck().setSearchText("this will never be found")
	myMultipleAttemptsSequenceData.getStepList()[1].getTextCheck().setSearchText("this will never be found")

	; don't put breakpoints in these chunks since A_TickCount would count those as processing time
	myMultipleAttemptsStartTime := A_TickCount
	EXECUTE_SEQUENCE_STEP(myMultipleAttemptsSequenceData.getStepList(), 1, true)
	myMultipleAttemptsEndTime := A_TickCount
	myMultipleAttemptsDuration := myMultipleAttemptsEndTime - myMultipleAttemptsStartTime

	mySingleAttemptsStartTime := A_TickCount
	EXECUTE_SEQUENCE_STEP(mySingleAttemptSequenceData.getStepList(), 1, true)
	mySingleAttemptsEndTime := A_TickCount
	mySingleAttemptsDuration := mySingleAttemptsEndTime - mySingleAttemptsStartTime

	theExpect.true(mySingleAttemptsDuration * 4 < myMultipleAttemptsDuration) ; multiply by one less than the actual attempts to absorb the variance of a single call
}


;;;;; EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT ;;;;;
TEST_EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT_USES_LOOP_LIMIT(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	theExpect.label("EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT - minimize then maximize twice via sequenceLoopLimit")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button then maximize via a Sequence twice")

	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT)
	if (myMaximizePromptResult) {
		; Time to get creative again. Since all we have (at time of writing) is text-based conditionals,
		; we really don't have a reliable way to set up a loop-able test scenario. So we'll have the sequence
		; itself perform its own setup by having it maximize itself after minimizing. The hard part is we don't
		; have a great way to maximize via click, since we don't know exactly where the SciTE4AutoHotkey's
		; icon will be in the task bar because of how many things may be open... This test will assume it's
		; the 7th because that's typically where it is with all my pins.
		mySequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1, 10, 10, 1])
		myWindowsTimeTextCheck := TEST_HELPER_BUILD_WINDOWS_TIME_TEXT_CHECK()
		myWindowsTimeStep := TEST_HELPER_BUILD_STEP([5], "SciTE4AutoHotkey icon in task bar probably", 100, 100, 700, 1050, myWindowsTimeTextCheck)
		mySequenceData.getStepList().push(myWindowsTimeStep)
		mySequenceData.setSequenceLoopLimit(2)
		EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT(mySequenceData)
	}

	myMultipleMinimizeMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey minimize, maximize, minimize, maximize?")
	theExpect.true(myMultipleMinimizeMaximizePromptResult)
}


;;;;; HANDLE_GLOBAL_INTERRUPT_* GENERAL ;;;;;
TEST_HANDLE_GLOBAL_INTERRUPT_TEST_INTEGRATED_IN_MAIN(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	; For this one, we won't directly call the method being tested, rather that it's integrated into the main method
	theExpect.label("HANDLE_GLOBAL_INTERRUPT_SINGLE - minimize interrupt during an otherwise impossible step")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via an interrupt sequence")

	myMinimizePromptResult := false ; declare outside the conditional so it has a result for the assertion
	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT)
	if (myMaximizePromptResult) {
		myImpossibleTextCheck := TEST_HELPER_BUILD_TEXT_CHECK(1, 1, "this will never be found", 2, 2)
		myImpossibleStep := TEST_HELPER_BUILD_STEP([1, 1], "impossible to find element", 1, 1, 1, 1, myImpossibleTextCheck)
		myImpossibleSequenceData := new SequenceData()
		myImpossibleSequenceData.setSequenceLoopLimit(1)
		myImpossibleSequenceData.setStepList([])
		myImpossibleSequenceData.getStepList().push(myImpossibleStep)

		myInterruptSequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1, 1])
		ADD_GLOBAL_INTERRUPT_VIA_OBJECT(myInterruptSequenceData)

		EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT(myImpossibleSequenceData)
		myMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT)
	}

	theExpect.true(myMinimizePromptResult)
}

TEST_HANDLE_GLOBAL_INTERRUPT_SINGLE_BASIC_TEST(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	theExpect.label("HANDLE_GLOBAL_INTERRUPT_SINGLE basic test")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button via an interrupt sequence (directly initiated)")

	myMinimizePromptResult := false ; declare outside the conditional so it has a result for the assertion
	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT)
	if (myMaximizePromptResult) {
		mySequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1])
		HANDLE_GLOBAL_INTERRUPT_SINGLE(mySequenceData)
		myMinimizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT)
	}

	theExpect.true(myMinimizePromptResult)
}

TEST_HANDLE_GLOBAL_INTERRUPT_ALL_BASIC_TEST(theExpect){
	global CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT
	global CONST_DID_SCITE4AUTOHOTKEY_MINIMIZE_PROMPT
	theExpect.label("HANDLE_GLOBAL_INTERRUPT_ALL basic test")
	TEST_HELPER_MAXIMIZE_SCITE4AUTOHOTKEY("This test will setup by maximizing SciTE4AutoHotkey, then actually test by clicking the minimize button the maximize via an interrupt sequence (directly initiated)")

	; So this isn't great. Because we're using a global variable to maintain
	; the interrupt list, the tests cross contaminate. So we need to clean up.
	global GLOBAL_INTERUPT_SEQUENCE_DATA_LIST
	GLOBAL_INTERUPT_SEQUENCE_DATA_LIST := []

	myMinimizeMaximizePromptResult := false ; declare outside the conditional so it has a result for the assertion
	myMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT(CONST_DID_SCITE4AUTOHOTKEY_MAXIMIZE_PROMPT)
	if (myMaximizePromptResult) {
		mySequenceData := TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE([1])
		myWindowsTimeTextCheck := TEST_HELPER_BUILD_WINDOWS_TIME_TEXT_CHECK()
		myWindowsTimeStep := TEST_HELPER_BUILD_STEP([5], "SciTE4AutoHotkey icon in task bar probably", 100, 100, 700, 1050, myWindowsTimeTextCheck)
		mySequenceData.getStepList().push(myWindowsTimeStep)
		ADD_GLOBAL_INTERRUPT_VIA_OBJECT(mySequenceData)
		HANDLE_GLOBAL_INTERRUPT_ALL()
		myMinimizeMaximizePromptResult := TEST_HELPER_DO_YES_NO_PROMPT("Did SciTE4AutoHotkey minimize then maximize?")
	}

	theExpect.true(myMinimizeMaximizePromptResult)
}
