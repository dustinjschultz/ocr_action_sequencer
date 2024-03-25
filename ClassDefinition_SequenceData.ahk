﻿#Include %A_ScriptDir%\ClassDefinition_Step.ahk

;~ 0::
	;~ myTestSequenceData := new SequenceData()

	;~ myTestSequenceData.setSequenceLoopLimit(123)
	;~ MsgBox % myTestSequenceData.getSequenceLoopLimit()

	;~ myTestStep := new Step()
	;~ myTestStep.setTapX(456)
	;~ myTestSequenceData.getStepList().push(myTestStep)
	;~ MsgBox % myTestSequenceData.getStepList()[1].getTapX()

	;~ myTestStep2 := new Step()
	;~ myTestStep2.setTapX(789)
	;~ myTestSequenceData.getStepList().push(myTestStep2)
	;~ MsgBox % myTestSequenceData.getStepList()[2].getTapX()


;~ return

Class SequenceData {

	;;;;;;;;;; Instance variables ;;;;;;;;;;
	sequenceLoopLimit := 1
	stepList := []


	;;;;;;;;;; Constructors ;;;;;;;;;;
	__New() {
		; __New is the constructor keywork in AHK https://www.autohotkey.com/docs/v2/Objects.htm#Custom_NewDelete
	}


	;;;;;;;;;; Getters ;;;;;;;;;;
	getSequenceLoopLimit() {
		return this.sequenceLoopLimit
	}

	getStepList() {
		return this.stepList
	}


	;;;;;;;;;; Setters ;;;;;;;;;;
	setSequenceLoopLimit(theSequenceLoopLimit) {
		this.sequenceLoopLimit := theSequenceLoopLimit
	}

	setStepList(theStepList) {
		this.stepList := theStepList
	}

}
