
// CramersDlg.h : header file
//

#pragma once


// CCramersDlg dialog
class CCramersDlg : public CDialog
{
// Construction
public:
	CCramersDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_CRAMERS_DIALOG };

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
	float m_a, m_b, m_e;
	float m_c, m_d, m_f;
	afx_msg void OnBnClickedButtonSolve();
};
