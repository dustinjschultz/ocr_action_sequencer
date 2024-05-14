#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\Noncore Helpers\Misc helpers.ahk

myExpect := new expect()

TEST_DOES_TEXT_CONTAIN_FRONT_EDGE(myExpect)
TEST_DOES_TEXT_CONTAIN_BACK_EDGE(myExpect)
TEST_DOES_TEXT_CONTAIN_INTERNAL(myExpect)
TEST_DOES_TEXT_CONTAIN_EXACT_MATCH(myExpect)
TEST_DOES_TEXT_CONTAIN_REGEX_PATTERN(myExpect)
TEST_DOES_TEXT_CONTAIN_CASE_SENSITIVITY(myExpect)
TEST_DOES_TEXT_CONTAIN_NON_MATCH(myExpect)
TEST_DOES_TEXT_CONTAIN_SKIP_LETTERS(myExpect)
TEST_READ_FILE_CONTENTS_BASIC_TEST(myExpect)

myExpect.fullReport()

;;;;; DOES_TEXT_CONTAIN ;;;;;
TEST_DOES_TEXT_CONTAIN_FRONT_EDGE(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN front edge")
	theExpect.true(DOES_TEXT_CONTAIN("abcde", "abc"))
}

TEST_DOES_TEXT_CONTAIN_BACK_EDGE(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN back edge")
	theExpect.true(DOES_TEXT_CONTAIN("abcde", "cde"))
}

TEST_DOES_TEXT_CONTAIN_INTERNAL(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN interior")
	theExpect.true(DOES_TEXT_CONTAIN("abcde", "bcd"))
}

TEST_DOES_TEXT_CONTAIN_EXACT_MATCH(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN exact match")
	theExpect.true(DOES_TEXT_CONTAIN("abcde", "abcde"))
}

TEST_DOES_TEXT_CONTAIN_REGEX_PATTERN(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN regex pattern")
	theExpect.true(DOES_TEXT_CONTAIN("abcde", "a.*e"))
}

TEST_DOES_TEXT_CONTAIN_CASE_SENSITIVITY(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN case sensitivity")
	theExpect.false(DOES_TEXT_CONTAIN("abcde", "ABC"))
}

TEST_DOES_TEXT_CONTAIN_NON_MATCH(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN non match")
	theExpect.false(DOES_TEXT_CONTAIN("abcde", "xyz"))
}

TEST_DOES_TEXT_CONTAIN_SKIP_LETTERS(theExpect){
	theExpect.label("DOES_TEXT_CONTAIN skip letters")
	theExpect.false(DOES_TEXT_CONTAIN("abcde", "abe"))
}


;;;;; READ_FILE_CONTENTS ;;;;;
TEST_READ_FILE_CONTENTS_BASIC_TEST(theExpect){
	theExpect.label("READ_FILE_CONTENTS basic test")
	myFilePath := A_ScriptDir . "\Tests\Test Files\"
	theExpect.equal("TestFileContents", READ_FILE_CONTENTS("TestInputFile.txt", myFilePath))
}

