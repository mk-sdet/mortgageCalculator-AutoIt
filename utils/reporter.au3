#comments-start
	This script contains the logic to generate and display the HTML report
	inside of the reports directory.

	Author:		Muana Kimba
	Since:		2020-03-12
	Updated:	2021-03-13
#comments-end

#include-once
;
;===== This function generates the HTML report with test results and execution times as parameters =====
Func GenerateReport($testResults, $times)
	Local $DATE = 'Date: ' & @YEAR & '-' & @MON & '-' & @MDAY
	Local $HTML = '<!DOCTYPE html>' _
					& @CRLF & '<html lang="en">' _
						& @CRLF & @TAB & '<head>' _
							& @CRLF & @TAB & @TAB & '<title>Automation Test Report</title>' _
							& @CRLF & @TAB & @TAB & '<link href="./css/style.css" rel="stylesheet" media="all" type="text/css">' _
						& @CRLF & @TAB & '</head>' _
						& @CRLF & @TAB & '<body>' _
							& @CRLF & @TAB & @TAB & '<h1><span>Report: mortgagecalculator.net</span></h1>' _
							& @CRLF & @TAB & @TAB & '<h4><span>' & $DATE & '</span></h4>'

	; Loop through the $testResults 3D array
	; to create the HTML table
	Local $nbRun = UBound($testResults)									; first dimensional array length (array of executions)
	Local $nbTestCase = UBound($testResults, 2)							; second dimensional array length (array of test cases for an execution)
	Local $count														; number of passed test cases
	For $i = 0 To $nbRun - 1
		$count = $nbTestCase
		$HTML &= @CRLF & @TAB & @TAB & '<h4>' & "Time " & $times[$i] & '</h4>' _
				& @CRLF & @TAB & @TAB & '<div class="table">' _
					& @CRLF & @TAB & @TAB & @TAB & '<table>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & '<thead>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '<tr>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<th colspan=5>Execution ' & ($i+1) & '</th>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '</tr>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & '</thead>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & '<tbody>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '<tr>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<th>#</th>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<th>ID</th>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<th>Test Case</th>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<th>Status</th>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<th>Failed Step Log<br/>&lt;actual value&gt; [&lt;expected value&gt;] </th>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '</tr>'
		For $j = 0 To $nbTestCase - 1
			$HTML &= @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '<tr>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<td>' & $j+1 & '</td>' _							; #
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<td>' & $testResults[$i][$j][0] & '</td>' _		; ID
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<td>' & $testResults[$i][$j][1] & '</td>' _		; Test Case
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB
			If $testResults[$i][$j][2] == "" Then									; empty log if the test case passed
				$HTML &= '<td style="background-color:darkgreen">'					; green for passed						; Status
			Else
				$HTML &= '<td style="background-color:darkred">'					; red for failed						; Status
				$count -= 1															; decrement test passed count
			EndIf
			$HTML &= '</td>' _
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<td>' & StringReplace($testResults[$i][$j][2], @CRLF, "</br>") & '</td>' _		; Log, replace AutoIt returns with HTML returns
					& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '</tr>'
		Next
		$HTML &= @CRLF & @TAB & @TAB & @TAB & @TAB & '</tbody>' _
				& @CRLF & @TAB & @TAB & @TAB & @TAB & '<tfoot>' _
				& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '<tr>' _
				& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & @TAB & '<td colspan=5>' & "Test Passed : " & $count/$nbTestCase*100 & "%" & '</td>' _		; Test passed %
				& @CRLF & @TAB & @TAB & @TAB & @TAB & @TAB & '</tr>' _
				& @CRLF & @TAB & @TAB & @TAB & @TAB & '</tfoot>' _
				& @CRLF & @TAB & @TAB & @TAB & '</table>' _
				& @CRLF & @TAB & @TAB & '</div>'
	Next

	; Closing <body> and <html> tags
	$HTML &= @CRLF & @TAB & '</body>' _
			& @CRLF & '</html>'

	; Write the HTML content into the index file
	Local $report = '..\..\reports\index.html'
	FileDelete($report)
	FileWrite($report, $HTML)
	ShellExecute($report)
EndFunc