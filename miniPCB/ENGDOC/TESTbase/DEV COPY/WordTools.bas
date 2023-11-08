Attribute VB_Name = "WordTools"
'Nolan Manteufel
'July 2020

'Used to access Content Controls
Private Const customer As String = "customer"
Private Const contact As String = "contact"
Private Const address As String = "address"
Private Const datereceived As String = "dateReceived"
Private Const device As String = "device"
Private Const complaint As String = "complaint"
Private Const caption As String = "caption"
Private Const followup As String = "followup"
Private Const codes As String = "codes"
Private Const stamp As String = "stamp"
Private Const datetimestamp As String = "datetimestamp"

Private Const PLACEHOLDER_TEXT As String = "N/A"

Private Const DATA_ARRAY_WIDTH = 2
Private Const DATA_ARRAY_LENGTH = 17

'Module level variables
Dim myDoc As Document
Dim lockState As Boolean
Dim cc As ContentControl
Dim CCs As ContentControls
Dim ccIndex As Long
Dim FFs As FormFields
Dim ff As FormField

Sub enable_Application()

'Reset button enables
ActiveDocument.saveButton.Enabled = True
ActiveDocument.saveAndCloseButton.Enabled = True
ActiveDocument.closeWithoutSavingButton.Enabled = True
ActiveDocument.deleteButton.Enabled = True

'Enable screen updating
Application.ScreenUpdating = True
End Sub

Sub move_CC_Text_to_Table_In_New_Document()

Set myDoc = ActiveDocument
Set CCs = myDoc.ContentControls

Dim dataArray(DATA_ARRAY_WIDTH, DATA_ARRAY_LENGTH) As String
ccIndex = 0

'Fill data array
For Each cc In CCs
    dataArray(0, ccIndex) = ccIndex
    dataArray(1, ccIndex) = cc.Tag
    dataArray(2, ccIndex) = cc.Range.Text
    ccIndex = ccIndex + 1
Next cc

'Create new document
Dim newDoc As Document
Set newDoc = Documents.Add

'Insert table
Dim newTable As Table
Set newTable = newDoc.Tables.Add(Range:=Selection.Range, _
NumRows:=DATA_ARRAY_LENGTH + 1, _
NumColumns:=DATA_ARRAY_WIDTH + 1)

Dim colIndex As Integer
Dim rowIndex As Integer

'Populate table with data array
With newTable
    For rowIndex = 0 To DATA_ARRAY_LENGTH
        For colIndex = 0 To DATA_ARRAY_WIDTH
            .Cell(rowIndex + 1, colIndex + 1).Range.InsertAfter dataArray(colIndex, rowIndex)
        Next colIndex
    Next rowIndex
    .Columns.AutoFit
End With
End Sub

Sub set_CC_Text_Per_Tag_Index()

Set myDoc = ActiveDocument

myDoc.SelectContentControlsByTag(customer)(1).Range.Text = "1"
myDoc.SelectContentControlsByTag(customer)(2).Range.Text = "2"
myDoc.SelectContentControlsByTag(customer)(3).Range.Text = "3"

myDoc.SelectContentControlsByTag(contact)(1).Range.Text = "1"
myDoc.SelectContentControlsByTag(contact)(2).Range.Text = "2"
myDoc.SelectContentControlsByTag(contact)(3).Range.Text = "3"
myDoc.SelectContentControlsByTag(contact)(4).Range.Text = "4"

myDoc.SelectContentControlsByTag(address)(1).Range.Text = "1"
myDoc.SelectContentControlsByTag(address)(2).Range.Text = "2"
myDoc.SelectContentControlsByTag(address)(3).Range.Text = "3"
myDoc.SelectContentControlsByTag(address)(4).Range.Text = "4"
myDoc.SelectContentControlsByTag(address)(5).Range.Text = "5"

myDoc.SelectContentControlsByTag(device)(1).Range.Text = "1"
myDoc.SelectContentControlsByTag(device)(2).Range.Text = "2"

myDoc.SelectContentControlsByTag(caption)(1).Range.Text = "1"
myDoc.SelectContentControlsByTag(caption)(2).Range.Text = "2"
myDoc.SelectContentControlsByTag(caption)(3).Range.Text = "3"
myDoc.SelectContentControlsByTag(caption)(4).Range.Text = "4"

myDoc.SelectContentControlsByTag(codes)(1).Range.Text = "1"
myDoc.SelectContentControlsByTag(codes)(2).Range.Text = "2"
myDoc.SelectContentControlsByTag(codes)(3).Range.Text = "3"

End Sub

Sub clear_CC_Title()
For Each cc In ActiveDocument.ContentControls
    cc.Title = ""
Next cc
End Sub

Sub clear_CC_Tag()
For Each cc In ActiveDocument.ContentControls
    cc.Tag = ""
Next cc
End Sub


Sub set_CC_Text_Per_CC_Order()
ccIndex = 0

For Each cc In ActiveDocument.ContentControls
    ccIndex = ccIndex + 1
    If (cc.Type = wdContentControlText) Then
    lockState = cc.LockContents
    cc.LockContents = False
    cc.Range.Text = "CC Index/Order: " & ccIndex
    cc.LockContents = lockState
    End If
Next cc
End Sub

Sub set_CC_Text_Per_CC_Index()
Set CCs = ActiveDocument.ContentControls

For ccIndex = 1 To CCs.Count
    Set cc = CCs(ccIndex)
    If (cc.Type = wdContentControlText) Then
        cc.LockContents = False
        cc.Range.Text = "CC Index: " & ccIndex
    End If
Next
End Sub



Sub set_CC_Placeholder_AND_Clear_Text()
Set CCs = ActiveDocument.ContentControls

For Each cc In myDoc.ContentControls
    ccIndex = ccIndex + 1
    If (cc.Type = wdContentControlText) Then
    lockState = cc.LockContents
    cc.LockContents = False
    cc.SetPlaceholderText Text:="Click here to enter text."
    cc.Range.Text = ""
    cc.LockContents = lockState
    End If
Next cc
End Sub

Sub clear_CC_Text()
Set CCs = ActiveDocument.ContentControls

For Each cc In myDoc.ContentControls
    ccIndex = ccIndex + 1
    If (cc.Type = wdContentControlText) Then
    lockState = cc.LockContents
    cc.LockContents = False
    cc.Range.Text = ""
    cc.LockContents = lockState
    End If
Next cc
End Sub

Sub directory()
MsgBox (ActiveDocument.Path)
End Sub

Sub filename()
MsgBox (ActiveDocument.name)
End Sub

Sub fullfilename()
MsgBox (ActiveDocument.FullName)
End Sub

Sub resetForm()
Set FFs = ActiveDocument.FormFields

'Reset the form to default values
For Each ff In FFs
ff.result = ff.TextInput.Default
Next

MsgBox ("Congratulations, your form has been reset to default values.")
End Sub

Sub clearForm()
Set FFs = ActiveDocument.FormFields

'Clear the form
For Each ff In FFs
ff.result = Clear
Next

MsgBox ("Congratulations, your form has been cleared.")
End Sub

Sub CC_COUNT()
MsgBox (ActiveDocument.ContentControls.Count)
End Sub

Sub DOC_COUNT()
MsgBox Application.Documents.Count
End Sub

'If (Application.Documents.Count = 0) Then
'ThisApplication.Quit
'End If

Sub END_APP()
Application.Quit
End Sub

Sub END_EXCEL_APP()
Excel.Application.Quit
End Sub

Sub deleteDoc()
Kill "Y:\ENG - Engineering Files\860\113 EKF VBA\996 LocalBase\Entries\NEW_20200724110812.doc"
End Sub
