
// RotateDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Rotate.h"
#include "RotateDlg.h"
#include <math.h>

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CRotateDlg dialog




CRotateDlg::CRotateDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CRotateDlg::IDD, pParent)
	, m_x(5.0)
	, m_y(0.0)
	, m_theta(90.0)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CRotateDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Text(pDX, IDC_EDIT_X, m_x);
	DDX_Text(pDX, IDC_EDIT_Y, m_y);
	DDX_Text(pDX, IDC_EDIT_THETA, m_theta);
}

BEGIN_MESSAGE_MAP(CRotateDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON1, &CRotateDlg::OnBnClickedButton1)
END_MESSAGE_MAP()


// CRotateDlg message handlers

BOOL CRotateDlg::OnInitDialog()
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

void CRotateDlg::OnPaint()
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
HCURSOR CRotateDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

#define PI 3.1415927

void multiply(double** m, double* v1, double* v2)
{
  for (int y = 0; y < 3; ++y)
  {
	double value = 0;

	for (int x = 0; x < 3; ++x)
    {
		value += m[y][x] * v1[x];
	}

	v2[y] = value;
  }
}

void CRotateDlg::OnBnClickedButton1()
{
	UpdateData(TRUE);

	double radians = m_theta * 2.0 * PI / 360.0;

	double m1[] = {cos(radians), -sin(radians), 0};
	double m2[] = {sin(radians),  cos(radians), 0};
	double m3[] = {           0,             0, 1};

	double* m[] = {m1, m2, m3};
	double  v[] = {m_x, m_y, 1};
	double  vPrime[3];

	multiply((double**)m, (double*)v, (double*)vPrime);

	CString sXprime, sYprime;
	sXprime.Format(L"%f", vPrime[0]);
	sYprime.Format(L"%f", vPrime[1]);

	GetDlgItem(IDC_EDIT_X_PRIME)->SetWindowText(sXprime);
	GetDlgItem(IDC_EDIT_Y_PRIME)->SetWindowText(sYprime);
}
