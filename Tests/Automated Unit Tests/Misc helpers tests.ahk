#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\..\..\External Dependencies\expect.ahk-master\export.ahk
#Include %A_ScriptDir%\..\..\Noncore Helpers\Misc helpers.ahk

expect := new expect()

;;;;; DOES_TEXT_CONTAIN ;;;;;
expect.label("DOES_TEXT_CONTAIN front edge")
expect.true(DOES_TEXT_CONTAIN("abcde", "abc"))

expect.label("DOES_TEXT_CONTAIN back edge")
expect.true(DOES_TEXT_CONTAIN("abcde", "cde"))

expect.label("DOES_TEXT_CONTAIN interior")
expect.true(DOES_TEXT_CONTAIN("abcde", "bcd"))

expect.label("DOES_TEXT_CONTAIN exact match")
expect.true(DOES_TEXT_CONTAIN("abcde", "abcde"))

expect.label("DOES_TEXT_CONTAIN regex pattern")
expect.true(DOES_TEXT_CONTAIN("abcde", "a.*e"))

expect.label("DOES_TEXT_CONTAIN capitals")
expect.false(DOES_TEXT_CONTAIN("abcde", "ABC"))

expect.label("DOES_TEXT_CONTAIN non match")
expect.false(DOES_TEXT_CONTAIN("abcde", "xyz"))

expect.label("DOES_TEXT_CONTAIN skip letters")
expect.false(DOES_TEXT_CONTAIN("abcde", "abe"))


;;;;; READ_FILE_CONTENTS ;;;;;
expect.label("READ_FILE_CONTENTS basic test")
myFilePath := A_ScriptDir . "\"
expect.equal("TestFileContents", READ_FILE_CONTENTS("TestInputFile.txt", myFilePath))


expect.fullReport()