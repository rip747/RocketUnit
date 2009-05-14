<html>
<head>
	<title>RocketUnit unit tests</title>
</head>
<body>
	<cfset test = createObject("component", "com.rocketboots.rocketunit.Test")>
	<cfset test.runTestPackage("com.rocketboots.rocketunit.rocketunittests")>
	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>