#include auto_oculus_touch.ahk

; Start the Oculus sdk.
InitOculus()

Gui, Color, White
Gui, Font,s16, Arial  
;Gui, Add, Button, Default xp+20 yp+250, Start the Bar Moving
;Gui, Add, Progress, vMyProgress w416
;Gui, Add, Text, vMyText wp  ; wp means "use width of previous".
Gui, Add, Text,, Left Thumbstick:
Gui, Add, Slider, vguiLeftX
Gui, Add, Slider, vguiLeftY
Gui, Add, Text,, Right Thumbstick:
Gui, Add, Slider, vguiRightX
Gui, Add, Slider, vguiRightY
Gui, Add, Text,, Left Index Trigger:
Gui, Add, Slider, vguiLeftIT
Gui, Add, Text,, Left Hand Trigger:
Gui, Add, Slider, vguiLeftHT
Gui, Add, Text,, Right Index Trigger:
Gui, Add, Slider, vguiRightIT
Gui, Add, Text,, Right Hand Trigger:
Gui, Add, Slider, vguiRightHT
Gui, Add, Text, vtb, Buttons: ----------------------------------------
Gui, Add, Text, vtt, Touch: ----------------------------------------

Gui, Add, Text,, Left Yaw Pitch Roll:
Gui, Add, Slider, vguiLYaw
Gui, Add, Slider, vguiLPitch
Gui, Add, Slider, vguiLRoll
Gui, Add, Text,, Right Yaw Pitch Roll:
Gui, Add, Slider, vguiRYaw
Gui, Add, Slider, vguiRPitch
Gui, Add, Slider, vguiRRoll
Gui, Add, Button,, VibrateOn
Gui, Add, Button,, VibrateOff
Gui, Show

DllCall("auto_oculus_touch\poll")
ResetFacing(0)
ResetFacing(1)

Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

    ; Get the various analog values. Triggers are 0.0-1.0, thumbsticks are -1.0-1.0
    leftIndexTrigger  := GetTrigger(LeftHand,  IndexTrigger)
    leftHandTrigger   := GetTrigger(LeftHand,  HandTrigger)
    rightIndexTrigger := GetTrigger(RightHand, IndexTrigger)
    rightHandTrigger  := GetTrigger(RightHand, HandTrigger)
    leftX             := GetThumbStick(LeftHand, XAxis)
    leftY             := GetThumbStick(LeftHand, YAxis)
    rightX            := GetThumbStick(RightHand, XAxis)
    rightY            := GetThumbStick(RightHand, YAxis)

	leftYaw 		  := (GetYaw(0)+180)/3.6
	leftPitch		  := (GetPitch(0)+90)/1.8
	leftRoll		  := (GetRoll(0)+180)/3.6
	rightYaw 		  := (GetYaw(1)+180)/3.6
	rightPitch		  := (GetPitch(1)+90)/1.8
	rightRoll		  := (GetRoll(1)+180)/3.6

    ; Get button states. 
    ; Down is the current state. If you test with this, you get a key every poll it is down. Repeating.
    ; Pressed is set if transitioned to down in the last poll. Non repeating.
    ; Released is set if transitioned to up in the last poll. Non repeating.
    down     := GetButtonsDown()
    pressed  := GetButtonsPressed()
    released := GetButtonsReleased()
    touchDown     := GetTouchDown()
    touchPressed  := GetTouchPressed()
    touchReleased := GetTouchReleased()
	lx := leftX*50+50
	ly := leftY*50+50
	rx := rightX*50+50
	ry := rightY*50+50
	buttontext := "Buttons: "
	if down & ovrA
		buttontext := buttontext . "A "
	else
		buttontext := buttontext . "- "
	if down & ovrB
		buttontext := buttontext . "B "
	else
		buttontext := buttontext . "- "
	if down & ovrX
		buttontext := buttontext . "X "
	else
		buttontext := buttontext . "- "
	if down & ovrY
		buttontext := buttontext . "Y "
	else
		buttontext := buttontext . "- "
	if down & ovrLThumb
		buttontext := buttontext . "LT "
	else
		buttontext := buttontext . "- "
	if down & ovrRThumb
		buttontext := buttontext . "RT "
	else
		buttontext := buttontext . "- "
	if down & ovrLShoulder
		buttontext := buttontext . "LS "
	else
		buttontext := buttontext . "- "
	if down & ovrRShoulder
		buttontext := buttontext . "RS "
	else
		buttontext := buttontext . "- "
	if down & ovrLeft
		buttontext := buttontext . "L "
	else
		buttontext := buttontext . "- "
	if down & ovrRight
		buttontext := buttontext . "R "
	else
		buttontext := buttontext . "- "
	if down & ovrUp
		buttontext := buttontext . "U "
	else
		buttontext := buttontext . "- "
	if down & ovrDown
		buttontext := buttontext . "D "
	else
		buttontext := buttontext . "- "
	if down & ovrBack
		buttontext := buttontext . "Back "
	else
		buttontext := buttontext . "- "
	if down & ovrEnter
		buttontext := buttontext . "E "
	else
		buttontext := buttontext . "- "

	touchtext := "Touching: "
	if touchDown & ovrTouch_A
		touchtext := touchtext . "A "
	if touchDown & ovrTouch_B
		touchtext := touchtext . "B "
	if touchDown & ovrTouch_X
		touchtext := touchtext . "X "
	if touchDown & ovrTouch_Y
		touchtext := touchtext . "Y "
	if touchDown & ovrTouch_LThumb
		touchtext := touchtext . "LThumb "
	if touchDown & ovrTouch_LThumbRest
		touchtext := touchtext . "LThumbRest "
	if touchDown & ovrTouch_LIndexTrigger
		touchtext := touchtext . "LTrig "
	if touchDown & ovrTouch_RThumb
		touchtext := touchtext . "RThumb "
	if touchDown & ovrTouch_RThumbRest
		touchtext := touchtext . "RThumbRest "
	if touchDown & ovrTouch_RIndexTrigger
		touchtext := touchtext . "RTrig "


	lit := leftIndexTrigger * 100
	lht := leftHandTrigger * 100
	rit := rightIndexTrigger * 100
	rht := rightHandTrigger * 100

	GuiControl,, guiLeftX, %lx%
	GuiControl,, guiLeftY, %ly%
	GuiControl,, guiRightX, %rx%
	GuiControl,, guiRightY, %ry%
	GuiControl,, guiLeftIT, %lit%
	GuiControl,, guiLeftHT, %lht%
	GuiControl,, guiRightIT, %rit%
	GuiControl,, guiRightHT, %rht%
	GuiControl,, tb, %buttontext%
	GuiControl,, tt, %touchtext%
	GuiControl,, guiLYaw, %leftYaw%
	GuiControl,, guiLPitch, %leftPitch%
	GuiControl,, guiLRoll, %leftRoll%
	GuiControl,, guiRYaw, %rightYaw%
	GuiControl,, guiRPitch, %rightPitch%
	GuiControl,, guiRRoll, %rightRoll%
	Gui, Show
	
    Sleep 10
}

ButtonVibrateOn:
	Vibrate(0, 1, 255, 0)
	Vibrate(1, 1, 255, 0)
	return

ButtonVibrateOff:
	Vibrate(0, 1, 0, 0)
	Vibrate(1, 1, 0, 0)
	return

GuiClose:
ExitApp
