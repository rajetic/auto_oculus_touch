#include auto_oculus_touch.ahk

; Start the Oculus sdk.
InitOculus()

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

    ; Pressed is set if transitioned to down in the last poll. Non repeating.
    pressed  := DllCall("auto_oculus_touch\getButtonsPressed")
    
    ; Use the up/down on the Oculus remote to cycle media tracks and the centre button to play/pause.   
    if released & ovrDown
        SendInput {Media_Next}
    if released & ovrUp
        SendInput {Media_Prev}
	if released & ovrEnter
		SendInput {Media_Play_Pause}

    Sleep 10
}

