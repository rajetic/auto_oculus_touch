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
Head := 2
IndexTrigger := 0
HandTrigger  := 1
XAxis := 0
YAxis := 1
LeftMouse := 0
RightMouse := 1
MiddleMouse := 2

; Tracking origin
OriginEye := 0
OriginFloor := 1

; Axis defines
AxisIndexTriggerLeft := 0
AxisIndexTriggerRight := 1
AxisHandTriggerLeft := 2
AxisHandTriggerRight := 3
AxisXLeft := 4
AxisXRight := 5
AxisYLeft := 6
AxisYRight := 7

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

; Grab the library. 
AOTModule := DllCall("LoadLibrary", "Str", "auto_oculus_touch.dll", "Ptr")
if AOTModule!=0
{
	
}
else
{
	MsgBox, The auto_oculus_touch.dll file is missing from the search path.
	ExitApp
}

Func_initOculus := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "initOculus", "Ptr")
Func_poll := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "poll", "Ptr")
Func_isWearing := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isWearing", "Ptr")
Func_isPressed := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isPressed", "Ptr")
Func_isReleased := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isReleased", "Ptr")
Func_isDown := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isDown", "Ptr")
Func_isTouchPressed := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isTouchPressed", "Ptr")
Func_isTouchReleased := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isTouchReleased", "Ptr")
Func_isTouchDown := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "isTouchDown", "Ptr")
Func_reached := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "reached", "Ptr")
Func_getAxis := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getAxis", "Ptr")
Func_getButtonsDown := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getButtonsDown", "Ptr")
Func_getButtonsReleased := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getButtonsReleased", "Ptr")
Func_getButtonsPressed := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getButtonsPressed", "Ptr")
Func_getTouchDown := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getTouchDown", "Ptr")
Func_getTouchPressed := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getTouchPressed", "Ptr")
Func_getTouchReleased := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getTouchReleased", "Ptr")
Func_getTrigger := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getTrigger", "Ptr")
Func_getThumbStick := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getThumbStick", "Ptr")
Func_setVibration := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "setVibration", "Ptr")
Func_getYaw := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getYaw", "Ptr")
Func_getPitch := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getPitch", "Ptr")
Func_getRoll := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getRoll", "Ptr")
Func_getPositionX := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getPositionX", "Ptr")
Func_getPositionY := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getPositionY", "Ptr")
Func_getPositionZ := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "getPositionZ", "Ptr")
Func_setTrackingOrigin := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "setTrackingOrigin", "Ptr")
Func_resetFacing := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "resetFacing", "Ptr")
Func_initvJoy := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "initvJoy", "Ptr")
Func_setvJoyAxis := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "setvJoyAxis", "Ptr")
Func_setvJoyButton := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "setvJoyButton", "Ptr")
Func_sendRawMouseMove := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "sendRawMouseMove", "Ptr")
Func_sendRawMouseButtonDown := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "sendRawMouseButtonDown", "Ptr")
Func_sendRawMouseButtonUp := DllCall("GetProcAddress", "Ptr", AOTModule, "AStr", "sendRawMouseButtonUp", "Ptr")

InitOculus()
{
	global Func_initOculus
	return DllCall(Func_initOculus, "UInt")
}

Poll()
{
	global Func_poll
    DllCall(Func_poll)
}

Wearing()
{
	global Func_isWearing
	return DllCall(Func_isWearing)
}

IsPressed(button)
{
	global Func_isPressed
    return DllCall(Func_isPressed, "UInt", button)
}

IsReleased(button)
{
	global Func_isReleased
    return DllCall(Func_isReleased, "UInt", button)
}

IsDown(button)
{
	global Func_isDown
    return DllCall(Func_isDown, "UInt", button)
}

IsTouchPressed(button)
{
	global Func_isTouchPressed
    return DllCall(Func_isTouchPressed, "UInt", button)
}

IsTouchReleased(button)
{
	global Func_isTouchReleased
    return DllCall(Func_isTouchReleased, "UInt", button)
}

IsTouchDown(button)
{
	global Func_isTouchDown
    return DllCall(Func_isTouchDown, "UInt", button)
}

Reached(axis, value)
{
	global Func_reached
	return DllCall(Func_reached, "UInt", axis, "Float", value)
}

GetAxis(axis)
{
	global Func_getAxis
	return DllCall(Func_getAxis, "UInt", axis, "Float")
}

GetButtonsDown()
{
	global Func_getButtonsDown
    return DllCall(Func_getButtonsDown)
}

GetButtonsReleased()
{
	global Func_getButtonsReleased
    return DllCall(Func_getButtonsReleased)
}

GetButtonsPressed()
{
	global Func_getButtonsPressed
    return DllCall(Func_getButtonsPressed)
}

GetTouchDown()
{
	global Func_getTouchDown
    return DllCall(Func_getTouchDown)
}

GetTouchPressed()
{
	global Func_getTouchPressed
    return DllCall(Func_getTouchPressed)
}

GetTouchReleased()
{
	global Func_getTouchReleased
    return DllCall(Func_getTouchReleased)
}

GetTrigger(hand, trigger)
{
	global Func_getTrigger
    return DllCall(Func_getTrigger, "Int", hand, "Int", trigger, "Float")
}

GetThumbStick(hand, axis)
{
	global Func_getThumbStick
    return DllCall(Func_getThumbStick, "Int", hand, "Int", axis, "Float")
}

Vibrate(controller, frequency, amplitude, length)
{
	global Func_setVibration
    DllCall(Func_setVibration, "UInt", controller, "UInt", frequency, "UChar", amplitude, "Float", length)
}

GetYaw(controller)
{
	global Func_getYaw
    return DllCall(Func_getYaw, "UInt", controller, "Float")
}

GetPitch(controller)
{
	global Func_getPitch
    return DllCall(Func_getPitch, "UInt", controller, "Float")
}

GetRoll(controller)
{
	global Func_getRoll
    return DllCall(Func_getRoll, "UInt", controller, "Float")
}

GetPositionX(controller)
{
	global Func_getPositionX
    return DllCall(Func_getPositionX, "UInt", controller, "Float")
}

GetPositionY(controller)
{
	global Func_getPositionY
    return DllCall(Func_getPositionY, "UInt", controller, "Float")
}

GetPositionZ(controller)
{
	global Func_getPositionZ
    return DllCall(Func_getPositionZ, "UInt", controller, "Float")
}

SetTrackingOrigin(origin)
{
	global Func_setTrackingOrigin
    return DllCall(Func_setTrackingOrigin, "UInt", origin)
}

ResetFacing(controller)
{
	global Func_resetFacing
	DllCall(Func_resetFacing, "UInt", controller)
}

InitvJoy(device)
{
	global Func_initvJoy
	result := DllCall(Func_initvJoy, "UInt", device, "AStr")
	ll := StrLen(result)
	if ll>0
	{
		MsgBox, %result%
		ExitApp
	}
}

SetvJoyAxis(axis, value)
{
	global Func_setvJoyAxis
    DllCall(Func_setvJoyAxis, "Float", value, "UInt", axis)
}

SetvJoyAxisU(axis, value)
{
	global Func_setvJoyAxis
    DllCall(Func_setvJoyAxis, "Float", value*2-1, "UInt", axis)
}

SetvJoyButton(button, value)
{
	global Func_setvJoyButton
    DllCall(Func_setvJoyButton, "UInt", value, "UInt", button)
}

SendRawMouseMove(x, y, z)
{
	global Func_sendRawMouseMove
    DllCall(Func_sendRawMouseMove, "Int", x, "Int", y, "Int", z)
}

SendRawMouseButtonDown(button)
{
	global Func_sendRawMouseButtonDown
    DllCall(Func_sendRawMouseButtonDown, "UInt", button)
}

SendRawMouseButtonUp(button)
{
	global Func_sendRawMouseButtonUp
    DllCall(Func_sendRawMouseButtonUp, "UInt", button)
}


