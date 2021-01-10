#include auto_oculus_touch.ahk

; Start the Oculus sdk.
InitOculus()

Gui, Color, White
Gui, Font,s16, Arial  
Gui, Add, Text,section, Left Thumbstick:
Gui, Add, Slider, vguiLeftX
Gui, Add, Slider, vguiLeftY
Gui, Add, Text,, Left Index Trigger:
Gui, Add, Slider, vguiLeftIT
Gui, Add, Text,, Left Hand Trigger:
Gui, Add, Slider, vguiLeftHT
Gui, Add, Text,ys, Right Thumbstick:
Gui, Add, Slider, vguiRightX
Gui, Add, Slider, vguiRightY
Gui, Add, Text,, Right Index Trigger:
Gui, Add, Slider, vguiRightIT
Gui, Add, Text,, Right Hand Trigger:
Gui, Add, Slider, vguiRightHT
Gui, Add, Text, vtb section xm, Buttons: ----------------------------------------
Gui, Add, Text, vtt, Touch: ----------------------------------------
Gui, Add, Text, vtw, Wearing: ---------------------------------------
Gui, Add, Text,section, Left Yaw Pitch Roll:
Gui, Add, Slider, vguiLYaw
Gui, Add, Slider, vguiLPitch
Gui, Add, Slider, vguiLRoll
Gui, Add, Text,, Left Position
Gui, Add, Text, vlpx, Left Pos X: --------------------------
Gui, Add, Text, vlpy, Left Pos Y: --------------------------
Gui, Add, Text, vlpz, Left Pos Z: --------------------------
Gui, Add, Text,ys, Right Yaw Pitch Roll:
Gui, Add, Slider, vguiRYaw
Gui, Add, Slider, vguiRPitch
Gui, Add, Slider, vguiRRoll
Gui, Add, Text,, Right Position
Gui, Add, Text, vrpx, Left Pos X: --------------------------
Gui, Add, Text, vrpy, Left Pos Y: --------------------------
Gui, Add, Text, vrpz, Left Pos Z: --------------------------
Gui, Add, Text,ys, Head Yaw Pitch Roll:
Gui, Add, Slider, vguiHYaw
Gui, Add, Slider, vguiHPitch
Gui, Add, Slider, vguiHRoll
Gui, Add, Text,, Head Position
Gui, Add, Text, vhpx, Left Pos X: --------------------------
Gui, Add, Text, vhpy, Left Pos Y: --------------------------
Gui, Add, Text, vhpz, Left Pos Z: --------------------------


Gui, Add, Button,section xm, VibrateOn
Gui, Add, Button,ys, VibrateOff
Gui, Add, Button,section xm, VibratePulse
Gui, Show

DllCall("auto_oculus_touch\poll")
ResetFacing(0)
ResetFacing(1)
ResetFacing(2)

SetTrackingOrigin(OriginFloor)

Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

    ; Get the various analog values. Triggers are 0.0-1.0, thumbsticks are -1.0-1.0
    leftIndexTrigger  := GetAxis(AxisIndexTriggerLeft)
    leftHandTrigger   := GetAxis(AxisHandTriggerLeft)
    rightIndexTrigger := GetAxis(AxisIndexTriggerRight)
    rightHandTrigger  := GetAxis(AxisHandTriggerRight)
    leftX             := GetAxis(AxisXLeft)
    leftY             := GetAxis(AxisYLeft)
    rightX            := GetAxis(AxisXRight)
    rightY            := GetAxis(AxisYRight)

	leftYaw 		  := (GetYaw(0)+180)/3.6
	leftPitch		  := (GetPitch(0)+90)/1.8
	leftRoll		  := (GetRoll(0)+180)/3.6
	rightYaw 		  := (GetYaw(1)+180)/3.6
	rightPitch		  := (GetPitch(1)+90)/1.8
	rightRoll		  := (GetRoll(1)+180)/3.6
	headYaw 		  := (GetYaw(2)+180)/3.6
	headPitch		  := (GetPitch(2)+90)/1.8
	headRoll		  := (GetRoll(2)+180)/3.6

    ; Get button states. 
	lx := leftX*50+50
	ly := leftY*50+50
	rx := rightX*50+50
	ry := rightY*50+50
	buttontext := "Buttons: "
	if IsDown(ovrA)
		buttontext := buttontext . "A "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrB)
		buttontext := buttontext . "B "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrX)
		buttontext := buttontext . "X "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrY)
		buttontext := buttontext . "Y "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrLThumb)
		buttontext := buttontext . "LT "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrRThumb)
		buttontext := buttontext . "RT "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrLShoulder)
		buttontext := buttontext . "LS "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrRShoulder)
		buttontext := buttontext . "RS "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrLeft)
		buttontext := buttontext . "L "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrRight)
		buttontext := buttontext . "R "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrUp)
		buttontext := buttontext . "U "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrDown)
		buttontext := buttontext . "D "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrBack)
		buttontext := buttontext . "Back "
	else
		buttontext := buttontext . "- "
	if IsDown(ovrEnter)
		buttontext := buttontext . "E "
	else
		buttontext := buttontext . "- "

	touchtext := "Touching: "
	if IsTouchDown(ovrTouch_A)
		touchtext := touchtext . "A "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_B)
		touchtext := touchtext . "B "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_X)
		touchtext := touchtext . "X "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_Y)
		touchtext := touchtext . "Y "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_LThumb)
		touchtext := touchtext . "LThumb "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_LThumbRest)
		touchtext := touchtext . "LThumbRest "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_LIndexTrigger)
		touchtext := touchtext . "LTrig "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_RThumb)
		touchtext := touchtext . "RThumb "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_RThumbRest)
		touchtext := touchtext . "RThumbRest "
	else
		touchtext := touchtext . "- "
	if IsTouchDown(ovrTouch_RIndexTrigger)
		touchtext := touchtext . "RTrig "
	else
		touchtext := touchtext . "- "
		
	if Wearing()
	{
		;touchtext := "Wear"
		wearingText := "Wearing headset: True"
		;Vibrate(0, 1, 255, 0)
		;Vibrate(1, 1, 255, 0)
	}
	else
	{
		wearingText := "Wearing headset: False"
	}

	lit := leftIndexTrigger * 100
	lht := leftHandTrigger * 100
	rit := rightIndexTrigger * 100
	rht := rightHandTrigger * 100

	leftPosX := GetPositionX(0)
	leftPosY := GetPositionY(0)
	leftPosZ := GetPositionZ(0)
	rightPosX := GetPositionX(1)
	rightPosY := GetPositionY(1)
	rightPosZ := GetPositionZ(1)
	headPosX := GetPositionX(2)
	headPosY := GetPositionY(2)
	headPosZ := GetPositionZ(2)
	
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
	GuiControl,, tw, %wearingText%
	GuiControl,, guiLYaw, %leftYaw%
	GuiControl,, guiLPitch, %leftPitch%
	GuiControl,, guiLRoll, %leftRoll%
	GuiControl,, guiRYaw, %rightYaw%
	GuiControl,, guiRPitch, %rightPitch%
	GuiControl,, guiRRoll, %rightRoll%
	GuiControl,, guiHYaw, %headYaw%
	GuiControl,, guiHPitch, %headPitch%
	GuiControl,, guiHRoll, %headRoll%
	GuiControl,, lpx, %leftPosX%
	GuiControl,, lpy, %leftPosY%
	GuiControl,, lpz, %leftPosZ%
	GuiControl,, rpx, %rightPosX%
	GuiControl,, rpy, %rightPosY%
	GuiControl,, rpz, %rightPosZ%
	GuiControl,, hpx, %headPosX%
	GuiControl,, hpy, %headPosY%
	GuiControl,, hpz, %headPosZ%
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

ButtonVibratePulse:
	Vibrate(0, 1, 255, 0.5)
	Vibrate(1, 1, 255, 0.5)
	return

GuiClose:
ExitApp
