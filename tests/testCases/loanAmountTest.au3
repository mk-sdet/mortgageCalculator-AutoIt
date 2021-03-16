#comments-start
	Test case 1:	Calculate the loan amount (positive test case)
	Test case 2:	Calculate the loan amount with an invalid payments per year (negative test case)

	Author:		Muana Kimba
	Since:		2020-06-09
	Updated:	2021-03-12
#comments-end

#include-once

Func ValidLoanAmount()
	; Test case info
	Local Const $ID = "RQ2.SC1.TC1"
	Local Const $NAME = "validLoanAmount"

	; Preconditions
	OpenApp()
	Local Const $preInputs = [$nbOfPayments_input]
	Local Const $preValues = [360]
	EnterPreValues($preInputs, $preValues)

	Local Const $nbSteps = 3	; number of steps

	; Variables
	Local Const $inputs[$nbSteps] = [$paymentsPerYear_input, $interestRate_input, $periodicPayment_input]
	Local Const $values[$nbSteps] = [8200, 2.5, 200]
	Local Const $expectedValues[$nbSteps] = [8200, 2.5, 200]
	Local Const $expectedValue = 71960.3926

	; Steps
	Local $log = EnterValues($inputs, $values, $expectedValues)					; execute steps 1 to 3
	$log &= ClickFind($loanAmount_btnFind, $loanAmount_input, $expectedValue)	; execute the last step, which is the validation
	Sleep(1000)

	; Failed step log
	$log = FormatFailedStepLog($log)

	; Postconditions
	CloseApp()

	; Result
	Local $result[3] = [$ID, $NAME, $log]
	Return $result
EndFunc

Func InvalidLoanAmount()
	; Test case info
	Local Const $ID = "RQ2.SC2.TC1"
	Local Const $NAME = "invalidLoanAmount"

	; Preconditions
	OpenApp()
	Local Const $preInputs = [$nbOfPayments_input]
	Local Const $preValues = [360]
	EnterPreValues($preInputs, $preValues)

	Local Const $nbSteps = 3	; number of steps

	; Variables
	Local Const $inputs[$nbSteps] = [$paymentsPerYear_input, $interestRate_input, $periodicPayment_input]
	Local Const $values[$nbSteps] = ["qwerty", 2.5, 200]
	Local Const $expectedValues[$nbSteps] = ["qwerty", 2.5, 200]
	Local Const $expectedValue = ""

	; Steps
	Local $log = EnterValues($inputs, $values, $expectedValues)					; execute steps 1 to 3
	$log &= ClickFind($loanAmount_btnFind, $loanAmount_input, $expectedValue)	; execute the last step, which is the validation
	Sleep(1000)

	; Failed step log
	$log = FormatFailedStepLog($log)

	; Postconditions
	CloseApp()

	; Result
	Local $result[3] = [$ID, $NAME, $log]
	Return $result
EndFunc