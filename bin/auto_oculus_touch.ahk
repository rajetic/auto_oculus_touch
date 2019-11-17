;///////////////////////////////////////////////////////////////////////////////
;// AutoOculusTouch - Helper library to provide AutoHotKey with Oculus Touch state.
;// Copyright (C) 2017 Kojack (rajetic@gmail.com)
;//
;// AutoOculusTouch is released under the MIT License  
;// https://opensource.org/licenses/MIT
;///////////////////////////////////////////////////////////////////////////////

; Button enums
ovrA         := 0x00000001      ; Touch-A            Remote-None         Xbox-A
ovrB         := 0x00000002      ; Touch-B            Remote-None         Xbox-B
ovrRThumb    := 0x00000004      ; Touch-Right Stick  Remote-None         Xbox-Right Thumbstick
ovrRShoulder := 0x00000008      ; Touch-None         Remote-None         Xbox-Right Shoulder
ovrX         := 0x00000100      ; Touch-X            Remote-None         Xbox-X
ovrY         := 0x00000200      ; Touch-Y            Remote-None         Xbox-Y
ovrLThumb    := 0x00000400      ; Touch-Left Stick   Remote-None         Xbox-Left Thumbstick
ovrLShoulder := 0x00000800      ; Touch-None         Remote-None         Xbox-Left Shoulder
ovrUp        := 0x00010000      ; Touch-None         Remote-Up           Xbox-Up
ovrDown      := 0x00020000      ; Touch-None         Remote-Down         Xbox-Down
ovrLeft      := 0x00040000      ; Touch-None         Remote-Left         Xbox-Left
ovrRight     := 0x00080000      ; Touch-None         Remote-Right        Xbox-Right
ovrEnter     := 0x00100000      ; Touch-Left Menu    Remote-Select       Xbox-Start
ovrBack      := 0x00200000      ; Touch-None         Remote-Back         Xbox-Back

; The following button enums exist in the SDK, but the buttons can't be detected by user programs.
; They are included here for completeness only, you will never see them.
ovrVolUp     := 0x00400000      ; Touch-None         Remote-Volume Up    Xbox-None
ovrVolDown   := 0x00800000      ; Touch-None         Remote-Volume Down  Xbox-None
ovrHome      := 0x01000000      ; Touch-Oculus       Remote-Oculus       Xbox-Home

; Capacitive touch sensors
ovrTouch_A              := 0x00000001
ovrTouch_B              := 0x00000002
ovrTouch_RThumb         := 0x00000004
ovrTouch_RThumbRest     := 0x00000008
ovrTouch_RIndexTrigger  := 0x00000010
ovrTouch_X              := 0x00000100
ovrTouch_Y              := 0x00000200
ovrTouch_LThumb         := 0x00000400
ovrTouch_LThumbRest     := 0x00000800
ovrTouch_LIndexTrigger  := 0x00001000

; Capacitive touch gestures
ovrTouch_RIndexPointing := 0x00000020
ovrTouch_RThumbUp       := 0x00000040
ovrTouch_LIndexPointing := 0x00002000
ovrTouch_LThumbUp       := 0x00004000

; Controller types for vibration
ovrControllerType_LTouch := 0x0001
ovrControllerType_RTouch := 0x0002
ovrControllerType_XBox   := 0x0010

; Misc defines
LeftHand  := 0
RightHand := 1
IndexTrigger := 0
HandTrigger  := 1
XAxis := 0
YAxis := 1

; vJoy defines
HID_USAGE_X   := 0x30	; Left gamepad thumbstick x
HID_USAGE_Y	  := 0x31	; Left gamepad thumbstick y
HID_USAGE_Z	  := 0x32	; Left gamepad trigger
HID_USAGE_RX  := 0x33	; Right gamepad thumbstick x
HID_USAGE_RY  := 0x34	; Right gamepad thumbstick y
HID_USAGE_RZ  := 0x35	; Right gamepad trigger
HID_USAGE_SL0 := 0x36
HID_USAGE_SL1 := 0x37
HID_USAGE_WHL := 0x38
HID_USAGE_POV := 0x39


InitOculus()
{
	return DllCall("auto_oculus_touch\initOculus", "UInt")
}

Poll()
{
    DllCall("auto_oculus_touch\poll")
}

GetButtonsDown()
{
    return DllCall("auto_oculus_touch\getButtonsDown")
}

GetButtonsReleased()
{
    return DllCall("auto_oculus_touch\getButtonsReleased")
}

GetButtonsPressed()
{
    return DllCall("auto_oculus_touch\getButtonsPressed")
}

GetTouchDown()
{
    return DllCall("auto_oculus_touch\getTouchDown")
}

GetTouchPressed()
{
    return DllCall("auto_oculus_touch\getTouchPressed")
}

GetTouchReleased()
{
    return DllCall("auto_oculus_touch\getTouchReleased")
}

GetTrigger(hand, trigger)
{
    return DllCall("auto_oculus_touch\getTrigger", "Int", hand, "Int", trigger, "Float")
}

GetThumbStick(hand, axis)
{
    return DllCall("auto_oculus_touch\getThumbStick", "Int", hand, "Int", axis, "Float")
}

Vibrate(controller, frequency, amplitude, oneshot)
{
    DllCall("auto_oculus_touch\setVibration", "UInt", controller, "UInt", frequency, "UChar", amplitude, "UInt", oneshot)
}

GetYaw(controller)
{
    return DllCall("auto_oculus_touch\getYaw", "UInt", controller, "Float")
}

GetPitch(controller)
{
    return DllCall("auto_oculus_touch\getPitch", "UInt", controller, "Float")
}

GetRoll(controller)
{
    return DllCall("auto_oculus_touch\getRoll", "UInt", controller, "Float")
}

ResetFacing(controller)
{
	DllCall("auto_oculus_touch\resetFacing", "UInt", controller)
}

InitvJoy(device)
{
	DllCall("auto_oculus_touch\initvJoy", "UInt", device, "UInt")
}

SetvJoyAxis(axis, value)
{
    DllCall("auto_oculus_touch\setvJoyAxis", "Float", value, "UInt", axis)
}

SetvJoyAxisU(axis, value)
{
    DllCall("auto_oculus_touch\setvJoyAxis", "Float", value*2-1, "UInt", axis)
}

SetvJoyButton(button, value)
{
    DllCall("auto_oculus_touch\setvJoyButton", "UInt", value, "UInt", button)
}

; Grab the library. 
hModule := DllCall("LoadLibrary", "Str", "auto_oculus_touch.dll", "Ptr")
