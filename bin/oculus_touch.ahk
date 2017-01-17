;///////////////////////////////////////////////////////////////////////////////
;// AutoOculusTouch - Helper library to provide AutoHotKey with Oculus Touch state.
;// Copyright (C) 2017 Kojack (rajetic@gmail.com)
;//
;// AutoOculusTouch is released under the MIT License  
;// https://opensource.org/licenses/MIT
;///////////////////////////////////////////////////////////////////////////////

; Button enums
ovrA         := 0x00000001
ovrB         := 0x00000002
ovrRThumb    := 0x00000004
ovrRShoulder := 0x00000008
ovrX         := 0x00000100
ovrY         := 0x00000200
ovrLThumb    := 0x00000400
ovrLShoulder := 0x00000800
ovrUp        := 0x00010000
ovrDown      := 0x00020000
ovrLeft      := 0x00040000
ovrRight     := 0x00080000
ovrEnter     := 0x00100000
ovrBack      := 0x00200000
ovrVolUp     := 0x00400000
ovrVolDown   := 0x00800000
ovrHome      := 0x01000000

; Grab the library.	
hModule := DllCall("LoadLibrary", "Str", "auto_oculus_touch.dll", "Ptr")

; Start the Oculus sdk.
DllCall("auto_oculus_touch\initOculus")

; This is used to treat the trigger like a button. We need to remember the old state.
oldTrigger:=0

; Main polling loop.
Loop {
	; Grab the latest Oculus input state (Touch, Remote and Xbox One).
	DllCall("auto_oculus_touch\poll")

	; Get the various analog values. Triggers are 0.0-1.0, thumbsticks are -1.0-1.0
	leftIndexTrigger  :=DllCall("auto_oculus_touch\getTrigger","Int",0,"Int",0,"Float")
	leftHandTrigger   :=DllCall("auto_oculus_touch\getTrigger","Int",0,"Int",1,"Float")
	rightIndexTrigger :=DllCall("auto_oculus_touch\getTrigger","Int",1,"Int",0,"Float")
	rightHandTrigger  :=DllCall("auto_oculus_touch\getTrigger","Int",1,"Int",1,"Float")
	leftX             :=DllCall("auto_oculus_touch\getThumbStick","Int",0,"Int",0,"Float")
	leftY             :=DllCall("auto_oculus_touch\getThumbStick","Int",0,"Int",1,"Float")
	rightX            :=DllCall("auto_oculus_touch\getThumbStick","Int",1,"Int",0,"Float")
	rightY            :=DllCall("auto_oculus_touch\getThumbStick","Int",1,"Int",1,"Float")

	; Get button states. 
	; Down is the current state. If you test with this, you get a key every poll it is down. Repeating.
	; Pressed is set if transitioned to down in the last poll. Non repeating.
	; Released is set if transitioned to up in the last poll. Non repeating.
	down     := DllCall("auto_oculus_touch\getButtonsDown")
	pressed  := DllCall("auto_oculus_touch\getButtonsPressed")
	released := DllCall("auto_oculus_touch\getButtonsReleased")

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
	
	Sleep, 0
}

