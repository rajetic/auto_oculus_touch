AutoOculusTouch - Helper library to provide AutoHotKey with Oculus Touch state.
Copyright (C) 2021 Kojack (rajetic@gmail.com)

AutoOculusTouch is released under the MIT License  
https://opensource.org/licenses/MIT


AutoOculusTouch is a library and script for AutoHotKey. It allows you to read the state of oculus controller devices (Touch, Remote or XBox controller) from within an AutoHotKey script.

Prerequisites
You must have AutoHotKey installed. It is available from https://autohotkey.com
(AutoOculusTouch is tested against AutoHotKey version 1.1.33.02)
If you want vJoy support, you must have it installed. It is available from http://vjoystick.sourceforge.net/site/index.php/download-a-install
(AutoOculusTouch is tested against vJoy version 2.1.8)


Change History
v0.1.1 - Initial release. Built against Oculus SDK 1.10
v0.1.2 - Added capacitive sensor support. Built against Oculus SDK 1.20
v0.1.3 - Changed initialisation to use Invisible mode. Added button comments to example script.
v0.1.4 - Added vibration. Added orientation tracking (yaw, pitch, roll) for touch. More example scripts. Built against Oculus SDK 1.26
v0.1.5 - Added vJoy integration. You can now output gamepad/joystick values for axes and buttons.
v0.1.6 - The vJoy installer has a slightly higher version than the latest vJoy sdk, which breaks compatibility. I've updated it so it should work again. I've added in the Oculus and vJoy sdk files needed to compile, some people had issues setting things up. It should be fairly self contained now. Built against Oculus SDK 1.41. I've improved the vJoy script to have all buttons.
v0.1.7 - Added new functions to get axis and button values. Added position tracking for controllers and headset. Added headset rotation. Added tracking origin control (floor or eye). Changed vibration to take a length to play an effect for (replaces oneShot parameter). Updated the example scripts. Changed main auto_oculus_touch.ahk script to use faster DLLCall system. Added error messageboxes for init of oculus and vjoy. Added raw mouse movement and buttons, for games made with Unity that ignore normal AHK mouse. Updated Oculus SDK to v23.

Installation
AutoOculusTouch can be placed anywhere. No explicit installation is required.
There are several files included in the AutoOculusTouch binary release:
- auto_oculus_touch.dll      (A library that wraps around the Oculus SDK.
- vJoyInterface.dll			 (Interface to the vJoy drivers)
- auto_oculus_touch.ahk      (An AutoHotKey script that defines various Oculus related functions. This is needed by the other scripts)
- oculus_remote_mouse.ahk    (Lets you use the remote as a mouse. Up/Down/Left/Right move. The centre button is left mouse. The back button is right mouse)
- oculus_remote_spotify.ahk  (Send media keys with the remote. Up is previous track, Down is next track, centre button is play/pause. Not just for spotify, works with any media key compatible program)
- oculus_touch_mouse.ahk     (Move the mouse with the right touch controller. Index trigger is left mouse. A is right mouse. Thumbstick is mouse move. Press B to reset yaw centre point to your current heading)
- oculus_touch_air_mouse.ahk (Move the mouse using pitch and yaw, like an LG TV remote, when you are holding the right hand trigger. Index trigger is left mouse.
- oculus_touch_test.ahk      (Display a GUI of all touch values)
- oculus_touch_vjoy.ahk      (Turn the Touch controllers into a virtual gamepad for DirectInput games)

You should keep these files together. The auto_oculus_touch.dll should be in the same location as any scripts you want to run.


Running
To start AutoOculusTouch, double click on one of the scripts (not auto_oculus_touch.ahk, it doesn't do anything on it's own). A green icon with a white H should appear in your system tray. AutoOculusTouch is now running.


Customising
The provided scripts has some example behaviour already defined. You can change any of this, or make your own.

AutoOculusTouch can give you:
- index and hand triggers of a Touch, as floats from 0.0 to 1.0.
- thumbstick axes as floats from -1.0 to 1.0.
- all Touch, Remote and XBox buttons (except the Oculus Home button and remote volume buttons).
- all Touch capacitive sensors.
- all Touch capacitive gestures (index pointing and thumbs up for either hand).
- Pitch, Roll and Yaw of both touch controllers and headset in degrees.
- Position of both touch controllers and headset in metres.
- Set continuous or limited time vibration effects of different frequencies and amplitudes on either touch controller.

Vibration Use
Vibration has 3 properties: frequency, amplitude and oneshot.
Frequency: 1==320Hz, 2==160Hz, 3==106.7Hz, 4=80Hz  (this is the frequency of vibration)
Amplitude: 0-255 (0 stops vibration, 1-255 are the strength)

Orientation Use
Yaw: clockwise is positive
Pitch: aiming up is positive
Roll: tilting clockwise is positive
Yaw works a little different to the other two angles. Pitch and roll have definite zero angles that make sense (holding the controller level). But yaw is based on where the controller is aiming when powered on. To fix this, you can call ResetFacing(controllerNumber) to record the current direction as a Yaw of 0 degrees.
Each controller may have a different Yaw origin.

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

(v0.1.7 and above)
New ways to access buttons and triggers have been added. You no longer need to grab the full buttons state and do boolean maths on them. You also no longer need to store previous trigger values to check of crossing over a value, there's a function for that.
The old way is still available existing scripts should work the same.

Different Headset Behaviour
Different Oculus headsets behave differently when not being worn (having the face sensor triggered). This is the Oculus SDK's behaviour, not Auto Oculus Touch.
Rift CV1 - When not worn for around 18 seconds, position tracking is disabled. Rotation tracking continues, but is purely IMU based (instead of the cameras) so the yaw can drift over time.
Rift-S - When not worn for around 18 seconds, position tracking, rotation tracking and vibration is disabled. Buttons, triggers and thumbsticks keep working.
Quest 1/2 Link - When not worn for around 16 seconds, everything stops. No tracking, buttons, etc. The controllers are completely shut down.

You can trick the headset into running by placing something (like a cloth) over the face sensor (just above the lenses, in the middle). But be warned, when it is triggered, all controls will be picked up by the Home app. You may be accidentally clicking on things (like the store!). I have plans to fix this, but it means adding rendering to AOT.

Function Reference

InitOculus()
- Initialise Auto Oculus Touch, start the Oculus runtime.

InitvJoy(device)
- Start the vJoy input feeder. Device is the number of the vJoy virtual gamepad. The first gamepad is 1. Only a single vJoy controller can be used by an AOT script, but you can have multiple scripts runnings at once, each using a different vJoy controller.

Poll()
- Update the tracking state and all inputs. Poll() should be called regularly (such as 90+ times a second), otherwise all inputs stop updating.

Wearing()
- Check if the headset is being worn (face sensor).
- Returns: 0 if not worn, 1 if worn.

IsDown(button), IsPressed(button), IsReleased(button)
- Check if a button is active. Down means held down, Pressed means changed from up to down since the last Poll(), Released means changed from down to up since the last Poll().
- button: one of the button enums from auto_oculus_touch.ahk, such as ovrA.
- Returns: 1 if pressed/released/down, otherwise 0.

IsTouchDown(button), IsTouchPressed(button), IsTouchReleased(button)
- Check if a capacitive touch sensor is active. Down means held down, Pressed means changed from up to down since the last Poll(), Released means changed from down to up since the last Poll().
- button: one of the capacitive sensor enums from auto_oculus_touch.ahk, such as ovrTouch_A.
- Returns: 1 if pressed/released/down, otherwise 0.

GetButtonsDown(), GetButtonsPressed(), GetButtonsReleased()
- Gets the state of every button as a bit field (one bit per button). Down means held down, Pressed means changed from up to down since the last Poll(), Released means changed from down to up since the last Poll().
- Returns: bit field. You can check a button by masking it with a button enum.
Example:
if GetButtonsDown() & ovrA

GetTouchDown(), GetTouchPressed(), GetTouchReleased()
- Gets the state of every button as a bit field (one bit per button). Down means held down, Pressed means changed from up to down since the last Poll(), Released means changed from down to up since the last Poll().
- Returns: bit field. You can check a button by masking it with a button enum.
Example:
if GetTouchDown() & ovrTouch_A

GetAxis(axis)
- Gets the current value of an analog axis, such as a trigger ot thumbstick.
- axis: one of the axis enums from auto_oculus_touch.ahk, such as AxisIndexTriggerLeft.
- Returns: triggers give 0.0 to 1.0 range. Thumbstick axes give -1.0 to 1.0 range.

Reached(axis, threshold)
-Check if an analog axis has crossed over a threshold value since the last Poll().
-axis: one of the axis enums from auto_oculus_touch.ahk, such as AxisIndexTriggerLeft.
-threshold: value that triggers an activation. 
-Returns: If the axis went from below threshold to equal or greater, returns 1.
          If the axis went from greater or equal to the threshold to below, returns -1.
		  If the threshold wasn't crossed since the last Poll(), returns 0.

GetTrigger(hand, trigger)
- Gets the current value of a trigger.
- hand: LeftHand or RightHand enums (0 or 1)
- trigger: IndexTrigger or HandTrigger enums
- Returns: 0.0 to 1.0

GetThumbStick(hand, axis)
- Gets the current value of a thumbstick axis.
- hand: LeftHand or RightHand enums (0 or 1)
- axis: XAxis or YAxis enums
- Returns: -1.0 to 1.0

GetPitch(controller)
- Get the Pitch in degrees of a touch controller or headset.
- controller: LeftHand, RightHand or Head enums.
- Returns: angle in degrees in -90.0 to 90.0 range.

GetYaw(controller)
- Get the Yaw in degrees of a touch controller or headset.
- controller: LeftHand, RightHand or Head enums.
- Returns: angle in degrees in -180.0 to 180.0 range.

GetRoll(controller)
- Get the Roll in degrees of a touch controller or headset.
- controller: LeftHand, RightHand or Head enums.
- Returns: angle in degrees in -180.0 to 180.0 range.

GetPositionX(controller)
- Get the X position in metres of a touch controller or headset.
- controller: LeftHand, RightHand or Head enums.
- Returns: position.

GetPositionY(controller)
- Get the Y position in metres of a touch controller or headset.
- controller: LeftHand, RightHand or Head enums.
- Returns: position.

GetPositionZ(controller)
- Get the Z position in metres of a touch controller or headset.
- controller: LeftHand, RightHand or Head enums.
- Returns: position.

SetTrackingOrigin(origin)
- Set the origin type used by the tracking system. Floor origin places (0,0,0) at the room calibrated origin at floor level. Eye origin places (0,0,0) where the headset is when started.
- origin: OriginEye or OriginFloor enums.

ResetFacing(controller)
- Reset the current Yaw to 0.
- controller: LeftHand, RightHand or Head enums.

SetvJoyAxis(axis, value)
- Send an axis value to vJoy.
- axis: one of the vJoy HID enums such as HID_USAGE_X.
- value: 0.0 to 1.0 range

SetvJoyAxisU(axis, value)
- Send an axis value to vJoy, expanding it's range from (0.0 to 1.0) to (-1.0 to 1.0).
- axis: one of the vJoy HID enums such as HID_USAGE_X.
- value: 0.0 to 1.0 range

SetvJoyButton(button, value)
- Send a button state to vJoy.
- button: the number of a button, starting at 1.
- value: 0 for up, 1 for down.

SendRawMouseMove(x, y, z)
- Some games ignore AutoHotKey mouse movement. This attempts to fix that.
- x: x axis movement offset.
- y: y axis movement offset.
- z: mouse wheel movement offset.

SendRawMouseButtonDown(button), SendRawMouseButtonUp(button)
- Some games ignore AutoHotKey mouse buttons. This attempts to fix that.
- button: LeftMouse, RightMouse or MiddleMouse enums

Vibrate(controller, frequency, amplitude, length)
- Turn on or off vibration of a controller.
- controller: LeftHand or RightHand enum.
- frequency: 1==320Hz, 2==160Hz, 3==106.7Hz, 4=80Hz
- amplitude: 0 to 255 for vibration strength.
- length: If 0, the vibration is infinite, otherwise it is the length in seconds before the vibration stops.


Simple Starting Script
	#include auto_oculus_touch.ahk
	InitOculus()
	Loop {
		Poll()
		; Do your stuff here.
		Sleep, 10
	}


