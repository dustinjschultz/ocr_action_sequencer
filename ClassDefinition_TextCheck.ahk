
Class TextCheck {

	;;;;;;;;;; Instance variables ;;;;;;;;;;
	bottomRightX := 1
	bottomRightY := 2
	searchText := "ABC"
	topLeftX := 3
	topLeftY := 4

	;;;;;;;;;; Constructors ;;;;;;;;;;
	__New() {
		; __New is the constructor keyword in AHK https://www.autohotkey.com/docs/v2/Objects.htm#Custom_NewDelete
	}


	;;;;;;;;;; Getters ;;;;;;;;;;
	getBottomRightX() {
		return this.bottomRightX
	}

	getBottomRightY() {
		return this.bottomRightY
	}

	getSearchText() {
		return this.searchText
	}

	getTopLeftX() {
		return this.topLeftX
	}

	getTopLeftY() {
		return this.topLeftY
	}


	;;;;;;;;;; Setters ;;;;;;;;;;
	setBottomRightX(theBottomRightX) {
		this.bottomRightX := theBottomRightX
	}

	setBottomRightY(theBottomRightY) {
		this.bottomRightY := theBottomRightY
	}

	setSearchText(theSearchText) {
		this.searchText := theSearchText
	}

	setTopLeftX(theTopLeftX) {
		this.topLeftX := theTopLeftX
	}

	setTopLeftY(theTopLeftY) {
		this.topLeftY := theTopLeftY
	}
}
;