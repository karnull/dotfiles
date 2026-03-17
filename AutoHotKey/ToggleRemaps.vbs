Option Explicit

' --- CONFIG ---
Dim ahkExe, ahkScript
ahkExe    = "C:\Users\karanjan\AppData\Local\Programs\AutoHotkey\UX\AutoHotkeyUX.exe"
ahkScript = "\\wsl.localhost\Debian\home\karsh\.config\dotfiles\AutoHotKey\remaps.ahk"

Dim shell: Set shell = CreateObject("WScript.Shell")

' --- Detect if AutoHotkeyUX.exe is running ---
Dim isRunning: isRunning = False
Dim svc: Set svc = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process")
Dim p

For Each p In svc
    If LCase(p.Name) = "autohotkeyux.exe" Then
        isRunning = True
        Exit For
    End If
Next

' --- Toggle ---
If Not isRunning Then
    ' Turn ON
    shell.Run """" & ahkExe & """ """ & ahkScript & """", 0, False   ' 0 = hidden, no window
Else
    ' Turn OFF
    For Each p In svc
        If LCase(p.Name) = "autohotkeyux.exe" Then
            On Error Resume Next
            p.Terminate()
            On Error GoTo 0
        End If
    Next
End If
