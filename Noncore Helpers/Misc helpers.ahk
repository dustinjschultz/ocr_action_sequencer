#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


READ_FILE_CONTENTS(theFileName, theDirectory := ""){
	global CONSTANT_DEFAULT_FILE_DIRECTORY
	if (theDirectory == "") {
		theDirectory := CONSTANT_DEFAULT_FILE_DIRECTORY
	}

	; use the built-in FileOpen method https://www.autohotkey.com/docs/v1/lib/FileOpen.htm
	myFile := FileOpen(theDirectory . theFileName, "r") ; using read-only flag
	myFileContents := myFile.Read()
	return myFileContents
}

DOES_TEXT_CONTAIN(theHaystackString, theNeedleString){
	return RegExMatch(theHaystackString, theNeedleString) > 0
}

DISPLAY_MESSAGE(theMessage){
	TrayTip ; hide previous
	Sleep, 1
	TrayTip, OCR_Action_Sequencer, %theMessage%, 1
	;MsgBox, %theMessage%
}