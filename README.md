# ocr_action_sequencer

ocr_action_sequencer is a project for defining a sequence of actions you take after confirming text is present on screen via
Optical Character Reading ("OCR"). This is like an lite version of Robotic Process Automation ("RPA").

To use this, you must follow 3 steps:

1. Define your main "SequenceData"
2. Define your interrupt SequenceData's (if any)
3. Configure the main file to use your SequenceData's

For an example of a SequenceData, see the example in the /Sequence Data/Test/ folder. 
Use the Screen cords reader.shk helper to get your screen coordinates X and Y fields.

Eventually there will be a UI to do all this. For now it's manual. At that point this will be more fleshed out.