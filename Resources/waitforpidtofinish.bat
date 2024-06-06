Option Explicit
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' File:     vbsWaitForProcess.vbs
' Updated:  Nov 2002
' Version:  1.0
' Author:   Dan Thomson, myITforum.com columnist
'           I can be contacted at dethomson@hotmail.com
'
' Usage:    The command processor version must be run using cscript
'           cscript vbsWaitForProcess.vbs notepad.exe 60 S
'           or
'           The IE and Popup versions can be run with cscript or wscript
'           wscript vbsWaitForProcess.vbs notepad.exe -1
'
' Input:    Name of executable  (ex: notepad.exe)
'           Time to wait in seconds before terminating the executable
'               -1 waits indefinitely for the process to finish
'               0 terminates the process imediately
'               Any value > 0 will cause the script to wait the specified
'               amount of time in seconds before terminating the process
'           Silent mode  (S)
'
' Notes:
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

On Error Resume Next

'Define some variables
Dim strProcess
Dim intWaitTime
Dim strSilent

'Get the command line arguments
strProcess = Wscript.Arguments.Item(0)
intWaitTime = CInt(Wscript.Arguments.Item(1))
strSilent = Wscript.Arguments.Item(2)

Call WaitForProcess (strProcess, intWaitTime, strSilent)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Function: ProcessIsRunningById
'
' Purpose:  Determine if a process is running
'
' Input:    Name of process
'
' Output:   True or False depending on if the process is running
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function ProcessIsRunningById( processId )
    Dim colProcessList

    Set colProcessList = Getobject("Winmgmts:").Execquery _
        ("Select * from Win32_Process Where ProcessId = " & processId)
    If colProcessList.Count > 0 Then
        ProcessIsRunningById = True
    Else
        ProcessIsRunningById = False
    End If

    Set colProcessList = Nothing
End Function


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Function: ProcessIsRunningByName
'
' Purpose:  Determine if a process is running
'
' Input:    Name of process
'
' Output:   True or False depending on if the process is running
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function ProcessIsRunningByName( processName )
    Dim colProcessList

    Set colProcessList = Getobject("Winmgmts:").Execquery _
        ("Select * from Win32_Process Where Name = '" & processName & "'")
    If colProcessList.Count > 0 Then
        ProcessIsRunningByName = True
    Else
        ProcessIsRunningByName = False
    End If

    Set colProcessList = Nothing
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Function: TerminateProcess
'
' Purpose:  Terminates a process
'
' Input:      Name of process
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Function ProcessTerminate( strProcess )
    Dim colProcessList, objProcess

    Set colProcessList = GetObject("Winmgmts:").ExecQuery _
        ("Select * from Win32_Process Where Name ='" & strProcess & "'")
    For Each objProcess in colProcessList
        objProcess.Terminate( )
    Next

    Set colProcessList = Nothing
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Sub: WaitForProcessByName
'
' Purpose:  Waits for a process
'
' Input:    Name of process
'           Wait time in seconds before termination.
'             -1 will cause the script to wait indefinitely
'             0 terminates the process imediately
'             Any value > 0 will cause the script to wait the specified
'             amount of time in seconds before terminating the process
'           Display mode.
'             Passing S will run the script silent and not show any prompts
'
' Output:   On screen status
'
' Notes:    The version echos user messages in the command window via StdOut
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub WaitForProcessByName( strProcess, intWaitTime, strMode )

  If ProcessIsRunningByName(strProcess) Then
    Dim StdOut
    Dim w : w = 0
    Dim strPrompt
    Dim intPause : intPause = 1

    If UCase(strMode) <> "S" Then
      strPrompt = "Waiting for " & strProcess & " to finish."
      Set StdOut = WScript.StdOut
      StdOut.WriteLine ""
      StdOut.Write strPrompt
    End If
    'Loop while the process is running
    Do While ProcessIsRunningByName(strProcess)
      'Check to see if specified # of seconds have passed before terminating
      'the process. If yes, then terminate the process
      If w >= intWaitTime AND intWaitTime >= 0 Then
        Call ProcessTerminate(strProcess)
        Exit Do
      End If
      'If not running silent, post user messages
      If UCase(strMode) <> "S" Then _
        StdOut.Write "."
      'Increment the seconds counter
      w = w + intPause
      'Pause
      Wscript.Sleep(intPause * 1000)
    Loop
    If UCase(strMode) <> "S" Then
      StdOut.WriteLine ""
      Set StdOut = Nothing
    End If
  End If
End Sub


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
' Sub: WaitForProcessById
'
' Purpose:  Waits for a process
'
' Input:    Name of process
'           Wait time in seconds before termination.
'             -1 will cause the script to wait indefinitely
'             0 terminates the process imediately
'             Any value > 0 will cause the script to wait the specified
'             amount of time in seconds before terminating the process
'           Display mode.
'             Passing S will run the script silent and not show any prompts
'
' Output:   On screen status
'
' Notes:    The version echos user messages in the command window via StdOut
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Private Sub WaitForProcessById( processId, intWaitTime, strMode )

  If ProcessIsRunningById(processId) Then
    Dim StdOut
    Dim w : w = 0
    Dim strPrompt
    Dim intPause : intPause = 1

    If UCase(strMode) <> "S" Then
      strPrompt = "Waiting for " & strProcess & " to finish."
      Set StdOut = WScript.StdOut
      StdOut.WriteLine ""
      StdOut.Write strPrompt
    End If
    'Loop while the process is running
    Do While ProcessIsRunningById(processId)
      'Check to see if specified # of seconds have passed before terminating
      'the process. If yes, then terminate the process
      If w >= intWaitTime AND intWaitTime >= 0 Then
        Call ProcessTerminate(strProcess)
        Exit Do
      End If
      'If not running silent, post user messages
      If UCase(strMode) <> "S" Then _
        StdOut.Write "."
      'Increment the seconds counter
      w = w + intPause
      'Pause
      Wscript.Sleep(intPause * 1000)
    Loop
    If UCase(strMode) <> "S" Then
      StdOut.WriteLine ""
      Set StdOut = Nothing
    End If
  End If
End Sub


const WaitUntilFinished = true, DontWaitUntilFinished = false, ShowWindow = 1, DontShowWindow = 0	
set oShell = WScript.CreateObject("WScript.Shell")
oShell.run """C:\Program Files\Microsoft Office\Office14\EXCEL.EXE"" " & File, DontShowWindow, WaitUntilFinished