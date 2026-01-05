; ============================================================================
; RSInfinity - Compatibility Check System
; ============================================================================
; This module detects Roblox version and anti-cheat status before installation
; to warn users about potential incompatibilities.
; ============================================================================

!include LogicLib.nsh
!include FileFunc.nsh
!include WinVer.nsh

; Compatibility status codes
!define COMPAT_OK 0
!define COMPAT_WARN_ANTICHEAT 1
!define COMPAT_WARN_VERSION 2
!define COMPAT_BLOCKED 3

; Known problematic versions (Byfron/Hyperion enabled)
; Update this list as new information becomes available
!define BYFRON_INDICATOR_FILE "RobloxPlayerBeta.dll"
!define HYPERION_INDICATOR "Windows.ApplicationModel.winmd"

Var CompatibilityStatus
Var CompatibilityMessage
Var RobloxVersionString
Var AnticheatDetected
Var RobloxChannel

; ============================================================================
; Main Compatibility Check Function
; ============================================================================
Function CheckCompatibility
    ; Initialize variables
    StrCpy $CompatibilityStatus ${COMPAT_OK}
    StrCpy $CompatibilityMessage ""
    StrCpy $AnticheatDetected "false"
    StrCpy $RobloxChannel "LIVE"
    
    ; Check if Roblox path is valid
    StrCmp $RobloxPath "" no_roblox
    
    ; Get Roblox version info
    Call GetRobloxVersionInfo
    
    ; Check for anti-cheat indicators
    Call DetectAnticheat
    
    ; Check Roblox channel (production vs beta)
    Call DetectRobloxChannel
    
    ; Evaluate overall compatibility
    Call EvaluateCompatibility
    
    ; Show results to user
    Call ShowCompatibilityResult
    Return
    
no_roblox:
    StrCpy $CompatibilityStatus ${COMPAT_BLOCKED}
    StrCpy $CompatibilityMessage "Roblox installation not found."
    Return
FunctionEnd

Function GetRobloxVersionInfo
    ReadRegStr $RobloxVersionString HKCU "${ROBLOXREGLOC}" "curPlayerVer"
    
    ${If} $RobloxVersionString == ""
        ; Try alternative registry location
        ReadRegStr $RobloxVersionString HKLM "SOFTWARE\Roblox" "Version"
    ${EndIf}
    
    ${If} $RobloxVersionString == ""
        ; get version from executable
        ${GetFileVersion} "$RobloxPath\RobloxPlayerBeta.exe" $RobloxVersionString
    ${EndIf}
    
    !insertmacro ToLog $LOGFILE "Compatibility" "Roblox version detected: $RobloxVersionString"
FunctionEnd

Function DetectAnticheat
    ; Method 1: Check for Byfron DLL
    ${If} ${FileExists} "$RobloxPath\${BYFRON_INDICATOR_FILE}"
        ${GetFileVersion} "$RobloxPath\${BYFRON_INDICATOR_FILE}" $0
        StrCmp $0 "" no_byfron_version
        StrCpy $AnticheatDetected "true"
        !insertmacro ToLog $LOGFILE "Compatibility" "Byfron indicator found: ${BYFRON_INDICATOR_FILE} v$0"
    no_byfron_version:
    ${EndIf}
    
    ; Method 2: Check for Hyperion-related files
    ${If} ${FileExists} "$RobloxPath\${HYPERION_INDICATOR}"
        StrCpy $AnticheatDetected "true"
        !insertmacro ToLog $LOGFILE "Compatibility" "Hyperion indicator found: ${HYPERION_INDICATOR}"
    ${EndIf}
    
    ; Method 3: Check for RobloxPlayerBeta.dll size (Byfron versions are larger)
    ${If} ${FileExists} "$RobloxPath\RobloxPlayerBeta.dll"
        ${GetSize} "$RobloxPath" "/M=RobloxPlayerBeta.dll /S=0B /G=0" $0 $1 $2
        ; byfron-enabled builds typically have larger DLLs (>50MB)
        ${If} $0 > 50000000
            StrCpy $AnticheatDetected "true"
            !insertmacro ToLog $LOGFILE "Compatibility" "Large RobloxPlayerBeta.dll detected ($0 bytes) - likely Byfron enabled"
        ${EndIf}
    ${EndIf}
    
    ; Method 4: Check for channel file that indicates production/beta
    ${If} ${FileExists} "$RobloxPath\channel"
        FileOpen $0 "$RobloxPath\channel" r
        FileRead $0 $1
        FileClose $0
        StrCpy $1 $1 -2 ; Remove CRLF
        !insertmacro ToLog $LOGFILE "Compatibility" "Roblox channel file content: $1"
    ${EndIf}
    
    ; Method 5: Check Windows Defender exclusions (indicates game protection)
    nsExec::ExecToStack 'powershell -Command "Get-MpPreference | Select-Object -ExpandProperty ExclusionPath | Where-Object { $$_ -like \"*Roblox*\" }"'
    pop $0
    pop $1
    StrCmp $1 "" no_defender_exclusion
    !insertmacro ToLog $LOGFILE "Compatibility" "Roblox found in Windows Defender exclusions"
no_defender_exclusion:
    
FunctionEnd

Function DetectRobloxChannel
    ReadRegStr $RobloxChannel HKCU "${ROBLOXREGLOC}" "channel"
    
    ${If} $RobloxChannel == ""
        StrCpy $RobloxChannel "LIVE"
    ${EndIf}
    
    !insertmacro ToLog $LOGFILE "Compatibility" "Roblox channel: $RobloxChannel"
FunctionEnd

Function EvaluateCompatibility
    ; check anti-cheat status
    StrCmp $AnticheatDetected "true" 0 check_version
        StrCpy $CompatibilityStatus ${COMPAT_WARN_ANTICHEAT}
        StrCpy $CompatibilityMessage "Anti-cheat system (Byfron/Hyperion) detected.$\n$\n\
RSInfinity may not work correctly with this version of Roblox.$\n$\n\
Current Status:$\n\
• Roblox Version: $RobloxVersionString$\n\
• Channel: $RobloxChannel$\n\
• Anti-cheat: DETECTED$\n$\n\
Options:$\n\
1. Continue anyway (shader injection may fail)$\n\
2. Use external tools like NVIDIA Freestyle instead$\n\
3. Wait for a compatible solution"
        !insertmacro ToLog $LOGFILE "Compatibility" "Status: WARN_ANTICHEAT"
        Return
    
check_version:
    ; Version-specific checks could go here
    ; For now, if no anti-cheat detected, we're OK
    StrCpy $CompatibilityStatus ${COMPAT_OK}
    StrCpy $CompatibilityMessage "Compatibility check passed.$\n$\n\
• Roblox Version: $RobloxVersionString$\n\
• Channel: $RobloxChannel$\n\
• Anti-cheat: Not detected$\n$\n\
RSInfinity should work correctly."
    !insertmacro ToLog $LOGFILE "Compatibility" "Status: OK"
FunctionEnd

; ============================================================================
; Show Compatibility Result Dialog
; ============================================================================
Function ShowCompatibilityResult
    ${Switch} $CompatibilityStatus
        ${Case} ${COMPAT_OK}
            !insertmacro ToLog $LOGFILE "Compatibility" "Check passed - proceeding with installation"
            ${Break}
            
        ${Case} ${COMPAT_WARN_ANTICHEAT}
            MessageBox MB_YESNOCANCEL|MB_ICONWARNING "⚠️ Compatibility Warning$\n$\n$CompatibilityMessage$\n$\nDo you want to continue anyway?" IDYES continue_anyway IDNO try_external
                ; Cancel - abort installation
                !insertmacro ToLog $LOGFILE "Compatibility" "User cancelled installation due to anti-cheat warning"
                Abort
            try_external:
                ; No - offer external tools
                Call OfferExternalTools
                Abort
            continue_anyway:
                ; Yes - continue with warning
                !insertmacro ToLog $LOGFILE "Compatibility" "User chose to continue despite anti-cheat warning"
            ${Break}
            
        ${Case} ${COMPAT_WARN_VERSION}
            MessageBox MB_YESNO|MB_ICONWARNING "Version Warning$\n$\n$CompatibilityMessage$\n$\nContinue anyway?" IDYES +2
                Abort
            ${Break}
            
        ${Case} ${COMPAT_BLOCKED}
            MessageBox MB_OK|MB_ICONSTOP "Installation Blocked$\n$\n$CompatibilityMessage"
            !insertmacro ToLog $LOGFILE "Compatibility" "Installation blocked: $CompatibilityMessage"
            Abort
            ${Break}
    ${EndSwitch}
FunctionEnd

; ============================================================================
; Offer External Tools as Alternative
; ============================================================================
Function OfferExternalTools
    MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to configure external alternatives that work with any Roblox version?$\n$\n\
These tools apply post-processing at the driver level and are not affected by anti-cheat:$\n$\n\
• NVIDIA Freestyle (GeForce Experience)$\n\
• AMD Adrenalin Software$\n\
• Windows HDR/Auto HDR$\n$\n\
Configure external tools now?" IDNO skip_external
        ; Use the ExternalTools module
        Call DetectGPUVendor
        Call ConfigureExternalTools
        !insertmacro ToLog $LOGFILE "Compatibility" "User chose to configure external tools"
        Return
    skip_external:
        ExecShell "open" "https://rsinfinity.software/docs/external-tools"
        !insertmacro ToLog $LOGFILE "Compatibility" "User redirected to external tools documentation"
FunctionEnd

; ============================================================================
; Macro for easy integration
; ============================================================================
!macro RunCompatibilityCheck
    Call CheckCompatibility
!macroend

; ============================================================================
; Additional utility: Check if running as admin (required for some operations)
; ============================================================================
Function CheckAdminRights
    UserInfo::GetAccountType
    pop $0
    StrCmp $0 "Admin" +3
        MessageBox MB_OK|MB_ICONEXCLAMATION "RSInfinity requires administrator privileges for full functionality."
        !insertmacro ToLog $LOGFILE "Compatibility" "Warning: Not running as administrator"
FunctionEnd
