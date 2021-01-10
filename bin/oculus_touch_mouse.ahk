#include auto_oculus_touch.ahk
; Mouse Example
; Use the right Touch controller's thumbstick as a mouse. Right index trigger is the left mouse button.

; Start the Oculus sdk.
InitOculus()

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

	rightX:= GetAxis(AxisXRight)
	rightY:= GetAxis(AxisYRight)
    ; Move the mouse using the right thumb stick.
    if (rightX>0.1) or (rightX<-0.1) or (rightY>0.1) or (rightY<-0.1)
        SendRawMouseMove(rightX*30,rightY*-30,0)

    ; Use the A button as a right mouse button
    if IsPressed(ovrA)
        SendRawMouseButtonDown(1)
    if IsReleased(ovrA)
        SendRawMouseButtonUp(1)

    if IsReleased(ovrB)
        ResetFacing(1)

    ; Use the right index trigger as the left mouse button
	if Reached(AxisIndexTriggerRight, 0.8) == 1
		SendRawMouseButtonDown(0)
	if Reached(AxisIndexTriggerRight, 0.8) == -1
		SendRawMouseButtonUp(0)
	
    Sleep, 10
}

