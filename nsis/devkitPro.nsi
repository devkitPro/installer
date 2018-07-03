RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)

; plugins required
; untgz          - http://nsis.sourceforge.net/UnTGZ_plug-in
; inetc          - http://nsis.sourceforge.net/Inetc_plug-in
;                  http://forums.winamp.com/showthread.php?s=&threadid=198596&perpage=40&highlight=&pagenumber=4
;                  http://forums.winamp.com/attachment.php?s=&postid=1831346
; ReplaceInFile  - http://nsis.sourceforge.net/ReplaceInFile
; NSIS 7zip      - http://nsis.sourceforge.net/Nsis7z_plug-in
; NTProfiles.nsh - http://nsis.sourceforge.net/NT_Profile_Paths
; AccessControl  - http://nsis.sourceforge.net/AccessControl_plug-in


; NSIS large strings build from http://nsis.sourceforge.net/Special_Builds

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "devkitProUpdater"
!define PRODUCT_VERSION "3.0.3"
!define PRODUCT_PUBLISHER "devkitPro"
!define PRODUCT_WEB_SITE "http://www.devkitpro.org"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"
!define BUILD "56"

SetCompressor /SOLID lzma

; MUI 1.67 compatible ------
!include "MUI2.nsh"
!include "Sections.nsh"
!include "StrFunc.nsh"
!include "InstallOptions.nsh"
!include "ReplaceInFile.nsh"
!include "NTProfiles.nsh"
!include LogicLib.nsh
!include x64.nsh

;${StrTok}
${StrRep}
${UnStrRep}

; StrContains
; This function does a case sensitive searches for an occurrence of a substring in a string.
; It returns the substring if it is found.
; Otherwise it returns null("").
; Written by kenglish_hi
; Adapted from StrReplace written by dandaman32


Var STR_HAYSTACK
Var STR_NEEDLE
Var STR_CONTAINS_VAR_1
Var STR_CONTAINS_VAR_2
Var STR_CONTAINS_VAR_3
Var STR_CONTAINS_VAR_4
Var STR_RETURN_VAR

Function StrContains
  Exch $STR_NEEDLE
  Exch 1
  Exch $STR_HAYSTACK
  ; Uncomment to debug
  ;MessageBox MB_OK 'STR_NEEDLE = $STR_NEEDLE STR_HAYSTACK = $STR_HAYSTACK '
    StrCpy $STR_RETURN_VAR ""
    StrCpy $STR_CONTAINS_VAR_1 -1
    StrLen $STR_CONTAINS_VAR_2 $STR_NEEDLE
    StrLen $STR_CONTAINS_VAR_4 $STR_HAYSTACK
    loop:
      IntOp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_1 + 1
      StrCpy $STR_CONTAINS_VAR_3 $STR_HAYSTACK $STR_CONTAINS_VAR_2 $STR_CONTAINS_VAR_1
      StrCmp $STR_CONTAINS_VAR_3 $STR_NEEDLE found
      StrCmp $STR_CONTAINS_VAR_1 $STR_CONTAINS_VAR_4 done
      Goto loop
    found:
      StrCpy $STR_RETURN_VAR $STR_NEEDLE
      Goto done
    done:
   Pop $STR_NEEDLE ;Prevent "invalid opcode" errors and keep the
   Exch $STR_RETURN_VAR
FunctionEnd

!macro _StrContainsConstructor OUT NEEDLE HAYSTACK
  Push "${HAYSTACK}"
  Push "${NEEDLE}"
  Call StrContains
  Pop "${OUT}"
!macroend

!define StrContains '!insertmacro "_StrContainsConstructor"'


; MUI Settings
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "devkitPro.bmp" ; optional
!define MUI_ABORTWARNING
; "Are you sure you want to quit ${PRODUCT_NAME} ${PRODUCT_VERSION}?"
!define MUI_COMPONENTSPAGE_SMALLDESC

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${PRODUCT_NAME}$\r$\nVersion ${PRODUCT_VERSION}"
!define MUI_WELCOMEPAGE_TEXT "${PRODUCT_NAME} automates the process of downloading, installing, and uninstalling devkitPro Components.$\r$\n$\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

Page custom ChooseMirrorPage
Page custom KeepFilesPage

var ChooseMessage

; Components page
!define MUI_PAGE_HEADER_SUBTEXT $ChooseMessage
!insertmacro MUI_PAGE_COMPONENTS

; Directory page
!define MUI_PAGE_HEADER_SUBTEXT "Choose the folder in which to install devkitPro."
!define MUI_DIRECTORYPAGE_TEXT_TOP "${PRODUCT_NAME} will install devkitPro components in the following directory. To install in a different folder click Browse and select another folder. Click Next to continue."
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortPage
!insertmacro MUI_PAGE_DIRECTORY

; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "devkitPro"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortPage
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP

var INSTALL_ACTION
; Instfiles page
!define MUI_PAGE_HEADER_SUBTEXT $INSTALL_ACTION
!define MUI_INSTFILESPAGE_ABORTHEADER_TEXT "Installation Aborted"
!define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT "The installation was not completed successfully."
!insertmacro MUI_PAGE_INSTFILES

var FINISH_TITLE
var FINISH_TEXT

; Finish page
;!define MUI_FINISHPAGE_TITLE $FINISH_TITLE
;!define MUI_FINISHPAGE_TEXT $FINISH_TEXT
;!define MUI_FINISHPAGE_TEXT_LARGE $INSTALLED_TEXT
;!define MUI_PAGE_CUSTOMFUNCTION_PRE FinishPagePre
;!define MUI_PAGE_CUSTOMFUNCTION_SHOW FinishPageShow
;!insertmacro MUI_PAGE_FINISH
Page custom FinishPage

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
;!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
Caption "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"
InstallDir "c:\devkitPro"
ShowInstDetails hide
ShowUnInstDetails show

var Install
var Updating
var MSYS2
var MSYS2_VER

var BASEDIR
var Updates

Section "Minimal System" SecMsys
SectionEnd

Section "Switch Development" SecSwitchDev
SectionEnd
Section "GBA Development" SecGBADev
SectionEnd
Section "GP32 Development" SecGp32Dev
SectionEnd
Section "NDS Development" SecNDSDev
SectionEnd
Section "3DS Development" Sec3DSDev
SectionEnd
Section "Gamecube Development" SecGameCubeDev
SectionEnd
Section "Wii Development" SecWiiDev
SectionEnd

Section -installComponents

  SetAutoClose false

  StrCpy $R0 $INSTDIR 1
  StrLen $0 $INSTDIR
  IntOp $0 $0 - 2

  StrCpy $R1 $INSTDIR $0 2
  ${StrRep} $R1 $R1 "\" "/"
  StrCpy $BASEDIR /$R0$R1

  push ${SecMsys}
  push $MSYS2
  Call DownloadIfNeeded

  SetDetailsView show

  IntCmp $Install 1 +1 SkipInstall SkipInstall

  IntCmp $Updating 1 test_Msys +1 +1

  CreateDirectory $INSTDIR

test_Msys:
  !insertmacro SectionFlagIsSet ${SecMsys} ${SF_SELECTED} install_Msys SkipMsys

install_Msys:
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  SetDetailsPrint both

  Nsis7z::ExtractWithDetails "$EXEDIR\$MSYS2" "Installing package %s..."
  WriteINIStr $INSTDIR\installed.ini msys2 Version $MSYS2_VER
  push $MSYS2
  call RemoveFile


  !insertmacro _ReplaceInFile "$INSTDIR\msys2\etc\fstab" "#{DEVKITPRO}" "$INSTDIR"

  ${ProfilesPath} $0
  !insertmacro _ReplaceInFile "$INSTDIR\msys2\etc\fstab" "#{PROFILES_ROOT}" "$0"

  AccessControl::GrantOnFile "$INSTDIR\msys2\etc\fstab" "(BU)" "GenericRead"
  pop $0

  Delete "$INSTDIR\msys2\etc\fstab.old"

  ExecWait '"$INSTDIR\msys2\usr\bin\bash.exe" --login -c exit'

  ; Reset msys path to start of path
  ReadRegStr $1 HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH"
  ; remove it to avoid multiple paths with separate installs
  ${StrRep} $2 $1 "$INSTDIR\msys\bin;" ""
  ${StrRep} $2 $2 "$INSTDIR\msys2\usr\bin;" ""
  StrCmp $2 "" 0 WritePath

  MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Trying to set path to blank string!$\nPlease add $INSTDIR\msys2\usr\bin; to the start of your path"
  goto AbortPath

WritePath:
  StrCpy $2 "$INSTDIR\msys2\usr\bin;$2"
  WriteRegExpandStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH" $2
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
AbortPath:

SkipMsys:

  ExecWait '"$INSTDIR\msys2\usr\bin\pacman.exe" -Syu --noconfirm'

  push "GBADev"
  push "gba-dev"
  push ${SecGBADev}
  call updateGroup

  push "GP32Dev"
  push "gp32-dev"
  push ${SecGP32Dev}
  call updateGroup

  push "NDSDev"
  push "nds-dev"
  push ${SecNDSDev}
  call updateGroup

  push "3DSDev"
  push "3ds-dev"
  push ${Sec3DSDev}
  call updateGroup

  push "GameCubeDev"
  push "gamecube-dev"
  push ${SecGameCubeDev}
  call updateGroup

  push "WiiDev"
  push "wii-dev"
  push ${SecWiiDev}
  call updateGroup

  push "SwitchDev"
  push "switch-dev"
  push ${SecSwitchDev}
  call updateGroup

  
  Strcpy $R1 "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"

  Delete $INSTDIR\devkitProUpdater*.*
  StrCmp $EXEDIR $INSTDIR skip_copy

  CopyFiles "$EXEDIR\$R1" "$INSTDIR\$R1"
skip_copy:

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  SetShellVarContext all ; Put stuff in All Users
  SetOutPath $INSTDIR

  IntCmp $Updating 1 CheckMsys2

  WriteIniStr "$INSTDIR\devkitPro.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\devkitpro.lnk" "$INSTDIR\devkitPro.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"

CheckMsys2:
  !insertmacro SectionFlagIsSet ${SecMsys} ${SF_SELECTED} +1 UpdateVars

  SetOutPath "$INSTDIR\msys2"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\MSys2.lnk" "$INSTDIR\msys2\msys2_shell.bat" "" "$INSTDIR\msys2\msys2.ico"

UpdateVars:
  SetOutPath $INSTDIR
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Update.lnk" "$INSTDIR\$R1"
  !insertmacro MUI_STARTMENU_WRITE_END

  WriteUninstaller "$INSTDIR\uninst.exe"
  IntCmp $Updating 1 SkipInstall

  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

SkipInstall:
  WriteRegStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITPRO" "/opt/devkitpro"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  WriteRegStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITARM" "/opt/devkitpro/devkitARM"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  WriteRegStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITPPC" "/opt/devkitpro/devkitPPC"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  ; write the version to the reg key so add/remove prograns has the right one
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"

SectionEnd

Section Uninstall
  SetShellVarContext all ; remove stuff from All Users
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
  RMDir /r "$SMPROGRAMS\$ICONS_GROUP"
  RMDir /r $INSTDIR

  ReadRegStr $1 HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH"
  ${UnStrRep} $1 $1 "$INSTDIR\msys\bin;" ""
  ${UnStrRep} $1 $1 "$INSTDIR\msys2\usr\bin;" ""

  StrCmp $1 "" 0 ResetPath

  MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Trying to set path to blank string!$\nPlease reset path manually"
  goto BlankedPath

ResetPath:
  WriteRegExpandStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH" $1
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

BlankedPath:
  DeleteRegKey HKCR ".pnproj"
  DeleteRegKey HKCR "PN2.pnproj.1\shell\open\command"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"

  DeleteRegValue HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITPPC"
  DeleteRegValue HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITPSP"
  DeleteRegValue HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITARM"
  DeleteRegValue HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITPRO"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  SetAutoClose true
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecMsys} "unix style tools for windows"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecSwitchDev} "tools for Switch development"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGBADev} "tools for GBA development"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGP32Dev} "tools for GP32 development"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecNDSDev} "tools for NDS development"
  !insertmacro MUI_DESCRIPTION_TEXT ${Sec3DSDev} "tools for 3DS development"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecGameCubeDev} "tools for Gamecube development"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecWiiDev} "tools for Wii development"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

var keepINI
var mirrorINI

;-----------------------------------------------------------------------------------------------------------------------
Function .onInit
;-----------------------------------------------------------------------------------------------------------------------

${If} ${RunningX64}
${Else}
  MessageBox mb_IconStop|mb_TopMost|mb_SetForeground "Sorry, this installer only supports 64 bit."
  Quit
${EndIf}  


  ; test existing ini file version
  ; if lower than build then use built in ini
  ifFileExists $EXEDIR\devkitProUpdate.ini +1 extractINI

  ReadINIStr $R1 "$EXEDIR\devkitProUpdate.ini" "devkitProUpdate" "Build"
  IntCmp ${BUILD} $R1 downloadINI downloadINI +1

extractINI:

  ; extract built in ini file
  File "/oname=$EXEDIR\devkitProUpdate.ini" INIfiles\devkitProUpdate.ini
  ReadINIStr $R1 "$EXEDIR\devkitProUpdate.ini" "devkitProUpdate" "Build"

downloadINI:
  ; save the current ini file in case download fails
  Rename $EXEDIR\devkitProUpdate.ini $EXEDIR\devkitProUpdate.ini.old

  ; Quietly download the latest devkitProUpdate.ini file
  inetc::get  /BANNER "Checking for updates ..." "https://downloads.devkitpro.org/devkitProUpdate.ini" "$EXEDIR\devkitProUpdate.ini" /END

  pop $R0

  StrCmp $R0 "OK" gotINI

  ; download failed so retrieve old file
  Rename $EXEDIR\devkitProUpdate.ini.old $EXEDIR\devkitProUpdate.ini

gotINI:
  ; Read devkitProUpdate build info from INI file
  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "devkitProUpdate" "Build"

  IntCmp ${BUILD} $R0 Finish newVersion +1

    ; downloaded ini older than current
    Delete $EXEDIR\devkitProUpdate.ini
    Rename $EXEDIR\devkitProUpdate.ini.old $EXEDIR\devkitProUpdate.ini
    Goto gotINI

  newVersion:
    MessageBox MB_YESNO|MB_ICONINFORMATION|MB_DEFBUTTON1 "A newer version of devkitProUpdater is available. Would you like to upgrade now?" IDYES upgradeMe IDNO Finish

  upgradeMe:
    Call UpgradedevkitProUpdate
  Finish:

  Delete $EXEDIR\devkitProUpdate.ini.old

  StrCpy $Updating 0

  StrCpy $ChooseMessage "Choose the devkitPro components you would like to install."

  ReadRegStr $1 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation"
  StrCmp $1 "" installing

  StrCpy $INSTDIR $1

  ; if the user has deleted installed.ini then revert to first install mode
  ifFileExists $INSTDIR\installed.ini +1 installing

  StrCpy $Updating 1

  StrCpy $ChooseMessage "Choose the devkitPro components you would like to update."

installing:

  IntOp $0 ${SF_SELECTED} | ${SF_RO}
  SectionSetFlags ${SecMsys} $0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "msys2" "Size"
  ReadINIStr $MSYS2 "$EXEDIR\devkitProUpdate.ini" "msys2" "File"
  ReadINIStr $MSYS2_VER "$EXEDIR\devkitProUpdate.ini" "msys2" "Version"
  SectionSetSize ${SecMsys} $R0

  !insertmacro INSTALLOPTIONS_EXTRACT_AS "Dialogs\PickMirror.ini" "PickMirror.ini"

  GetTempFileName $keepINI $PLUGINSDIR
  File /oname=$keepINI "Dialogs\keepfiles.ini"

  GetTempFileName $mirrorINI $PLUGINSDIR
  File /oname=$mirrorINI "Dialogs\PickMirror.ini"

  IntCmp $Updating 1 +1 first_install

  StrCpy $Updates 0

  push "msys2"
  push $MSYS2_VER
  push ${SecMsys}
  call checkVersion

  push "GBADev"
  push ${SecGBADev}
  call checkEnabled

  push "GP32Dev"
  push ${SecGP32Dev}
  call checkEnabled

  push "NDSDev"
  push ${SecNDSDev}
  call checkEnabled

  push "3DSDev"
  push ${Sec3DSDev}
  call checkEnabled

  push "GameCubeDev"
  push ${SecGameCubeDev}
  call checkEnabled

  push "WiiDev"
  push ${SecWiiDev}
  call checkEnabled

  push "SwitchDev"
  push ${SecSwitchDev}
  call checkEnabled

first_install:

FunctionEnd

var CurrentVer
var InstalledVer
var PackageSection
var PackageFlags
var key
var isNew

;-----------------------------------------------------------------------------------------------------------------------
Function checkVersion
;-----------------------------------------------------------------------------------------------------------------------
  pop $PackageSection
  pop $CurrentVer
  pop $key

  ReadINIStr $InstalledVEr "$INSTDIR\installed.ini" "$key" "Version"

  IntOp $isNew 0 + 0

  ; check for blank installed version
  StrLen $0 $InstalledVer
  IntCmp $0 0 +1 gotinstalled gotinstalled

  StrCpy $InstalledVer 0
  WriteINIStr $INSTDIR\installed.ini "$key" "Version" "0"

  IntOp $isNew 0 + 1

gotinstalled:

  SectionGetFlags $PackageSection $PackageFlags

  IntOp $R1 ${SF_RO} ~
  IntOp $PackageFlags $PackageFlags & $R1
  IntOp $PackageFlags $PackageFlags & ${SECTION_OFF}

  StrCmp $CurrentVer $InstalledVer noupdate

  Intop $Updates $Updates + 1

  IntCmp $isNew 1 selectit noselectit noselectit

noselectit:
  ; don't select if not installed
  StrCmp $InstalledVer 0 done

selectit:
  IntOp $PackageFlags $PackageFlags | ${SF_SELECTED}

  Goto done

noupdate:

  SectionSetText $PackageSection ""

done:
  SectionSetFlags $PackageSection $PackageFlags

FunctionEnd

var Enabled
;-----------------------------------------------------------------------------------------------------------------------
Function checkEnabled
;-----------------------------------------------------------------------------------------------------------------------
  pop $PackageSection
  pop $key

  ReadINIStr $Enabled "$INSTDIR\installed.ini" "$key" "Enabled"

  ; check for blank enabled key
  StrLen $0 $Enabled
  IntCmp $0 0 +1 gotinstalled gotinstalled

  StrCpy $Enabled  1
  WriteINIStr $INSTDIR\installed.ini "$key" "Enabled" "1"

gotinstalled:

  SectionGetFlags $PackageSection $PackageFlags

  IntOp $R1 ${SF_RO} ~
  IntOp $PackageFlags $PackageFlags & $R1
  IntOp $PackageFlags $PackageFlags & ${SECTION_OFF}

  IntCmp $Enabled 1 selectit noselectit noselectit

selectit:
  IntOp $PackageFlags $PackageFlags | ${SF_SELECTED}

noselectit:

  SectionSetFlags $PackageSection $PackageFlags

FunctionEnd

var group

;-----------------------------------------------------------------------------------------------------------------------
Function updateGroup
;-----------------------------------------------------------------------------------------------------------------------
  pop $PackageSection
  pop $group
  pop $key

  StrCpy $Enabled  0

  SectionGetFlags $PackageSection $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} +1 skipUpdate

  StrCpy $Enabled  1

  ExecWait '"$INSTDIR\msys2\usr\bin\pacman.exe" -S $group --noconfirm --needed'

skipUpdate:
  WriteINIStr $INSTDIR\installed.ini "$key" "Enabled" "$Enabled"

FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function .onVerifyInstDir
;-----------------------------------------------------------------------------------------------------------------------
  ${StrContains} $0 " " $INSTDIR
  StrCmp $0 "" PathGood
    Abort
PathGood:
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function un.onUninstSuccess
;-----------------------------------------------------------------------------------------------------------------------
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "All devkitPro packages were successfully removed from your computer."
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function un.onInit
;-----------------------------------------------------------------------------------------------------------------------
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove all devkitPro packages?" IDYES +2
  Abort

  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you absolutely sure you want to do this?$\r$\nThis will remove the whole devkitPro folder and it's contents." IDYES +2
  Abort

FunctionEnd



;-----------------------------------------------------------------------------------------------------------------------
; Check for a newer version of the installer, download and ask the user if they want to run it
;-----------------------------------------------------------------------------------------------------------------------
Function UpgradedevkitProUpdate
;-----------------------------------------------------------------------------------------------------------------------
  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "devkitProUpdate" "URL"
  ReadINIStr $R1 "$EXEDIR\devkitProUpdate.ini" "devkitProUpdate" "Filename"

  DetailPrint "Downloading new version of devkitProUpdater..."
  inetc::get /BANNER "Downloading new version of devkitProUpdater..." /RESUME "" "$R0/$R1" "$EXEDIR\$R1" /END
  Pop $0
  StrCmp $0 "OK" success
    ; Failure
    SetDetailsView show
    DetailPrint "Download failed: $0"
    Abort

  success:
    MessageBox MB_YESNO|MB_ICONQUESTION "Would you like to run the new version of devkitProUpdater now?" IDYES runNew
    return

  runNew:
    Exec "$EXEDIR\$R1"
    Quit
FunctionEnd


;-----------------------------------------------------------------------------------------------------------------------
Function AbortPage
;-----------------------------------------------------------------------------------------------------------------------

  IntCmp $Updating 1 +1 TestInstall TestInstall
    Abort

TestInstall:
  IntCmp $Install 1 ShowPage +1 +1
    Abort

ShowPage:
FunctionEnd

var FileName
var Section
var retry

;-----------------------------------------------------------------------------------------------------------------------
Function DownloadIfNeeded
;-----------------------------------------------------------------------------------------------------------------------
  pop $FileName  ; Filename
  pop $Section  ; section flags


  SectionGetFlags $Section $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} +1 SkipThisDL


  ifFileExists "$EXEDIR\$FileName" ThisFileFound


  StrCpy $retry 3

retryLoop:
  inetc::get /RESUME "" "https://downloads.devkitpro.org/$FileName" "$EXEDIR\$FileName" /END
  Pop $0
  StrCmp $0 "OK" ThisFileFound

  IntOp $retry $retry - 1
  IntCmp $retry 0 +1 +1 retryLoop

  detailprint $0
  ; zero byte files tend to be left at this point
  ; delete it so the installer doesn't decide the file exists and break when trying to extract
  Delete "$EXEDIR\$Filename"
  abort "$FileName could not be downloaded at this time."

ThisFileFound:
SkipThisDL:

FunctionEnd


var keepfiles
;-----------------------------------------------------------------------------------------------------------------------
Function KeepFilesPage
;-----------------------------------------------------------------------------------------------------------------------
  StrCpy $keepfiles 0
  IntCmp $Install 0 nodisplay

  IntCmp $Updating 1 +1 defaultkeep

  WriteINIStr $keepINI "Field 3" "State" 0
  WriteINIStr $keepINI "Field 2" "State" 1
  FlushINI $keepINI

defaultkeep:

  InstallOptions::initDialog /NOUNLOAD "$keepINI"
  InstallOptions::show

  ReadINIStr $keepfiles "$keepINI" "Field 3" "State"

nodisplay:
FunctionEnd


;-----------------------------------------------------------------------------------------------------------------------
; delete an archive unless the user has elected to keep downloaded files
;-----------------------------------------------------------------------------------------------------------------------
Function RemoveFile
;-----------------------------------------------------------------------------------------------------------------------
  pop $filename
  IntCmp $keepfiles 1 keepit

  Delete "$EXEDIR\$filename"

keepit:

FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function ChooseMirrorPage
;-----------------------------------------------------------------------------------------------------------------------
  IntCmp $Updating 1 update +1

  InstallOptions::initDialog /NOUNLOAD "$mirrorINI"
  InstallOptions::show

  ReadINIStr $Install "$mirrorINI" "Field 2" "State"
  IntCmp $Install 1 install +1

  StrCpy $INSTALL_ACTION "Please wait while ${PRODUCT_NAME} downloads the components you selected."
  StrCpy $FINISH_TITLE "Download complete."
  StrCpy $FINISH_TEXT "${PRODUCT_NAME} has finished downloading the components you selected. To install the package please run the installer again and select the download and install option. To install on a machine with no net access copy all the files downloaded by this process, the installer will use the files in the same directory instead of downloading."

  Goto done

install:
  StrCpy $INSTALL_ACTION "Please wait while ${PRODUCT_NAME} downloads and installs the components you selected."
  StrCpy $FINISH_TITLE "Installation complete."
  StrCpy $FINISH_TEXT "${PRODUCT_NAME} has finished installing the components you selected."

  Goto done

update:
  StrCpy $INSTALL_ACTION "Please wait while ${PRODUCT_NAME} downloads and installs the components you selected."
  StrCpy $FINISH_TITLE "Update complete."
  StrCpy $FINISH_TEXT "${PRODUCT_NAME} has finished updating the installed components."
  StrCpy $Install 1
done:

FunctionEnd

var donation

;-----------------------------------------------------------------------------------------------------------------------
Function Donate
;-----------------------------------------------------------------------------------------------------------------------
  pop $donation
  ExecShell "open" "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=donations%40devkitpro%2eorg&item_name=devkitPro%20donation&item_number=002&amount=$donation%2e00&no_shipping=0&return=http%3a%2f%2fwww%2edevkitpro%2eorg%2fthanks%2ephp&cancel_return=http%3a%2f%2fwww%2edevkitpro%2eorg%2fsupport%2ddevkitpro%2f&tax=0&currency_code=USD&bn=PP%2dDonationsBF&charset=UTF%2d8"
FunctionEnd


;-----------------------------------------------------------------------------------------------------------------------
Function Donate5
;-----------------------------------------------------------------------------------------------------------------------
  push 5
  call Donate
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function Donate10
;-----------------------------------------------------------------------------------------------------------------------
  push 10
  call Donate
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function Donate20
;-----------------------------------------------------------------------------------------------------------------------
  push 20
  call Donate
FunctionEnd
;-----------------------------------------------------------------------------------------------------------------------
Function WhyDonate
;-----------------------------------------------------------------------------------------------------------------------
  ExecShell "open" "https://devkitpro.org/support-devkitpro/"
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function FinishPage
;-----------------------------------------------------------------------------------------------------------------------
  SendMessage $mui.Button.Next ${WM_SETTEXT} 0 "STR:Finish"

  ;Create dialog
  nsDialogs::Create /NOUNLOAD 1044
  Pop $R0
  nsDialogs::SetRTL /NOUNLOAD $(^RTL)
  SetCtlColors $R0 "" "${MUI_BGCOLOR}"

  ;Image control
  ${NSD_CreateBitmap} 0u 0u 109u 193u ""
  Pop $R1

  ${NSD_SetImage} $R1 $PLUGINSDIR\modern-wizard.bmp $R2

  ${NSD_CreateLabel} 120u 10u 195u 38u "$FINISH_TITLE"
  Pop $R0
  SetCtlColors $R0 "" "${MUI_BGCOLOR}"
  CreateFont $R1 "$(^Font)" "12" "700"
  SendMessage $R0 ${WM_SETFONT} $R1 0

  ${NSD_CreateLabel} 120u 50u -1u 10u "$FINISH_TEXT"
  Pop $R0
  SetCtlColors $R0 "" "${MUI_BGCOLOR}"

  ${NSD_CreateLabel} 140u 120u 162u 12u "Help keep devkitPro toolchains free"
  Pop $R0
  SetCtlColors $R0 "000080" "FFFFFF"
  CreateFont $R1 "(^Font)" "10" "700"
  SendMessage $R0 ${WM_SETFONT} $R1 1

  ${NSD_CreateButton} 120u 134u 50u 18u "$$5"
  pop $R0
  CreateFont $R1 "(^Font)" "12" "700"
  SendMessage $R0 ${WM_SETFONT} $R1 1
  ${NSD_OnClick} $R0 Donate5

  ${NSD_CreateButton} 190u 134u 50u 18u "$$10"
  pop $R0
  CreateFont $R1 "(^Font)" "12" "700"
  SendMessage $R0 ${WM_SETFONT} $R1 1
  ${NSD_OnClick} $R0 Donate10

  ${NSD_CreateButton} 260u 134u 50u 18u "$$20"
  pop $R0
  CreateFont $R1 "(^Font)" "12" "700"
  SendMessage $R0 ${WM_SETFONT} $R1 1
  ${NSD_OnClick} $R0 Donate20


  ${NSD_CreateLink} 190u 154u 76u 12u "Why Donate?"
  pop $R0
  SetCtlColors $R0 "000080" "FFFFFF"
  CreateFont $R1 "(^Font)" "8" "700"
  SendMessage $R0 ${WM_SETFONT} $R1 1
  ${NSD_OnClick} $R0 WhyDonate

  nsDialogs::Show

FunctionEnd
