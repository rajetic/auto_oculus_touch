AutoOculusTouch - Helper library to provide AutoHotKey with Oculus Touch state.
Copyright (C) 2019 Kojack (rajetic@gmail.com)

AutoOculusTouch is released under the MIT License  
https://opensource.org/licenses/MIT


AutoOculusTouch is a library and script for AutoHotKey. It allows you to read the state of oculus controller devices (Touch, Remote or XBox controller) from within an AutoHotKey script.

Prerequisites
You must have AutoHotKey installed. It is available from https://autohotkey.com
(AutoOculusTouch is tested against AutoHotKey version 1.1.29.01)
If you want vJoy support, you must have it installed. It is available from http://vjoystick.sourceforge.net/site/index.php/download-a-install
(AutoOculusTouch is tested against vJoy version 2.1.8)


Change History
v0.1.1 - Initial release. Built against Oculus SDK 1.10
v0.1.2 - Added capacitive sensor support. Built against Oculus SDK 1.20
v0.1.3 - Changed initialisation to use Invisible mode. Added button comments to example script.
v0.1.4 - Added vibration. Added orientation tracking (yaw, pitch, roll) for touch. More example scripts. Built against Oculus SDK 1.26
v0.1.5 - Added vJoy integration. You can now output gamepad/joystick values for axes and buttons.
v0.1.6 - The vJoy installer has a slightly higher version than the latest vJoy sdk, which breaks compatibility. I've updated it so it should work again. I've added in the Oculus and vJoy sdk files needed to compile, some people had issues setting things up. It should be fairly self contained now. Built against Oculus SDK 1.41. I've improved the vJoy script to have all buttons.

Installation
AutoOculusTouch can be placed anywhere. No explicit installation is required.
There are several files included in the AutoOculusTouch binary release:
- auto_oculus_touch.dll     (A library that wraps around the Oculus SDK.
- vJoyInterface.dll			(Interface to the vJoy drivers)
- auto_oculus_touch.ahk     (An AutoHotKey script that defines various Oculus related functions. This is needed by the other scripts)
- oculus_remote_mouse.ahk   (Lets you use the remote as a mouse. Up/Down/Left/Right move. The centre button is left mouse. The back button is right mouse)
- oculus_remote_spotify.ahk (Send media keys with the remote. Up is previous track, Down is next track, centre button is play/pause. Not just for spotify, works with any media key compatible program)
- oculus_touch_mouse.ahk    (Move the mouse with the right touch controller. Index trigger is left mouse. A is right mouse. Thumbstick is mouse move. Hold the hand trigger to enable tracking, then pitch or yaw the mouse to move. Press B to reset yaw centre point to your current heading)
- oculus_touch_test.ahk     (Display a GUI of all touch values)
- oculus_touch_vjoy.ahk     (Turn the Touch controllers into a virtual gamepad for DirectInput games)

You should keep these files together.


Running
To start AutoOculusTouch, double click on one of the scripts (not auto_oculus_touch.ahk, it doesn't do anything on it's own). A green icon with a white H should appear in your system tray. AutoOculusTouch is now running.


Customising
The provided scripts has some example behaviour already defined. You can change any of this, or make your own.

AutoOculusTouch can give you:
- index and hand triggers of a Touch, as floats from 0.0 to 1.0.
- thumbstick axes as floats from -1.0 to 1.0.
- all Touch, Remote and XBox buttons.
- all Touch capacitive sensors.
- all Touch capacitive gestures (index pointing and thumbs up for either hand).
- Pitch, Roll and Yaw of both touch controllers in degrees.
- Set continuous or one shot vibration effects of different frequencies and amplitudes on either touch controller.

Vibration Use
Vibration has 3 properties: frequency, amplitude and oneshot.
Frequency: 1==320Hz, 2==160Hz, 3==106.7Hz, 4=80Hz  (this is the frequency of vibration)
Amplitude: 0-255 (0 stops vibration, 1-255 are the strength)
Oneshot: If this is zero, the vibration will stay at the level you set until you manually change/stop it. If this is 1, the vibration will be a short pulse then stops on it's own.
(Note: this probably doesn't work on a Rift-S, they apparently aren't compatible with this style of vibration, it was deprecated)

Orientation Use
Yaw: clockwise is positive
Pitch: aiming up is positive
Roll: tilting clockwise is positive
Yaw works a little different to the other two angles. Pitch and roll have definite zero angles that make sense (holding the controller level). But yaw is based on where the controller is aiming when powered on. To fix this, you can call ResetFacing(controllerNumber) to record the current direction as a Yaw of 0 degrees.
Each controller may have a different Yaw origin.
If you aren't wearing the Oculus headset, camera tracking is disabled. Touch rotation can still be tracked, but it is done with the onboard IMUs, which may drift over time.

vJoy Support
Normally AutoHotKey can only generate keyboard and mouse events.
vJoy is a driver that emulates one or more virtual joysticks with configurable features. AutoOculusTouch can now send analog axis and digital button values to vJoy. This lets you use Touch (or the remote) as a gamepad in games that support DirectInput.
Note: while most of the controls match an XBox controller, it technically isn't one. Any game that uses XInput directly can't see vJoy. Only DirectInput games will work here.

To use vJoy support, you need to install the vJoy drivers. You can download them from here: http://vjoystick.sourceforge.net/site/index.php/download-a-install
If you don't want vJoy support, you don't need to install the drivers, this is an optional feature, AutoOculusTouch works like v0.1.4 without it.


Important Notes
(v0.1.2 and below)
Due to the way the Oculus SDK works, running AutoOculusTouch will make Oculus Home or Dash think that a VR application is running that isn't rendering. The original intent was for AutoOculusTouch to run when no headset is being worn, such as using the Oculus Remote for controlling a PC for media playback, so this didn't matter. Running both AutoOculusTouch and another VR application at the same time probably shouldn't work, but it currently seems to.

What does this mean? Well, Oculus Home and Dash refuse to run a VR app while another is already running. But you can still run multiple apps at once if you start them using a means besides Home or Dash (such as explorer).

(v0.1.3 and above)
The note above is no longer valid in these versions. By setting the Invisible flag when calling the oculus sdk, AutoOculusTouch no longer appears to Dash as a VR app. This means it won't make the headset show a never ending loading screen and other VR apps can be run from Dash without an error.

