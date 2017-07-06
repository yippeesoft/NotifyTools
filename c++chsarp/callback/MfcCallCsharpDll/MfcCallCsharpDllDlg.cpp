
// MfcCallCsharpDllDlg.cpp : implementation file
//

#include "stdafx.h"
#include "MfcCallCsharpDll.h"
#include "MfcCallCsharpDllDlg.h"
#include "afxdialogex.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CMfcCallCsharpDllDlg dialog
#import "CsharpDll4Mfc.tlb"  named_guids
ATL::CComModule _Module;
using namespace CsharpDll4Mfc;
 //http://blog.csdn.net/xxdddail/article/details/17305467?utm_source=jiancool

class EventReceiver :
	public IDispEventImpl<0,
	EventReceiver,
	&(__uuidof(CsharpDll4Mfc::IEvent)),
	&(__uuidof(CsharpDll4Mfc::__CsharpDll4Mfc)), 1, 0>
{
public:
	STDMETHOD(DrawEventResponse)(int count);

	BEGIN_SINK_MAP(EventReceiver)
		SINK_ENTRY_EX(0, (__uuidof(CsharpDll4Mfc::IEvent)), 20, DrawEventResponse)
	END_SINK_MAP()
};

STDMETHODIMP EventReceiver::DrawEventResponse(int count)
{
	TRACE("Event Reponse : %d\n", count);
	return S_OK;
}



CMfcCallCsharpDllDlg::CMfcCallCsharpDllDlg(CWnd* pParent /*=NULL*/)
	: CDialogEx(IDD_MFCCALLCSHARPDLL_DIALOG, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CMfcCallCsharpDllDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CMfcCallCsharpDllDlg, CDialogEx)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDOK, &CMfcCallCsharpDllDlg::OnBnClickedOk)
END_MESSAGE_MAP()


// CMfcCallCsharpDllDlg message handlers

BOOL CMfcCallCsharpDllDlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CMfcCallCsharpDllDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CMfcCallCsharpDllDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

extern "C" int PASCAL EXPORT CallBack(int dd)
{
	TRACE("C%d\r\n", dd);
	return dd + 9;
}

void CMfcCallCsharpDllDlg::OnBnClickedOk()
{
	// TODO: Add your control notification handler code here
	_Module.Init(NULL, (HINSTANCE)GetModuleHandle(NULL));
	HRESULT hr = CoInitialize (NULL);
	if (hr != S_OK)
		printf("hr failed\n");
	else
		printf("hr ok\n");

	CsharpDll4Mfc::ICalculatorPtr ic(__uuidof(CsharpDll4Mfc::Class1));
	CsharpDll4Mfc::ICalculator *icc = ic;

	EventReceiver * pReceiver = new EventReceiver; //Detected memory leaks!
	
	HRESULT hresult = pReceiver->DispEventAdvise(ic);

	int kk=icc->Add(111, 9);
	TRACE("A%d\r\n", kk);
	kk = icc->testCallBack(kk, (long)CallBack);
	TRACE("B%d\r\n", kk);

	
	pReceiver->DispEventUnadvise(ic);
	
	_Module.Term();
	CoUninitialize();
	pReceiver->Release();
	icc->Release();
	ic.Release();
 
	//CDialogEx::OnOK();
}
