#include auto_oculus_touch.ahk

; Start the Oculus sdk.
InitOculus()

speedX := 1
speedY := 1

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    DllCall("auto_oculus_touch\poll")

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
    
    ; Use the Enter button as a left mouse button
    if pressed & ovrEnter
        Send, {LButton down}
    if released & ovrEnter
        Send, {LButton up}

	; Back button is right mouse
    if pressed & ovrBack
        Send, {RButton down}
    if released & ovrBack
        Send, {RButton up}

	if down & ovrLeft   
	{
		MouseMove, -speedX,0,0,R
		speedX := speedX + 0.3
	}
	else
	if down & ovrRight
	{
		MouseMove, speedX,0,0,R
		speedX := speedX + 0.3
	}
	else
		speedX := 1

	if down & ovrUp   
	{
		MouseMove, 0,-speedY,0,R
		speedY := speedY + 0.3
	}
	else
	if down & ovrDown
	{
		MouseMove, 0,speedY,0,R
		speedY := speedY + 0.3
	}
	else
		speedY := 1

	if speedX > 30
		speedX := 30
	if speedY > 30
		speedY := 30
	
    Sleep, 10
}

