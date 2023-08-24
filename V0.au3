;INCLUDE NECESSARY CONSTANTS/FILES-------------------------------------------------------------

#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <FileConstants.au3>
#include <ScreenCapture.au3>
AutoItSetOption( "WinTitleMatchMode", 2)
AutoItSetOption( "PixelCoordMode", 1)
AutoItSetOption( "MouseCoordMode", 1)

;DEFINE HOT KEYS AND EXECUTION CONSTANTS-------------------------------------------------------

HotKeySet("{esc}", "Terminate") ;sets the esc key to call the Terminate function defined below. Can be pressed during execution.
HotKeySet("{p}", "ShowMousePos") ;shows mouse position
HotKeySet("{c}", "Capture")
HotKeySet("{i}", "Inspect")
HotKeySet("{space}", "Improve")
HotKeySet("{l}", "Loop")

Global $iRunePax = 0.61*@DesktopWidth
Global $iRunex = 0.58*@DesktopWidth

;pa sa
Global $i3SAGy = 0.33*@DesktopHeight

;rune cri
Global $i1CRIy = 0.37*@DesktopHeight

;do neutre
Global $i1DONy = 0.41*@DesktopHeight

;do terre
Global $i1DOTy = 0.45*@DesktopHeight

;do eau
Global $i1DOEy = 0.49*@DesktopHeight

Global $iFusionnerx = 0.5*@DesktopWidth
Global $iFusionnery = 0.243*@DesktopHeight

Global $iFMWindowTop = 0.40*@DesktopHeight
Global $iFMWindowLeft = 0.52*@DesktopWidth
Global $iFMWindowBottom = 0.8*@DesktopHeight
Global $iFMWindowRight = 0.65*@DesktopWidth

;SIGNALS START OF PROGRAM AND BEGINS STANDBY---------------------------------------------------

Beep(500,1000)
While 1 ;empty loop for testing hotkeys
	Sleep(100)
WEnd

;ALL FUNCTIONS DEFINITION----------------------------------------------------------------------

Func Terminate() ;signals a beep and exits the program instantly
	Beep(500,1000)
	Exit
EndFunc 

Func ShowMousePos() ;coordinates are 0,0 in upper left corner
	Local $aPos = MouseGetPos()
	MsgBox($MB_SYSTEMMODAL, "Cursor Pos", $aPos[0]/@DesktopWidth & ", " & $aPos[1]/@DesktopHeight)
EndFunc

Func Inspect() ;runs the python OCR and updates feedback.txt 
	RunWait(@ComSpec & " /c " & "Python Decision.py", "") 
EndFunc

Func Capture() 
	WinActivate("Dofus")
	Sleep(200)
	_ScreenCapture_Capture(@ScriptDir & "\Imgs\Screenshot.png", $iFMWindowLeft, $iFMWindowTop, $iFMWindowRight, $iFMWindowBottom)
	RunWait(@ComSpec & " /c " & "magick Imgs\screenshot.png -monochrome Imgs\screenshot.png", "")
EndFunc	


Func Improve() ;applies the adequate action runs after the python OCR file
	Local $hFeedBack = FileOpen("feedback.txt",$FO_READ)
	If $hFeedBack = -1 Then
		MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the feedback file.")
	Else 
		$sFeedBack = FileRead($hFeedBack, 4)
		;MsgBox($MB_SYSTEMMODAL, "FeedBack", $sFeedBack)
	EndIf

	Switch $sFeedBack
		Case "EXIT"
			MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the feedback file.")
			Terminate()
		Case "3SAG"
			MouseClick($MOUSE_CLICK_LEFT, $iRunePax, $i3SAGy, 2)
			Sleep(500)
			Fusionner()
		Case "1CRI"
			MouseClick($MOUSE_CLICK_LEFT, $iRunex, $i1CRIy, 2)
			Sleep(500)
			Fusionner()
		Case "1DON"
			MouseClick($MOUSE_CLICK_LEFT, $iRunex, $i1DONy, 2)
			Sleep(500)
			Fusionner()
		Case "1DOT"
			MouseClick($MOUSE_CLICK_LEFT, $iRunex, $i1DOTy, 2)
			Sleep(500)
			Fusionner()
		Case "1DOE"
			MouseClick($MOUSE_CLICK_LEFT, $iRunex, $i1DOEy, 2)
			Sleep(500)
			Fusionner()
		Case Else
			MsgBox($MB_SYSTEMMODAL, "FeedBack", $sFeedBack)
			Terminate()
		EndSwitch
	;MouseClick($MOUSE_CLICK_LEFT, 500, 500, 2)
EndFunc

Func Fusionner()
	MouseClick($MOUSE_CLICK_LEFT, $iFusionnerx, $iFusionnery, 1)
EndFunc

Func Loop()
	While 1
		Capture()
		Sleep(500)
		Inspect()
		Sleep(500)
		Improve()
		Sleep(500)
	WEnd
EndFunc