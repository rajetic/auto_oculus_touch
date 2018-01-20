AutoOculusTouch - Helper library to provide AutoHotKey with Oculus Touch state.
Copyright (C) 2017 Kojack (rajetic@gmail.com)

AutoOculusTouch is released under the MIT License  
https://opensource.org/licenses/MIT


AutoOculusTouch is a library and script for AutoHotKey. It allows you to read the state of oculus controller devices (Touch, Remote or XBox controller) from within an AutoHotKey script.

Prerequisites
You must have AutoHotKey installed. It is available from https://autohotkey.com
(AutoOculusTouch is tested against AutoHotKey version 1.1.24.04)


Change History
v0.1.1 - Initial release. Built against Oculus SDK 1.10
v0.1.2 - Added capacitive sensor support. Built against Oculus SDK 1.20
v0.1.3 - Changed initialisation to use Invisible mode. Added button comments to example script.

Installation
AutoOculusTouch can be placed anywhere. No explicit installation is required.
There are two files included in the AutoOculusTouch binary release:
- auto_oculus_touch.dll (A library that wraps around the Oculus SDK.
- oculus_touch.ahk (An AutoHotKey script that calls auto_oculus_touch.dll)
You should keep these two files together.


Running
To start AutoOculusTouch, double click on the oculus_touch.ahk script. A green icon with a white H should appear in your system tray. AutoOculusTouch is now running.


Customising
The provided script has some example behaviour already defined. You can change any of this. Currently it does the following:
- Right thumbstick moves the windows mouse cursor.
- Touch X button and right Touch index trigger both control the left mouse button.
- Up and down on the Oculus remote do media previous and next (track selection in programs like Spotify)

In the script, search for the "; Now to do something with them." comment. Below this are all the behaviours.

AutoOculusTouch can give you:
- index and hand triggers of a Touch, as floats from 0.0 to 1.0.
- thumbstick axes as floats from -1.0 to 1.0.
- all Touch, Remote and XBox buttons.
- all Touch capacitive sensors.
- all Touch capacitive gestures (index pointing and thumbs up for either hand).


Important Notes
(v0.1.2 and below)
Due to the way the Oculus SDK works, running AutoOculusTouch will make Oculus Home or Dash think that a VR application is running that isn't rendering. The original intent was for AutoOculusTouch to run when no headset is being worn, such as using the Oculus Remote for controlling a PC for media playback, so this didn't matter. Running both AutoOculusTouch and another VR application at the same time probably shouldn't work, but it currently seems to.

What does this mean? Well, Oculus Home and Dash refuse to run a VR app while another is already running. But you can still run multiple apps at once if you start them using a means besides Home or Dash (such as explorer).

(v0.1.3 and above)
The note above is no longer valid in these versions. By setting the Invisible flag when calling the oculus sdk, AutoOculusTouch no longer appears to Dash as a VR app. This means it won't make the headset show a never ending loading screen and other VR apps can be run from Dash without an error.

