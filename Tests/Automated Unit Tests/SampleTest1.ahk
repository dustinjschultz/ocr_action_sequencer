#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\External Dependencies\expect.ahk-master\export.ahk

myExpect := new expect()

myExpect.equal("this should succeed", "this should succeed")
myExpect.equal("aaa", "this is an expected failure to demo the results")
myExpect.fullReport()