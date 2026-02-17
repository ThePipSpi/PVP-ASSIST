# Installation Package Information

## Package Contents

This repository contains a complete World of Warcraft addon for PVP Honor and Conquest tracking.

### Required Files for Installation

To install the addon, you only need these 3 files:

1. **PVPAssist.toc** - Addon table of contents (manifest)
2. **Core.lua** - Core functionality and data management
3. **UI.lua** - User interface and display logic

### Optional Files (Documentation)

The following files are documentation and not required for the addon to function:

- README.md - Main documentation
- INSTALLAZIONE.md - Italian installation guide
- QUICKSTART.md - Quick reference
- UI_GUIDE.md - UI visual documentation
- API_NOTES.md - API integration notes
- ARCHITECTURE.md - Technical architecture
- TESTING.md - Testing procedures
- DEVELOPER.md - Developer guide
- CHANGELOG.md - Version history
- .gitignore - Git configuration

## Quick Installation Steps

### Method 1: Manual Installation

1. **Download these 3 files:**
   - PVPAssist.toc
   - Core.lua
   - UI.lua

2. **Create addon folder:**
   - Windows: `C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\PVP-ASSIST\`
   - Mac: `/Applications/World of Warcraft/_retail_/Interface/AddOns/PVP-ASSIST/`

3. **Copy the 3 files into the PVP-ASSIST folder**

4. **Restart WoW or use `/reload`**

### Method 2: Full Repository Clone

If you want all documentation as well:

```bash
cd "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\"
git clone https://github.com/ThePipSpi/PVP-ASSIST.git
```

Then restart WoW or use `/reload`.

## Verification

After installation, you should see:
- Message on login: "PVP Assist loaded! Type /pvpassist to open the tracker."
- Addon in character select addon list
- Minimap button with PVP sword icon

## Folder Structure

```
WoW/_retail_/Interface/AddOns/PVP-ASSIST/
├── PVPAssist.toc          ← Required
├── Core.lua               ← Required
├── UI.lua                 ← Required
├── README.md              ← Optional (documentation)
├── INSTALLAZIONE.md       ← Optional (documentation)
├── QUICKSTART.md          ← Optional (documentation)
├── UI_GUIDE.md            ← Optional (documentation)
├── API_NOTES.md           ← Optional (documentation)
├── ARCHITECTURE.md        ← Optional (documentation)
├── TESTING.md             ← Optional (documentation)
├── DEVELOPER.md           ← Optional (documentation)
├── CHANGELOG.md           ← Optional (documentation)
└── .gitignore             ← Optional (git config)
```

## File Sizes

- PVPAssist.toc: < 1 KB
- Core.lua: ~6 KB
- UI.lua: ~10 KB
- **Total required:** ~17 KB
- **Total with docs:** ~50 KB

## Platform Compatibility

- ✅ Windows
- ✅ Mac
- ✅ Linux (with WoW installed)

## WoW Version Compatibility

- **Interface:** 110002 (The War Within / Dragonflight)
- **Client:** Retail (NOT Classic or Classic Era)
- **Tested on:** Latest retail version

## Distribution

This addon can be:
- ✅ Shared freely
- ✅ Modified and redistributed
- ✅ Uploaded to CurseForge/Wago
- ✅ Included in addon packs

**Note:** Please maintain attribution to original author (ThePipSpi)

## Support

For issues or questions:
- GitHub Issues: https://github.com/ThePipSpi/PVP-ASSIST/issues
- Check TESTING.md for troubleshooting
- Check README.md for usage instructions

## Version

Current Version: **1.0.0**

Release Date: February 17, 2026

## Author

ThePipSpi

## License

Open source - Free to use and modify
