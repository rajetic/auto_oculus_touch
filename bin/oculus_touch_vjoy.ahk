#include auto_oculus_touch.ahk
; vJoy Example
; Set up Touch controllers as a gamepad using vJoy.

; Start the Oculus sdk.
InitOculus()
InitvJoy(1)

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

	SetvJoyAxis(HID_USAGE_X, GetAxis(AxisXLeft))
	SetvJoyAxis(HID_USAGE_Y, -GetAxis(AxisYLeft))
	SetvJoyAxis(HID_USAGE_RX, GetAxis(AxisXRight))
	SetvJoyAxis(HID_USAGE_RY, -GetAxis(AxisYRight))
	SetvJoyAxisU(HID_USAGE_Z, GetAxis(AxisHandTriggerLeft))
	SetvJoyAxisU(HID_USAGE_RZ, GetAxis(AxisHandTriggerRight))

		
	if IsPressed(ovrA)
        SetvJoyButton(1,1)
    if IsReleased(ovrA)
        SetvJoyButton(1,0)
	if IsPressed(ovrB)
        SetvJoyButton(2,1)
    if IsReleased(ovrB)
        SetvJoyButton(2,0)
	if IsPressed(ovrX)
        SetvJoyButton(3,1)
    if IsReleased(ovrX)
        SetvJoyButton(3,0)
	if IsPressed(ovrY)
        SetvJoyButton(4,1)
    if IsReleased(ovrY)
        SetvJoyButton(4,0)
	if IsPressed(ovrEnter)
        SetvJoyButton(7,1)
    if IsReleased(ovrEnter)
        SetvJoyButton(7,0)

	if IsPressed(ovrLThumb)
        SetvJoyButton(9,1)
    if IsReleased(ovrLThumb)
        SetvJoyButton(9,0)
	if IsPressed(ovrRThumb)
        SetvJoyButton(10,1)
    if IsReleased(ovrRThumb)
        SetvJoyButton(10,0)

	if GetAxis(AxisIndexTriggerLeft) > 0.7
        SetvJoyButton(5,1)
	else
        SetvJoyButton(5,0)
	if GetAxis(AxisIndexTriggerRight) > 0.7
        SetvJoyButton(6,1)
	else
        SetvJoyButton(6,0)

    Sleep, 10
}

