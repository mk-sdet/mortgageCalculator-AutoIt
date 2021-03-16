#comments-start
	Test case:	Calculate the interest rate (positive test case)

	Author:		Muana Kimba
	Since:		2020-06-09
	Updated:	2021-03-12
#comments-end

#include-once

Func ValidInterestRate()
	; Test case info
	Local Const $ID = "RQ1.SC1.TC1"
	Local Const $NAME = "validInterestRate"

	; Preconditions
	OpenApp()
	Local Const $preInputs = [$nbOfPayments_input]
	Local Const $preValues = [360]
	EnterPreValues($preInputs, $preValues)

	Local Const $nbSteps = 3	; number of steps

	; Variables
	Local Const $inputs[$nbSteps] = [$paymentsPerYear_input, $loanAmount_input, $periodicPayment_input]
	Local Const $values[$nbSteps] = [3100, 53100, 200]
	Local Const $expectedValues[$nbSteps] = [3100, 53100, 200]
	Local Const $expectedValue = 55.2773

	; Steps
	Local $log = EnterValues($inputs, $values, $expectedValues)						; execute steps 1 to 3
	$log &= ClickFind($interestRate_btnFind, $interestRate_input, $expectedValue)	; execute the last step, which is the validation
	Sleep(1000)

	; Failed step log
	$log = FormatFailedStepLog($log)

	; Postconditions
	CloseApp()

	; Result
	Local $result[3] = [$ID, $NAME, $log]
	Return $result
EndFunc