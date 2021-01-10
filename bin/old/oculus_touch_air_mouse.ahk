#include auto_oculus_touch.ahk

pitch:=0
yaw:=0
speed:=30

InitOculus()

Loop {
    Poll()
	y:=GetYaw(1)
	p:=GetPitch(1)
	MouseMove, (y-yaw)*speed, (p-pitch)*-speed, 0, R
	yaw := yaw*0.1 + y*0.9
	pitch := pitch*0.1 + p*0.9
	
    Sleep, 10
}

