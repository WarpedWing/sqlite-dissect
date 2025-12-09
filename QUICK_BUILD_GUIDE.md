# Quick Build Guide - sqlite_dissect

## Three Ways to Build

### 1. Python Wheel (Distributable Python Package) - FASTEST

```bash
uv build
```

**Output:** `dist/sqlite_dissect-1.0.0-py3-none-any.whl` (~200KB)

**Install with:**
```bash
pip install dist/sqlite_dissect-1.0.0-py3-none-any.whl
```

**Use case:** For users who have Python 3.12+ installed

---

### 2. Standalone Executable (No Python Required) - EASIEST FOR END USERS

```bash
./build_standalone.sh onefile
```

**Output:** `dist/macos/bin/sqlite_dissect` (~11MB)

**Run directly:**
```bash
./dist/macos/bin/sqlite_dissect --version
```

**Use case:** For users without Python, single file distribution

---

### 3. Development Mode (Editable Install) - FOR DEVELOPMENT

```bash
uv sync
uv run sqlite_dissect --help
```

**Use case:** For active development with live code changes

---

## Platform-Specific Builds

### Current Platform (Auto-detected)
```bash
./build_standalone.sh onefile
```

### Specific Platform
```bash
# macOS
uv run pyinstaller pyinstaller/sqlite_dissect_macos_onefile.spec

# Linux
uv run pyinstaller pyinstaller/sqlite_dissect_linux-x64_onefile.spec

# Windows
uv run pyinstaller pyinstaller/sqlite_dissect_win-x86_64_onefile.spec
```

---

## Quick Commands

```bash
# Clean everything
rm -rf build/ dist/ *.egg-info .venv

# Fresh install
uv sync

# Run tests
uv run python -m pytest

# Run directly
uv run sqlite_dissect --version

# Build wheel
uv build

# Build standalone
./build_standalone.sh onefile

# Test standalone
./dist/macos/bin/sqlite_dissect --version
```

---

## Troubleshooting

### Build fails with "module not found"
```bash
# Reinstall dependencies
rm -rf .venv
uv sync
```

### PyInstaller fails
```bash
# Clean build cache
rm -rf build/
./build_standalone.sh onefile
```

### macOS blocks executable
```bash
# Remove quarantine
xattr -d com.apple.quarantine dist/macos/bin/sqlite_dissect
```

---

## File Sizes

| Type | Size | Python Required |
|------|------|-----------------|
| Wheel | ~200KB | Yes |
| Standalone (onefile) | ~11MB | No |
| Standalone (onedir) | ~20MB | No |

---

## Distribution Checklist

- [ ] Build succeeds without errors
- [ ] `--version` shows correct version
- [ ] `--help` displays properly
- [ ] Test with sample database
- [ ] Create release archive (tar.gz/zip)
- [ ] Include README and LICENSE
- [ ] Test on clean system
- [ ] Upload to GitHub Releases

---

## Need Help?

See detailed documentation:
- [BUILD.md](BUILD.md) - Complete build documentation
- [DISTRIBUTION.md](DISTRIBUTION.md) - Distribution guide
- [README.md](README.md) - Project README
