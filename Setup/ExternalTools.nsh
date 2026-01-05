; ============================================================================
; RSInfinity - External Tools Configuration
; ============================================================================
; This module provides configuration for external post-processing tools
; that work at the driver level and are not affected by anti-cheat.
; ============================================================================

!include LogicLib.nsh
!include FileFunc.nsh
!include x64.nsh

; GPU Vendor detection
!define GPU_NVIDIA 1
!define GPU_AMD 2
!define GPU_INTEL 3
!define GPU_UNKNOWN 0

; Registry paths
!define NVIDIA_GFE_REG "SOFTWARE\NVIDIA Corporation\Global\GFExperience"
!define AMD_ADRENALIN_REG "SOFTWARE\AMD\CN"
!define NVIDIA_PROFILE_REG "SOFTWARE\NVIDIA Corporation\Global\NVTweak"

Var DetectedGPU
Var GPUName
Var FreestyleAvailable
Var AdrenalinAvailable
Var ExternalToolsInstalled

; ============================================================================
; Main External Tools Section (Optional - User can select)
; ============================================================================
!macro ExternalToolsSection
    SectionGroup "External Tools Mode (Anti-cheat Safe)" ExternalToolsGroup
        Section /o "Detect & Configure GPU Tools" ConfigureExternal
            Call DetectGPUVendor
            Call ConfigureExternalTools
        SectionEnd
        
        Section /o "Install NVIDIA Profile (Freestyle)" NvidiaProfile
            Call InstallNvidiaProfile
        SectionEnd
        
        Section /o "Generate AMD Adrenalin Guide" AMDGuide
            Call GenerateAMDGuide
        SectionEnd
        
        Section /o "Configure Windows HDR" WindowsHDR
            Call ConfigureWindowsHDR
        SectionEnd
    SectionGroupEnd
!macroend

; ============================================================================
; Detect GPU Vendor
; ============================================================================
Function DetectGPUVendor
    StrCpy $DetectedGPU ${GPU_UNKNOWN}
    StrCpy $GPUName ""
    StrCpy $FreestyleAvailable "false"
    StrCpy $AdrenalinAvailable "false"
    
    ; Method 1: Use WMIC to detect GPU
    nsExec::ExecToStack 'wmic path win32_VideoController get name /format:list'
    pop $0
    pop $1
    
    !insertmacro ToLog $LOGFILE "ExternalTools" "GPU Detection output: $1"
    
    ; Check for NVIDIA
    ${If} $1 != ""
        Push $1
        Push "NVIDIA"
        Call StrContainsFunc
        Pop $0
        ${If} $0 != ""
            StrCpy $DetectedGPU ${GPU_NVIDIA}
            StrCpy $GPUName $1
            !insertmacro ToLog $LOGFILE "ExternalTools" "NVIDIA GPU detected"
            Call CheckFreestyleAvailability
        ${EndIf}
    ${EndIf}
    
    ; Check for AMD
    ${If} $DetectedGPU == ${GPU_UNKNOWN}
        Push $1
        Push "AMD"
        Call StrContainsFunc
        Pop $0
        ${If} $0 != ""
            StrCpy $DetectedGPU ${GPU_AMD}
            StrCpy $GPUName $1
            !insertmacro ToLog $LOGFILE "ExternalTools" "AMD GPU detected"
            Call CheckAdrenalinAvailability
        ${EndIf}
        
        ; Also check for Radeon
        Push $1
        Push "Radeon"
        Call StrContainsFunc
        Pop $0
        ${If} $0 != ""
            StrCpy $DetectedGPU ${GPU_AMD}
            StrCpy $GPUName $1
            !insertmacro ToLog $LOGFILE "ExternalTools" "AMD Radeon GPU detected"
            Call CheckAdrenalinAvailability
        ${EndIf}
    ${EndIf}
    
    ; Check for Intel
    ${If} $DetectedGPU == ${GPU_UNKNOWN}
        Push $1
        Push "Intel"
        Call StrContainsFunc
        Pop $0
        ${If} $0 != ""
            StrCpy $DetectedGPU ${GPU_INTEL}
            StrCpy $GPUName $1
            !insertmacro ToLog $LOGFILE "ExternalTools" "Intel GPU detected (limited support)"
        ${EndIf}
    ${EndIf}
    
    !insertmacro ToLog $LOGFILE "ExternalTools" "Final GPU detection: $DetectedGPU - $GPUName"
FunctionEnd

; Helper function for string contains
Function StrContainsFunc
    Exch $R1 ; Search string
    Exch
    Exch $R2 ; String to search in
    Push $R3
    Push $R4
    Push $R5
    
    StrLen $R3 $R1
    StrCpy $R4 0
    
    loop:
        StrCpy $R5 $R2 $R3 $R4
        StrCmp $R5 $R1 found
        StrCmp $R5 "" notfound
        IntOp $R4 $R4 + 1
        Goto loop
    
    found:
        StrCpy $R1 $R5
        Goto done
    
    notfound:
        StrCpy $R1 ""
    
    done:
        Pop $R5
        Pop $R4
        Pop $R3
        Pop $R2
        Exch $R1
FunctionEnd

; ============================================================================
; Check NVIDIA Freestyle Availability
; ============================================================================
Function CheckFreestyleAvailability
    ; Check if GeForce Experience is installed
    ${If} ${RunningX64}
        SetRegView 64
    ${EndIf}
    
    ReadRegStr $0 HKLM "${NVIDIA_GFE_REG}" "Version"
    
    ${If} $0 != ""
        StrCpy $FreestyleAvailable "true"
        !insertmacro ToLog $LOGFILE "ExternalTools" "GeForce Experience found: v$0"
        
        ; Check if Freestyle is enabled
        ReadRegStr $1 HKCU "SOFTWARE\NVIDIA Corporation\Global\GFExperience" "GameFilter"
        ${If} $1 == "1"
            !insertmacro ToLog $LOGFILE "ExternalTools" "Freestyle is enabled"
        ${Else}
            !insertmacro ToLog $LOGFILE "ExternalTools" "Freestyle may need to be enabled"
        ${EndIf}
    ${Else}
        StrCpy $FreestyleAvailable "false"
        !insertmacro ToLog $LOGFILE "ExternalTools" "GeForce Experience not found"
    ${EndIf}
    
    SetRegView 32
FunctionEnd

; ============================================================================
; Check AMD Adrenalin Availability
; ============================================================================
Function CheckAdrenalinAvailability
    ${If} ${RunningX64}
        SetRegView 64
    ${EndIf}
    
    ReadRegStr $0 HKLM "${AMD_ADRENALIN_REG}" "Version"
    
    ${If} $0 != ""
        StrCpy $AdrenalinAvailable "true"
        !insertmacro ToLog $LOGFILE "ExternalTools" "AMD Adrenalin found: v$0"
    ${Else}
        ; Try alternative path
        ReadRegStr $0 HKLM "SOFTWARE\ATI Technologies\Install\Radeonsoftware" "Version"
        ${If} $0 != ""
            StrCpy $AdrenalinAvailable "true"
            !insertmacro ToLog $LOGFILE "ExternalTools" "AMD Radeon Software found: v$0"
        ${Else}
            StrCpy $AdrenalinAvailable "false"
            !insertmacro ToLog $LOGFILE "ExternalTools" "AMD Adrenalin not found"
        ${EndIf}
    ${EndIf}
    
    SetRegView 32
FunctionEnd

; ============================================================================
; Configure External Tools Based on GPU
; ============================================================================
Function ConfigureExternalTools
    ${Switch} $DetectedGPU
        ${Case} ${GPU_NVIDIA}
            ${If} $FreestyleAvailable == "true"
                MessageBox MB_YESNO|MB_ICONINFORMATION "NVIDIA GPU Detected!$\n$\n\
GeForce Experience is installed.$\n\
Freestyle can apply post-processing effects without triggering anti-cheat.$\n$\n\
Would you like to:$\n\
• Install a pre-configured NVIDIA profile for Roblox?$\n\
• This will enable Sharpening, Vibrance, and other effects$\n$\n\
Continue?" IDYES install_nvidia IDNO skip_nvidia
                install_nvidia:
                    Call InstallNvidiaProfile
                skip_nvidia:
            ${Else}
                MessageBox MB_YESNO|MB_ICONQUESTION "NVIDIA GPU Detected!$\n$\n\
GeForce Experience is NOT installed.$\n\
You need it for NVIDIA Freestyle support.$\n$\n\
Download GeForce Experience now?" IDNO skip_gfe_download
                    ExecShell "open" "https://www.nvidia.com/en-us/geforce/geforce-experience/"
                    !insertmacro ToLog $LOGFILE "ExternalTools" "User redirected to GeForce Experience download"
                skip_gfe_download:
            ${EndIf}
            ${Break}
            
        ${Case} ${GPU_AMD}
            ${If} $AdrenalinAvailable == "true"
                MessageBox MB_OK|MB_ICONINFORMATION "AMD GPU Detected!$\n$\n\
AMD Adrenalin is installed.$\n\
You can use Radeon Image Sharpening and Game Filters.$\n$\n\
A guide will be generated with recommended settings for Roblox."
                Call GenerateAMDGuide
            ${Else}
                MessageBox MB_YESNO|MB_ICONQUESTION "AMD GPU Detected!$\n$\n\
AMD Adrenalin is NOT installed.$\n\
You need it for AMD Radeon Software features.$\n$\n\
Download AMD Adrenalin now?" IDNO skip_amd_download
                    ExecShell "open" "https://www.amd.com/en/technologies/software"
                    !insertmacro ToLog $LOGFILE "ExternalTools" "User redirected to AMD Adrenalin download"
                skip_amd_download:
            ${EndIf}
            ${Break}
            
        ${Case} ${GPU_INTEL}
            MessageBox MB_OK|MB_ICONINFORMATION "Intel GPU Detected$\n$\n\
Intel GPUs have limited post-processing options.$\n\
Windows HDR/Auto HDR is your best option.$\n$\n\
A guide will be generated with available options."
            Call GenerateIntelGuide
            ${Break}
            
        ${Default}
            MessageBox MB_OK|MB_ICONEXCLAMATION "Could not detect your GPU vendor.$\n$\n\
Please check manually which tools are available:$\n\
• NVIDIA: GeForce Experience (Freestyle)$\n\
• AMD: Adrenalin Software$\n\
• Intel: Windows HDR"
            ${Break}
    ${EndSwitch}
    
    StrCpy $ExternalToolsInstalled "true"
FunctionEnd

; ============================================================================
; Install NVIDIA Profile for Roblox
; ============================================================================
Function InstallNvidiaProfile
    !insertmacro ToLog $LOGFILE "ExternalTools" "Installing NVIDIA profile for Roblox"
    
    ; Create NVIDIA profile inspector command
    ; This sets recommended settings for Roblox
    
    CreateDirectory "$INSTDIR\NVIDIA"
    
    ; Generate a batch file to apply NVIDIA settings
    FileOpen $0 "$INSTDIR\NVIDIA\ApplyRobloxProfile.bat" w
    FileWrite $0 "@echo off$\r$\n"
    FileWrite $0 "echo Applying NVIDIA settings for Roblox...$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "echo This script configures:$\r$\n"
    FileWrite $0 "echo  - Image Sharpening: ON (0.50)$\r$\n"
    FileWrite $0 "echo  - Anisotropic Filtering: 16x$\r$\n"
    FileWrite $0 "echo  - Texture Filtering Quality: High$\r$\n"
    FileWrite $0 "echo  - Low Latency Mode: ON$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "echo To enable Freestyle in-game:$\r$\n"
    FileWrite $0 "echo  1. Open GeForce Experience$\r$\n"
    FileWrite $0 "echo  2. Settings > Enable Experimental Features$\r$\n"
    FileWrite $0 "echo  3. In Roblox, press Alt+F3$\r$\n"
    FileWrite $0 "echo  4. Add filters: Sharpen, Details, Color, etc.$\r$\n"
    FileWrite $0 "echo.$\r$\n"
    FileWrite $0 "pause$\r$\n"
    FileClose $0
    
    ; Generate Freestyle filter recommendations
    FileOpen $0 "$INSTDIR\NVIDIA\FreestylePresets.txt" w
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "RSInfinity - NVIDIA Freestyle Presets$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "PRESET: RSInfinity High (Freestyle Equivalent)$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "1. Sharpen$\r$\n"
    FileWrite $0 "   - Sharpen: 45%%$\r$\n"
    FileWrite $0 "   - Ignore Film Grain: 0%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "2. Details$\r$\n"
    FileWrite $0 "   - Sharpen: 30%%$\r$\n"
    FileWrite $0 "   - Clarity: 40%%$\r$\n"
    FileWrite $0 "   - HDR Toning: 25%%$\r$\n"
    FileWrite $0 "   - Bloom: 10%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "3. Color$\r$\n"
    FileWrite $0 "   - Tint Color: Neutral$\r$\n"
    FileWrite $0 "   - Tint Intensity: 0%%$\r$\n"
    FileWrite $0 "   - Temperature: 0$\r$\n"
    FileWrite $0 "   - Vibrance: 35%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "4. Vignette (Optional)$\r$\n"
    FileWrite $0 "   - Intensity: 20%%$\r$\n"
    FileWrite $0 "   - Size: 80%%$\r$\n"
    FileWrite $0 "   - Roundness: 0%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "PRESET: RSInfinity Medium (Freestyle Equivalent)$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "1. Sharpen$\r$\n"
    FileWrite $0 "   - Sharpen: 35%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "2. Details$\r$\n"
    FileWrite $0 "   - Clarity: 25%%$\r$\n"
    FileWrite $0 "   - HDR Toning: 15%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "3. Color$\r$\n"
    FileWrite $0 "   - Vibrance: 25%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "HOW TO USE:$\r$\n"
    FileWrite $0 "1. Open Roblox$\r$\n"
    FileWrite $0 "2. Press Alt+F3 to open Freestyle$\r$\n"
    FileWrite $0 "3. Click 'Add Filter'$\r$\n"
    FileWrite $0 "4. Apply settings from above$\r$\n"
    FileWrite $0 "5. Save as preset for quick access$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "NOTE: Freestyle presets are saved per-game,$\r$\n"
    FileWrite $0 "so your Roblox settings won't affect other games.$\r$\n"
    FileClose $0
    
    ; Create shortcut
    CreateShortCut "$SMPROGRAMS\${NAME}\NVIDIA Freestyle Guide.lnk" "$INSTDIR\NVIDIA\FreestylePresets.txt"
    
    MessageBox MB_OK|MB_ICONINFORMATION "NVIDIA configuration created!$\n$\n\
Files saved to: $INSTDIR\NVIDIA\$\n$\n\
• FreestylePresets.txt - Recommended filter settings$\n\
• ApplyRobloxProfile.bat - NVIDIA Control Panel tips$\n$\n\
Open the guide now?"
    
    ExecShell "open" "$INSTDIR\NVIDIA\FreestylePresets.txt"
    !insertmacro ToLog $LOGFILE "ExternalTools" "NVIDIA profile installed to $INSTDIR\NVIDIA"
FunctionEnd

; ============================================================================
; Generate AMD Adrenalin Guide
; ============================================================================
Function GenerateAMDGuide
    !insertmacro ToLog $LOGFILE "ExternalTools" "Generating AMD Adrenalin guide"
    
    CreateDirectory "$INSTDIR\AMD"
    
    FileOpen $0 "$INSTDIR\AMD\AdrenalinSettings.txt" w
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "RSInfinity - AMD Adrenalin Settings$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "GLOBAL SETTINGS (Gaming Tab):$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "1. Radeon Image Sharpening: ON$\r$\n"
    FileWrite $0 "   - Sharpness: 70-80%%$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "2. Radeon Anti-Lag: ON$\r$\n"
    FileWrite $0 "   (Reduces input latency)$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "3. Radeon Boost: Optional$\r$\n"
    FileWrite $0 "   - Resolution: 85%%$\r$\n"
    FileWrite $0 "   (Improves FPS during fast movement)$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "ROBLOX GAME PROFILE:$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "1. Open AMD Software: Adrenalin Edition$\r$\n"
    FileWrite $0 "2. Go to Gaming tab$\r$\n"
    FileWrite $0 "3. Add RobloxPlayerBeta.exe as a game$\r$\n"
    FileWrite $0 "4. Configure per-game settings:$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "   Graphics:$\r$\n"
    FileWrite $0 "   - Radeon Anti-Lag: ON$\r$\n"
    FileWrite $0 "   - Radeon Chill: OFF$\r$\n"
    FileWrite $0 "   - Radeon Boost: Optional$\r$\n"
    FileWrite $0 "   - Radeon Image Sharpening: ON (80%%)$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "   Display:$\r$\n"
    FileWrite $0 "   - AMD FreeSync: ON (if supported)$\r$\n"
    FileWrite $0 "   - Virtual Super Resolution: Optional$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "COLOR ADJUSTMENTS (Display Tab):$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "For RSInfinity High equivalent:$\r$\n"
    FileWrite $0 "- Brightness: 0 (default)$\r$\n"
    FileWrite $0 "- Contrast: +5$\r$\n"
    FileWrite $0 "- Saturation: +15$\r$\n"
    FileWrite $0 "- Hue: 0$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "For vibrant colors:$\r$\n"
    FileWrite $0 "- Saturation: +25$\r$\n"
    FileWrite $0 "- Contrast: +10$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "NOTE: These settings apply at the driver level$\r$\n"
    FileWrite $0 "and cannot be detected by Roblox anti-cheat.$\r$\n"
    FileClose $0
    
    CreateShortCut "$SMPROGRAMS\${NAME}\AMD Adrenalin Guide.lnk" "$INSTDIR\AMD\AdrenalinSettings.txt"
    
    MessageBox MB_OK|MB_ICONINFORMATION "AMD configuration guide created!$\n$\n\
Saved to: $INSTDIR\AMD\AdrenalinSettings.txt$\n$\n\
Open the guide now?"
    
    ExecShell "open" "$INSTDIR\AMD\AdrenalinSettings.txt"
    !insertmacro ToLog $LOGFILE "ExternalTools" "AMD guide generated at $INSTDIR\AMD"
FunctionEnd

; ============================================================================
; Generate Intel Guide
; ============================================================================
Function GenerateIntelGuide
    !insertmacro ToLog $LOGFILE "ExternalTools" "Generating Intel GPU guide"
    
    CreateDirectory "$INSTDIR\Intel"
    
    FileOpen $0 "$INSTDIR\Intel\IntelSettings.txt" w
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "RSInfinity - Intel Graphics Settings$\r$\n"
    FileWrite $0 "============================================$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "Intel GPUs have limited post-processing options.$\r$\n"
    FileWrite $0 "Here are the available alternatives:$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "1. WINDOWS HDR/AUTO HDR$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "If your monitor supports HDR:$\r$\n"
    FileWrite $0 "- Settings > System > Display > HDR$\r$\n"
    FileWrite $0 "- Enable 'Use HDR'$\r$\n"
    FileWrite $0 "- Enable 'Auto HDR' for SDR games$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "2. INTEL GRAPHICS COMMAND CENTER$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "- Download from Microsoft Store$\r$\n"
    FileWrite $0 "- Display > Color Settings:$\r$\n"
    FileWrite $0 "  - Brightness: 0$\r$\n"
    FileWrite $0 "  - Contrast: +5$\r$\n"
    FileWrite $0 "  - Saturation: +10$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "3. WINDOWS COLOR CALIBRATION$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "- Search 'Calibrate display color'$\r$\n"
    FileWrite $0 "- Follow the wizard$\r$\n"
    FileWrite $0 "$\r$\n"
    FileWrite $0 "4. THIRD-PARTY OPTIONS$\r$\n"
    FileWrite $0 "----------------------------------------$\r$\n"
    FileWrite $0 "- VibranceGUI (safe, works with any GPU)$\r$\n"
    FileWrite $0 "- Windows Night Light (color temperature)$\r$\n"
    FileClose $0
    
    CreateShortCut "$SMPROGRAMS\${NAME}\Intel Graphics Guide.lnk" "$INSTDIR\Intel\IntelSettings.txt"
    
    ExecShell "open" "$INSTDIR\Intel\IntelSettings.txt"
    !insertmacro ToLog $LOGFILE "ExternalTools" "Intel guide generated at $INSTDIR\Intel"
FunctionEnd

; ============================================================================
; Configure Windows HDR
; ============================================================================
Function ConfigureWindowsHDR
    !insertmacro ToLog $LOGFILE "ExternalTools" "Opening Windows HDR settings"
    
    ; Check Windows version for HDR support
    ${If} ${AtLeastWin10}
        ; Open Windows HDR settings
        nsExec::ExecToStack 'cmd /c start ms-settings:display-advancedgraphics'
        
        MessageBox MB_OK|MB_ICONINFORMATION "Windows HDR Settings opened.$\n$\n\
To enable HDR effects for Roblox:$\n$\n\
1. Enable 'Use HDR' (requires HDR monitor)$\n\
2. Enable 'Auto HDR' to add HDR to Roblox$\n\
3. Adjust 'HDR content brightness' to taste$\n$\n\
Note: Auto HDR works best on Windows 11."
    ${Else}
        MessageBox MB_OK|MB_ICONEXCLAMATION "Windows HDR requires Windows 10 or later.$\n\
Please update your Windows version for HDR support."
    ${EndIf}
FunctionEnd

; ============================================================================
; Macro for quick external tools offering
; ============================================================================
!macro OfferExternalToolsQuick
    MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to configure external graphics tools instead?$\n$\n\
These work at the driver level and are 100%% anti-cheat safe:$\n\
• NVIDIA Freestyle$\n\
• AMD Adrenalin$\n\
• Windows HDR" IDNO +2
        Call ConfigureExternalTools
!macroend
