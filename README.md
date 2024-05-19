# ocr_action_sequencer

## Intro

ocr_action_sequencer is a project for defining a sequence of actions you take after confirming text is present on screen via
Optical Character Reading ("OCR"). This is like a lite version of Robotic Process Automation ("RPA").

## Usage

To use this, you must follow 3 steps:

1. Define your main "SequenceData"
2. Define your interrupt SequenceData's (if any)
3. Configure `Launcher.ahk` to use your SequenceData's

For an example of a SequenceData, see the example in the `/Sequence Data/Test/` folder. 
Use `/Noncore Helpers/Screen cords reader.ahk` helper to get your screen coordinates X and Y fields.

Eventually there will be a UI to do all this. For now it's manual. At that point this will be more fleshed out.

## Development Notes

The bulk of the functions are in `OCR Action Sequencer Main.ahk`. To run it, update `Launcher.ahk`. The "actual" code 
was split from the launcher so that it can be `#Include`'d in other files, notably the test files.

Within `OCR Action Sequencer Main.ahk`, the main driver function is EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT (referred to simply as "main" from here on). 
There are a few supporting functions that can called be called before, but this is where the majority of the logic happens.

### Help Understanding

Short version: Go look at `ClassDefinition_SequenceData.ahk`, follow its `#Include` chain, then look at `OCR Action Sequencer Main.ahk`'s 
EXECUTE_SEQUENCE_UNTIL_CAP_VIA_OBJECT.

### Pre-Main Supporting Functions

- Input object creation
    - LOAD_SEQUENCE_DATA_FROM_JSON_STRING - converts a JSON string into a SequenceData object
	- READ_FILE_CONTENTS - read a file as a string, useful for getting JSON strings representing SequenceData objects (located in `Noncore Helpers/Misc helpers.ahk`)
- Interrupt registering
	- ADD_GLOBAL_INTERRUPT_VIA_PATH - takes a string that's the relative path to your SequenceData file, adds that SequenceData to the global interrupt list
	- ADD_GLOBAL_INTERRUPT_VIA_OBJECT - similar to ADD_GLOBAL_INTERRUPT_VIA_PATH but takes a SequenceData as input
	
### File Structure Notes

Annoyingly, Autohotkey doesn't have a great way to handle dependency management. You can use the `#Include` keyword combined with the built-in
variable `%A_ScriptDir%` to find files relative to the one you're in. But where it gets tricky is when you start chaining `#Include` statements.
`%A_ScriptDir%` always evaluates to singular starting point of the `#Include` chain. Meaning any subsequent `#Include`s in the chain would break
unless they just happened to match the original files's. Because of this limitation, anything that needs to `#Include` another file is placed at 
the root. The main impact is the test launcher (`ExecuteTests.ahk`) not being in the `/Tests/` folder.

### Testing Notes

The tests use an external dependency, ["expect"](https://www.autohotkey.com/boards/viewtopic.php?t=95017) [GitHub](https://github.com/Chunjee/expect.ahk).

Tests are broken up into two types, each with a folder:
- `/Automated Unit Tests/` - can reliably be ran without any setup
- `/Screen Manipulating Unit Tests/` - rely on screen specifics (like size), and will assuredly break if not executed on the author's machine

### External Dependencies

Located in their own folder for clarity, these are Autohotkey scripts others have made and distributed online. Autohotkey doesn't really have
great dependency management (that I know of), so for now they get to live in the same repo. Since this is just a hobby project that's probably fine.
But if this is ever used for anything more it'll be worth figuring that out.
