# Important
InstallDir "$LOCALAPPDATA\RSInfinity"


# Attributes
!define VERSION "2.0.0"
!define MANUFACTURER "Zaikonurami"
!define NAME "RSInfinity"
!define ROBLOXREGLOC "SOFTWARE\ROBLOX Corporation\Environments\roblox-player"
!define SELFREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
!define UninstallerExe "Uninstall RSInfinity.exe"
!define HELPLINK "https://rsinfinity.software/go/discord"
!define ABOUTLINK "https://rsinfinity.software/"
!define UPDATELINK "https://github.com/Zaikonurami/RSInfinity/releases"
!define RENDERAPI "d3d11.dll"

# Directories
!define PRESETFOLDER "$INSTDIR\presets"
!define RESHADESOURCE "..\Files\Reshade"
!define PRESETSOURCE "..\Files\Preset"
!define PRESETTEMPFOLDER "$TEMP\Presets"
!define TEMPFOLDER "$TEMP\ZaikoTemp - RSInfinity"
!define LOGDIRECTORY "$TEMP\rsinfinity"

# Files
!define SPLASHICON "$PLUGINSDIR\RSInfinity.gif"
!define SHADERSINI "$PLUGINSDIR\Shaders.ini"
!define RESHADEINI "$PLUGINSDIR\Reshade.ini"
!define APPICON "$INSTDIR\AppIcon.ico"

Var Techniques
Var Repositories
Var ShaderDir
Var RobloxPath
Var PresetPriority # Determine which preset should be loaded. Lower = higher priority.

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "${NAME}"
VIAddVersionKey "CompanyName" "${MANUFACTURER}"
VIAddVersionKey "LegalCopyright" "Copyright (C) 2025 Zaikonurami"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileVersion" "${VERSION}"

Name "${NAME}"
Caption "$(^Name) Installation"
Outfile "..\RSInfinitySetup.exe"
BrandingText "${MANUFACTURER}"
CRCCHECK force