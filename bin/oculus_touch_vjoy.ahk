#include auto_oculus_touch.ahk

; This is used to treat the trigger like a button. We need to remember the old state.
oldTrigger:=0

; Start the Oculus sdk.
InitOculus()
InitvJoy(1)

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

    ; Get the various analog values. Triggers are 0.0-1.0, thumbsticks are -1.0-1.0
    leftIndexTrigger  := GetTrigger(LeftHand, IndexTrigger)
    leftHandTrigger   := GetTrigger(LeftHand, HandTrigger)
    leftX             := GetThumbStick(LeftHand, XAxis)
    leftY             := GetThumbStick(LeftHand, YAxis)
    rightIndexTrigger := GetTrigger(RightHand, IndexTrigger)
    rightHandTrigger  := GetTrigger(RightHand, HandTrigger)
    rightX            := GetThumbStick(RightHand, XAxis)
    rightY            := GetThumbStick(RightHand, YAxis)

    ; Get button states. 
    ; Down is the current state. If you test with this, you get a key every poll it is down. Repeating.
    ; Pressed is set if transitioned to down in the last poll. Non repeating.
    ; Released is set if transitioned to up in the last poll. Non repeating.
    down          := GetButtonsDown()
    pressed       := GetButtonsPressed()
    released      := GetButtonsReleased()
    touchDown     := GetTouchDown()
    touchPressed  := GetTouchPressed()
    touchReleased := GetTouchReleased()

    ; Now to do something with them.
	SetvJoyAxis(HID_USAGE_X, leftX)
	SetvJoyAxis(HID_USAGE_Y, -leftY)
	SetvJoyAxis(HID_USAGE_RX, rightX)
	SetvJoyAxis(HID_USAGE_RY, -rightY)
	SetvJoyAxisU(HID_USAGE_Z, leftIndexTrigger)
	SetvJoyAxisU(HID_USAGE_RZ, rightIndexTrigger)

		
	if pressed & ovrA
        SetvJoyButton(1,1)
    if released & ovrA
        SetvJoyButton(1,0)
	if pressed & ovrB
        SetvJoyButton(2,1)
    if released & ovrB
        SetvJoyButton(2,0)
	if pressed & ovrX
        SetvJoyButton(3,1)
    if released & ovrX
        SetvJoyButton(3,0)
	if pressed & ovrY
        SetvJoyButton(4,1)
    if released & ovrY
        SetvJoyButton(4,0)
	if pressed & ovrEnter
        SetvJoyButton(5,1)
    if released & ovrEnter
        SetvJoyButton(5,0)

	if pressed & ovrLThumb
        SetvJoyButton(8,1)
    if released & ovrLThumb
        SetvJoyButton(8,0)
	if pressed & ovrRThumb
        SetvJoyButton(9,1)
    if released & ovrRThumb
        SetvJoyButton(9,0)

	if leftHandTrigger > 0.7
        SetvJoyButton(6,1)
	else
        SetvJoyButton(6,0)
	if rightHandTrigger > 0.7
        SetvJoyButton(7,1)
	else
        SetvJoyButton(7,0)

    Sleep, 10
}

