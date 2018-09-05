///////////////////////////////////////////////////////////////////////////////
// AutoTouch - Helper library to provide AutoHotKey with Oculus Touch state.
// Copyright (C) 2017 Kojack (rajetic@gmail.com)
//
// AutoTouch is released under the MIT License  
// https://opensource.org/licenses/MIT
///////////////////////////////////////////////////////////////////////////////

#define ROBUST
#include "stdafx.h"
#include "OVR_CAPI.h"
#include "cmath"
#include "Extras\OVR_Math.h"
#include "public.h"
#include "vjoyinterface.h"

#pragma comment(lib,"LibOVR")

// Global Variables
ovrSession			g_HMD = 0;	// The session of the headset

// Button and touch states
ovrInputState		g_touchStateLast;
ovrInputState		g_touchState;

// Vibration
unsigned char		g_sampleBuffer[2][24];		// Buffer used to hold touch vibration patterns
unsigned char		g_amplitude[2] = { 0, 0 };		// Current amplitude used to generate touch patterns
int					g_frequency[2] = { 1, 1 };		// Current frequency used to generate touch patterns
bool				g_oneShot[2] = { false, false };		// If true, amplitude is reset to 0 after filling the buffer once

// Angle and position tracking
ovrTrackingState	g_trackingState;		// Touch and head tracking data
float				g_identityAngle[2] = { 0,0 };	// Tracked angle that is reported as 0 degrees to the user (set by resetFacing)
ovrVector3f			g_xAxis = { 1,0,0 };	// X axis of reset tracking coordinate system
ovrVector3f			g_yAxis = { 0,1,0 };	// Y axis of reset tracking coordinate system
ovrVector3f			g_zAxis = { 0,0,1 };	// Z axis of reset tracking coordinate system
ovrVector3f			g_origin = { 0,0,0 };	// Origin of reset tracking coordinate system

// vJoy
int				g_vjoy = -1;

// Functions exported to AutoHotkey
extern "C"
{
	// Initialise the Oculus session
	__declspec(dllexport) int initOculus()
	{
		memset(&g_touchState, 0, sizeof(ovrInputState));
		memset(&g_touchStateLast, 0, sizeof(ovrInputState));
		memset(&g_trackingState, 0, sizeof(ovrTrackingState));
		g_frequency[0] = 1;	// 1 = 320Hz
		g_frequency[1] = 1;	// 1 = 320Hz
		g_amplitude[0] = 0;
		g_amplitude[1] = 0;
		g_identityAngle[0] = 0;
		g_identityAngle[1] = 0;

		ovrGraphicsLuid g_luid;
		ovrInitParams params;
		params.Flags = ovrInit_Invisible;
		params.ConnectionTimeoutMS = 0;
		params.RequestedMinorVersion = 8;
		params.UserData = 0;
		params.LogCallback = 0;

		ovrResult result = ovr_Initialize(&params);
		if (OVR_FAILURE(result))
			return 0;

		result = ovr_Create(&g_HMD, &g_luid);

		return g_HMD ? 1 : 0;
	}

	// Poll the current state of the controllers.
	// This needs to be called at a regular rate for the rest of the functions to work (this one gathers the data they use).
	// It also updates the vibration queues.
	__declspec(dllexport) void poll()
	{
		if (g_HMD)
		{
			g_touchStateLast = g_touchState;
			ovr_GetInputState(g_HMD, ovrControllerType_Active , &g_touchState);
			g_trackingState = ovr_GetTrackingState(g_HMD, 0, false);

			// Check the left touch vibration queue
			ovrHapticsPlaybackState state;
			for (int controller = 0; controller < 2; ++controller)
			{
				ovr_GetControllerVibrationState(g_HMD, (ovrControllerType)((int)ovrControllerType_LTouch+controller), &state);
				if (state.SamplesQueued < 40 && g_amplitude[controller] > 0)
				{
					ovrHapticsBuffer haptics;
					haptics.SubmitMode = ovrHapticsBufferSubmit_Enqueue;
					haptics.SamplesCount = 24;
					haptics.Samples = &g_sampleBuffer[controller];
					ovr_SubmitControllerVibration(g_HMD, (ovrControllerType)((int)ovrControllerType_LTouch + controller), &haptics);
					if (g_oneShot[controller])
					{
						g_amplitude[controller] = 0;
					}
				}
			}
		}
	}
	
	// Initialise a vJoy device. Currently only a single device can be used by a single auto_oculus_touch script.
	// device - index from 1 to the number of vJoy devices
	// return - 0 if init failed, 1 if succeeded
	__declspec(dllexport) int initvJoy(unsigned int device)
	{
		g_vjoy = -1;
		if (vJoyEnabled())
		{
			WORD VerDll, VerDrv;
			if (DriverMatch(&VerDll, &VerDrv))
			{
				VjdStat status = GetVJDStatus(device);
				if (status == VJD_STAT_FREE)
				{
					if(AcquireVJD(device))
					{
						g_vjoy = device;
					}
				}
			}
		}
		return g_vjoy > -1 ? 1 : 0;
	}

	// Set the state of a vJoy axis.
	// value - a float value from -1 to 1
	// hid - the HID usage code of the axis. These are listed in the auto_oculus_touch.ahk file as HID_USAGE_*
	__declspec(dllexport) void setvJoyAxis(float value, unsigned int hid)
	{
		if (g_vjoy > -1)
		{
			if (value < -1.0f)
				value = -1.0f;
			if (value > 1.0f)
				value = 1.0f;
			long v = long((value*0.5f + 0.5f) * 0x7999) + 1;
			SetAxis(v, g_vjoy, hid);
		}
	}

	// Set the state of a vJoy button.
	// value - 0==not pressed, 1==pressed
	// button - an index from 1 to the number of buttons set in vJoy
	__declspec(dllexport) void setvJoyButton(unsigned int value, unsigned int button)
	{
		if (g_vjoy > -1)
		{
			SetBtn(value, g_vjoy, button);
		}
	}

	// Sets the current desired vibration pattern.
	// controller - 0==left, 1==right
	// frequency  - vibration at 1==320Hz, 2==160Hz, 3==106.7Hz, 4=80Hz
	// amplitude  - 0 to 255 is the strength of the vibration
	// oneShot    - This makes the vibration stop after a short pulse
	__declspec(dllexport) void setVibration(unsigned int controller, unsigned int frequency, unsigned char amplitude, unsigned int oneShot)
	{
		if (g_HMD)
		{
			if (controller < 2)
			{
					g_oneShot[controller] = oneShot;
					g_amplitude[controller] = amplitude;
					if (frequency >= 1 && frequency < 24)
						g_frequency[controller] = frequency;
					for (int i = 0; i < 24; ++i)
					{
						g_sampleBuffer[controller][i] = (i % g_frequency[controller]) == 0 ? amplitude : 0;
					}
			}
		}
	}

	// Retrieve the current trigger value
	// return     - 0 to 1 for trigger press
	// controller - 1==left, 2==right
	// trigger    - 0==index, 1==hand
	__declspec(dllexport) float getTrigger(int controller, int trigger)
	{
		if (g_HMD)
		{
			if (trigger >= 0 && trigger < 2 && controller >= 0 && controller < 2)
			{
				switch (trigger)
				{
				case 0:
					return g_touchState.IndexTrigger[controller];
				case 1:
					return g_touchState.HandTrigger[controller];
				}
			}
		}
		return 0.0f;
	}

	// Retrieve the current thumbstick value
	// return     - -1 to 1 for thumbstick axis
	// controller - 0==left, 1==right
	// axis       - 0==X, 1==Y
	__declspec(dllexport) float getThumbStick(int controller, int axis)
	{
		if (g_HMD)
		{
			if (axis >= 0 && axis < 2 && controller >= 0 && controller < 2)
				switch (axis)
				{
				case 0:
					return g_touchState.Thumbstick[controller].x;
				case 1:
					return g_touchState.Thumbstick[controller].y;
				}
		}
		return 0;
	}

	__declspec(dllexport) unsigned int getButtonsDown()
	{
		if (g_HMD)
		{
			return g_touchState.Buttons;
		}
		return 0;
	}

	__declspec(dllexport) unsigned int getButtonsPressed()
	{
		if (g_HMD)
		{
			return g_touchState.Buttons & ~g_touchStateLast.Buttons;
		}
		return 0;
	}

	__declspec(dllexport) unsigned int getButtonsReleased()
	{
		if (g_HMD)
		{
			unsigned int value = ~g_touchState.Buttons & g_touchStateLast.Buttons;
			if(g_touchState.Buttons)
				int dummy = 0;
			if (g_touchStateLast.Buttons>0)
			{
				int dummy = 0;
			}
			return ~g_touchState.Buttons & g_touchStateLast.Buttons;
		}
		return 0;
	}

	__declspec(dllexport) unsigned int getTouchDown()
	{
		if (g_HMD)
		{
			return g_touchState.Touches;
		}
		return 0;
	}

	__declspec(dllexport) unsigned int getTouchPressed()
	{
		if (g_HMD)
		{
			return g_touchState.Touches & ~g_touchStateLast.Touches;
		}
		return 0;
	}

	__declspec(dllexport) unsigned int getTouchReleased()
	{
		if (g_HMD)
		{
			return ~g_touchState.Touches & g_touchStateLast.Touches;
		}
		return 0;
	}

	__declspec(dllexport) float getYaw(unsigned int controller)
	{
		if (g_HMD)
		{
			OVR::Quatf q = g_trackingState.HandPoses[controller].ThePose.Orientation;
			float yaw, pitch, roll;
			q.GetYawPitchRoll(&yaw, &pitch, &roll);
			yaw -= g_identityAngle[controller];
			yaw = fmod(yaw + 3.14159265, 3.14159265*2.0) - 3.14159265;
			return -yaw * (180.0 / 3.14159265);
		}
		return 0;
	}

	__declspec(dllexport) float getPitch(unsigned int controller)
	{
		if (g_HMD)
		{
			OVR::Quatf q = g_trackingState.HandPoses[controller].ThePose.Orientation;
			float yaw, pitch, roll;
			q.GetYawPitchRoll(&yaw, &pitch, &roll);
			return pitch * (180.0 / 3.14159265);
		}
		return 0;
	}

	__declspec(dllexport) float getRoll(unsigned int controller)
	{
		if (g_HMD)
		{
			OVR::Quatf q = g_trackingState.HandPoses[controller].ThePose.Orientation;
			float yaw, pitch, roll;
			q.GetYawPitchRoll(&yaw, &pitch, &roll);
			return -roll * (180.0/3.14159265);
		}
		return 0;
	}

	__declspec(dllexport) void resetFacing(unsigned int controller)
	{
		if (!g_HMD || controller > 1)
			return;

		OVR::Quatf q = g_trackingState.HandPoses[controller].ThePose.Orientation;
		float pitch, roll;
		q.GetYawPitchRoll(&g_identityAngle[controller], &pitch, &roll);

		//g_origin = g_trackingState.HandPoses[controller].ThePose.Position;
		//float x = g_trackingState.HandPoses[controller].ThePose.Orientation.x;
		//float y = g_trackingState.HandPoses[controller].ThePose.Orientation.y;
		//float z = g_trackingState.HandPoses[controller].ThePose.Orientation.z;
		//float w = g_trackingState.HandPoses[controller].ThePose.Orientation.w;
		//g_xAxis.x = 1.0f - (2*y*y + 2*z*z);
		//g_xAxis.y = 2*x*y - 2*w*z;
		//g_xAxis.z = 2 * x*z + 2 * w*y;
		//g_yAxis.x = 2 * x*y + 2 * w*z;
		//g_yAxis.y = 1.0f - (2 * x*x + 2 * z*z);
		//g_yAxis.z = 2 * y*z - 2 * w*x;
		//g_zAxis.x = 2 * x*z - 2 * w*y;
		//g_zAxis.y = 2 * y*z + 2 * w*x;
		//g_zAxis.z = 1.0f - (2 * x*x + 2 * y*y);
	}
}

BOOL APIENTRY DllMain(HMODULE hModule,	DWORD  ul_reason_for_call,	LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	{
		break;
	}
	case DLL_THREAD_ATTACH:
		break;
	case DLL_THREAD_DETACH:
		break;
	case DLL_PROCESS_DETACH:
		if (g_HMD)
		{
			if (g_vjoy > -1)
			{
				RelinquishVJD(g_vjoy);
				g_vjoy = -1;
			}
			ovr_Destroy(g_HMD);
		}
		ovr_Shutdown();
		break;
	}
	return TRUE;
}
