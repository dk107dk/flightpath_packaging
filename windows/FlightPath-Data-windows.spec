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
    # S3 — boto3/botocore
    'boto3',
    'boto3.session',
    'botocore',
    'botocore.session',
    'botocore.credentials',
    'botocore.regions',
    'botocore.loaders',
    'botocore.parsers',
    'botocore.serialize',
    'botocore.signers',
    's3transfer',
    's3transfer.futures',
    's3transfer.manager',
    # Azure Blob Storage
    'azure',
    'azure.storage',
    'azure.storage.blob',
    'azure.storage.blob._blob_client',
    'azure.storage.blob._container_client',
    'azure.core',
    'azure.core.credentials',
    'azure.core.pipeline',
    'azure.core.pipeline.transport',
    'azure.identity',
    # Google Cloud Storage
    'google.cloud.storage',
    'google.cloud.storage.client',
    'google.cloud.storage.blob',
    'google.cloud.storage.bucket',
    'google.auth',
    'google.auth.credentials',
    'google.auth.transport',
    'google.auth.transport.requests',
    'google.oauth2',
    'google.oauth2.credentials',
    'google.oauth2.service_account',
    
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
    console=False,
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






