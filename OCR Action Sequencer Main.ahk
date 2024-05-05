﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

GLOBAL_BASE_DIRECTORY := "C:\git\ocr_action_sequencer"

#Include %A_ScriptDir%\External Dependencies\AutoHotkey-JSON-master\JSON.ahk
#Include %A_ScriptDir%\ClassDefinition_SequenceData.ahk
#Include %A_ScriptDir%\Noncore Helpers\Misc helpers.ahk

GLOBAL_INTERUPT_SEQUENCE_DATA_LIST := []

CONSTANT_DEFAULT_FILE_DIRECTORY := "C:\git\ocr_action_sequencer\Sequence Data\"
;CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST := ["PGo Auto Trader\Laptop_APowerMirrorResumeSequenceData.txt", "PGo Auto Trader\Laptop_PGoNewSizeRecordPopupSequenceData.txt"]
;CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST := ["PGo Auto Trader\Desktop_SP20Tablet_APowerMirrorResumeSequenceData.txt", "PGo Auto Trader\Desktop_SP20Tablet_PGoNewSizeRecordPopupSequenceData.txt"]
CONSTANT_CAPTURE_2_TEXT_EXECUTABLE_ABSOLUTE_PATH := "C:\Users\dusti\OneDrive\Desktop\Capture2Text\Capture2Text.exe"

CLICK_HELPER(theXCoordinate, theYCoordinate){
	CoordMode, Mouse, Screen
	Click, %theXCoordinate% %theYCoordinate%
}

CHECK_TEXT_ON_SCREEN(theInputSearchText, theMillisecondsBetweenRetries, theTryLimit, theCoordinatesObject){
	myFoundTextFlag := false
	;DISPLAY_MESSAGE("Looking for " . theInputSearchText)
	Loop, %theTryLimit% {
		myScreenText := GET_SCREEN_TEXT(theCoordinatesObject.getTopLeftX(), theCoordinatesObject.getTopLeftY(), theCoordinatesObject.getBottomRightX(), theCoordinatesObject.getBottomRightY())
		;DISPLAY_MESSAGE(myScreenText)
		if (DOES_TEXT_CONTAIN(myScreenText, theInputSearchText)) {
			myFoundTextFlag := true
			break
		}
		Sleep, theMillisecondsBetweenRetries
	}

	return myFoundTextFlag
}

GET_SCREEN_TEXT(theTopLeftX, theTopLeftY, theBottomRightX, theBottomRightY){
	global CONSTANT_CAPTURE_2_TEXT_EXECUTABLE_ABSOLUTE_PATH
	; https://capture2text.sourceforge.net/#command_line
	; "-s" flag is the "screen-rect" flag which we pass our rectangle's coordinates to
	; "--clipboard" flag is the way we tell it to do OCR and put the results on the clipboard
	RunWait, %CONSTANT_CAPTURE_2_TEXT_EXECUTABLE_ABSOLUTE_PATH% -s "%theTopLeftX% %theTopLeftY% %theBottomRightX% %theBottomRightY%" --clipboard
	clipboard := trim(clipboard,"`n`r`t ")
	myReturn := clipboard
	return myReturn
}

EXECUTE_SEQUENCE_STEP(theStepList, the1IndexedStepOrdinal, theIsOriginalTryFlag){
	myExecuteResult := false
	myStep := theStepList[the1IndexedStepOrdinal]

	; use a local copy of the checkExistsIntervalList, since we may make changes
	myCheckExistsIntervalList := myStep.getCheckExistsTryLimitIntervalList().clone()

	if (!theIsOriginalTryFlag) {
		myCheckExistsIntervalList := []
		myCheckExistsIntervalList.Push(1)
		;DISPLAY_MESSAGE("Overwrote checkExistsTryLimitIntervalList")
	}

	myCheckTextResult := false
	myCheckExistsIntervalCount := myCheckExistsIntervalList.Length()
	Loop, %myCheckExistsIntervalCount% {
		; Reminder: "A_Index" is the built-in AutoHotkey index for loops
		; https://www.autohotkey.com/docs/v1/Variables.htm#Index
		myCheckExistsTryLimit := myCheckExistsIntervalList[A_Index]
		myCheckTextResult := CHECK_TEXT_ON_SCREEN(myStep.getTextCheck().getSearchText(), myStep.getMillisecondsBetweenRetries(), myCheckExistsTryLimit, myStep.getTextCheck())
		if (myCheckTextResult) {
			break
		} else {
			myIsLastIntervalFlag := A_Index == myCheckExistsIntervalCount
			if (theIsOriginalTryFlag AND !myIsLastIntervalFlag) {
				;DISPLAY_MESSAGE("Retrying previous step")
				myPreviousStepOrdinal := GET_PREVIOUS_STEP_ORDINAL(the1IndexedStepOrdinal, theStepList.Length())
				myRetryPreviousResult := EXECUTE_SEQUENCE_STEP(theStepList, myPreviousStepOrdinal, false)
				;DISPLAY_MESSAGE("Retried previous step, got " . myRetryPreviousResult)
				HANDLE_GLOBAL_INTERRUPT_ALL()
			}
		}
	}

	if (myCheckTextResult) {
		myExecuteResult := true
		CLICK_HELPER(myStep.getTapX(), myStep.getTapY())
	}

	if (myExecuteResult) {
		mySleep := myStep.getMillisecondsWaitAfter()
		Sleep, %mySleep%
	}

	return myExecuteResult
}

GET_PREVIOUS_STEP_ORDINAL(theCurrentStepOrdinal, theStepTotal){
	; 1-Indexed
	myReturn := theCurrentStepOrdinal - 1
	if (myReturn < 1) {
		myReturn := theStepTotal
	}
	return myReturn
}

EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT(theSequenceData){
	; This is the main driver operation
	myCap := theSequenceData.getSequenceLoopLimit()
	myStepListSize := theSequenceData.getStepList().Length()

	mySequenceLoopCounter := 0

	while (mySequenceLoopCounter < myCap) {
		mySequenceLoopCounter++
		;DISPLAY_MESSAGE(mySequenceLoopCounter)

		myCurrentStepCounter := 0
		while (myCurrentStepCounter < myStepListSize) {
			myCurrentStepCounter++
			Sleep, 100
			myStepResult := EXECUTE_SEQUENCE_STEP(theSequenceData.getStepList(), myCurrentStepCounter, true)
			if (!myStepResult) {
				DISPLAY_MESSAGE("Failed, ending early")
				return
			}
		}
	}
}

EXECUTE_SEQUENCE_UNTIL_CAP_VIA_PATH(theSequenceDataStringRelativePath){
	mySequenceDataString := READ_FILE_CONTENTS(theSequenceDataStringRelativePath)
	mySequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(mySequenceDataString)
	EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT(mySequenceData)
}

HANDLE_GLOBAL_INTERRUPT_SINGLE(theGlobalInteruptSequenceData){
	myFirstStep := theGlobalInteruptSequenceData.getStepList()[1]

	myCurrentStepCounter := 0 ; we want to use 1-indexed, so start at 0 then increment right away in the loop
	myTotalStepCount := theGlobalInteruptSequenceData.getStepList().Length()
	myCheckTextResult := CHECK_TEXT_ON_SCREEN(myFirstStep.getTextCheck().getSearchText(), myFirstStep.getMillisecondsBetweenRetries(), 1, myFirstStep.getTextCheck())

	if (myCheckTextResult) {
		while (myCurrentStepCounter <= myTotalStepCount) {
			myCurrentStepCounter++
			EXECUTE_SEQUENCE_STEP(theGlobalInteruptSequenceData.getStepList(), myCurrentStepCounter, true)
		}
	}
}

HANDLE_GLOBAL_INTERRUPT_ALL(){
	; Use this for step sequences that could occur out of order. Ex: A streaming service's "Are you still watching" popup which could appear at any time.
	global GLOBAL_INTERUPT_SEQUENCE_DATA_LIST
	for myIndex in GLOBAL_INTERUPT_SEQUENCE_DATA_LIST {
		HANDLE_GLOBAL_INTERRUPT_SINGLE(GLOBAL_INTERUPT_SEQUENCE_DATA_LIST[myIndex])
	}
}

ADD_GLOBAL_INTERRUPT_VIA_PATH(theGlobalInterruptSequenceDataStringRelativePath){
	mySequenceDataString := READ_FILE_CONTENTS(theGlobalInterruptSequenceDataStringRelativePath)
	mySequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(mySequenceDataString)
	ADD_GLOBAL_INTERRUPT_VIA_OBJECT(mySequenceData)
}

ADD_GLOBAL_INTERRUPT_VIA_OBJECT(theSequenceData){
	global GLOBAL_INTERUPT_SEQUENCE_DATA_LIST
	GLOBAL_INTERUPT_SEQUENCE_DATA_LIST.push(theSequenceData)
}

LOAD_SEQUENCE_DATA_FROM_JSON_STRING(theJsonString){
	myJsonObject := JSON.Load(theJsonString)

	mySequenceData := new SequenceData()

	mySequenceData.setSequenceLoopLimit(myJsonObject.sequenceLoopLimit)

	Loop, % myJsonObject.stepList.Length() {
		myCurrentJsonStep := myJsonObject.stepList[A_Index]
		myNewStep := new Step()

		myNewStep.setCheckExistsTryLimitIntervalList(myCurrentJsonStep.checkExistsTryLimitIntervalList)
		myNewStep.setElementName(myCurrentJsonStep.elementName)
		myNewStep.setMillisecondsBetweenRetries(myCurrentJsonStep.millisecondsBetweenRetries)
		myNewStep.setMillisecondsWaitAfter(myCurrentJsonStep.millisecondsWaitAfter)
		myNewStep.setTapX(myCurrentJsonStep.tapX)
		myNewStep.setTapY(myCurrentJsonStep.tapY)

		myNewTextCheck := new TextCheck()
		myNewTextCheck.setBottomRightX(myCurrentJsonStep.textCheckObject.bottomRightX)
		myNewTextCheck.setBottomRightY(myCurrentJsonStep.textCheckObject.bottomRightY)
		myNewTextCheck.setSearchText(myCurrentJsonStep.textCheckObject.searchText)
		myNewTextCheck.setTopLeftX(myCurrentJsonStep.textCheckObject.topLeftX)
		myNewTextCheck.setTopLeftY(myCurrentJsonStep.textCheckObject.topLeftY)

		myNewStep.setTextCheck(myNewTextCheck)
		mySequenceData.getStepList().push(myNewStep)
	}

	return mySequenceData
}