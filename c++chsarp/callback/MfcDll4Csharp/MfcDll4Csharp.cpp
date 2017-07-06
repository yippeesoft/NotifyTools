// MfcDll4Csharp.cpp : Defines the initialization routines for the DLL.
//

#include "stdafx.h"
#include "MfcDll4Csharp.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

//
//TODO: If this DLL is dynamically linked against the MFC DLLs,
//		any functions exported from this DLL which call into
//		MFC must have the AFX_MANAGE_STATE macro added at the
//		very beginning of the function.
//
//		For example:
//
//		extern "C" BOOL PASCAL EXPORT ExportedFunction()
//		{
//			AFX_MANAGE_STATE(AfxGetStaticModuleState());
//			// normal function body here
//		}
//
//		It is very important that this macro appear in each
//		function, prior to any calls into MFC.  This means that
//		it must appear as the first statement within the 
//		function, even before any object variable declarations
//		as their constructors may generate calls into the MFC
//		DLL.
//
//		Please see MFC Technical Notes 33 and 58 for additional
//		details.
//

// CMfcDll4CsharpApp

BEGIN_MESSAGE_MAP(CMfcDll4CsharpApp, CWinApp)
END_MESSAGE_MAP()


// CMfcDll4CsharpApp construction

CMfcDll4CsharpApp::CMfcDll4CsharpApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CMfcDll4CsharpApp object

CMfcDll4CsharpApp theApp;


// CMfcDll4CsharpApp initialization

BOOL CMfcDll4CsharpApp::InitInstance()
{
	CWinApp::InitInstance();

	return TRUE;
}

//声明

typedef int (CALLBACK *MatrixReceive)( int nBufSize);

MatrixReceive m_RecInfoCall;  //回复信息的回调函数


extern "C" int PASCAL EXPORT ExportedFunction(int a,int b, MatrixReceive m)
{
	AFX_MANAGE_STATE(AfxGetStaticModuleState());
	int dd = a + b;
	return m(dd);
}