
// MfcCallCsharpDllDlg.h : header file
//

#pragma once


// CMfcCallCsharpDllDlg dialog
class CMfcCallCsharpDllDlg : public CDialogEx
{
// Construction
public:
	CMfcCallCsharpDllDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_MFCCALLCSHARPDLL_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
};
