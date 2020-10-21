// MfcDll4Csharp.h : main header file for the MfcDll4Csharp DLL
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CMfcDll4CsharpApp
// See MfcDll4Csharp.cpp for the implementation of this class
//

class CMfcDll4CsharpApp : public CWinApp
{
public:
	CMfcDll4CsharpApp();

// Overrides
public:
	virtual BOOL InitInstance();

	DECLARE_MESSAGE_MAP()
};
