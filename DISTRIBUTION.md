# sqlite_dissect Distribution Guide

This guide explains how to distribute sqlite_dissect to end users.

## Quick Start for Distribution

### For End Users Who Have Python

**Distribute the wheel file:**

```bash
# Build the wheel
uv build

# Share this file:
dist/sqlite_dissect-1.0.0-py3-none-any.whl
```

**Users install with:**

```bash
pip install sqlite_dissect-1.0.0-py3-none-any.whl
```

### For End Users Without Python (Standalone)

**Build the standalone executable:**

```bash
./build_standalone.sh onefile
```

**Share the entire file:**

- **macOS**: `dist/macos/bin/sqlite_dissect` (~11MB)
- **Linux**: `dist/linux-x64/bin/sqlite_dissect`
- **Windows**: `dist/win-x86_64/bin/sqlite_dissect.exe`

**Users can run directly:**

```bash
# macOS/Linux (may need to make executable first)
chmod +x sqlite_dissect
./sqlite_dissect --version

# Windows
sqlite_dissect.exe --version
```

## Distribution Options

### Option 1: GitHub Releases (Recommended)

Create releases with pre-built binaries:

```bash
# Build for your platform
./build_standalone.sh onefile

# Create a release archive
cd dist/macos/bin
tar -czf sqlite_dissect-1.0.0-macos-arm64.tar.gz sqlite_dissect
```

Upload to GitHub Releases with:
- `sqlite_dissect-1.0.0-macos-arm64.tar.gz` (macOS)
- `sqlite_dissect-1.0.0-linux-x64.tar.gz` (Linux)
- `sqlite_dissect-1.0.0-windows-x64.zip` (Windows)
- `sqlite_dissect-1.0.0-py3-none-any.whl` (Python wheel)

### Option 2: PyPI (Python Package Index)

For Python users to install with `pip install sqlite-dissect`:

```bash
# Build
uv build

# Upload to PyPI (requires account and API token)
uv pip install twine
twine upload dist/*
```

### Option 3: Direct File Sharing

Simply share the executable file or wheel via:
- Email
- Shared drive
- Download link
- USB drive

## Platform-Specific Notes

### macOS

**Code Signing:** macOS will block unsigned executables from unknown developers.

**Solution 1 - Sign the binary (requires Apple Developer account):**
```bash
codesign --force --sign "Developer ID Application: Your Name" sqlite_dissect
```

**Solution 2 - Users can bypass (one-time):**
```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine sqlite_dissect

# Or use System Preferences > Security & Privacy > "Allow Anyway"
```

**Distribution tip:** Create a DMG installer:
```bash
# Create DMG (requires create-dmg tool)
brew install create-dmg
create-dmg \
  --volname "SQLite Dissect" \
  --window-size 600 400 \
  --icon sqlite_dissect 200 150 \
  --app-drop-link 400 150 \
  sqlite_dissect-1.0.0.dmg \
  dist/macos/bin/
```

### Linux

**Make executable:**
```bash
chmod +x sqlite_dissect
```

**Distribution tip:** Create a .deb or .rpm package, or use AppImage:
```bash
# Simple approach: tar.gz
tar -czf sqlite_dissect-1.0.0-linux-x64.tar.gz sqlite_dissect README.md LICENSE.txt
```

### Windows

**Antivirus Warning:** PyInstaller executables may trigger false positives.

**Solutions:**
1. Sign the executable with a code signing certificate
2. Build with onedir instead of onefile (less suspicious)
3. Distribute the wheel for Python users
4. Upload to VirusTotal and share the clean report

**Distribution tip:** Create an installer with NSIS or Inno Setup:
```bash
# Or just zip it
zip sqlite_dissect-1.0.0-windows-x64.zip sqlite_dissect.exe README.md LICENSE.txt
```

## File Checklist for Distribution

### Standalone Binary Distribution

Include these files in your distribution:

```
sqlite_dissect-1.0.0-macos-arm64/
├── sqlite_dissect          # The executable
├── README.md               # User documentation
├── LICENSE.txt             # License file
└── USAGE.txt              # Quick start guide
```

### Python Wheel Distribution

```
dist/
├── sqlite_dissect-1.0.0-py3-none-any.whl
└── README.md
```

## Creating Release Archives

### Automated Script

Create `package_release.sh`:

```bash
#!/bin/bash
VERSION="1.0.0"
PLATFORM="macos-arm64"  # or linux-x64, windows-x64

# Build
./build_standalone.sh onefile

# Create release directory
mkdir -p "release/sqlite_dissect-${VERSION}-${PLATFORM}"
cp dist/macos/bin/sqlite_dissect "release/sqlite_dissect-${VERSION}-${PLATFORM}/"
cp README.md "release/sqlite_dissect-${VERSION}-${PLATFORM}/"
cp LICENSE.txt "release/sqlite_dissect-${VERSION}-${PLATFORM}/"

# Create archive
cd release
tar -czf "sqlite_dissect-${VERSION}-${PLATFORM}.tar.gz" "sqlite_dissect-${VERSION}-${PLATFORM}"
cd ..

echo "Release package created: release/sqlite_dissect-${VERSION}-${PLATFORM}.tar.gz"
```

## Verification

Before distributing, verify the build:

```bash
# Test the executable
./dist/macos/bin/sqlite_dissect --version
./dist/macos/bin/sqlite_dissect --help

# Test with a sample database
./dist/macos/bin/sqlite_dissect sample.db

# Check file size (should be reasonable)
ls -lh dist/macos/bin/sqlite_dissect

# Check dependencies (should be self-contained)
otool -L dist/macos/bin/sqlite_dissect  # macOS
ldd dist/linux-x64/bin/sqlite_dissect   # Linux
```

## Support and Documentation

Include these URLs in your distribution:

- **Source Code**: Your GitHub repository
- **Issues**: GitHub Issues page
- **Documentation**: Link to full documentation
- **License**: Link to LICENSE.txt

## Size Optimization

If the executable is too large:

1. **Use onedir instead of onefile** - Faster startup, similar size
2. **Exclude unnecessary modules** in the `.spec` file:
   ```python
   excludes=['tkinter', 'matplotlib', 'numpy', 'pandas']
   ```
3. **Use UPX compression** (already enabled in spec files)
4. **Strip debug symbols** (already enabled)

## Example Distribution README

Create a simple README.txt for users:

```
SQLite Dissect v1.0.0
====================

A forensic tool for SQLite database analysis and recovery.

QUICK START:

  ./sqlite_dissect database.db

For more options:

  ./sqlite_dissect --help

SYSTEM REQUIREMENTS:

  - macOS 10.15 or later (Intel or Apple Silicon)
  - No additional software required

LICENSE:

  See LICENSE.txt

SUPPORT:

  https://github.com/yourusername/sqlite-dissect
```

## Testing Checklist

Before releasing:

- [ ] Test on clean system without Python installed
- [ ] Verify --version shows correct version
- [ ] Test with sample SQLite database
- [ ] Check file permissions (executable)
- [ ] Verify no dependency errors
- [ ] Test on target OS version
- [ ] Check antivirus false positives (Windows)
- [ ] Verify code signature (macOS)
- [ ] Test with different database types
- [ ] Check error messages are user-friendly
