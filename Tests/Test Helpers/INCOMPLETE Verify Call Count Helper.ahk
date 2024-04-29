#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; ChatGPT was asked for a Mockito.verify-like way to test code in AHK, with some tweaking

; Define a global variable to track the call count
Global CallCount := {}

; The original function to be tested
MyFunction()
{
    ; Do something
    MsgBox, "Original MyFunction called."
}

; Mock function to intercept calls
MockFunction(funcName, params*)
{
    ;MsgBox % "MockFunction called for " . funcName
    Global CallCount
    ; Increment the call count for the specified function
    CallCount[funcName] := (CallCount[funcName] == null ? 0 : CallCount[funcName]) + 1

    ; Execute the original function
    myReturn := Func(funcName).call(params)
    return myReturn
}

; Function to verify call count
VerifyCallCount(funcName, expectedCallCount)
{
    if (CallCount.HasKey(funcName) && CallCount[funcName] = expectedCallCount)
        MsgBox % "Function " . funcName . " called " . expectedCallCount . " times."
    else
        MsgBox % "Function " . funcName . " called " . (CallCount.HasKey(funcName) ? CallCount[funcName] : 0) . " times, expected " . expectedCallCount . "."
}

; Usage example
myMockFunctionObject := Func("MockFunction")
myActualFunctionObject := Func("MyFunction")
myFunctionObjectName := myActualFunctionObject.Name
MyFunctionCallable := myMockFunctionObject.Bind(myFunctionObjectName)
MyFunctionCallable.call() ; Call the function
MyFunctionCallable.call() ; Call the function again

MyFunction() ; calling the actual function rather than the wrapper doesn't actually contribute to the counter...

; Verify call count
VerifyCallCount(Func("MyFunction").Name, 2) ; Verify MyFunction was called (via mock) 2 times

VerifyCallCount(Func("MyFunction").Name, 10) ; Expecting this to fail, regardless of mock/non-mock working

; The above works to add a wrapper that counts calls to your original function.
; But isn't helpful yet since we can't override the original definition to use the wrapper's.
; Overriding a function definition of these globally defined functions isn't proving fruitful...
; So for now, just going to mark this as INCOMPLETE and move on without it.


