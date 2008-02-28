; $Id: devkitPro.nsi,v 1.40 2008-02-28 18:53:42 wntrmute Exp $

; plugins required
; untgz     - http://nsis.sourceforge.net/wiki/UnTGZ
; inetc     - http://nsis.sourceforge.net/Inetc_plug-in
;             http://forums.winamp.com/showthread.php?s=&threadid=198596&perpage=40&highlight=&pagenumber=4
;             http://forums.winamp.com/attachment.php?s=&postid=1831346

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "devkitProUpdater"
!define PRODUCT_VERSION "1.4.5"
!define PRODUCT_PUBLISHER "devkitPro"
!define PRODUCT_WEB_SITE "http://www.devkitpro.org"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"
!define BUILD "34"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "zipdll.nsh"
!include "Sections.nsh"
!include "StrFunc.nsh"
${StrTok}
${StrRep}
${UnStrRep}

; MUI Settings
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "devkitPro.bmp" ; optional
!define MUI_ABORTWARNING "Are you sure you want to quit ${PRODUCT_NAME} ${PRODUCT_VERSION}?"
!define MUI_COMPONENTSPAGE_SMALLDESC

; Welcome page
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${PRODUCT_NAME}\r\nVersion ${PRODUCT_VERSION}"
!define MUI_WELCOMEPAGE_TEXT "${PRODUCT_NAME} automates the process of downloading, installing, and uninstalling devkitPro Components.\r\n\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

Page custom ChooseMirrorPage
Page custom KeepFilesPage

var ChooseMessage

; Components page
!define MUI_PAGE_HEADER_SUBTEXT $ChooseMessage
!define MUI_PAGE_CUSTOMFUNCTION_PRE AbortComponents
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
!define MUI_FINISHPAGE_TITLE $FINISH_TITLE
!define MUI_FINISHPAGE_TEXT $FINISH_TEXT
!define MUI_FINISHPAGE_TEXT_LARGE $INSTALLED_TEXT
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
Caption "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"
InstallDir "c:\devkitPro"
ShowInstDetails hide
ShowUnInstDetails show

var Install
var Updating
var MSYS
var MSYS_VER
var DEVKITARM
var DEVKITARM_VER
var LIBGBA
var LIBGBA_VER
var LIBGBA_FAT
var LIBGBA_FAT_VER
var LIBNDS
var LIBNDS_VER
var DSWIFI
var DSWIFI_VER
var LIBNDS_FAT
var LIBNDS_FAT_VER
var NDSEXAMPLES
var NDSEXAMPLES_VER
var GBAEXAMPLES
var GBAEXAMPLES_VER
var GP32EXAMPLES
var GP32EXAMPLES_VER

var DEVKITPPC
var DEVKITPPC_VER
var CUBEEXAMPLES
var CUBEEXAMPLES_VER
var WIIEXAMPLES
var WIIEXAMPLES_VER
var LIBOGC
var LIBOGC_VER

var DEVKITPSP
var DEVKITPSP_VER
var PSPDOC
var PSPDOC_VER
var LIBMIRKO
var LIBMIRKO_VER
var PNOTEPAD
var PNOTEPAD_VER
var INSIGHT
var INSIGHT_VER

var GCUBE
var GCUBE_VER

var BASEDIR
var Updates

InstType "Full"
InstType "devkitARM"
InstType "devkitPPC"
InstType "devkitPSP"

Section "Minimal System" SecMsys
    SectionIn 1 2 3 4
SectionEnd

SectionGroup devkitARM SecdevkitARM
	; Application
	Section "devkitARM" SecdkARM
          SectionIn 1 2
        SectionEnd

	Section "libgba" Seclibgba
          SectionIn 1 2
        SectionEnd

	Section "libfat-gba" Seclibgbafat
          SectionIn 1 2
	SectionEnd

	Section "libmirko" Seclibmirko
          SectionIn 1 2
	SectionEnd

	Section "libnds" Seclibnds
          SectionIn 1 2
	SectionEnd

	Section "libfat-nds" Seclibndsfat
          SectionIn 1 2
	SectionEnd

	Section "dswifi lib" Secdswifi
          SectionIn 1 2
	SectionEnd

	Section "nds examples" ndsexamples
          SectionIn 1 2
	SectionEnd

	Section "gba examples" gbaexamples
          SectionIn 1 2
	SectionEnd

	Section "gp32 examples" gp32examples
          SectionIn 1 2
	SectionEnd
SectionGroupEnd

SectionGroup "devkitPPC" grpdevkitPPC
  Section "devkitPPC" devkitPPC
    SectionIn 1 3
  SectionEnd
  Section "libogc" libogc
    SectionIn 1 3
  SectionEnd
  Section "Gamecube examples" cubeexamples
    SectionIn 1 3
  SectionEnd
  Section "Wii examples" wiiexamples
    SectionIn 1 3
  SectionEnd
  Section "Gcube" gcube
    SectionIn 1 3
  SectionEnd
SectionGroupEnd

SectionGroup "devkitPSP" grpdevkitPSP
  Section "devkitPSP" devkitPSP
    SectionIn 1 4
  SectionEnd
  Section "psp sdk documentation" pspdoc
    SectionIn 1 4
  SectionEnd
SectionGroupEnd

Section "Programmer's Notepad" Pnotepad
  SectionIn 1 2 3 4
SectionEnd

Section "Insight" Secinsight
  SectionIn 1
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
  push $MSYS
  Call DownloadIfNeeded

  push ${SecdkARM}
  push $DEVKITARM
  Call DownloadIfNeeded

  push ${Seclibgba}
  push $LIBGBA
  Call DownloadIfNeeded

  push ${Seclibgbafat}
  push $LIBGBA_FAT
  Call DownloadIfNeeded

  push ${Seclibnds}
  push $LIBNDS
  Call DownloadIfNeeded

  push ${Secdswifi}
  push $DSWIFI
  Call DownloadIfNeeded

  push ${Seclibndsfat}
  push $LIBNDS_FAT
  Call DownloadIfNeeded

  push ${Seclibmirko}
  push $LIBMIRKO
  Call DownloadIfNeeded

  push ${ndsexamples}
  push $NDSEXAMPLES
  Call DownloadIfNeeded

  push ${gbaexamples}
  push $GBAEXAMPLES
  Call DownloadIfNeeded

  push ${gp32examples}
  push $GP32EXAMPLES
  Call DownloadIfNeeded

  push ${devkitPPC}
  push $DEVKITPPC
  Call DownloadIfNeeded

  push ${libogc}
  push $LIBOGC
  Call DownloadIfNeeded

  push ${cubeexamples}
  push $CUBEEXAMPLES
  Call DownloadIfNeeded

  push ${wiiexamples}
  push $WIIEXAMPLES
  Call DownloadIfNeeded

  push ${devkitPSP}
  push $DEVKITPSP
  Call DownloadIfNeeded

  push ${pspdoc}
  push $PSPDOC
  Call DownloadIfNeeded

  push ${pnotepad}
  push $PNOTEPAD
  Call DownloadIfNeeded

  push ${Secinsight}
  push $INSIGHT
  Call DownloadIfNeeded
  
  push ${gcube}
  push $GCUBE
  Call DownloadIfNeeded

  SetDetailsView show

  IntCmp $Install 1 +1 SkipInstall SkipInstall

  IntCmp $Updating 1 test_Msys +1 +1

  CreateDirectory $INSTDIR
  File /oname=$INSTDIR\installed.ini INIfiles\installed.ini


test_Msys:
  !insertmacro SectionFlagIsSet ${SecMsys} ${SF_SELECTED} install_Msys SkipMsys
install_Msys:

  ExecWait '"$EXEDIR\$MSYS" -y -o$INSTDIR'
  WriteINIStr $INSTDIR\installed.ini msys Version $MSYS_VER
  push $MSYS
  call RemoveFile

SkipMsys:
  push ${SecdkARM}
  push "DEVKITARM"
  push $DEVKITARM
  push "$BASEDIR/devkitARM"
  push "devkitARM"
  push $DEVKITARM_VER
  push 1
  call ExtractToolChain

  push ${devkitPPC}
  push "DEVKITPPC"
  push $DEVKITPPC
  push "$BASEDIR/devkitPPC"
  push "devkitPPC"
  push $DEVKITPPC_VER
  push 1
  call ExtractToolChain

  push ${devkitPSP}
  push "DEVKITPSP"
  push $DEVKITPSP
  push "$BASEDIR/devkitPSP"
  push "devkitPSP"
  push $DEVKITPSP_VER
  push 0
  call ExtractToolChain

  push ${Seclibgba}
  push "libgba"
  push $LIBGBA
  push "libgba"
  push $LIBGBA_VER
  call ExtractLib
  
  push ${Seclibgbafat}
  push "libgba"
  push $LIBGBA_FAT
  push "libgbafat"
  push $LIBGBA_FAT_VER
  call ExtractLib

  push ${Seclibnds}
  push "libnds"
  push $LIBNDS
  push "libnds"
  push $LIBNDS_VER
  call ExtractLib

  push ${Seclibndsfat}
  push "libnds"
  push $LIBNDS_FAT
  push "libndsfat"
  push $LIBNDS_FAT_VER
  call ExtractLib

  push ${Secdswifi}
  push "libnds"
  push $DSWIFI
  push "dswifi"
  push $DSWIFI_VER
  call ExtractLib

  push ${Seclibmirko}
  push "libmirko"
  push $LIBMIRKO
  push "libmirko"
  push $LIBMIRKO_VER
  call ExtractLib

  push ${libogc}
  push "libogc"
  push $LIBOGC
  push "libogc"
  push $LIBOGC_VER
  call ExtractLib

  push ${ndsexamples}
  push "examples\nds"
  push $NDSEXAMPLES
  push "ndsexamples"
  push $NDSEXAMPLES_VER
  call ExtractExamples

  push ${gbaexamples}
  push "examples\gba"
  push $GBAEXAMPLES
  push "gbaexamples"
  push $GBAEXAMPLES_VER
  call ExtractExamples

  push ${gp32examples}
  push "examples\gp32"
  push $GP32EXAMPLES
  push "gp32examples"
  push $GP32EXAMPLES_VER
  call ExtractExamples

  push ${cubeexamples}
  push "examples\gamecube"
  push $CUBEEXAMPLES
  push "cubeexamples"
  push $CUBEEXAMPLES_VER
  call ExtractExamples

  push ${wiiexamples}
  push "examples\wii"
  push $WIIEXAMPLES
  push "wiiexamples"
  push $WIIEXAMPLES_VER
  call ExtractExamples


  push ${pspdoc}
  push "doc\pspsdk"
  push $PSPDOC
  push "pspdoc"
  push $PSPDOC_VER
  call ExtractLib

  push ${gcube}
  push "emulators"
  push $GCUBE
  push "gcube"
  push $GCUBE_VER
  call ExtractLib

  !insertmacro SectionFlagIsSet ${Secinsight} ${SF_SELECTED} +1 SkipInsight

  RMDir /r "$INSTDIR/Insight"

  ExecWait '"$EXEDIR/$INSIGHT" -y -o$INSTDIR'
  WriteINIStr $INSTDIR\installed.ini insight Version $INSIGHT_VER
  push $INSIGHT
  call RemoveFile

SkipInsight:
  SectionGetFlags ${Pnotepad} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  IntCmp $R0 ${SF_SELECTED} +1 SkipPnotepad

  RMDir /r "$INSTDIR/Programmers Notepad"

  ZipDLL::extractall $EXEDIR/$PNOTEPAD "$INSTDIR/Programmers Notepad"
  push $PNOTEPAD
  call RemoveFile

  WriteRegStr HKCR ".pnproj" "" "PN2.pnproj.1"
  WriteRegStr HKCR "PN2.pnproj.1\shell\open\command" "" '"$INSTDIR\Programmers Notepad\pn.exe" "%1"'
  WriteINIStr $INSTDIR\installed.ini pnotepad Version $PNOTEPAD_VER

SkipPnotepad:

  Strcpy $R1 "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"

  Delete $INSTDIR\devkitProUpdater*.*
  StrCmp $EXEDIR $INSTDIR skip_copy

  CopyFiles $EXEDIR\$R1 $INSTDIR\$R1
skip_copy:

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  SetShellVarContext all ; Put stuff in All Users
  SetOutPath $INSTDIR
  IntCmp $Updating 1 CheckPN2
  WriteIniStr "$INSTDIR\devkitPro.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\devkitpro.lnk" "$INSTDIR\devkitPro.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  SetOutPath $INSTDIR\msys\bin
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\MSys.lnk" "$INSTDIR\msys\msys.bat" "-norxvt" "$INSTDIR\msys\m.ico"
CheckPN2:
  !insertmacro SectionFlagIsSet ${Pnotepad} ${SF_SELECTED} +1 SkipPN2Menu
  SetOutPath "$INSTDIR\Programmers Notepad"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Programmers Notepad.lnk" "$INSTDIR\Programmers Notepad\pn.exe"
SkipPN2Menu:
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP\documentation"
  !insertmacro SectionFlagIsSet ${pspdoc} ${SF_SELECTED} +1 SkipPSPdocMenu
  WriteIniStr "$INSTDIR\pspsdk.url" "InternetShortcut" "URL" "file://$INSTDIR\doc\pspsdk\doc\html\index.html"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\documentation\pspsdk.lnk" "$INSTDIR\pspsdk.url"

SkipPSPdocMenu:
  SetOutPath $INSTDIR
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Update.lnk" "$INSTDIR\$R1"
  !insertmacro MUI_STARTMENU_WRITE_END
  WriteUninstaller "$INSTDIR\uninst.exe"
  IntCmp $Updating 1 SkipInstall
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

  WriteRegStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "DEVKITPRO" "$BASEDIR"
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  ReadRegStr $1 HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH"
  ; remove it to avoid multiple paths with separate installs
  ${StrRep} $1 $1 "$INSTDIR\msys\bin;" ""
  StrCpy $1 "$INSTDIR\msys\bin;$1"
  WriteRegExpandStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH" $1
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

SkipInstall:
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
  WriteRegExpandStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" "PATH" $1
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

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
  !insertmacro MUI_DESCRIPTION_TEXT ${SecdevkitARM} "toolchain for ARM platforms"
  !insertmacro MUI_DESCRIPTION_TEXT ${SecdkARM} "toolchain for ARM platforms"
  !insertmacro MUI_DESCRIPTION_TEXT ${devkitPPC} "toolchain for powerpc platforms"
  !insertmacro MUI_DESCRIPTION_TEXT ${devkitPSP} "toolchain for psp"
  !insertmacro MUI_DESCRIPTION_TEXT ${pspdoc} "PSP SDK documentation"
  !insertmacro MUI_DESCRIPTION_TEXT ${Pnotepad} "a programmer's editor"
  !insertmacro MUI_DESCRIPTION_TEXT ${Seclibgba} "Nintendo GBA development library"
  !insertmacro MUI_DESCRIPTION_TEXT ${Seclibgbafat} "Nintendo GBA FAT library"
  !insertmacro MUI_DESCRIPTION_TEXT ${Seclibmirko} "Gamepark GP32 development library"
  !insertmacro MUI_DESCRIPTION_TEXT ${Seclibnds} "Nintendo DS development library"
  !insertmacro MUI_DESCRIPTION_TEXT ${Secdswifi} "Nintendo DS wifi library"
  !insertmacro MUI_DESCRIPTION_TEXT ${Seclibndsfat} "Nintendo DS FAT library"
  !insertmacro MUI_DESCRIPTION_TEXT ${libogc} "Nintendo Wii and Gamecube development library"
  !insertmacro MUI_DESCRIPTION_TEXT ${ndsexamples} "Nintendo DS example code"
  !insertmacro MUI_DESCRIPTION_TEXT ${gbaexamples} "Nintendo GBA example code"
  !insertmacro MUI_DESCRIPTION_TEXT ${gp32examples} "Gamepark GP32 example code"
  !insertmacro MUI_DESCRIPTION_TEXT ${cubeexamples} "Nintendo Gamecube example code"
  !insertmacro MUI_DESCRIPTION_TEXT ${wiiexamples} "Nintendo Wii example code"
  !insertmacro MUI_DESCRIPTION_TEXT ${Secinsight} "GUI debugger"
  !insertmacro MUI_DESCRIPTION_TEXT ${gcube} "Gamecube emulator"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

var keepINI
var mirrorINI

;-----------------------------------------------------------------------------------------------------------------------
Function .onInit
;-----------------------------------------------------------------------------------------------------------------------
  System::Call "kernel32::CreateMutexA(i 0, i 0, t '$(^Name)') i .r0 ?e"
  Pop $0
  StrCmp $0 0 launch
  StrLen $0 "$(^Name)"
  IntOp $0 $0 + 1
loop:
  FindWindow $1 '#32770' '' 0 $1
  IntCmp $1 0 +4
  System::Call "user32::GetWindowText(i r1, t .r2, i r0) i."
  StrCmp $2 "$(^Name)" 0 loop
  System::Call "user32::SetForegroundWindow(i r1) i."
  System::Call "user32::ShowWindow(i r1,i 9) i."
  Abort
launch:


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
  inetc::get  /BANNER "Checking for updates ..." "http://devkitpro.sourceforge.net/devkitProUpdate.ini" "$EXEDIR\devkitProUpdate.ini" /END


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

  InstTypeSetText 0 ""
  InstTypeSetText 1 ""
  InstTypeSetText 2 ""
  InstTypeSetText 3 ""

installing:

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "msys" "Size"
  ReadINIStr $MSYS "$EXEDIR\devkitProUpdate.ini" "msys" "File"
  ReadINIStr $MSYS_VER "$EXEDIR\devkitProUpdate.ini" "msys" "Version"
  SectionSetSize ${SecMsys} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "devkitARM" "Size"
  ReadINIStr $DEVKITARM "$EXEDIR\devkitProUpdate.ini" "devkitARM" "File"
  ReadINIStr $DEVKITARM_VER "$EXEDIR\devkitProUpdate.ini" "devkitARM" "Version"
  SectionSetSize ${SecdkARM} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "libgba" "Size"
  ReadINIStr $LIBGBA "$EXEDIR\devkitProUpdate.ini" "libgba" "File"
  ReadINIStr $LIBGBA_VER "$EXEDIR\devkitProUpdate.ini" "libgba" "Version"
  SectionSetSize ${Seclibgba} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "libgbafat" "Size"
  ReadINIStr $LIBGBA_FAT "$EXEDIR\devkitProUpdate.ini" "libgbafat" "File"
  ReadINIStr $LIBGBA_FAT_VER "$EXEDIR\devkitProUpdate.ini" "libgbafat" "Version"
  SectionSetSize ${Seclibgbafat} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "libnds" "Size"
  ReadINIStr $LIBNDS "$EXEDIR\devkitProUpdate.ini" "libnds" "File"
  ReadINIStr $LIBNDS_VER "$EXEDIR\devkitProUpdate.ini" "libnds" "Version"
  SectionSetSize ${Seclibnds} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "libndsfat" "Size"
  ReadINIStr $LIBNDS_FAT "$EXEDIR\devkitProUpdate.ini" "libndsfat" "File"
  ReadINIStr $LIBNDS_FAT_VER "$EXEDIR\devkitProUpdate.ini" "libndsfat" "Version"
  SectionSetSize ${Seclibndsfat} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "dswifi" "Size"
  ReadINIStr $DSWIFI "$EXEDIR\devkitProUpdate.ini" "dswifi" "File"
  ReadINIStr $DSWIFI_VER "$EXEDIR\devkitProUpdate.ini" "dswifi" "Version"
  SectionSetSize ${Secdswifi} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "libmirko" "Size"
  ReadINIStr $LIBMIRKO "$EXEDIR\devkitProUpdate.ini" "libmirko" "File"
  ReadINIStr $LIBMIRKO_VER "$EXEDIR\devkitProUpdate.ini" "libmirko" "Version"
  SectionSetSize ${Seclibmirko} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "libogc" "Size"
  ReadINIStr $LIBOGC "$EXEDIR\devkitProUpdate.ini" "libogc" "File"
  ReadINIStr $LIBOGC_VER "$EXEDIR\devkitProUpdate.ini" "libogc" "Version"
  SectionSetSize ${libogc} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "ndsexamples" "Size"
  ReadINIStr $NDSEXAMPLES "$EXEDIR\devkitProUpdate.ini" "ndsexamples" "File"
  ReadINIStr $NDSEXAMPLES_VER "$EXEDIR\devkitProUpdate.ini" "ndsexamples" "Version"
  SectionSetSize ${ndsexamples} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "gbaexamples" "Size"
  ReadINIStr $GBAEXAMPLES "$EXEDIR\devkitProUpdate.ini" "gbaexamples" "File"
  ReadINIStr $GBAEXAMPLES_VER "$EXEDIR\devkitProUpdate.ini" "gbaexamples" "Version"
  SectionSetSize ${gbaexamples} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "gp32examples" "Size"
  ReadINIStr $GP32EXAMPLES "$EXEDIR\devkitProUpdate.ini" "gp32examples" "File"
  ReadINIStr $GP32EXAMPLES_VER "$EXEDIR\devkitProUpdate.ini" "gp32examples" "Version"
  SectionSetSize ${gp32examples} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "devkitPPC" "Size"
  ReadINIStr $DEVKITPPC "$EXEDIR\devkitProUpdate.ini" "devkitPPC" "File"
  ReadINIStr $DEVKITPPC_VER "$EXEDIR\devkitProUpdate.ini" "devkitPPC" "Version"
  SectionSetSize ${devkitPPC} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "cubeexamples" "Size"
  ReadINIStr $CUBEEXAMPLES "$EXEDIR\devkitProUpdate.ini" "cubeexamples" "File"
  ReadINIStr $CUBEEXAMPLES_VER "$EXEDIR\devkitProUpdate.ini" "cubeexamples" "Version"
  SectionSetSize ${cubeexamples} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "wiiexamples" "Size"
  ReadINIStr $WIIEXAMPLES "$EXEDIR\devkitProUpdate.ini" "wiiexamples" "File"
  ReadINIStr $WIIEXAMPLES_VER "$EXEDIR\devkitProUpdate.ini" "wiiexamples" "Version"
  SectionSetSize ${wiiexamples} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "gcube" "Size"
  ReadINIStr $GCUBE "$EXEDIR\devkitProUpdate.ini" "gcube" "File"
  ReadINIStr $GCUBE_VER "$EXEDIR\devkitProUpdate.ini" "gcube" "Version"
  SectionSetSize ${gcube} $R0


  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "devkitPSP" "Size"
  ReadINIStr $DEVKITPSP "$EXEDIR\devkitProUpdate.ini" "devkitPSP" "File"
  ReadINIStr $DEVKITPSP_VER "$EXEDIR\devkitProUpdate.ini" "devkitPSP" "Version"
  SectionSetSize ${devkitPSP} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "pspdoc" "Size"
  ReadINIStr $PSPDOC "$EXEDIR\devkitProUpdate.ini" "pspdoc" "File"
  ReadINIStr $PSPDOC_VER "$EXEDIR\devkitProUpdate.ini" "pspdoc" "Version"
  SectionSetSize ${pspdoc} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "pnotepad" "Size"
  ReadINIStr $PNOTEPAD "$EXEDIR\devkitProUpdate.ini" "pnotepad" "File"
  ReadINIStr $PNOTEPAD_VER "$EXEDIR\devkitProUpdate.ini" "pnotepad" "Version"
  SectionSetSize ${Pnotepad} $R0

  ReadINIStr $R0 "$EXEDIR\devkitProUpdate.ini" "insight" "Size"
  ReadINIStr $INSIGHT "$EXEDIR\devkitProUpdate.ini" "insight" "File"
  ReadINIStr $INSIGHT_VER "$EXEDIR\devkitProUpdate.ini" "insight" "Version"
  SectionSetSize ${Secinsight} $R0

  !insertmacro MUI_INSTALLOPTIONS_EXTRACT_AS "Dialogs\PickMirror.ini" "PickMirror.ini"


  GetTempFileName $keepINI $PLUGINSDIR
  File /oname=$keepINI "Dialogs\keepfiles.ini"

  GetTempFileName $mirrorINI $PLUGINSDIR
  File /oname=$mirrorINI "Dialogs\PickMirror.ini"

  IntCmp $Updating 1 +1 first_install

  StrCpy $Updates 0

  !insertmacro SetSectionFlag SecdevkitARM SF_EXPAND
  !insertmacro SetSectionFlag SecdevkitARM SF_TOGGLED

  ReadINIStr $0 "$INSTDIR\installed.ini" "devkitARM" "Version"

  push $0
  push $DEVKITARM_VER
  push ${SecdkARM}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "libmirko" "Version"

  push $0
  push $LIBMIRKO_VER
  push ${Seclibmirko}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "libgba" "Version"

  push $0
  push $LIBGBA_VER
  push ${Seclibgba}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "libgbafat" "Version"

  push $0
  push $LIBGBA_FAT_VER
  push ${Seclibgbafat}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "libnds" "Version"

  push $0
  push $LIBNDS_VER
  push ${Seclibnds}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "dswifi" "Version"

  push $0
  push $DSWIFI_VER
  push ${Secdswifi}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "libndsfat" "Version"

  push $0
  push $LIBNDS_FAT_VER
  push ${Seclibndsfat}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "ndsexamples" "Version"

  push $0
  push $NDSEXAMPLES_VER
  push ${ndsexamples}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "gbaexamples" "Version"

  push $0
  push $GBAEXAMPLES_VER
  push ${gbaexamples}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "gp32examples" "Version"

  push $0
  push $GP32EXAMPLES_VER
  push ${gp32examples}
  call checkVersion

  IntCmp $Updates 0 +1 dkARMupdates dkARMupdates

  SectionSetText ${SecdevkitARM} ""

dkARMupdates:
  ReadINIStr $0 "$INSTDIR\installed.ini" "msys" "Version"

  push $0
  push $MSYS_VER
  push ${SecMsys}
  call checkVersion

  StrCpy $R2 $Updates
  ReadINIStr $0 "$INSTDIR\installed.ini" "devkitPPC" "Version"

  push $0
  push $DEVKITPPC_VER
  push ${devkitPPC}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "libogc" "Version"

  push $0
  push $LIBOGC_VER
  push ${libogc}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "cubeexamples" "Version"

  push $0
  push $CUBEEXAMPLES_VER
  push ${cubeexamples}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "wiiexamples" "Version"

  push $0
  push $WIIEXAMPLES_VER
  push ${wiiexamples}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "gcube" "Version"

  push $0
  push $GCUBE_VER
  push ${gcube}
  call checkVersion


  IntOp $R1 $Updates - $R2
  IntCmp $R1 0 +1 dkPPCupdates dkPPCupdates

  SectionSetText ${grpdevkitPPC} ""

dkPPCupdates:

  StrCpy $R2 $Updates
  ReadINIStr $0 "$INSTDIR\installed.ini" "devkitPSP" "Version"

  push $0
  push $DEVKITPSP_VER
  push ${devkitPSP}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "pspdoc" "Version"
  push $0
  push $PSPDOC_VER
  push ${pspdoc}
  call checkVersion

  IntOp $R1 $Updates - $R2
  IntCmp $R1 0 +1 dkPSPupdates dkPSPupdates

  SectionSetText ${grpdevkitPSP} ""

dkPSPupdates:
  ReadINIStr $0 "$INSTDIR\installed.ini" "pnotepad" "Version"

  push $0
  push $PNOTEPAD_VER
  push ${Pnotepad}
  call checkVersion

  ReadINIStr $0 "$INSTDIR\installed.ini" "insight" "Version"

  push $0
  push $INSIGHT_VER
  push ${Secinsight}
  call checkVersion

first_install:

FunctionEnd

var CurrentVer
var InstalledVer
var PackageSection
var PackageFlags
;-----------------------------------------------------------------------------------------------------------------------
Function checkVersion
;-----------------------------------------------------------------------------------------------------------------------
  pop $PackageSection
  pop $CurrentVer
  pop $InstalledVer

  SectionGetFlags $PackageSection $PackageFlags

  IntOp $R1 ${SF_RO} ~
  IntOp $PackageFlags $PackageFlags & $R1
  IntOp $PackageFlags $PackageFlags & ${SECTION_OFF}

  StrCmp $CurrentVer $InstalledVer noupdate
  
  Intop $Updates $Updates + 1
  
  ; don't select if not installed
  StrCmp $InstalledVer 0 done
  
  IntOp $PackageFlags $PackageFlags | ${SF_SELECTED}

  Goto done

noupdate:

  SectionSetText $PackageSection ""

done:
  SectionSetFlags $PackageSection $PackageFlags

FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function .onVerifyInstDir
;-----------------------------------------------------------------------------------------------------------------------
  StrCpy $R0 $INSTDIR 1 1
;  IfFileExists $INSTDIR\Winamp.exe PathGood
;    Abort ;
;PathGood:
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function un.onUninstSuccess
;-----------------------------------------------------------------------------------------------------------------------
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "devkitPro was successfully removed from your computer."
FunctionEnd

;-----------------------------------------------------------------------------------------------------------------------
Function un.onInit
;-----------------------------------------------------------------------------------------------------------------------
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove devkitPro and all of its components?" IDYES +2
  Abort
FunctionEnd


;-----------------------------------------------------------------------------------------------------------------------
; Check for a newer version of the installer, download and ask the user if he wants to run it
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
Function AbortComponents
;-----------------------------------------------------------------------------------------------------------------------

  IntCmp $Updating 1 +1 ShowPage ShowPage

  IntCmp $Updates 0 +1 Showpage Showpage
  
  StrCpy $FINISH_TEXT "${PRODUCT_NAME} found no updates to install."
  Abort

ShowPage:

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
  inetc::get /RESUME "" "http://downloads.sourceforge.net/devkitpro/$FileName" "$EXEDIR\$FileName" /END
  Pop $0
  StrCmp $0 "OK" ThisFileFound

  IntOp $retry $retry - 1
  IntCmp $retry 0 +1 +1 retryLoop

  detailprint $0
  abort "$FileName could not be downloaded at this time."

ThisFileFound:
SkipThisDL:

FunctionEnd


var LIB
var FOLDER


;-----------------------------------------------------------------------------------------------------------------------
Function ExtractToolChain
;-----------------------------------------------------------------------------------------------------------------------
  pop $R6  ; delete directory flag
  pop $R5  ; version
  pop $R4  ; section name
  pop $R3  ; name
  pop $R2  ; 7zip sfx
  pop $R1  ; env variable
  pop $R0  ; section flags

  SectionGetFlags $R0 $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} +1 SkipExtract


  MessageBox MB_ICONINFORMATION|MB_OK "$R6"

  IntCmp $R6 1 +1 SkipRemove

  MessageBox MB_ICONINFORMATION|MB_OK "$R4"

  RMDir /r "$INSTDIR\$R4"

SkipRemove:
  ExecWait '"$EXEDIR\$R2" -y -o$INSTDIR'

  WriteRegStr HKLM "System\CurrentControlSet\Control\Session Manager\Environment" $R1 $R3
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

  WriteINIStr $INSTDIR\installed.ini $R4 Version $R5

  push $R2
  call RemoveFile

SkipExtract:

FunctionEnd



;-----------------------------------------------------------------------------------------------------------------------
Function ExtractExamples
;-----------------------------------------------------------------------------------------------------------------------
  pop $R3  ; version
  pop $R2  ; section name
  pop $LIB ; filename
  pop $FOLDER ; extract to
  pop $R0  ; section flags

  SectionGetFlags $R0 $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} +1 SkipExtract

  RMDir /r "$INSTDIR\$FOLDER"
  CreateDirectory "$INSTDIR\$FOLDER"
  untgz::extract -d "$INSTDIR\$FOLDER" -zbz2 "$EXEDIR\$LIB"

  StrCmp $R0 "success" succeeded

    SetDetailsView show
    DetailPrint "failed to extract $LIB: $R0"

  abort
  goto SkipExtract
succeeded:

  WriteINIStr $INSTDIR\installed.ini $R2 Version $R3
  push $LIB
  call RemoveFile

SkipExtract:

FunctionEnd



;-----------------------------------------------------------------------------------------------------------------------
Function ExtractLib
;-----------------------------------------------------------------------------------------------------------------------
  pop $R3  ; version
  pop $R2  ; section name
  pop $LIB ; filename
  pop $FOLDER ; extract to
  pop $R0  ; section flags

  SectionGetFlags $R0 $0
  IntOp $0 $0 & ${SF_SELECTED}
  IntCmp $0 ${SF_SELECTED} +1 SkipExtract

  CreateDirectory "$INSTDIR\$FOLDER"
  untgz::extract -d "$INSTDIR\$FOLDER" -zbz2 "$EXEDIR\$LIB"

  StrCmp $R0 "success" succeeded

    SetDetailsView show
    DetailPrint "failed to extract $LIB: $R0"

  abort
  goto SkipExtract
succeeded:

  WriteINIStr $INSTDIR\installed.ini $R2 Version $R3
  push $LIB
  call RemoveFile

SkipExtract:

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
