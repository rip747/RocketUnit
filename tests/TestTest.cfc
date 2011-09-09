<!---
	Test case to check that testing code is working.

	Copyright 2006 RocketBoots Pty Limited - http://www.rocketboots.com.au

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

	$Header: $
--->

<cfcomponent extends="src.Test">

	<cffunction access="public" returntype="void" name="setup">
		<cfset package = "tests.testtests">
	</cffunction>


	<cffunction access="public" returntype="void" name="test_00_run_test_package">
		<cfscript>
		runTestPackage(package, "testtest1");
		assert("not request.testtest1.ok");
		assert("request.testtest1.numCases eq 2");
		assert("request.testtest1.numTests eq 13");
		assert("request.testtest1.numFailures eq 5");
		assert("request.testtest1.numErrors eq 1");
		// TODO: Check rest of results
		</cfscript>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_01_run_specific_test_case">
		<cfscript>
		createObject("component", "#package#.TestCase2").runTest("testtest2");
		assert("request.testtest2.ok");
		assert("request.testtest2.numCases eq 1");		// This case hasn't finished yet
		assert("request.testtest2.numTests eq 4");		// This test hasn't finished yet
		assert("request.testtest2.numFailures eq 0");
		assert("request.testtest2.numErrors eq 0");
		// TODO: Check rest of results
		</cfscript>
	</cffunction>

</cfcomponent>