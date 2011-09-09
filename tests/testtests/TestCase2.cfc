<!---
	Second test case with no failures or errors. Used by test case TestTest.cfc
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


	<cffunction access="public" returntype="void" name="test_01_assert_true">
		<!--- An assert that evaluates to true should pass without note --->
		<cfset assert("true")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_02_assert_2_equals_2">
		<!--- A basic expression that evaluates to true should pass without note --->
		<cfset assert("2 eq 2")>
	</cffunction>


	<cffunction access="public" returntype="void" name="test_03_assert_a_equals_b">
		<!--- Check that true expression with variables doesn't cause failure --->
		<cfset a=1>
		<cfset b=1>
		<cfset assert("a eq b")>
	</cffunction>

</cfcomponent>