<cfcomponent output="false">
	
	<!--- used to determine if the component is expending us --->
	<cfset this.ROCKETUNIT_TEST_COMPONENT = true>
	
	<!--- used to hold debug information for display --->
	<cfif !StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING")>
		<cfset request["TESTING_FRAMEWORK_DEBUGGING"] = {}>
	</cfif>



	
	<cffunction name="runTestPackage" access="public" returntype="boolean" output="false"
		hint="Instanciate all components in specified package and call their runTest() method.">
		<cfargument name="testPackage" type="string" required="true" hint="Package containing test components">
		<cfargument name="resultKey" type="string" required="false" default="test" hint="Key to store distinct test result sets under in request scope, defaults to 'test'">	
		<cfset var packageDir = "">
		<cfset var qPackage = "">
		<cfset var instance = "">
		<cfset var result = 0>
		
		<!--
			Called with a testPackage argument.  List package directory contents, instanciate
			any components we find and call their run() method.
		--->
		<cfset packageDir = "/" & replace(testpackage, ".", "/", "ALL")>
		<cfdirectory action="list"  directory="#expandPath(packageDir)#" name="qPackage">
	
		<cfloop query="qPackage">
			<cfif listLast(qPackage.name, ".") eq "cfc">
				<cfset instance = createObject("component", testPackage & "." & listFirst(qPackage.name, "."))>
				<cfif StructKeyExists(instance, "ROCKETUNIT_TEST_COMPONENT")>
					<cfset result = result + instance.runTest(resultKey)>
				</cfif>
			</cfif>
		</cfloop>
		
		<cfreturn result eq 0>
	</cffunction>




	<cffunction name="runTest" access="public" returntype="boolean" output="false"
		hint="Run all the tests in a component.">
		<cfargument name="resultKey" type="string" required="false" default="test" hint="Key to store distinct test result sets under in request scope, defaults to 'test'">	
		<cfargument name="testname" type="string" required="false" default="" hint="the name of the test to run">
	
		<cfset var key = "">
		<cfset var keyList = "">
		<cfset var time = "">
		<cfset var testCase = "">
		<cfset var status = "">
		<cfset var result = "">
		<cfset var message = "">
		<cfset var numTests = 0>
		<cfset var numTestFailures = 0>
		<cfset var numTestErrors = 0>
		<cfset var newline = chr(10) & chr(13)>
	
		<!---
			Check for and if necessary set up the structure to store test results
		--->
		<cfif !StructKeyExists(request, resultKey)>
			<cfset resetTestResults(resultKey)>
		</cfif>
	
		<cfset testCase = getMetadata(this).name>
	
		<!---
			Iterate through the members of the this scope in alphabetical order,
			invoking methods starting in "test".  Wrap with calls to setup()
			and teardown() if provided.
		--->
		<cfset keyList = listSort(structKeyList(this), "textnocase", "asc")>
	
		<cfloop list="#keyList#" index="key">
		
			<!--- keep track of the test name so we can display debug information --->
			<cfset TESTING_FRAMEWORK_VARS.RUNNING_TEST = key>
	
			<cfif (left(key, 4) eq "test" and isCustomFunction(this[key])) and (!len(arguments.testname) or (len(arguments.testname) and arguments.testname eq key))>
	
				<cfset time = getTickCount()>
	
				<cfif structKeyExists(this, "setup")>
					<cfset setup()>
				</cfif>
	
				<cftry>
	
					<cfset message = "">
					<cfinvoke method="#key#">
					<cfset status = "Success">
					<cfset request[resultkey].numSuccesses = request[resultkey].numSuccesses + 1>
	
				<cfcatch type="any">
	
					<cfset message = cfcatch.message>

					<cfif cfcatch.ErrorCode eq "__FAIL__">
	
						<!---
							fail() throws __FAIL__ exception
						--->
						<cfset status = "Failure">
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numFailures = request[resultkey].numFailures + 1>
						<cfset numTestFailures = numTestFailures + 1>
	
					<cfelse>
	
						<!---
							another exception thrown
						--->
						<cfset status = "Error">
						<cfset message = message & newline & listLast(cfcatch.tagContext[1].template, "/") & " line " & cfcatch.tagContext[1].line  & newline & newline & cfcatch.detail>
						<cfset request[resultkey].ok = false>
						<cfset request[resultkey].numErrors = request[resultkey].numErrors + 1>
						<cfset numTestErrors = numTestErrors + 1>
	
					</cfif>
	
				</cfcatch>
				</cftry>
	
				<cfif structKeyExists(this, "teardown")>
					<cfset teardown()>
				</cfif>
	
				<cfset time = getTickCount() - time>
	
				<!---
					Record test results
				--->
				<cfset result = structNew()>
				<cfset result.testCase = testCase>
				<cfset result.testName = key>
				<cfset result.time = time>
				<cfset result.status = status>
				<cfset result.message = message>
				<cfset arrayAppend(request[resultkey].results, result)>
	
				<cfset request[resultkey].numTests = request[resultkey].numTests + 1>
				<cfset numTests = numTests + 1>
	
			</cfif>
	
		</cfloop>
	
		<cfset result = structNew()>
		<cfset result.testCase = testCase>
		<cfset result.numTests = numTests>
		<cfset result.numFailures = numTestFailures>
		<cfset result.numErrors = numTestErrors>
		<cfset arrayAppend(request[resultkey].summary, result)>
	
		<cfset request[resultkey].numCases = request[resultkey].numCases + 1>
		<cfset request[resultkey]["end"] = now()>
	
		<cfreturn numTestErrors eq 0>
	</cffunction>




	<cffunction name="fail" access="public" returntype="void" output="false"
		hint="Called from a test function to cause the test to fail.">
		<cfargument name="message" type="string" required="false" default="" hint="Message to record in test results against failure.">
	
		<!---
			run() interprets exception with this errorcode as a "Failure".
			All other errorcodes cause are interpreted as an "Error".
		--->
		<cfthrow errorcode="__FAIL__" message="#HTMLEditFormat(message)#">
	</cffunction>




	<cffunction name="assert" access="public" returntype="void" output="false"
		hint="Called from a test function. If expression evaluates to false, record a failure against the test.">
		<cfargument name="expression" type="string" required="true" hint="String containing CFML expression to evaluate">
		<cfset var token = "">
		<cfset var tokenValue = "">
		<cfset var message = "assert failed: #expression#">
		<cfset var newline = chr(10) & chr(13)>
		<cfset var i = "">
		<cfset var evaluatedTokens = "">
	
		<cfif not evaluate(expression)>
	
			<cfloop from="1" to="#arrayLen(arguments)#" index="i">
	
				<cfset expression = arguments[i]>
				<cfset evaluatedTokens = structNew()>
	
				<!---
					Double pass of expressions with different delimiters so that for expression "a(b) or c[d]",
					"a(b)", "c[d]", "b" and "d" are evaluated.  Do not evaluate any expression more than once.
				--->
				<cfloop list="#expression# #reReplace(expression, "[([\])]", " ")#" delimiters=" +=-*/%##" index="token">
	
					<cfif not structKeyExists(evaluatedTokens, token)>
	
						<cfset evaluatedTokens[token] = true>
						<cfset tokenValue = "__INVALID__">
	
						<cfif not (isNumeric(token) or isBoolean(token))>
	
							<cftry>
								<cfset tokenValue = evaluate(token)>
							<cfcatch type="expression"/>
							</cftry>
	
						</cfif>
	
						<!---
							Format token value according to type
						--->
						<cfif (not isSimpleValue(tokenValue)) or (tokenValue neq "__INVALID__")>
	
							<cfif isSimpleValue(tokenValue)>
								<cfif not (isNumeric(tokenValue) or isBoolean(tokenValue))>
									<cfset tokenValue ="'#tokenValue#'">
								</cfif>
							<cfelse>
								<cfif isArray(tokenValue)>
									<cfset tokenValue = "array of #arrayLen(tokenValue)# items">
								<cfelseif isStruct(tokenValue)>
									<cfset tokenValue = "struct with #structCount(tokenValue)# members">
								<cfelseif IsCustomFunction(tokenValue)>
									<cfset tokenValue = "UDF">
								</cfif>
							</cfif>
	
							<cfset message = message & newline & token & " = " & tokenValue>
	
						</cfif>
	
					</cfif>
	
				</cfloop>
	
			</cfloop>
	
			<cfset fail(message)>
	
		</cfif>

	</cffunction>




	<cffunction name="debug" access="public" returntype="Any" output="false"
		hint="used to examine an expression. any overloaded arguments get passed to cfdump's attributeCollection">
		<cfargument name="expression" type="string" required="true" hint="the expression to examine.">
		<cfargument name="display" type="boolean" required="false" default="true" hint="whether to display the debug call. false returns without outputting anything into the buffer. good when you want to leave the debug command in the test for later purposes, but don't want it to display">
		<cfset var attributeArgs = {}>
		<cfset var dump = "">
		
		<cfif !arguments.display>
			<cfreturn>
		</cfif>

		<cfset attributeArgs["var"] = "#evaluate(arguments.expression)#">
		
		<cfset structdelete(arguments, "expression")>
		<cfset structdelete(arguments, "display")>
		<cfset structappend(attributeArgs, arguments, true)>

		<cfsavecontent variable="dump">
		<cfdump attributeCollection="#attributeArgs#">
		</cfsavecontent>
		
		<cfif !StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], TESTING_FRAMEWORK_VARS.RUNNING_TEST)>
			<cfset request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST] = []>
		</cfif>
		<cfset arrayAppend(request["TESTING_FRAMEWORK_DEBUGGING"][TESTING_FRAMEWORK_VARS.RUNNING_TEST], dump)>
	</cffunction>




	<cffunction name="raised" access="public" returntype="string" output="false"
		hint="catches an raised error and returns the error type. great if you want to test that a certain exception will be raised.">
		<cfargument name="expression" type="string" required="true">
		<cftry>
			<cfset evaluate(arguments.expression)>
			<cfcatch type="any">
				<cfreturn trim(cfcatch.type)>
			</cfcatch>
		</cftry>
		<cfreturn "">
	</cffunction>




	<cffunction name="stringsEqual" access="public" returntype="void" output="false"
		hint="Called from a test function to compare strings that might differ in minor ways that may be hard to spot. Fails test with a message containing a table of character index comparisons">
		<cfargument name="string1" type="string" required="true">
		<cfargument name="string2" type="string" required="true">
		
		<cfset var output = "<table>">
		<cfset var i = 0>
		<cfset var c1 = 0>
		<cfset var c2 = 0>
		<cfset var bFail = false>
		<cfset var maxLen = max(len(string1), len(string2))>
		
		<cfloop from="1" to="#maxLen#" index="i">
			
			<cfset c1 = 0>
			<cfset c2 = 0>
			
			<cfif i le len(string1)>
				<cfset c1 = asc(mid(string1, i, 1))>
			</cfif>
			
			<cfif i le len(string2)>
				<cfset c2 = asc(mid(string2, i, 1))>
			</cfif>
			
			<cfif c1 neq c2>
				<cfset bFail = true>
				<cfset output = output & "<tr><td><b>#chr(c1)#</b></td><td><b>#c1#</b></td><td><b>#chr(c2)#</b></td><td><b>#c2#</b></td></tr>">
				<cfbreak>
			<cfelse>
				<cfset output = output & "<tr><td>#chr(c1)#</td><td>#c1#</td><td>#chr(c2)#</td><td>#c2#</td></tr>">	
			</cfif>
			
		</cfloop>
		
		<cfif bFail>
			<cfset fail(output & "</table>")>
		</cfif>

	</cffunction>




	<cffunction name="resetTestResults" access="public" returntype="void" output="false"
		hint="Clear results.">
		<cfargument name="resultKey" type="string" required="false" default="test" hint="Key to store distinct test result sets under in request scope, defaults to 'test'">
		<cfscript>
		request[resultkey] = {};
		request[resultkey].begin = now();
		request[resultkey].ok = true;
		request[resultkey].numCases = 0;
		request[resultkey].numTests = 0;
		request[resultkey].numSuccesses = 0;
		request[resultkey].numFailures = 0;
		request[resultkey].numErrors = 0;
		request[resultkey].summary = [];
		request[resultkey].results = [];
		</cfscript>
	</cffunction>




	<cffunction name="HTMLFormatTestResults" access="public" returntype="string" output="false"
		hint="Report test results at overall, test case and test level, highlighting failures and errors.">
		<cfargument name="resultKey" type="string" required="false" default="test" hint="Key to retrive distinct test result sets from in request scope, defaults to 'test'">
		<cfargument name="showPassedTests" type="boolean" required="false" default="true" hint="HTML formatted test results">
	
		<cfset var testIndex = "">
		<cfset var newline = chr(10) & chr(13)>

		<cfsavecontent variable="result">
		<cfoutput>
		<table cellpadding="5" cellspacing="0">
			<cfif not request[resultkey].ok>
				<tr><th align="left"><span style="color:red;font-weight:bold">Status</span></th><td><span style="color:red;font-weight:bold">Failed</span></td></tr>
			<cfelse>
				<tr><th align="left">Status</th><td>Passed</td></tr>
			</cfif>
			<tr><th align="left">Date</th><td>#dateFormat(request[resultkey].end)#</td></tr>
			<tr><th align="left">Begin</th><td>#timeFormat(request[resultkey].begin, "HH:mm:ss L")#</td></tr>
			<tr><th align="left">End</th><td>#timeFormat(request[resultkey].end, "HH:mm:ss L")#</td></tr>
			<tr><th align="left">Cases</th><td align="right">#request[resultkey].numCases#</td></tr>
			<tr><th align="left">Tests</th><td align="right">#request[resultkey].numTests#</td></tr>
			<cfif request[resultkey].numFailures neq 0>
				<tr><th align="left"><span style="color:red;font-weight:bold">Failures</span></th>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].numFailures#</span></td></tr>
			<cfelse>
				<tr><th align="left">Failures</th><td align="right">#request[resultkey].numFailures#</td></tr>
			</cfif>
			<cfif request[resultkey].numErrors neq 0>
				<tr><th align="left"><span style="color:red;font-weight:bold">Errors</span></th>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].numErrors#</span></td></tr>
			<cfelse>
				<tr><th align="left">Errors</th><td align="right">#request[resultkey].numErrors#</td></tr>
			</cfif>
		</table>
		<br>
		<table border="0" cellpadding="5" cellspacing="0">
		<tr align="left"><th>Test Case</th><th>Tests</th><th>Failures</th><th>Errors</th></tr>
		<cfloop from="1" to=#arrayLen(request[resultkey].summary)# index="testIndex">
			<tr valign="top">
			<td>#request[resultkey].summary[testIndex].testCase#</td>
			<td align="right">#request[resultkey].summary[testIndex].numTests#</td> 
			<cfif request[resultkey].summary[testIndex].numFailures neq 0>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].summary[testIndex].numFailures#</span></td>
			<cfelse>
				<td align="right">#request[resultkey].summary[testIndex].numFailures#</td>
			</cfif>
			<cfif request[resultkey].summary[testIndex].numErrors neq 0>
				<td align="right"><span style="color:red;font-weight:bold">#request[resultkey].summary[testIndex].numErrors#</span></td>
			<cfelse>
				<td align="right">#request[resultkey].summary[testIndex].numErrors#</td>
			</cfif>
			</tr>
		</cfloop>
		</table>
		<br>
		<table border="0" cellpadding="5" cellspacing="0">
		<tr align="left"><th>Test Case</th><th>Test Name</th><th>Time</th><th>Status</th><th>Message</th></tr>
		<cfloop from="1" to=#arrayLen(request[resultkey].results)# index="testIndex">
			<cfif arguments.showPassedTests>
				<tr valign="top">
				<td>#request[resultkey].results[testIndex].testCase#</td>
				<td>#request[resultkey].results[testIndex].testName#</td>
				<td align="right">#request[resultkey].results[testIndex].time#</td>
				<cfif request[resultkey].results[testIndex].status neq "Success">
					<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].status#</span></td>
					<td><span style="color:red;font-weight:bold">#replace(request[resultkey].results[testIndex].message, newline, "<br>", "ALL")#</span></td>
				<cfelse>
					<td>#request[resultkey].results[testIndex].status#</td>
					<td>#request[resultkey].results[testIndex].message#</td>
				</cfif>
				</tr>
			<cfelseif request[resultkey].results[testIndex].status neq "Success">
				<tr valign="top">
				<td>#request[resultkey].results[testIndex].testCase#</td>
				<td>#request[resultkey].results[testIndex].testName#</td>
				<td align="right">#request[resultkey].results[testIndex].time#</td>
				<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].status#</span></td>
				<td><span style="color:red;font-weight:bold">#request[resultkey].results[testIndex].message#</span></td>
				</tr>
			</cfif>
			<cfif StructKeyExists(request, "TESTING_FRAMEWORK_DEBUGGING") && StructKeyExists(request["TESTING_FRAMEWORK_DEBUGGING"], request[resultkey].results[testIndex].testName)>
				<cfloop array="#request['TESTING_FRAMEWORK_DEBUGGING'][request[resultkey].results[testIndex].testName]#" index="i">
				<tr class="<cfif request[resultkey].results[testIndex].status neq 'Success'>errRow<cfelse>sRow</cfif>"><td colspan="5">#i#</tr>
				</cfloop>
			</cfif>
		</cfloop>
		</table>
		</cfoutput>
		</cfsavecontent>
	
		<cfreturn REReplace(result, "[	 " & newline & "]{2,}", newline, "ALL")>
	</cffunction>
	
</cfcomponent>