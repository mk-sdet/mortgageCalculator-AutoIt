#comments-start
	This script contains the test runner GUI for the mortgagecalculator.net application
	AUT:		mcalcnetn.exe
	Tool:		AutoIt
	Version:	3.3.14.5
	OS:			Windows 8.1
	Arch:		64 bit

	Author:		Muana Kimba
	Since:		2020-06-12
	Updated:	2021-03-13
#comments-end

;===== UTILITIES =====
#include '..\..\utils\library.au3'
#include '..\..\utils\reporter.au3'

;===== TEST CASES =====
#include '..\testCases\interestRateTest.au3'
#include '..\testCases\loanAmountTest.au3'
#include '..\testCases\numberOfPaymentsTest.au3'
#include '..\testCases\periodicPaymentTest.au3'

;===== AUTOIT LIBRARIES =====
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <Constants.au3>
#include <String.au3>

Global Const $testCases = ["validInterestRate", "validLoanAmount", "invalidLoanAmount", "validNumberOfPayments", "validPeriodicPayment"]	; test cases array
Global Const $nbTestCase = UBound($testCases)																								; test cases array length
Global $randomTestCases[$nbTestCase]																										; random test cases array

_Main()

Func _Main()
	;===== CREATE GUI =====
	Local $hGUI = GUICreate("Test Runner: mortgagecalculator.net", 500, 280)
	GUISetFont(14, $FW_MEDIUM, $GUI_FONTNORMAL, "Verdana")			; default font for GUI elements

	;===== TEST CASE LABEL=====
	Local $lblChoisir = GUICtrlCreateLabel("Choose a test case:", 165, 25, 210)

	;===== TEST CASES COMBOBOX =====
	Local $comboBox = GUICtrlCreateCombo("", 120, 60, 260, 0, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_DROPDOWNLIST))
	Local $cbItems
	For $i = 0 To $nbTestCase - 1
		$cbItems &= $testCases[$i] & "|"							; build the string that will be use to fill the combobox of options delimited with "|"
	Next
	$cbItems = StringLeft($cbItems, StringLen($cbItems) - 1)		; -1 to remove "|" of the last added option
	GUICtrlSetData (-1, $cbItems, $testCases[0])					; set the $testCases[0] as the default combobox option

	;===== RUN BUTTONS =====
	Local $btnTest = GUICtrlCreateButton("Run the test", 50, 120, 140, 50)
	Local $btnSuite = GUICtrlCreateButton("Run the suite", 50, 200, 140, 50)

	;===== NB RUN LABEL AND INPUT =====
	Local $lblNbRun = GUICtrlCreateLabel("Number of executions:", 255, 120, 210)
	Local $txtNbRun = GUICtrlCreateInput('', 305, 150, 100, 30, BitOR($ES_CENTER, $ES_NUMBER))		; center value and only allow digits
	GUICtrlSetState($txtNbRun, $GUI_DISABLE)	; by default the Execution text input field is disabled because the checkbox is unchecked
	Local $nbRun			; amount of times to execute the test suite

	Local $random = 0		; 0 to execute the test suite in order based on test case ID and 1 for a random execution (integer is easier to toggle value than boolean)

	;===== RANDOM CHECKBOX =====
	Local $checkBox = GUICtrlCreateCheckbox("Random", 305, 210, 110, 25)

	;===== DISPLAY GUI =====
	GUISetState()

	;===== GUI EVENTS HANDLER =====
	While(1)
		Switch GUIGetMsg()
			Case $btnTest
				RunTest(GUICtrlRead($comboBox))						; ControlGetText would be for getting the value of a control in an external GUI
			Case $btnSuite
				$nbRun = Number(GUICtrlRead($txtNbRun))				; format the text input field number to remove the zeros in front i.e.007
					RunSuite($random, $nbRun)
			Case $checkBox
				$random = Mod($random + 1, 2)						; toggle the $random variable value when the checkbox is clicked
				If GUICtrlRead($checkBox) = $GUI_CHECKED Then
					GUICtrlSetState($txtNbRun, $GUI_ENABLE)			; enable the Execution text input field
				Else
					GUICtrlSetState($txtNbRun, $GUI_DISABLE)		; disable the Execution text input field
					GUICtrlSetData($txtNbRun, "")					; clear the Execution text input field
				EndIf
			Case $GUI_EVENT_CLOSE
				MsgBox($MB_ICONINFORMATION, "Testing Fact", '"Testing shows the presence, not the absence of bugs."' _
				& @CRLF & _StringRepeat(" ", 23) & 'Edsger W. Dijkstra (1968)')
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>_Main



;===== This function execute a test case =====
Func RunTest($test)
	Local $result = Execute($test & "()")															; Execution of the selected test case one time
	Local $TIME[1] = [@HOUR & ':' & @MIN & ':' & @SEC]

	; 3D array
	Local $results[1][1][UBound($result)] = [ _														; start of executions array
												[ _													; start of test cases arary of an execution
													[$result[0], $result[1], $result[2]] _			; start and end of information (ID, Name, Log) array of an test case
												] _													; end of test cases arary of an execution
											]														; end of executions array
	GenerateReport($results, $TIME)
EndFunc

;===== This function executes the entire test suite =====
Func RunSuite($random, $nbRun)
	$nbRun = $nbRun < 1 ? 1 : $nbRun										; check if $nbRun is valid
	Local $TIME[$nbRun]														; time array of each execution cycle
	Local $nbInfo = 3														; number of info a test case has
	Local $results[$nbRun][$nbTestCase][$nbInfo]							; 3D array (executions, test cases, info) - for reporting
	Local $result															; 1D array (ID, Name, Log) - information of a test case

	;===== Execution of test cases in order based on their ID one time =====
	If $random == 0 Then
		For $i = 0 To $nbTestCase - 1
			$result = Execute($testCases[$i] & "()")
			For $j = 0 To $nbInfo - 1
				$results[0][$i][$j] = $result[$j]
			Next
		Next
		$TIME[0] = @HOUR & ':' & @MIN & ':' & @SEC


	;===== Execution of test cases randomly $nbRun times =====
	Else
		For $i = 0 To $nbRun - 1
			GenerateTestCases()
			For $j = 0 To $nbTestCase - 1
				$result = Execute($randomTestCases[$j] & "()")
				For $k = 0 To $nbInfo - 1
					$results[$i][$j][$k] = $result[$k]
				Next
			Next
			$TIME[$i] = @HOUR & ':' & @MIN & ':' & @SEC
		Next
	EndIf

	GenerateReport($results, $TIME)
EndFunc

;===== This function generates a random test cases array =====
Func GenerateTestCases()
	ClearTestCases()													; clear the random test cases array to avoid an infinite loop
	Local $index														; random position of the test cases array

	For $i = 0 To $nbTestCase - 1
        Do
			$index = Random(0,$nbTestCase - 1,1)						; generate a random integer between 0 and $nbTestCase - 1 inclusive
		Until Not ContainsInRandomTestCasesArray($testCases[$index])	; stop generating if the random test cases array does not contain the test case at the generated index of the test cases array
		$randomTestCases[$i] = $testCases[$index]						; add the test case to the random test cases array
    Next
EndFunc

;===== This function clears the random test cases array =====
Func ClearTestCases()
	For $i = 0 To $nbTestCase - 1
		$randomTestCases[$i] = ''
    Next
EndFunc

;===== This function verifies if the random test cases array contains the given test case =====
Func ContainsInRandomTestCasesArray($testCase)
	For $i = 0 To $nbTestCase - 1
        If $testCase == $randomTestCases[$i] Then						; == Case sensitive comparison
			Return True
		EndIf
    Next

	Return False
EndFunc