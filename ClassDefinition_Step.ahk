#Include %A_ScriptDir%\ClassDefinition_TextCheck.ahk

Class Step {

	; TODO: figure out how to enforce types on these properties

	;;;;;;;;;; Instance variables ;;;;;;;;;;
	checkExistsTryLimitIntervalList := [1]
	elementName := "defaultElementName"
	millisecondsBetweenRetries := 1
	millisecondsWaitAfter := 1
	tapX := 1 ; TODO: not sure why these are strings in the json, tset if we're good without
	tapY := 1
	textCheck := new TextCheck()


	;;;;;;;;;; Constructors ;;;;;;;;;;
	__New() {
		; __New is the constructor keyword in AHK https://www.autohotkey.com/docs/v2/Objects.htm#Custom_NewDelete
	}


	;;;;;;;;;; Getters ;;;;;;;;;;
	getCheckExistsTryLimitIntervalList() {
		return this.checkExistsTryLimitIntervalList
	}

	getElementName() {
		return this.elementName
	}

	getMillisecondsBetweenRetries() {
		return this.millisecondsBetweenRetries
	}

	getMillisecondsWaitAfter() {
		return this.millisecondsWaitAfter
	}

	getTapX() {
		return this.tapX
	}

	getTapY() {
		return this.tapY
	}

	getTextCheck() {
		return this.textCheck
	}

	;;;;;;;;;; Setters ;;;;;;;;;;
 	setCheckExistsTryLimitIntervalList(theCheckExistsTryLimitIntervalList){
		this.checkExistsTryLimitIntervalList := theCheckExistsTryLimitIntervalList
	}

	setElementName(theElementName) {
		this.elementName := theElementName
	}

	setMillisecondsBetweenRetries(theMillisecondsBetweenRetries){
		this.millisecondsBetweenRetries := theMillisecondsBetweenRetries
	}

	setMillisecondsWaitAfter(theMillisecondsWaitAfter){
		this.millisecondsWaitAfter := theMillisecondsWaitAfter
	}

	setTapX(theTapX){
		this.tapX := theTapX
	}

	setTapY(theTapY){
		this.tapY := theTapY
	}

	setTextCheck(theTextCheck) {
		this.textCheck := theTextCheck
	}

}
