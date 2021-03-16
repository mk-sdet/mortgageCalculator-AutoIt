#comments-start
	Test case:	Calculate the number of payments (positive test case)

	Author:		Muana Kimba
	Since:		2020-06-09
	Updated:	2021-03-12
#comments-end

#include-once

Func ValidNumberOfPayments()
	; Test case info
	Local Const $ID = "RQ3.SC1.TC1"
	Local Const $NAME = "validNumberOfPayments"

	; Preconditions
	OpenApp()

	Local Const $nbSteps = 4	; number of steps

	; Variables
	Local Const $inputs[$nbSteps] = [$paymentsPerYear_input, $loanAmount_input, $interestRate_input, $periodicPayment_input]
	Local Const $values[$nbSteps] = [3100, 53100, 2.5, 200]
	Local Const $expectedValues[$nbSteps] = [3100, 53100, 2.5, 200]
	Local Const $expectedValue = 266

	; Steps
	Local $log = EnterValues($inputs, $values, $expectedValues)						; execute steps 1 to 4
	$log &= ClickFind($nbOfPayments_btnFind, $nbOfPayments_input, $expectedValue)	; execute the last step, which is the validation
	Sleep(1000)

	; Failed step log
	$log = FormatFailedStepLog($log)

	; Postconditions
	CloseApp()

	; Result
	Local $result[3] = [$ID, $NAME, $log]
	Return $result
EndFunc