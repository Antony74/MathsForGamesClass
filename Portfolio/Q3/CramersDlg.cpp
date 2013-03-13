
// CramersDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Cramers.h"
#include "CramersDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CCramersDlg dialog




CCramersDlg::CCramersDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CCramersDlg::IDD, pParent)
	, m_a(2.0), m_b(3.0), m_e(10.0)
	, m_c(3.0), m_d(5.0), m_f(16.0)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CCramersDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_A, m_a);
	DDX_Text(pDX, IDC_EDIT_B, m_b);
	DDX_Text(pDX, IDC_EDIT_C, m_c);
	DDX_Text(pDX, IDC_EDIT_D, m_d);
	DDX_Text(pDX, IDC_EDIT_E, m_e);
	DDX_Text(pDX, IDC_EDIT_F, m_f);
}

BEGIN_MESSAGE_MAP(CCramersDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_SOLVE, &CCramersDlg::OnBnClickedButtonSolve)
END_MESSAGE_MAP()


// CCramersDlg message handlers

BOOL CCramersDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

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

void CCramersDlg::OnPaint()
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
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CCramersDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

float determinant(float a, float b,
				  float c, float d)
{
	return (a*d) - (b*c);
}

void CCramersDlg::OnBnClickedButtonSolve()
{
	UpdateData(TRUE);

	float denominator = determinant(m_a, m_b,
		                            m_c, m_d);

	if (denominator == 0.0)
	{
		GetDlgItem(IDC_EDIT_X)->SetWindowText(_T(""));
		GetDlgItem(IDC_EDIT_Y)->SetWindowText(_T(""));
		AfxMessageBox(_T("Can't solve - lines are parallel or the same"));
		return;
	}

	float x = determinant(m_e, m_b,
		                  m_f, m_d);

	float y = determinant(m_a, m_e,
		                  m_c, m_f);

	x /= denominator;
	y /= denominator;

	CString sX, sY;
	sX.Format(L"%f", x);
	sY.Format(L"%f", y);

	GetDlgItem(IDC_EDIT_X)->SetWindowText(sX);
	GetDlgItem(IDC_EDIT_Y)->SetWindowText(sY);
}
