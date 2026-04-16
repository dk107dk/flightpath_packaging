from PyInstaller.utils.hooks import collect_all, collect_data_files
import os

base_path = os.path.abspath('..')
flightpath_path = os.path.join(base_path, 'flightpath')

datas = []
binaries = []
hiddenimports = []

# Mirror the Mac approach — collect_all on the whole package first
if os.path.exists(flightpath_path):
    tmp_ret = collect_all("flightpath")
    datas += tmp_ret[0]
    binaries += tmp_ret[1]
    hiddenimports += tmp_ret[2]

# Explicitly add assets (may be redundant after collect_all, but be explicit)
assets_path = os.path.join(base_path, 'flightpath', 'assets')

print(f"Assets path: {assets_path}")
print(f"Assets exists: {os.path.exists(assets_path)}")

if os.path.exists(assets_path):
    datas.append((assets_path, 'assets'))
    print(f"Datas after append: {datas[-1]}")

print("=== DATAS BEFORE LiteLLM ===")
print(f"   {len(datas)} datas found")


# litellm data — extend, don't overwrite
datas += collect_data_files('litellm')










icon_path = os.path.join(assets_path, 'icons', 'icon.ico')  # .ico not .icns

a = Analysis(
    ['../flightpath/main.py'],
    pathex=[],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)
exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='FlightPathData',
    debug=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    icon=os.path.abspath('../flightpath/assets/icons/icon.ico'),
)

