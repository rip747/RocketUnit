***NOTE!***

The official repo for this project is located on RIAForge at [http://rocketunit.riaforge.org/](http://rocketunit.riaforge.org/). This is my personal fork.

If you like this project please consider contributing from the main repo. I will be sending my changes to the original author.

---

RocketUnit is a unit testing framework for ColdFusion. What? I hear you say, Not another one! Well yes, but this one is a bit different:

* It is small - a single CFC.
* It has one assert() function, not tens, but still gives detailed, meaningful messages when assertions fail.

Together, the above features make RocketUnit pretty approachable and easy to use. A few of our clients have been successfully using RocketUnit to test anything from a single custom tag up to a complex payment gateway.

Requirements:
ColdFusion MX


Terminology
-----------
-	A Test Package is a collection of Test Cases that tests the functionality
	of an application/service/whatever.

-	A Test Case is a collection of Tests to apply to a particular CF component,
	tag or include file.

- 	A Test is a sequence of calls to the code being tested and Assertions about
	the results we get from the code.

-	An Assertion is a statement we make about the results we get that should
	evaluate to true if the tested code is working properly.

How are these things represented in test code using this file?
--------------------------------------------------------------
-	A Test Package is a directory that can be referred to by a CF mapping, and
	ideally outside the web root for security.

-	A Test Case is a CF component in that directory that has this file included
	in itself or a component it extends.  The include should be inside the
	<cfcomponent> tag and outside any <cffunction> tags.

-	A Test is a method in one of these components.  The method name should start with
	the word "test", it should require no arguments and return void.  Any setup or
	clearup code common to all test functions can be added to optional setup() and
	teardown() methods, which again take no arguments and return void.

	Tests in each Test Case are run in alphabetical order.  If you want your tests
	to run in a particular order you could name them test01xxx, test02yyy, etc.

-	An Assertion is a call to the assert() method (mixed in by this file) inside
	a test method.  assert() takes a string argument, an expression (see ColdFusion
	evaluate() documentation) that evaluates to true or false.  If false, a "failure"
	is recorded for the test case and the test case fails.  assert() tries to include
	the value of any variables it finds in the expression.

	If there are specific variable values you would like included in the failure message,
	pass them as additional string arguments to assert().  Multiple variables can be
	listed in a single space-delimited string if this is convenient.

	For more complicated assertions you may call the fail() method directly, which takes
	a single message string as an argument.

-	If an uncaught exception is thrown an "error" is recorded for the Test Case and the
	Test Case fails.

Running tests
-------------
This file can be included in any ColdFusion code, not just components.  To run
a Test Package include this file and call run(), passing the Test Package name in dot
format, e.g. run("com.rocketboots.myapp.test").  If you want to run a specific Test Case,
create an instance of the Test Case component and call its run() method without any
arguments.

The test results are available in the request.test structure.  If you would like to
use a different key in request (as we do for the rocketunit self-tests) for the results
you can pass the key name as a second argument to the run method.  If you would like
a formatted HTML string of the test results call HTMLFormatTestResults().  You can call
run() multiple times and the test results will be combined.  If you wish to reset the test
results before calling run() again, call resetTestResults().