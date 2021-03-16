#comments-start
	Test case:	Calculate periodic payments (positive test case)

	Author:		Muana Kimba
	Since:		2020-06-09
	Updated:	2021-03-12
#comments-end

#include-once

Func ValidPeriodicPayment()
	; Test case info
	Local Const $ID = "RQ4.SC1.TC1"
	Local Const $NAME = "validPeriodicPayment"

	; Preconditions
	OpenApp()
	Local Const $preInputs = [$nbOfPayments_input]
	Local Const $preValues = [360]
	EnterPreValues($preInputs, $preValues)

	Local Const $nbSteps = 3	; number of steps

	; Variables
	Local Const $inputs[$nbSteps] = [$paymentsPerYear_input, $loanAmount_input, $interestRate_input]
	Local Const $values[$nbSteps] = [2000, 22000, 2.5]
	Local Const $expectedValues[$nbSteps] = [2000, 2200, 3.5]
	Local Const $expectedValue = 61.25

	; Steps
	Local $log = EnterValues($inputs, $values, $expectedValues)								; execute steps 1 to 3
	$log &= ClickFind($periodicPayment_btnFind, $periodicPayment_input, $expectedValue)		; execute the last step, which is the validation
	Sleep(1000)

	; Failed step log
	$log = FormatFailedStepLog($log)

	; Postconditions
	CloseApp()

	; Result
	Local $result[3] = [$ID, $NAME, $log]
	Return $result
EndFunc