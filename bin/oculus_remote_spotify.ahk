#include auto_oculus_touch.ahk
; Media player Remote Example
; Use the up/down on the Oculus remote to cycle media tracks and the centre button to play/pause.
; Should work with anything that accepts the next/previous and play media keys, such as Spotify.

; Start the Oculus sdk.
InitOculus()

; Main polling loop.
Loop {
    ; Grab the latest Oculus input state (Touch, Remote and Xbox One).
    Poll()

       
    if IsReleased(ovrDown)
        SendInput {Media_Next}
    if IsReleased(ovrUp)
        SendInput {Media_Prev}
	if IsReleased(ovrEnter)
		SendInput {Media_Play_Pause}

    Sleep 10
}

