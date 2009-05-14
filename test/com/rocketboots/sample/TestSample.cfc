<!---
	Test suite for Sample Application
	
	Note that although we are testing a CFC in this instance, we could also test includes,
	custom tags, functions or even web pages or remote services using cfhttp etc.

	Copyright 2007 RocketBoots Pty Limited - http://www.rocketboots.com.au

    This file is part of RocketUnit.

    RocketUnit is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    RocketUnit is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with RocketUnit; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

	@version $Id: TestSample.cfc 168 2007-04-12 07:50:38Z robin $
--->

<cfcomponent extends="com.rocketboots.rocketunit.Test">

	<!---
		Set up some constants used during the tests
	--->
	
	<cfset CLASS_NAME="com.rocketboots.sample.Sample">



	<!---
		This optional method is called for you automatically before every test 
		to set things up for you - if using a database you might reset the table
		contents etc.
	--->
	<cffunction access="public" returntype="void" name="setup">
		<cfset instance = createObject("component", CLASS_NAME).init()>
	</cffunction>



	<!---
		This optional method is called for you automatically after every test
		to clean things up.
	--->
	<cffunction access="public" returntype="void" name="teardown">
		<cfset structDelete(variables, "instance")>
	</cffunction>
	
	
	
	<!---
		When working with cfcs it's a good reality check to see that the instance
		was created successfully before you proceed further.
	--->
	<cffunction access="public" returntype="void" name="test_00_instance">
		<cfscript>
			assert("isDefined('instance')");
			assert("getMetadata(instance).name eq CLASS_NAME");
			// You could go on to check the superclass, existance of methods etc
		</cfscript>
	</cffunction>
	

	<!---
		This test case fails because of a bug (for demo purposes) in
		the addOne() method. The test output reports this as a "Failure"
		and breaks down the assert expression so that you understand why it failed.
		This breaking-down is why RocketUnit can get away with a single assert statement,
		unlike the various *Units that need assertEquals(), assertNotEquals() etc
		to make a sensible message when an assertion fails.
		
		Note that a bug in your test method will also be reported as an error.
	--->
	<cffunction access="public" returntype="void" name="test_01_addOne">
		<cfset assert("instance.addOne(1) eq 2")>
	</cffunction>
	
		
		
	<!---
		The squareRoot function has a syntax error in it.  In the results this
		will be reported as an "Error" rather that a "Failure".  Note that
		an error in the test method itself will also be reported as "Error".
	--->
	<cffunction access="public" returntype="void" name="test_02_squareRoot">
		<cfset assert("instance.squareRoot(4) eq 2")>
	</cffunction>



	<!---
		A test case that actually passes!  Not very interesting to watch, though.
	--->
	<cffunction access="public" returntype="void" name="test_03_squareRoot">
		<cfset assert("instance.squareRoot2(4) eq 2")>
	</cffunction>
	
	
	
	<!---
		You should test for abnormal processing too.  Here is an example of testing 
		for an exception that should be thrown by our method.  We're not suggesting you should
		test all the built in functions - that's Adobe's job. You might want to check that
		cfparams are in place, or that the cfthrow in your method is creating the right
		sort of exception.
	--->
	<cffunction access="public" returntype="void" name="test_04_squareRoot_negative">
		<cftry>
			<cfset x = instance.squareRoot2(-4)>
			<!---
				If we got this far the method did not thow an error as it was supposed to!
				Use the fail() method to create a custom failure message.
			--->
			<cfset fail("Did not throw expression exception")>
		<cfcatch type="expression">
			<!--- 
				The function correctly threw an expression exception.
				You could do further interrogation of the cfcatch scope
				at this point to check error codes etc and call fail if
				they don't pass muster.
			--->
		</cfcatch>
		</cftry>
	</cffunction>
	
	
	<!---
		Here you could add some private helper methods to be used by your testing code.
		For instance, working with a database you might add methods to clear rows out of a
		table or set up test data.
	--->
	
</cfcomponent>