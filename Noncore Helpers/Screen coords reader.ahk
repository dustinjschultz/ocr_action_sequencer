﻿; Source: //www.autohotkey.com/board/topic/75360-how-to-know-the-x-y-coordinate-of-my-screen/?p=479671

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#singleinstance force
#Persistent

if 1	; screen coordinates
  coord=screen
else
  coord=relative
tooltip, %coord%
sleep, 1000

CoordMode, ToolTip, %coord%
CoordMode, Pixel, %coord%
CoordMode, Mouse, %coord%
CoordMode, Caret, %coord%
CoordMode, Menu, %coord%

SetTimer, WatchCursor, 100
return

WatchCursor:
MouseGetPos,xpos , ypos
ToolTip, xpos: %xpos%`nypos: %ypos%
return

esc::exitapp

f12::reload