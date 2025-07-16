#Persistent
#InstallKeybdHook
SetTitleMatchMode, 2

inputBuffer := ""

SetTimer, CheckInput, 100
return

CheckInput:
InputKey := GetKeyState("Shift") ? GetKeyState("CapsLock", "T") ? "" : "" : ""
Loop, 1 {
    Input, key, L1 V, {Enter}{Backspace}{Space}
    if (ErrorLevel = "EndKey:Enter") {
        if (InStr(inputBuffer, "start")) {
            inputBuffer := "" ; Clear after trigger
            Gosub, RunATCommands
        } else {
            inputBuffer := "" ; Clear on Enter anyway
        }
    } else if (ErrorLevel = "EndKey:Backspace") {
        StringTrimRight, inputBuffer, inputBuffer, 1
    } else {
        inputBuffer .= key
    }
}
return

RunATCommands:
; Make sure emulator is active
WinActivate, AT.bat
Sleep, 500

Send AT{Enter}                 ; Basic attention command
Sleep 1000
Send ATI{Enter}
Sleep 1000
Send AT{+}GMI{Enter}             ; Get Manufacturer ID
Sleep 1000
Send AT{+}GMM{Enter}             ; Get Model
Sleep 1000
Send AT{+}GMR{Enter}             ; Get Revision
Sleep 1000
Send AT{+}CREG?{Enter}           ; Check network registration
Sleep 1000
Send AT{+}CGATT?{Enter}          ; GPRS attach status
Sleep 1000
Send AT{+}CSQ{Enter}
Sleep 1000
Send AT{+}CPIN?{Enter}       ; Check SIM card status
Sleep 1000
Send AT{+}COPS?{Enter}       ; Query the current network operator
Sleep 1000
Send AT{+}CMGF=1{Enter}      ; Set SMS mode to Text
Sleep 1000
Send AT{+}CMGS="9876543210"{Enter} ; Send SMS to number
Sleep 1500
Send This is AutoHotkey test message
Sleep 1000
Send ^z                   ; Ctrl+Z to send SMS
Sleep 2000
Send AT{+}CMGR=1{Enter}      ; Read message at index 1
Send AT+CMEE=2{Enter}          ; Enable verbose error
Sleep 1000
Send AT+XYZTEST{Enter}         ; Invalid command to trigger error
Sleep 1000
return