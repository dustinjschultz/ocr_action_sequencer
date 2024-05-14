#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



#Include %A_ScriptDir%\tests\Automated Unit Tests\MiscHelpersTests.ahk
#Include %A_ScriptDir%\tests\Automated Unit Tests\OCRActionSequencerMainTests.ahk
;Include %A_ScriptDir%\tests\Automated Unit Tests\SampleTest1.ahk ; don't use this one unless testing the tests, it has an intentional fail
#Include %A_ScriptDir%\tests\Screen Manipulating Unit Tests\OCRActionSequencerMainScreenManipulatingTests.ahk


; We need this class for one main reason: in AHK you can't be dynamic with your #Include statement.
; We're using %Include% with %A_ScriptDir% in the various files so they can use each other.
; The thing about %A_ScriptDir% is though, is that it contains the directory of the parent-most
; caller of the scripts. So in the case of executing our main script, using %A_ScriptDir% there returns its
; directory. This is good, because the scripts it needs to include are also in that directory.
; But once we're executing from one of the unit tests (located in a subfolder from where the main script is),
; %A_ScriptDir% will contain the subfolder where the test resides, meaning that when the main script
; tries using it to include the scripts that are truly right next to it, the #Include statement
; tries to look for files in the test's folder.
;
; This means we have two options: Make it so %A_ScriptDir% is the same as the main script's (which this file
; does), or try to %Include% not based on %A_ScriptDir%.
; The problem with the latter option is that #Include won't evaluate any user variables, only built-in ones
; (like %A_ScriptDir%). To make things harder, #Include is the first thing evaluated in a script. So you can't
; even get cute by manipulating built-in variables beforehand (if there are even manipulatable ones, didn't
; dive too deep here). The one caveat to this is you can put your #Include within a function,
; but even that doesn't help us because (quoting the docs) "A script behaves as
; though the included file's contents are physically present at the exact position of the #Include directive
; (as though a copy-and-paste were done from the included file)." Which means loading via functions is out,
; because even if we did load something in that way, its scope would only be that function, which
; isn't helpful. And to double down, class declarations (one of the main goals of using #Include) don't work
; when in a function anyway.
; Function-based loading was figured out, but doesn't work because of the restrictions above.
; Here's the working code:
;INCLUDE_FILES(){
;	myCurrentScriptDirectory := A_ScriptDir
;	SetWorkingDir "C:\git\ocr_action_sequencer" ; wherever your class actually is, set it however you need, ideally loaded dynamically
;	#Include %A_WorkingDir%\External Dependencies\AutoHotkey-JSON-master\JSON.ahk
;	#Include %A_WorkingDir%\ClassDefinition_SequenceData.ahk
;	#Include %A_WorkingDir%\Noncore Helpers\Misc helpers.ahk
;	SetWorkingDir myCurrentScriptDirectory
;}
;
; The one workaround the community found has is make a pre-processor script to combine your files you want into
; one via file manipulation (since that can use dynamic files), place it next to your main script, then load both
; the pre-processor and your main script using a separate loader script (so the pre-processor fully executes before
; including the main script), with your main script including the pre-processed file which is now created right next
; to it. Maybe I'll do this one day, but today's not that day.