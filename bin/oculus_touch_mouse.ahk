#include auto_oculus_touch.ahk

; This is used to treat the trigger like a button. We need to remember the old state.
oldTrigger:=0

; Start the Oculus sdk.
InitOculus()

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    DllCall("auto_oculus_touch\poll")

    ; Get the various analog values. Triggers are 0.0-1.0, thumbsticks are -1.0-1.0
    rightIndexTrigger := GetTrigger(RightHand, IndexTrigger)
    rightHandTrigger  := GetTrigger(RightHand, HandTrigger)
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
    if pressed & ovrA
        Send, {RButton down}
    if released & ovrA
        Send, {RButton up}

    if released & ovrB
        ResetFacing(1)

    ; Use the right index trigger as the left mouse button
    if (rightIndexTrigger > 0.8) and (oldTrigger<=0.8)
        Send, {LButton down}
    if (rightIndexTrigger <= 0.8) and (oldTrigger>0.8)
        Send, {LButton up}
        
	if rightHandTrigger > 0.8
	{
		y:=GetYaw(1)
		p:=GetPitch(1)
		dx:=0
		dy:=0
		if p>10
			dy:=p-10
		if p<-10
			dy:=p+10
		if y>10
			dx:=y-10
		if y<-10
			dx:=y+10

		MouseMove, dx,-dy,0,R
	}
	    
    oldTrigger := rightIndexTrigger
	
    Sleep, 10
}

