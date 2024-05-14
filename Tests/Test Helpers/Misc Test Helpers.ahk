#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

TEST_HELPER_BUILD_MINIMIZE_SCITE4AUTOHOTKEY_SEQUENCE(theCheckExistsTryLimitIntervalList){
	mySequenceData := new SequenceData()
	mySequenceData.setSequenceLoopLimit(1)
	mySequenceData.setStepList([])
	myTextCheck := TEST_HELPER_BUILD_TEXT_CHECK(900, 20, ".*SciTE4AutoHotkey.*|.*SCiTE4AutoHotkey.*", 20, 0)
	myStep := TEST_HELPER_BUILD_STEP(theCheckExistsTryLimitIntervalList, "SciTE4AutoHotkey title bar", 100, 500, 1806, 3, myTextCheck)
	mySequenceData.getStepList().push(myStep)
	return mySequenceData
}

TEST_HELPER_BUILD_WINDOWS_TIME_TEXT_CHECK(){
	return TEST_HELPER_BUILD_TEXT_CHECK(1864, 1060, "AM|PM", 1801, 1041)
}

TEST_HELPER_BUILD_STEP(theCheckExistsTryLimitIntervalList, theElementName, theMillisecondsBetweenRetries, theMillisecondsWaitAfter, theTapX, theTapY, theTextCheck){
	myStep := new Step()
	myStep.setCheckExistsTryLimitIntervalList(theCheckExistsTryLimitIntervalList)
	myStep.setElementName(theElementName)
	myStep.setMillisecondsBetweenRetries(theMillisecondsBetweenRetries)
	myStep.setMillisecondsWaitAfter(theMillisecondsWaitAfter)
	myStep.setTapX(theTapX)
	myStep.setTapY(theTapY)
	myStep.setTextCheck(theTextCheck)
	return myStep
}

TEST_HELPER_BUILD_TEXT_CHECK(theBottomRightX, theBottomRightY, theSearchText, theTopLeftX, theTopLeftY){
	myTextCheck := new TextCheck()
	myTextCheck.setBottomRightX(theBottomRightX)
	myTextCheck.setBottomRightY(theBottomRightY)
	myTextCheck.setSearchText(theSearchText)
	myTextCheck.setTopLeftX(theTopLeftX)
	myTextCheck.setTopLeftY(theTopLeftY)
	return myTextCheck
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