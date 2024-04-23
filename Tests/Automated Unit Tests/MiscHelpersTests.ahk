#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\Noncore Helpers\Misc helpers.ahk

myExpect := new expect()

;;;;; DOES_TEXT_CONTAIN ;;;;;
myExpect.label("DOES_TEXT_CONTAIN front edge")
myExpect.true(DOES_TEXT_CONTAIN("abcde", "abc"))

myExpect.label("DOES_TEXT_CONTAIN back edge")
myExpect.true(DOES_TEXT_CONTAIN("abcde", "cde"))

myExpect.label("DOES_TEXT_CONTAIN interior")
myExpect.true(DOES_TEXT_CONTAIN("abcde", "bcd"))

myExpect.label("DOES_TEXT_CONTAIN exact match")
myExpect.true(DOES_TEXT_CONTAIN("abcde", "abcde"))

myExpect.label("DOES_TEXT_CONTAIN regex pattern")
myExpect.true(DOES_TEXT_CONTAIN("abcde", "a.*e"))

myExpect.label("DOES_TEXT_CONTAIN capitals")
myExpect.false(DOES_TEXT_CONTAIN("abcde", "ABC"))

myExpect.label("DOES_TEXT_CONTAIN non match")
myExpect.false(DOES_TEXT_CONTAIN("abcde", "xyz"))

myExpect.label("DOES_TEXT_CONTAIN skip letters")
myExpect.false(DOES_TEXT_CONTAIN("abcde", "abe"))


;;;;; READ_FILE_CONTENTS ;;;;;
myExpect.label("READ_FILE_CONTENTS basic test")
myFilePath := A_ScriptDir . "\Tests\Test Files\"
myExpect.equal("TestFileContents", READ_FILE_CONTENTS("TestInputFile.txt", myFilePath))


myExpect.fullReport()