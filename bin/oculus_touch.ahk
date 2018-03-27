;///////////////////////////////////////////////////////////////////////////////
;// AutoOculusTouch - Helper library to provide AutoHotKey with Oculus Touch state.
;// Copyright (C) 2017 Kojack (rajetic@gmail.com)
;//
;// AutoOculusTouch is released under the MIT License  
;// https://opensource.org/licenses/MIT
;///////////////////////////////////////////////////////////////////////////////

; Button enums
ovrA         := 0x00000001      ; Touch-A            Remote-Select       Xbox-A
ovrB         := 0x00000002      ; Touch-B            Remote-Back         Xbox-B
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
ovrEnter     := 0x00100000      ; Touch-Left Menu    Remote-None         Xbox-Start
ovrBack      := 0x00200000      ; Touch-None         Remote-None         Xbox-Back
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


GetTrigger(hand, trigger)
{
    return DllCall("auto_oculus_touch\getTrigger", "Int", hand, "Int", trigger, "Float")
}

GetThumbStick(hand, axis)
{
    return DllCall("auto_oculus_touch\getThumbStick", "Int", hand, "Int", axis, "Float")
}

Vibrate(controller, frequency, amplitude)
{
    DllCall("auto_oculus_touch\setVibration", "UInt", controller, "Float", frequency, "Float", amplitude)
}

; Grab the library. 
hModule := DllCall("LoadLibrary", "Str", "auto_oculus_touch.dll", "Ptr")
if !hModule
{
    if (A_LastError = 193)
    {
        MsgBox You're trying to load 64-bit dll with 32-bit AutoHotkey, use AutoHotkeyU64.exe
    } else {
        MsgBox Failed to load dll (error %A_LastError%).
    }
    ExitApp
}

; Start the Oculus sdk.
DllCall("auto_oculus_touch\initOculus")

; This is used to treat the trigger like a button. We need to remember the old state.
oldTrigger:=0

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    DllCall("auto_oculus_touch\poll")

    ; Get the various analog values. Triggers are 0.0-1.0, thumbsticks are -1.0-1.0
    leftIndexTrigger  := GetTrigger(LeftHand,  IndexTrigger)
    leftHandTrigger   := GetTrigger(LeftHand,  HandTrigger)
    rightIndexTrigger := GetTrigger(RightHand, IndexTrigger)
    rightHandTrigger  := GetTrigger(RightHand, HandTrigger)
    leftX             := GetThumbStick(LeftHand, XAxis)
    leftY             := GetThumbStick(LeftHand, YAxis)
    rightX            := GetThumbStick(RightHand, XAxis)
    rightY            := GetThumbStick(RightHand, YAxis)

    ; Get button states. 
    ; Down is the current state. If you test with this, you get a key every poll it is down. Repeating.
    ; Pressed is set if transitioned to down in the last poll. Non repeating.
    ; Released is set if transitioned to up in the last poll. Non repeating.
    down     := DllCall("auto_oculus_touch\getButtonsDown")
    pressed  := DllCall("auto_oculus_touch\getButtonsPressed")
    released := DllCall("auto_oculus_touch\getButtonsReleased")
    touchDown     := DllCall("auto_oculus_touch\getTouchDown")
    touchPressed  := DllCall("auto_oculus_touch\getTouchPressed")
    touchReleased := DllCall("auto_oculus_touch\getTouchReleased")

    ; Now to do something with them.
    
    ; Move the mouse using the right thumb stick.
    if (rightX>0.1) or (rightX<-0.1) or (rightY>0.1) or (rightY<-0.1)
        MouseMove, rightX*10,rightY*-10,0,R

    ; Use the X button as a left mouse button
    if pressed & ovrX
        Send, {LButton down}
    if released & ovrX
        Send, {LButton up}

    ; Use the right index trigger as the left mouse button
    if (rightIndexTrigger > 0.8) and (oldTrigger<=0.8)
        Send, {LButton down}
    if (rightIndexTrigger <= 0.8) and (oldTrigger>0.8)
        Send, {LButton up}
        
    ; Use the up/down on the Oculus remote to cycle media tracks.   
    if released & ovrDown
        Send, {Media_Next}
    if released & ovrUp
        Send, {Media_Prev}
    
    oldTrigger := rightIndexTrigger

    Sleep, 10
}

