# RSInfinity [![Build](https://github.com/Zaikonurami/RSInfinity/actions/workflows/nsis.yaml/badge.svg?branch=main)](https://github.com/Zaikonurami/RSInfinity/actions/workflows/nsis.yaml) [![RSInfinity](https://badgen.net/badge/visit/RSInfinity.software/orange)](https://RSInfinity.software/) ![Downloads](https://img.shields.io/github/downloads/Zaikonurami/RSInfinity/total) [![NSIS](https://badgen.net/badge/NSIS/3.08/cyan)](https://nsis.sourceforge.io/Download)

RSInfinity is an advanced installation package that simplifies the process of installing Reshade presets and shaders to the Roblox directory. With RSInfinity, you can quickly and easily enhance your Roblox experience with stunning visual effects.

## 📖 History & Context

### The Problem
In recent updates, Roblox implemented new security measures that inadvertently blocked legitimate and harmless programs like Reshade-based graphics enhancers. These tools only improved the visual experience without affecting gameplay, but the new anti-cheat protections detected them as potential threats.

This resulted in the original project (RoShade) ceasing to function, depriving thousands of users of the ability to enjoy enhanced graphics in Roblox.

### 🔱 Preserving the Legacy
**RSInfinity is built as a fork of the original RoShade project created by Zeal** to honor and preserve its legacy. Rather than letting the project fade into history, we're committed to:
- 📚 Maintaining the original codebase and Zeal's innovations
- 🛠️ Modernizing and adapting it for current needs
- 🌟 Ensuring the community's work and contributions aren't lost
- 🔄 Evolving the project while respecting Zeal's original vision

By working on a fork, we ensure that Zeal's original work remains intact while we explore new paths forward.

### 🎯 RSInfinity's Mission

**Primary Goal**: Revive and modernize graphics enhancement functionality for Roblox in a legitimate and secure manner.

**Our Commitment**:
- 🔬 Research methods compatible with Roblox's new security measures
- 🤝 Seek collaboration with Roblox Corporation to find official solutions
- 🛡️ Ensure all implementations are safe and non-violating
- 🌟 Keep the community informed about progress and challenges

**Future Vision**:
If we successfully develop a functional method, our ultimate goal is to work directly with Roblox to:
- Obtain official approval for graphics modifiers
- Establish standards for safe visual enhancement tools
- Potentially integrate these capabilities natively into Roblox

> ⚠️ **Current Status**: This project is in active research phase. The installer is functional but compatibility with current Roblox versions may vary due to implemented security measures.

## ✨ Key Features (Legacy)
- 🔍 Uses the registry to locate and manage Roblox, ensuring safe installations
- ⌨️ Allows you to customize essential Reshade keybinds during installation
- 🛡️ Provides detailed error handling through dialog messages
- 📊 Displays system requirements for each preset component
- 🌐 Automatically downloads required shaders from GitHub
- 🎨 Multiple preset quality options (Low, Medium, High)
- ⚡ Fast and lightweight installer

## 🔬 Current Status

> **⚠️ IMPORTANT**: RSInfinity is currently in active research and development phase. The program and website are not yet active due to compatibility issues with Roblox's current anti-cheat system.

**What this means**:
- 🚫 **No active releases available** - Installation is not possible at this time
- 🔬 **Research in progress** - We are investigating compatible solutions
- 🌐 **Website pending** - Will launch once a working solution is found
- 📅 **Stay tuned** - Follow the project for updates on progress

### Support & Community
While we work on a solution, you can:
- 🐛 Check progress on the [GitHub repository](https://github.com/Zaikonurami/RSInfinity)
- 💬 Join discussions on our [Discord server](https://rsinfinity.software/go/discord) (when available)
- 📖 Read the [ROADMAP](ROADMAP.md) for detailed development plans

## 🛠️ Building from Source

> **⚠️ Note**: Since the project is in research phase, building from source will produce an installer that may not be compatible with current Roblox versions. This is primarily for development and testing purposes.

The installer is written in [NSIS](https://nsis.sourceforge.io/Download "Download NSIS"), a popular open-source tool for creating Windows installers.

### Prerequisites
- NSIS 3.08 or later installed on your machine
- All required NSIS plugins (see below)
- Git for cloning the repository

### Required NSIS Plugins

#### NSIS Plugins Directory:
- [LogEx](https://nsis.sourceforge.io/LogEx_plug-in)
- [NScurl](https://github.com/negrutiu/nsis-nscurl)
- [Nsisunz](https://github.com/past-due/nsisunz)
- [NsProcess](https://nsis.sourceforge.io/mediawiki/index.php?title=NsProcess_plugin&oldid=24277)
- [TitlebarProgress](https://nsis.sourceforge.io/TitlebarProgress_plug-in)
- [TaskbarProgress](https://nsis.sourceforge.io/TaskbarProgress_plug-in)
- [nsJSON](https://nsis.sourceforge.io/NsJSON_plug-in)
- [AccessControl](https://nsis.sourceforge.io/AccessControl_plug-in)

For more information on installing plugins to the NSIS directory, click [here](https://nsis.sourceforge.io/How_can_I_install_a_plugin).

#### Setup\Util Folder:
- [MoveFileFolder](https://nsis.sourceforge.io/MoveFileFolder)
- [GetSectionNames](https://nsis.sourceforge.io/Get_all_section_names_of_INI_file)
- [Explode](https://nsis.sourceforge.io/Explode)
- [StrContains](https://nsis.sourceforge.io/StrContains)
- [ConfigRead](https://nsis.sourceforge.io/ConfigRead)

### Build Commands

**Basic build:**
```bash
makensis Setup\Setup.nsi
```

**Production build with LZMA compression (recommended):**
```bash
makensis /X"SetCompressor /FINAL lzma" Setup\Setup.nsi
```

**Using VS Code:**
- Press `Ctrl+Shift+B` to build
- Use the "Launch" task to run the compiled installer

### Build Output
The installer will be generated as `RSInfinitySetup.exe` in the root directory.

## 📋 Project Structure
```
RoShadeInfinity/
├── Files/
│   ├── Preset/          # Reshade preset configurations
│   ├── Reshade/         # Reshade core files
│   ├── RSInfinity/      # Custom fonts and resources
│   └── Textures/        # Shader textures
├── Setup/
│   ├── Graphics/        # Installer graphics
│   ├── CustomDlg/       # Custom dialogs
│   ├── Util/            # Utility scripts
│   └── *.nsh            # NSIS script files
└── .github/
    └── workflows/       # CI/CD workflows
```

## 🎨 Available Presets

### Base Presets
- **High Quality** - For high-end systems (RTX 2070+ / RX 5700 XT+)
- **Medium Quality** - For mid-range systems (GTX 1050 Ti+ / RX 570+)
- **Low Quality** - For entry-level systems (GTX 970+ / AMD 390+)

### Special Presets
- **Glossy** - Enhanced reflections
- **Very Glossy** - Maximum reflections
- **Snow** - Winter weather effects
- **Zeal's Presets** - Legacy presets (Ultra, High, Medium, Low)

## 📄 License
Copyright (C) 2025 Zaikonurami

See [LICENSE](LICENSE) file for full license text.

## 🙏 Credits
- **Original RoShade project** by Zeal - This project is a fork built upon their foundation
- **Reshade** by crosire - The core graphics enhancement technology
- Community contributors and testers from both projects
- All those who supported the original vision

> 💡 **Note**: RSInfinity is a fork of RoShade, created to preserve and continue the legacy of the original project.

## ⚠️ Disclaimer

**Important**: This project is NOT affiliated with or endorsed by Roblox Corporation.

- 🔍 RSInfinity is in active development to find compatible methods
- 🛡️ We fully respect Roblox's Terms of Service
- 🤝 We seek official collaboration with Roblox for legitimate solutions
- ⚖️ We do not promote or support the use of tools that violate Roblox policies
- 🎮 Use this software at your own risk

**Status**: Due to Roblox security updates, functionality may be limited. We are working on compatible solutions.

---

**Note**: For a detailed development roadmap and future plans, see [ROADMAP.md](ROADMAP.md)

Made with 💚 by Zaikonurami