# Auto-generated by EclipseNSIS Script Wizard
# May 15, 2009 1:13:57 AM

Name "OpenITG beta 1"

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"

# MUI Symbol Definitions
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install-blue-full.ico"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "OpenITG beta 1"
!define MUI_FINISHPAGE_SHOWREADME $INSTDIR\Readme.txt
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall-blue-full.ico"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI2.nsh
!include InstallOptions.nsh
!include WordFunc.nsh

!ifndef LB_ADDSTRING
!define LB_ADDSTRING 0x0180
!endif
!ifndef LB_FINDSTRING
!define LB_FINDSTRING 0x018f
!endif
!ifndef LB_DELETESTRING
!define LB_DELETESTRING 0x0182
!endif

# Variables
Var StartMenuGroup
Var HWND
Var /GLOBAL AdditionalSongFolders

# Custom Page Functions
Function ASFCreate
    !insertmacro MUI_HEADER_TEXT "Additional Song Folders" "Specify Song group directories used before"
    !insertmacro INSTALLOPTIONS_INITDIALOG "ASF.ini"
    Pop $HWND
    GetDlgItem $0 $HWND 1203
    EnableWindow $0 0
    !insertmacro INSTALLOPTIONS_SHOW
FunctionEnd

Function ASFLeave
    !insertmacro INSTALLOPTIONS_READ $0 "ASF.ini" "Settings" "State"
    !insertmacro INSTALLOPTIONS_READ $R0 "ASF.ini" "Field 1" "State"
    !insertmacro INSTALLOPTIONS_READ $R1 "ASF.ini" "Field 4" "State"
    ;MessageBox MB_OK '$$0 = $0'
    ;MessageBox MB_OK '$$R1 = $R1'
    StrCmp $0 0 GoNext
    StrCmp $0 1 AddToFoldersList
    StrCmp $0 2 AddToFoldersList
    StrCmp $0 3 DeleteFromFoldersList
    StrCmp $0 4 SelectFromFoldersList
    abort
    
    AddToFoldersList:
    IfFileExists $R0 +4
    StrCmp $R0 '' +2
    MessageBox MB_OK 'Folder does not exist'
    abort
    GetDlgItem $1 $HWND 1204
    SendMessage $1 ${LB_FINDSTRING} 1 "STR:$R0" $0
    StrCmp $0 -1 +2
    MessageBox MB_OK 'Folder already in Additional Song Folders list' IDOK +2
    SendMessage $1 ${LB_ADDSTRING} 1 "STR:$R0"
    GetDlgItem $1 $HWND 1200
    SendMessage $1 ${WM_SETTEXT} 0 'STR:'
    abort
    
    SelectFromFoldersList:
    GetDlgItem $1 $HWND 1203
    StrCmp $R0 '' +3
    EnableWindow $1 1
    abort
    EnableWindow $1 0
    abort
    
    DeleteFromFoldersList:
    ;MessageBox MB_OK '$$R1 = $R1'
    StrCmp $R1 '' End 
    GetDlgItem $1 $HWND 1204
    SendMessage $1 ${LB_FINDSTRING} 1 "STR:$R1" $0
    ;MessageBox MB_OK '$$0 = $0'
    SendMessage $1 ${LB_DELETESTRING} $0 1
    GetDlgItem $1 $HWND 1203
    EnableWindow $1 0
    
    End:    
    abort
    
    GoNext:
    GetDlgItem $1 $HWND 1204
    SendMessage $1 ${LB_GETCOUNT} 0 0 $2
    ;MessageBox MB_OK '# of AdditionalFolders: $2'
    IntOp $0 0 + 0
    Loop_ASF:
    System::Call 'user32::SendMessage(i $1, i ${LB_GETTEXT}, i $0, t .r3)'
    ;MessageBox MB_OK 'Text ($0): $3'
    ${WordAdd} '$AdditionalSongFolders' ',' '+$3' $AdditionalSongFolders
    IntOp $0 $0 + 1
    StrCmp $0 $2 +1 Loop_ASF
    ;MessageBox MB_OK 'AdditionalSongFolders: $AdditionalSongFolders'
FunctionEnd

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
Page custom ASFCreate ASFLeave
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile OpenITG-beta2-setup.exe
InstallDir "$PROGRAMFILES\OpenITG beta 1"
CRCCheck on
XPStyle on
ShowInstDetails show
InstallDirRegKey HKLM "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File /r /x OpenITG-beta2-setup.exe /x src /x setup.nsi /x ASF.ini *
    SetOutPath $INSTDIR\Program
    File ..\Program\zlib1.dll
    File ..\Program\avcodec.dll
    File ..\Program\avformat.dll
    File ..\Program\dbghelp.dll
    File ..\Program\jpeg.dll
    File ..\Program\libusb0.dll
    File ..\Program\msvcp70.dll
    File ..\Program\msvcp71.dll
    File ..\Program\msvcr70.dll
    File ..\Program\msvcr71.dll
    File ..\Program\OpenITG-PC.exe
    File ..\Program\OpenITG-PC.vdi
    File ..\Program\OpenITG-PC-SSE2.exe
    File ..\Program\OpenITG-PC-SSE2.vdi
    File ..\Program\resample.dll
    File ..\Program\sdl.dll
    WriteRegStr HKLM "${REGKEY}\Components" Main 1
SectionEnd

Section -post SEC0001
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    FileOpen $0 $INSTDIR\Data\StepMania.ini a
    IfErrors continue
    FileSeek $0 0 END
    FileWrite $0 '$\r$\nAdditionalSongFolders='
    FileWrite $0 '$AdditionalSongFolders$\r$\n'
    FileClose $0
    continue:
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^Name).lnk" $INSTDIR\Program\OpenITG-PC.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^Name) (SSE2).lnk" $INSTDIR\Program\OpenITG-PC-SSE2.exe
    CreateShortCut "$DESKTOP\$(^Name).lnk" $INSTDIR\Program\OpenITG-PC.exe
    CreateShortCut "$DESKTOP\$(^Name) (SSE2).lnk" $INSTDIR\Program\OpenITG-PC-SSE2.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    Delete /REBOOTOK $INSTDIR\Program\sdl.dll
    Delete /REBOOTOK $INSTDIR\Program\resample.dll
    Delete /REBOOTOK $INSTDIR\Program\OpenITG-PC-SSE2.vdi
    Delete /REBOOTOK $INSTDIR\Program\OpenITG-PC-SSE2.exe
    Delete /REBOOTOK $INSTDIR\Program\OpenITG-PC.vdi
    Delete /REBOOTOK $INSTDIR\Program\OpenITG-PC.exe
    Delete /REBOOTOK $INSTDIR\Program\msvcr71.dll
    Delete /REBOOTOK $INSTDIR\Program\msvcr70.dll
    Delete /REBOOTOK $INSTDIR\Program\msvcp71.dll
    Delete /REBOOTOK $INSTDIR\Program\msvcp70.dll
    Delete /REBOOTOK $INSTDIR\Program\libusb0.dll
    Delete /REBOOTOK $INSTDIR\Program\jpeg.dll
    Delete /REBOOTOK $INSTDIR\Program\dbghelp.dll
    Delete /REBOOTOK $INSTDIR\Program\avformat.dll
    Delete /REBOOTOK $INSTDIR\Program\avcodec.dll
    Delete /REBOOTOK $INSTDIR\Program\zlib1.dll
    RmDir /r /REBOOTOK $INSTDIR
    DeleteRegValue HKLM "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^Name).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^Name) (SSE2).lnk"
    Delete "$DESKTOP\$(^Name).lnk"
    Delete "$DESKTOP\$(^Name) (SSE2).lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    !insertmacro INSTALLOPTIONS_EXTRACT_AS "ASF.ini" "ASF.ini"
    InitPluginsDir
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

