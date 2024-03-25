#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\AutoHotkey-JSON-master\JSON.ahk
#Include %A_ScriptDir%\ClassDefinition_SequenceData.ahk

CONSTANT_DEFAULT_FILE_DIRECTORY := "C:\git\temp OCR Action Sequencer\Sequence Data\"
;CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST := ["PGo Auto Trader\Laptop_APowerMirrorResumeSequenceData.txt", "PGo Auto Trader\Laptop_PGoNewSizeRecordPopupSequenceData.txt"]
CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST := ["PGo Auto Trader\Desktop_APowerMirrorResumeSequenceData.txt", "PGo Auto Trader\Desktop_PGoNewSizeRecordPopupSequenceData.txt"]
CONSTANT_CAPTURE_2_TEXT_EXECUTABLE_ABSOLUTE_PATH := "C:\Users\dusti\OneDrive\Desktop\Capture2Text\Capture2Text.exe"


\::
	EXECUTE_SEQUENCE_UNTIL_CAP("PGo Auto Trader\Desktop_PGoAutoTradeSequenceData.txt")
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

	;HANDLE_GLOBAL_INTERRUPT_SINGLE("PGo Auto Trader\Laptop_APowerMirrorResumeSequenceData.txt")
	;HANDLE_GLOBAL_INTERRUPT_ALL()

	LOAD_SEQUENCE_DATA_FROM_JSON_STRING(READ_FILE_CONTENTS("PGo Auto Trader\Laptop_PGoAutoTradeSequenceData.txt"))
return


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
		if(RegExMatch(myScreenText, theInputSearchText) > 0){
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

	if(!theIsOriginalTryFlag) {
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
		if(myCheckTextResult){
			break
		} else {
			myIsLastIntervalFlag := A_Index == myCheckExistsIntervalCount
			if(theIsOriginalTryFlag AND !myIsLastIntervalFlag){
				;DISPLAY_MESSAGE("Retrying previous step")
				myPreviousStepOrdinal := GET_PREVIOUS_STEP_ORDINAL(the1IndexedStepOrdinal, theStepList.Length())
				myRetryPreviousResult := EXECUTE_SEQUENCE_STEP(theStepList, myPreviousStepOrdinal, false)
				;DISPLAY_MESSAGE("Retried previous step, got " . myRetryPreviousResult)
				HANDLE_GLOBAL_INTERRUPT_ALL()
			}
		}
	}

	if(myCheckTextResult){
		myExecuteResult := true
		CLICK_HELPER(myStep.getTapX(), myStep.getTapY())
	}

	if(myExecuteResult){
		mySleep := myStep.getMillisecondsWaitAfter()
		Sleep, %mySleep%
	}

	return myExecuteResult
}

DISPLAY_MESSAGE(theMessage){
	TrayTip ; hide previous
	Sleep, 1
	TrayTip, OCR_Action_Sequencer, %theMessage%, 1
	;MsgBox, %theMessage%
}

GET_PREVIOUS_STEP_ORDINAL(theCurrentStepOrdinal, theStepTotal){
	; 1-Indexed
	myReturn := theCurrentStepOrdinal - 1
	if(myReturn < 1){
		myReturn := theStepTotal
	}
	return myReturn
}

EXECUTE_SEQUENCE_UNTIL_CAP(theSequenceDataStringRelativePath){
	; This is the main driver operation

	mySequenceDataString := READ_FILE_CONTENTS(theSequenceDataStringRelativePath)
	mySequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(mySequenceDataString)
	myCap := mySequenceData.getSequenceLoopLimit()
	myStepListSize := mySequenceData.getStepList().Length()

	mySequenceLoopCounter := 0

	while (mySequenceLoopCounter < myCap) {
		mySequenceLoopCounter++
		;DISPLAY_MESSAGE(mySequenceLoopCounter)

		myCurrentStepCounter := 0
		while(myCurrentStepCounter < myStepListSize) {
			myCurrentStepCounter++
			Sleep, 100
			myStepResult := EXECUTE_SEQUENCE_STEP(mySequenceData.getStepList(), myCurrentStepCounter, true)
			if(!myStepResult){
				DISPLAY_MESSAGE("Failed, ending early")
				exitapp
			}
		}
	}
}

HANDLE_GLOBAL_INTERRUPT_SINGLE(theGlobalInteruptSequenceDataRelativePath){
	mySequenceDataString := READ_FILE_CONTENTS(theGlobalInteruptSequenceDataRelativePath)
	mySequenceData := LOAD_SEQUENCE_DATA_FROM_JSON_STRING(mySequenceDataString)
	myFirstStep := mySequenceData.getStepList()[1]

	myCurrentStepCounter := 0 ; we want to use 1-indexed, so start at 0 then increment right away in the loop
	myTotalStepCount := mySequenceData.getStepList().Length()
	myCheckTextResult := CHECK_TEXT_ON_SCREEN(myFirstStep.getTextCheck().getSearchText(), myFirstStep.getMillisecondsBetweenRetries(), 1, myFirstStep.getTextCheck())

	if(myCheckTextResult){
		while(myCurrentStepCounter <= myTotalStepCount){
			myCurrentStepCounter++
			EXECUTE_SEQUENCE_STEP(mySequenceData.getStepList(), myCurrentStepCounter, true)
		}
	}
}

HANDLE_GLOBAL_INTERRUPT_ALL(){
	; Use this for step sequences that could occur out of order. Ex: A streaming service's "Are you still watching" popup which could appear at any time.
	global CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST
	for myIndex in CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST
		HANDLE_GLOBAL_INTERRUPT_SINGLE(CONSTANT_GLOBAL_INTERRUPT_SEQUENCE_DATA_RELATIVE_PATH_LIST[myIndex])
}

READ_FILE_CONTENTS(theFileName, theDirectory := ""){
	global CONSTANT_DEFAULT_FILE_DIRECTORY
	if (theDirectory == ""){
		theDirectory := CONSTANT_DEFAULT_FILE_DIRECTORY
	}

	; use the built-in FileOpen method https://www.autohotkey.com/docs/v1/lib/FileOpen.htm
	myFile := FileOpen(theDirectory . theFileName, "r") ; using read-only flag
	myFileContents := myFile.Read()
	return myFileContents
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