VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "���ʽ����"
   ClientHeight    =   3195
   ClientLeft      =   5700
   ClientTop       =   2265
   ClientWidth     =   5475
   LinkTopic       =   "Form1"
   ScaleHeight     =   3195
   ScaleWidth      =   5475
   Begin VB.CommandButton Command2 
      Caption         =   "����"
      Height          =   300
      Left            =   4680
      TabIndex        =   2
      Top             =   120
      Width           =   735
   End
   Begin VB.TextBox Text3 
      Height          =   2055
      Left            =   3600
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   8
      Top             =   1080
      Width           =   975
   End
   Begin VB.TextBox Text2 
      Height          =   2415
      Left            =   2520
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   4
      Top             =   720
      Width           =   975
   End
   Begin VB.TextBox Text1 
      Height          =   2415
      Left            =   600
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   3
      Top             =   720
      Width           =   1215
   End
   Begin VB.TextBox SourceText 
      Height          =   270
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3615
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Calc"
      Height          =   300
      Left            =   3840
      TabIndex        =   1
      Top             =   120
      Width           =   735
   End
   Begin VB.Label Label3 
      Caption         =   "���Ϊ"
      Height          =   255
      Left            =   3720
      TabIndex        =   7
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label2 
      Caption         =   "����ջ"
      Height          =   255
      Left            =   1920
      TabIndex        =   6
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label1 
      Caption         =   "������"
      Height          =   255
      Left            =   0
      TabIndex        =   5
      Top             =   720
      Width           =   615
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'˵����
'���������GNU����Դ����Э��
'
'�������������ƣ�������������ͨ��GNUЭ��
'Υ�����Ա��ı�Ϊ��
'
'Designed By Sun Rui������
'E-mail:sunruiyeyipeng@163.com
'�人����ѧ������Ϣ����רҵ
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)  '����

Private Sub Command1_Click()
    Dim sTxt As String
    Dim strNumFix As String
    Dim curChar As String
    Dim i As Long
    Dim signCount As Long
    Dim ops1 As String, ops2 As String, opC As String
    '����գ�
    Text3.Text = ""
    '��ʼ����ջ
        opNum.Clear
        opChar.Clear
        Call UpdateShow
    '��ջ��ʼ������
    sTxt = SourceText.Text
    For i = 1 To Len(sTxt)
        curChar = Mid(sTxt, i, 1)
        If IsSymbol(curChar) = True Then
            '��������Ԥ������û��
            If strNumFix <> "" Then
                opNum.Push strNumFix
                Call UpdateShow
                strNumFix = ""
            End If
redo:
            If IsHigh(curChar, opChar.Peek) = 1 Then 'if new come char is higher then push it to stack
                opChar.Push curChar '����ȼ��ߵĿ��Ʒ��������
                signCount = signCount + 1
                Call UpdateShow
            ElseIf IsHigh(curChar, opChar.Peek) = 0 Then
                'Debug.Print "����ǣ�" & opNum.Pop
                'Exit Sub
                If curChar = "#" And opChar.Peek = "#" Then
                    opChar.Pop
                    Call UpdateShow
                    Text3.Text = "�������ǣ�" & opNum.Pop
                    Call UpdateShow
                    Exit Sub
                End If
            ElseIf IsHigh(curChar, opChar.Peek) = -1 Then 'if low then ready to calculate
                '�ж��ǲ��ǵ�һ������
                If signCount = 1 Then '��������Ǹո�����#����Ǹ������������ջ
                    opChar.Push curChar
                    signCount = signCount + 1
                    GoTo nextone
                End If
                ops2 = opNum.Pop
                Call UpdateShow
                ops1 = opNum.Pop
                Call UpdateShow
                opC = opChar.Pop
                Call UpdateShow
                opNum.Push CStr(Calc(ops1, ops2, opC))
                Call UpdateShow
                If curChar = ")" And opChar.Peek = "(" Then
                    opChar.Pop  '����������ǣ����Ͱѣ�������
                    Call UpdateShow
                    GoTo moveon
                End If
                GoTo redo
moveon:
            End If
        Else '�Ƿ���
            strNumFix = strNumFix & curChar
        End If
nextone:
    Next i
End Sub

Private Sub Command2_Click()
Text3.Text = CalcString(SourceText.Text)
End Sub

Private Sub Form_Load()
Me.Show
opNum.Clear
opChar.Clear
End Sub

Sub Delay(ByVal msec As Long) '������msecΪ������
DoEvents
Sleep msec
End Sub
Sub UpdateShow()
    DoEvents
    Text1.Text = opChar.ViewStack
    DoEvents
    Text2.Text = opNum.ViewStack
    DoEvents
    Call Delay(500)
End Sub
