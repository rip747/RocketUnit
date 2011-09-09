<!---
	First test case with 5 failures and 1 error used by test case TestTest.cfc
	that tests rapide_test.cfm.

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


	<cffunction access="public" returntype="void" name="test_00_null_test">
		<!--- Should record 'Success' by default --->
	</cffunction>


	<cffunction access="public" returntype="void" name="test_01_deliberate_fail">
		<!--- Ensure failure recorded correctly - assert() calls fail() internally --->
		<cfset fail("Deliberate fail")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_02_deliberate_error">
		<!--- Ensure error recorded correctly --->
		<cfthrow message="Deliberate error">
	</cffunction>


	<cffunction access="public" returntype="void" name="test_03_assert_true">
		<!--- An assert that evaluates to true should pass without note --->
		<cfset assert("true")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_04_assert_false">
		<!--- An assert that evaluates to false should record a failure --->
		<cfset assert("false")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_05_assert_1_equals_2">
		<!--- A basic expression that evaluates to false should likewise record a failure --->
		<cfset assert("1 eq 2")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_06_assert_2_equals_2">
		<!--- A basic expression that evaluates to true should pass without note --->
		<cfset assert("2 eq 2")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_07_assert_a_equals_b">
		<!--- Check that assert prints out value of variables found in expression --->
		<cfset a = 1>
		<cfset b = "One">
		<cfset assert("a eq (b)")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_08_assert_c_equals_d">
		<!---
			Check that assert prints out value of variables and intermediate results
			found across multiple arguments, in this case:

			structCount(c), arrayLen(d), c, c.len and d.
		--->
		<cfset c = structNew()>
		<cfset c.len = 1>
		<cfset d = arrayNew(1)>
		<cfset assert("structCount(c) eq arrayLen(d)", "c c.len", "d")>
	</cffunction>

</cfcomponent>