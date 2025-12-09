# Building sqlite_dissect

This document describes how to build and distribute sqlite_dissect in various formats.

## Prerequisites

- Python 3.12 or higher
- [uv](https://github.com/astral-sh/uv) package manager

## Installation Methods

### Method 1: Development Installation (Editable)

For local development with hot-reload:

```bash
# Install dependencies and create virtual environment
uv sync

# Run the CLI directly
uv run sqlite_dissect --help
```

The `sqlite_dissect` command will be available in your virtual environment at `.venv/bin/sqlite_dissect`.

### Method 2: Python Wheel Package (Distributable)

Build a Python wheel package that can be installed on any system with Python:

```bash
# Build the wheel
uv build

# This creates two files in dist/:
# - sqlite_dissect-1.0.0-py3-none-any.whl (wheel - preferred)
# - sqlite_dissect-1.0.0.tar.gz (source distribution)
```

**Installing the wheel:**

```bash
# On any system with Python 3.12+
pip install dist/sqlite_dissect-1.0.0-py3-none-any.whl

# Or with uv
uv pip install dist/sqlite_dissect-1.0.0-py3-none-any.whl

# Now sqlite_dissect is available system-wide
sqlite_dissect --version
```

**Publishing to PyPI (optional):**

```bash
# Install twine
uv pip install twine

# Upload to PyPI
twine upload dist/*

# Then anyone can install with:
pip install sqlite-dissect
```

### Method 3: Standalone Executable (No Python Required)

Build a standalone executable using PyInstaller that includes Python and all dependencies:

#### Quick Build (Recommended)

```bash
# Build for your current platform (single executable file)
./build_standalone.sh onefile

# Or build as a directory bundle (faster startup)
./build_standalone.sh onedir
```

#### Manual Build

**macOS:**

```bash
# Single file executable
uv run pyinstaller pyinstaller/sqlite_dissect_macos_onefile.spec
# Output: dist/macos/bin/sqlite_dissect (11MB)

# Directory bundle (recommended for faster startup)
uv run pyinstaller pyinstaller/sqlite_dissect_macos_onedir.spec
# Output: dist/macos/sqlite_dissect/sqlite_dissect
```

**Linux:**

```bash
# Single file executable
uv run pyinstaller pyinstaller/sqlite_dissect_linux-x64_onefile.spec
# Output: dist/linux-x64/bin/sqlite_dissect

# Directory bundle
uv run pyinstaller pyinstaller/sqlite_dissect_linux-x64_onedir.spec
# Output: dist/linux-x64/sqlite_dissect/sqlite_dissect
```

**Windows:**

```bash
# Single file executable
uv run pyinstaller pyinstaller/sqlite_dissect_win-x86_64_onefile.spec
# Output: dist/win-x86_64/bin/sqlite_dissect.exe

# Directory bundle
uv run pyinstaller pyinstaller/sqlite_dissect_win-x86_64_onedir.spec
# Output: dist/win-x86_64/sqlite_dissect/sqlite_dissect.exe
```

#### Testing the Standalone Executable

```bash
# macOS/Linux
./dist/macos/bin/sqlite_dissect --version
./dist/macos/bin/sqlite_dissect --help

# Windows
dist\win-x86_64\bin\sqlite_dissect.exe --version
```

## Distribution Comparison

| Method | Size | Startup Time | Requires Python | Cross-Platform | Use Case |
|--------|------|--------------|-----------------|----------------|----------|
| Wheel | ~200KB | Fast | Yes | Yes (any Python 3.12+) | Python developers, pip install |
| Onefile | ~11MB | Slow (unpacks on start) | No | No (OS-specific) | Single executable distribution |
| Onedir | ~20MB | Fast | No | No (OS-specific) | Best performance, directory bundle |

## Build Configuration

### Project Configuration

The main configuration is in `pyproject.toml`:

```toml
[project.scripts]
sqlite_dissect = "sqlite_dissect.entrypoint:cli"
```

This defines the CLI entry point that creates the `sqlite_dissect` command.

### PyInstaller Spec Files

Spec files in `pyinstaller/` control how standalone executables are built:

- `sqlite_dissect_macos_onefile.spec` - macOS single file
- `sqlite_dissect_macos_onedir.spec` - macOS directory bundle
- `sqlite_dissect_linux-x64_onefile.spec` - Linux single file
- `sqlite_dissect_linux-x64_onedir.spec` - Linux directory bundle
- `sqlite_dissect_win-x86_64_onefile.spec` - Windows single file
- `sqlite_dissect_win-x86_64_onedir.spec` - Windows directory bundle

## Troubleshooting

### PyInstaller Build Fails

If you get errors about missing modules, add them to the `hiddenimports` list in the spec file:

```python
a = Analysis(['../main.py'],
             hiddenimports=['module_name'],
             ...)
```

### Executable is Too Large

Use the onedir build instead of onefile for better performance and to avoid unpacking overhead.

### Code Signing (macOS)

macOS may block unsigned executables. To sign:

```bash
# Sign the executable
codesign --force --sign - dist/macos/bin/sqlite_dissect

# Or allow in System Preferences > Security & Privacy
```

### Windows Defender False Positives

PyInstaller executables sometimes trigger false positives. You may need to:
1. Add an exception in Windows Defender
2. Sign the executable with a code signing certificate
3. Distribute the wheel package instead

## Clean Build

To start fresh:

```bash
# Remove all build artifacts
rm -rf build/ dist/ *.egg-info .venv

# Reinstall
uv sync
```

## Advanced: Cross-Platform Building

To build for other platforms, use a VM, Docker, or GitHub Actions:

```yaml
# .github/workflows/build.yml example
- name: Build for Linux
  run: |
    uv run pyinstaller pyinstaller/sqlite_dissect_linux-x64_onefile.spec
```
