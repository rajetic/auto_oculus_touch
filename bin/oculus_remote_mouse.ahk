#include auto_oculus_touch.ahk

; Start the Oculus sdk.
InitOculus()
speedX := 1
speedY := 1

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

    ; Now to do something with them.
    
    ; Use the Enter button as a left mouse button
    if IsPressed(ovrEnter)
        SendRawMouseButtonDown(0)
    if IsReleased(ovrEnter)
        SendRawMouseButtonUp(0)

	; Back button is right mouse
    if IsPressed(ovrBack)
        SendRawMouseButtonDown(1)
    if IsReleased(ovrBack)
        SendRawMouseButtonUp(1)

	if IsDown(ovrLeft)
	{
		SendRawMouseMove(-speedX, 0, 0)
		speedX := speedX + 0.3
	}
	else
	if IsDown(ovrRight)
	{
		SendRawMouseMove(speedX, 0, 0)
		speedX := speedX + 0.3
	}
	else
		speedX := 1

	if IsDown(ovrUp)  
	{
		SendRawMouseMove(0,-speedY, 0)
		speedY := speedY + 0.3
	}
	else
	if IsDown(ovrDown)
	{
		SendRawMouseMove(0,speedY, 0)
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

