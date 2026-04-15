
from PyInstaller.utils.hooks import collect_all, collect_data_files
import os

# LiteLLM JSON files
datas = collect_data_files('litellm')

# Build number
build_number = None
if os.path.exists("build_number.txt"):
    with open("build_number.txt", "r") as file:
        build_number = file.read().strip()
else:
    build_number = "dev"

binaries = []
hiddenimports = [
    'paramiko', 'boto3', 'botocore', 'azure.storage.blob', 'google.cloud.storage',
    'smart_open.sftp', 'smart_open.s3', 'smart_open.azure', 'smart_open.gcs',
    'smart_open.ssh', 'smart_open.webhdfs'
]

# Collect everything from flightpath/
base_path = os.path.abspath('.')
flightpath_path = os.path.join(base_path, 'flightpath')
if os.path.exists(flightpath_path):
    tmp_ret = collect_all(flightpath_path)
    datas += tmp_ret[0]
    binaries += tmp_ret[1]
    hiddenimports += tmp_ret[2]

# Add assets
assets_path = os.path.join(base_path, 'flightpath', 'assets')
if os.path.exists(assets_path):
    datas.append((assets_path, 'assets'))

# Windows icon
icon_path = os.path.join(assets_path, 'assets', 'icon.ico')

# --- ANALYSIS (shared) ---
a = Analysis(
    [os.path.join(base_path, 'flightpath', 'main.py')],
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

# --- GUI EXE ---
gui_exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='FlightPath Data',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    icon=icon_path if os.path.exists(icon_path) else None,
)

# --- SERVER EXE ---
server_script = os.path.join(base_path, 'flightpath', 'main.py')

server_exe = EXE(
    pyz,
    [server_script],
    [],
    exclude_binaries=True,
    name='FlightPath Server',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    icon=icon_path if os.path.exists(icon_path) else None,
)

# --- COLLECT ---
coll = COLLECT(
    gui_exe,
    server_exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='FlightPath',
)


