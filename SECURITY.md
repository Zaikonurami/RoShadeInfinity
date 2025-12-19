# Security Policy

## 🔒 Supported Versions

Currently supported versions for security updates:

| Version | Supported          |
| ------- | ------------------ |
| 2.0.x   | ✅ Yes             |
| 1.4.x   | ⚠️ Limited Support |
| < 1.4   | ❌ No              |

## 🚨 Reporting a Vulnerability

If you discover a security vulnerability in RSInfinity, please follow these steps:

### DO NOT open a public issue

Security vulnerabilities should be reported privately to protect users.

### How to Report

1. **Email**: Send details to security@rsinfinity.software (if available)
2. **Discord**: Contact administrators directly on our [Discord server](https://rsinfinity.software/go/discord)
3. **GitHub**: Use the private vulnerability reporting feature

### What to Include

Please provide:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if you have one)
- Your contact information

### Response Time

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Fix Timeline**: Depends on severity (Critical: <7 days, High: <14 days, Medium: <30 days)

## 🛡️ Security Best Practices

When using RSInfinity:

1. **Download from Official Sources Only**
   - GitHub Releases
   - Official website: https://rsinfinity.software/

2. **Verify File Integrity**
   - Check SHA256 hashes (provided in releases)
   - Verify digital signatures when available

3. **Keep Updated**
   - Always use the latest version
   - Enable auto-update notifications

4. **System Requirements**
   - Use on legitimate Roblox installations only
   - Ensure Windows Defender/Antivirus is active
   - Run with appropriate user permissions

## ⚠️ Known Issues

Current known security considerations:

- **Admin Rights**: The installer requires administrator privileges to modify Roblox files
- **Registry Access**: Reads Roblox installation path from Windows Registry
- **File Modifications**: Modifies Roblox directory to inject Reshade DLL

These are intended behaviors and necessary for the application to function.

## 📋 Security Audit Log

| Date       | Issue                    | Severity | Status   |
|------------|--------------------------|----------|----------|
| 2025-12-18 | Initial security review  | Info     | Complete |

## 🔐 Code Signing

- Currently: Installers are not code-signed
- Planned: Code signing certificate for future releases

## 📞 Contact

For security concerns:
- Discord: [RSInfinity Community](https://rsinfinity.software/go/discord)
- Issues: Use private reporting on GitHub

---

Thank you for helping keep RSInfinity and its users safe!
