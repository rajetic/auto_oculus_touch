///////////////////////////////////////////////////////////////////////////////
// AutoTouch - Helper library to provide AutoHotKey with Oculus Touch state.
// Copyright (C) 2017 Kojack (rajetic@gmail.com)
//
// AutoTouch is released under the MIT License  
// https://opensource.org/licenses/MIT
///////////////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "OVR_CAPI.h"

ovrSession g_HMD = 0;
ovrInputState g_touchStateLast;
ovrInputState g_touchState;

#pragma comment(lib,"LibOVR")

extern "C"
{
	__declspec(dllexport) int initOculus()
	{
		memset(&g_touchState, 0, sizeof(ovrInputState));
		memset(&g_touchStateLast, 0, sizeof(ovrInputState));

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

	__declspec(dllexport) void poll()
	{
		if (g_HMD)
		{
			g_touchStateLast = g_touchState;
			ovr_GetInputState(g_HMD, ovrControllerType_Active , &g_touchState);
		}
	}
	
	__declspec(dllexport) void setVibration(unsigned int controller, float frequency, float amplitude)
	{
		if (g_HMD)
		{
			ovr_SetControllerVibration(g_HMD, (ovrControllerType)controller, frequency, amplitude);
		}
	}

	__declspec(dllexport) float getTrigger(int controller, int trigger)
	{
		if (g_HMD)
		{
			if(trigger>=0 && trigger<2 && controller>=0 && controller<2)
			switch (trigger)
			{
			case 0:
				return g_touchState.IndexTrigger[controller];
			case 1:
				return g_touchState.HandTrigger[controller];
			}
		}
		return 0.0f;
	}

	__declspec(dllexport) float getThumbStick(int controller, int axis)
	{
		if (g_HMD)
		{
			if (axis >= 0 && axis<2 && controller >= 0 && controller<2)
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

	__declspec(dllexport) float getButtonsDown()
	{
		if (g_HMD)
		{
			return g_touchState.Buttons;
		}
		return 0;
	}

	__declspec(dllexport) float getButtonsPressed()
	{
		if (g_HMD)
		{
			return g_touchState.Buttons & ~g_touchStateLast.Buttons;
		}
		return 0;
	}

	__declspec(dllexport) float getButtonsReleased()
	{
		if (g_HMD)
		{
			return ~g_touchState.Buttons & g_touchStateLast.Buttons;
		}
		return 0;
	}

	__declspec(dllexport) float getTouchDown()
	{
		if (g_HMD)
		{
			return g_touchState.Touches;
		}
		return 0;
	}

	__declspec(dllexport) float getTouchPressed()
	{
		if (g_HMD)
		{
			return g_touchState.Touches & ~g_touchStateLast.Touches;
		}
		return 0;
	}

	__declspec(dllexport) float getTouchReleased()
	{
		if (g_HMD)
		{
			return ~g_touchState.Touches & g_touchStateLast.Touches;
		}
		return 0;
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
			ovr_Destroy(g_HMD);
		}
		ovr_Shutdown();
		break;
	}
	return TRUE;
}
