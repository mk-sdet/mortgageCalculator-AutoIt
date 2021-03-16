#comments-start
	This script contains locators and utility functions for interacting
	with UI elements of the mortgagecalculator.net application

	Author:		Muana Kimba
	Since:		2020-06-11
	Updated:	2021-03-12
#comments-end

#include-once

; #START OF LOCATORS# =======================================================================

;===== Application under test =====
Global Const $AUT = '../../app/mcalcnetn.exe'

;===== Variables for the main window =====
Global Const  $mainWindow = 'MortgageCalculator.net'

; Variables for text input fields
Global Const  $paymentsPerYear_input = 'TEdits5'
Global Const  $loanAmount_input = 'TEdits4'
Global Const  $interestRate_input = 'TEdits3'
Global Const  $periodicPayment_input = 'TEdits2'
Global Const  $nbOfPayments_input = 'TEdits1'

; Variables for buttons
Global Const  $loanAmount_btnFind = 'TBitBtns7'
Global Const  $interestRate_btnFind = 'TBitBtns6'
Global Const  $periodicPayment_btnFind = 'TBitBtns5'
Global Const  $nbOfPayments_btnFind = 'TBitBtns4'
Global Const  $btnClear = 'TBitBtns3'
Global Const  $btnExit = 'TBitBtns2'
Global Const  $btnSchedule = 'TBitBtns1'

;===== Variables for the 'Schedule' window =====
Global Const  $scheduleWindow = 'Full Loan Amortization'

; Variable for the text area
Global Const  $textArea = 'TRichEdits1'

; Variables for buttons
Global Const  $btnClose = 'TBitBtns2'
Global Const  $btnPrint = 'TBitBtns1'

; #END OF LOCATORS# =========================================================================

; #START OF FUNCTIONS# ===========================================================================

;===== This function open the application =====
Func OpenApp()
	Run(@ScriptDir & '\' & $AUT)	; launch the application

	WinWaitActive($mainWindow)		; wait for the application to open to give focus
EndFunc

;===== This function close the application =====
Func CloseApp()
	WinClose($mainWindow)		; close the application

	WinWaitClose($mainWindow)	; wait for the applciation to close
EndFunc

;===== This function enters n values into n text input fields =====
Func EnterPreValues(Const $inputs, Const $values)
	Local Const $arrayLength = UBound($inputs)							; length of inputs and values arrays

	For $i = 0 To $arrayLength - 1
		$input = ControlGetText($mainWindow, '', $inputs[$i])
		If Not ($input == $values[$i]) Then								; case sensitive comparison with Not(==) instead of <>
			ControlSetText($mainWindow, '', $inputs[$i], $values[$i])
		EndIf
    Next
EndFunc

;===== This function enters n values into n text input fields and returns the result (log) =====
Func EnterValues(Const $inputs, Const $values, Const $expectedValues)
	Local $log = ""
	Local Const $arrayLength = UBound($inputs)			; length of inputs and values arrays

	For $i = 0 To $arrayLength - 1
        ControlSetText($mainWindow, '', $inputs[$i], $values[$i])			; step $i
		$log &= VerifyValue("Step " & $i+1, $inputs[$i], $expectedValues[$i])
    Next

	Return $log
EndFunc

;===== This function verifies the text input field value with the expected value given as parameter and returns a log =====
;===== if both values are the same, log would be empty, otherwise it would contains the step, actual value and the expected one between square brackets
Func VerifyValue($step, $input, $expectedValue)
	Local $log = ""
	Local $actualValue = ControlGetText($mainWindow, '', $input)

	If Not ($actualValue == $expectedValue) Then			; case sensitive comparison with Not(==) instead of <>
		$log = $step & ": " & $actualValue & " [" & $expectedValue & "]" & @CRLF
	EndIf

	Return $log
EndFunc

;===== This function clicks on a Find button and returns the result (log) =====
Func ClickFind($btnFind, $input, $expectedValue)
	ControlClick($mainWindow, '', $btnFind)

	Return VerifyValue("Last Step", $input, $expectedValue)
EndFunc

;===== This function formats the log for failed steps and returns it =====
Func FormatFailedStepLog($log)
	If $log <> "" Then
		$log = StringLeft($log, StringLen($log) - 2)		; to remove the last @CRLF (works like substring method)
	EndIf

	Return $log
EndFunc

; #END OF FUNCTIONS# =============================================================================