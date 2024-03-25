#Include %A_ScriptDir%\ClassDefinition_Step.ahk

Class SequenceData {

	;;;;;;;;;; Instance variables ;;;;;;;;;;
	sequenceLoopLimit := 1
	stepList := []


	;;;;;;;;;; Constructors ;;;;;;;;;;
	__New() {
		; __New is the constructor keyword in AHK https://www.autohotkey.com/docs/v2/Objects.htm#Custom_NewDelete
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
