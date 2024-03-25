#Include %A_ScriptDir%\ClassDefinition_TextCheck.ahk

;~ 0::
	; test function
	;~ myTestStep := new Step()

	;~ myTestStep.setCheckExistsTryLimitIntervalList([1, 10, 100])
	;~ MsgBox % myTestStep.getCheckExistsTryLimitIntervalList()[3]
	;~ myTestStep.setElementName("newElementName")
	;~ MsgBox % myTestStep.getElementName()
	;~ myTestStep.setMillisecondsBetweenRetries(222)
	;~ MsgBox % myTestStep.getMillisecondsBetweenRetries()
	;~ myTestStep.SetMillisecondsWaitAfter(333)
	;~ MsgBox % myTestStep.getMillisecondsWaitAfter()
	;~ myTestStep.setTapX(444)
	;~ MsgBox % myTestStep.getTapX()
	;~ myTestStep.setTapY(555)
	;~ MsgBox % myTestStep.getTapY()

 	;~ myTestTextCheck := new TextCheck()
	;~ myTestTextCheck.setTopLeftY(123)
	;~ myTestStep.setTextCheck(myTestTextCheck)
	;~ MsgBox % myTestStep.getTextCheck().getTopLeftY()
;~ return

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
		; __New is the constructor keywork in AHK https://www.autohotkey.com/docs/v2/Objects.htm#Custom_NewDelete
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
