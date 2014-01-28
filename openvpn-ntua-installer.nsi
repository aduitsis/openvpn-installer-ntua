Name openvpn


RequestExecutionLevel admin

SetCompressor lzma

!include MUI2.nsh
!include "WinVer.nsh"
;--------------------------------

ShowInstDetails show

!define URL "http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.2-I003-i686.exe"
!define FILENAME "openvpn-install-2.3.2-I003-i686.exe"

; The file to write
OutFile "ntua-${FILENAME}"

!define RASCMAK_INSTALL_COMMAND "Dism /online /enable-feature /featurename:rascmak"

!define STATIC resources
!define MUI_ICON "${STATIC}\images\icon.ico" 

!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_FINISHPAGE_SHOWREADME_CHECKED
  
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${STATIC}\images\openvpn-ntua.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE
!define MUI_WELCOMEFINISHPAGE_BITMAP "${STATIC}\images\arrow-ntua.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${STATIC}\images\arrow-ntua.bmp"

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING

!define PRODUCT_NAME openvpn

; to customize those pages
;!define MUI_WELCOMEPAGE_TEXT "$MUI_WELCOMEPAGE_TEXT $(welcome1)"
;!define MUI_WELCOMEPAGE_TITLE $(title1)

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
;!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Greek"
!define MUI_LANGDLL_ALWAYSSHOW
!define MUI_LANGDLL_ALLLANGUAGES
 

  
; Pages

;Page components
;Page directory
;Page instfiles

;UninstPage uninstConfirm
;UninstPage instfiles

;--------------------------------
LangString welcome1 ${LANG_ENGLISH} "This wizard will guide you through the installation of ${PRODUCT_NAME}, an Open Source VPN package by James Yonan.\r\n\r\nNote that the Windows version of ${PRODUCT_NAME} will only run on Win 2000, XP, or higher.\r\n\r\n\r\n"
LangString welcome1  ${LANG_GREEK} "Οδηγός Εγκατάστασης:\r\n\r\nOpenVPN - Λογισμικό ανοιχτού κώδικα για εικονικά δίκτυα (James Yonan).\r\n\r\n Προσοχή! Μόνο για Win 2000, XP, Vista ή νεότερη έκδοση.\r\n\r\n\r\n"

LangString title1 ${LANG_ENGLISH} "Welcome to the ${PRODUCT_NAME} Setup Wizard"
LangString title1  ${LANG_GREEK} "Οδηγός Εγκατάστασης ${PRODUCT_NAME}"

LangString DESC_OpenVPN_installer ${LANG_ENGLISH} "Install ${PRODUCT_NAME} using the official OpenVPN installer from openvpn.net."
LangString DESC_OpenVPN_installer ${LANG_GREEK} "Εγκατάσταση του ${PRODUCT_NAME} με το πρόγραμμα εγκατάστασης από το openvpn.net."

; LangString DESC_OpenVPN_installer64 ${LANG_ENGLISH} "Install ${PRODUCT_NAME} using the official 64-bit OpenVPN installer from openvpn.net."
; LangString DESC_OpenVPN_installer64 ${LANG_GREEK} "Εγκατάσταση του ${PRODUCT_NAME} με το πρόγραμμα εγκατάστασης (έκδοση 64-bit) από το openvpn.net."

LangString DESC_Conf ${LANG_GREEK} "Αρχεία ρυθμίσεων για σύνδεση στο ΕΜΠ."
LangString DESC_Conf ${LANG_ENGLISH} "NTUA services configuration."

LangString rascmak_warn ${LANG_GREEK} "Επιλέξατε να εγκατασταθεί και το RAS Connection Manager Administration Kit.$\n$\nH εγκατάσταση του RAS Connection Manager Administration Kit δεν είναι απαραίτητη για αυτή την έκδοση των Windows.$\n$\nΓια να επιβεβαιώσετε ότι ξέρετε τί κάνετε, πιέστε ΟΚ." 
LangString rascmak_warn ${LANG_ENGLISH} "You have selected to install the RASConnection Manager Administration Kit$\n$\nThe installation of the RAS Connection Manager Administration Kit is not needed in this version of Windows.$\n$\nTo confirm that you actually know what you are doing, please press OK, otherwise press Cancel." 







; The stuff to install
Section "Download and install openvpn from openvpn.net" OpenVPN_installer

  ;SectionIn RO
  
  NSISdl::download ${URL} "$TEMP\${FILENAME}"
  Pop $R0 ;Get the return value
    StrCmp $R0 "success" +3
      MessageBox MB_OK "Download failed: $R0"
      Quit

   ExecWait "$TEMP\${FILENAME}"
   DetailPrint "openvpn installer returned $0"
   IfErrors 0 noError
      MessageBox MB_OK "OpenVPN installation failed" 
   Quit
  noError:

SectionEnd


; Section "Download and install openvpn from openvpn.net using 64-bit installer" OpenVPN_installer64

  
  ; NSISdl::download http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.2-I001-x86_64.exe "$TEMP\openvpn-install-2.3.2-I001-x86_64.exe"
  ; Pop $R0 ;Get the return value
    ; StrCmp $R0 "success" +3
      ; MessageBox MB_OK "Download failed: $R0"
      ; Quit

   ; ExecWait "$TEMP\openvpn-install-2.3.2-I001-x86_64.exe"
   ; DetailPrint "openvpn installer returned $0"
   ; IfErrors 0 noError
      ; MessageBox MB_OK "OpenVPN installation failed" 
   ; Quit
  ; noError:

; SectionEnd

Section "NTUA openvpn configuration files" OpenVPN_conf
	Var /GLOBAL destination_dir
	ReadRegStr $destination_dir HKLM "SOFTWARE\OpenVPN-GUI" 'config_dir'
	IfErrors 0 config_dir_ok
		DetailPrint "cannot find HKLM\Software\OpenVPN-GUI config_dir"
		ReadRegStr $destination_dir HKLM "SOFTWARE\OpenVPN" 'config_dir'
		IfErrors 0 config_dir_ok
			DetailPrint "cannot find HKLM\Software\OpenVPN config_dir"
			ReadRegStr $destination_dir HKLM "Software\OpenVPN" ''
			ifErrors 0 default_dir_found
				MessageBox MB_ICONEXCLAMATION|MB_OK "Unable to locate openvpn installation" IDOK 
				Quit
		
	
    
	default_dir_found:
		DetailPrint "detected openvpn location $destination_dir"
		StrCpy $destination_dir "$destination_dir/config"
	config_dir_ok:
		DetailPrint "configuration files go to $destination_dir"
		
		
	SetOutPath $destination_dir

	; push two arguments
	; 1.File name as will be saved on local machine 
	; 2.URL of the file to be downloaded
;	Push "ntua with IPv6.ovpn"
;	Push "http://www.noc.ntua.gr/openvpn/ntua%20with%20IPv6.ovpn"
;	Call download_file
	Push "ntua.ovpn"
	Push "http://www.noc.ntua.gr/openvpn/ntua.ovpn"
	Call download_file
;	Push "ntua-udp.ovpn"
;	Push "http://www.noc.ntua.gr/openvpn/ntua-udp.ovpn"
;	Call download_file
;	Push "ntua-tcp.ovpn"	
;	Push "http://www.noc.ntua.gr/openvpn/ntua-tcp.ovpn"	
;	Call download_file
;	Push "cacert.crt"
;	Push "http://www.noc.ntua.gr/openvpn/cacert.crt"
;	Call download_file
;	Push "ROOT-NTUA-cacert.crt"
;	Push "http://www.noc.ntua.gr/openvpn/ROOT-NTUA-cacert.crt"
;	Call download_file

	
SectionEnd

Section "(only needed by Windows 8) Install Windows RASCMAK feature" rascmak_enable


	${If} ${AtMostWin7}

		MessageBox MB_OK $(rascmak_warn)

	${EndIf}

	!include "x64.nsh"

	; 64-bit systems are redicting our calls to wow64, so we may have temporarily disable this redirection
	${If} ${RunningX64} 
		!insertmacro DisableX64FSRedirection 
		ExecWait "${RASCMAK_INSTALL_COMMAND}"
		!insertmacro EnableX64FSRedirection 
	${Else}
		ExecWait "${RASCMAK_INSTALL_COMMAND}"
	${EndIf}



SectionEnd

Function download_file
	Pop $0
	Pop $1
	NSISdl::download $0 $1
	Pop $R0 ;Get the return value
    StrCmp $R0 "success" +3
      MessageBox MB_OK "Download failed for $0: $R0"
      Quit
	DetailPrint "$1 downloaded"
FunctionEnd


Function .onInit

	!insertmacro MUI_LANGDLL_DISPLAY
	
	; !include "x64.nsh"

	; StrCpy $R9 ${OpenVPN_installer} 
	; ${If} ${RunningX64}
		; Call enable64 
	; ${EndIf} 

	${If} ${AtMostWin7}
		!insertmacro UnselectSection ${rascmak_enable}
	${EndIf}		

FunctionEnd


; Function enable64
		
		; !insertmacro SelectSection ${OpenVPN_installer64}
		
		; !insertmacro UnselectSection ${OpenVPN_installer}
		
		; StrCpy $R9 ${OpenVPN_installer64} 
; FunctionEnd

; Function enable32

		; !insertmacro SelectSection ${OpenVPN_installer}
		
		; !insertmacro UnselectSection ${OpenVPN_installer64}
		
		
		; StrCpy $R9 ${OpenVPN_installer} 
; FunctionEnd




Function .onSelChange
	
	Push $0

	${If} ${AtMostWin7}
		SectionGetFlags ${rascmak_enable} $0
		IntOp $0 $0 & ${SF_SELECTED}
		IntCmp $0 ${SF_SELECTED} 0 deselected deselected
			MessageBox MB_ICONEXCLAMATION|MB_OKCANCEL  $(rascmak_warn) IDOK dontdoit
				!insertmacro UnselectSection ${rascmak_enable}	
			dontdoit:
		deselected:
	${EndIf}
	
	; SectionGetFlags ${OpenVPN_installer} $0
	; IntOp $0 $0 & ${SF_SELECTED}
	; IntCmp $0 ${SF_SELECTED} 0 deselected deselected
		; SectionGetFlags ${OpenVPN_installer64} $0
		; IntOp $0 $0 & ${SF_SELECTED}
		; IntCmp $0 ${SF_SELECTED} 0 done done
				; StrCmp $R9 ${OpenVPN_installer64} do32 do64
	; deselected:
		; SectionGetFlags ${OpenVPN_installer64} $0
		; IntOp $0 $0 & ${SF_SELECTED}
		; IntCmp $0 ${SF_SELECTED} done 0 0
				; StrCmp $R9 ${OpenVPN_installer64} do32 do64
	
	; do64:
	; Call enable64
	; Goto done
	; do32:
	; Call enable32

	; done:
 
	Pop $0
	
FunctionEnd


!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
 
  !insertmacro MUI_DESCRIPTION_TEXT ${OpenVPN_installer} $(DESC_OpenVPN_installer)
  ; !insertmacro MUI_DESCRIPTION_TEXT ${OpenVPN_installer64} $(DESC_OpenVPN_installer64)
  !insertmacro MUI_DESCRIPTION_TEXT ${OpenVPN_conf} $(DESC_Conf)
 
!insertmacro MUI_FUNCTION_DESCRIPTION_END

