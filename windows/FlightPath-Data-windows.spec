from PyInstaller.utils.hooks import collect_all, collect_data_files
import os

base_path = os.path.abspath('..')
flightpath_path = os.path.join(base_path, 'flightpath')
print(f"flightpath_path: {flightpath_path}")

datas = []
binaries = []
hiddenimports = []

tmp_ret = collect_all("flightpath")
datas += tmp_ret[0]
binaries += tmp_ret[1]
hiddenimports += tmp_ret[2]

tmp_ret = collect_all("flightpath_generator")
gdatas = tmp_ret[0]
gbinaries = tmp_ret[1]
ghiddenimports = tmp_ret[2]

tmp_ret = collect_all("smart_open")
cdatas = tmp_ret[0]
cbinaries = tmp_ret[1]
chiddenimports = tmp_ret[2]

hiddenimports += [ 
    # smart-open core 
    'smart_open', 
    'smart_open.ssh',
    # the SFTP/SSH transport 
    'smart_open.local_file', 
    'smart_open.http', 
    'smart_open.compression', 
    # Paramiko (SFTP underlying library) 
    'paramiko', 
    'paramiko.transport', 
    'paramiko.sftp_client', 
    'paramiko.sftp_file', 
    'paramiko.auth_handler', 
    'paramiko.ed25519key', 
    'paramiko.ecdsakey', 
    # cryptography backend that paramiko pulls in 
    'cryptography.hazmat.primitives.asymmetric.ed25519', 
]

hiddenimports += ['tiktoken_ext.openai_public', 'tiktoken_ext']

assets_path = os.path.join(base_path, 'flightpath', 'assets')

if os.path.exists(assets_path):
    datas.append((assets_path, 'assets'))
    print(f"Datas after append: {datas[-1]}")

# litellm data — extend, don't overwrite
datas += collect_data_files('litellm')

datas += gdatas
binaries += gbinaries
hiddenimports += ghiddenimports
datas += cdatas
binaries += cbinaries
hiddenimports += chiddenimports


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
    console=True,
    disable_windowed_traceback=False,
    icon=os.path.abspath('../flightpath/assets/icons/icon.ico'),
)
#
#
print("\n\n=============== SERVER =================\n\n")
#
a = Analysis(
    ['../flightpath/server.py'],
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
    name='FlightPathServer',
    debug=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    icon=os.path.abspath('../flightpath/assets/icons/icon.ico'),
)






