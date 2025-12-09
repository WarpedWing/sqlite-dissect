# Initially generated with the "pyinstaller main.py" command.  Altered after for minor changes.
# Consecutively run after modifications from the project root directory as:
# pyinstaller pyinstaller\sqlite_dissect_win-x86_64_onedir.spec
# -*- mode: python -*-

import PyInstaller.config

PyInstaller.config.CONF['distpath'] = "./dist/win-x86_64"

block_cipher = None


a = Analysis(['../main.py'],
             pathex=[],
             binaries=[],
             datas=[],
             hiddenimports=[
                 'sqlite_dissect',
                 'sqlite_dissect.file',
                 'sqlite_dissect.file.database',
                 'sqlite_dissect.file.journal',
                 'sqlite_dissect.file.schema',
                 'sqlite_dissect.file.wal',
                 'sqlite_dissect.file.wal_index',
                 'sqlite_dissect.carving',
                 'sqlite_dissect.export',
                 'sqlite_dissect.tests',
                 'sqlite_dissect.version_history',
                 'sqlite_dissect.entrypoint',
                 'sqlite_dissect.interface',
                 'sqlite_dissect.utilities',
                 'sqlite_dissect.output',
                 'sqlite_dissect.constants',
                 'sqlite_dissect.exception',
             ],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=True,
          name='sqlite_dissect',
          debug=False,
          strip=False,
          upx=True,
          console=True )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               name='sqlite_dissect')
