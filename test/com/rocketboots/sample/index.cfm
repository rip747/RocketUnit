<!---
	Browseable file to invoke the sample test suite.  We normally recommend using cf mappings 
	outside the webroot for your code - if you install RocketUnit outside the webroot you can
	copy this file somewhere under your webroot to run your tests.

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
	
	@version $Id: index.cfm 168 2007-04-12 07:50:38Z robin $
--->

<html>
<head>
	<title>Sample unit tests</title>
	<style>
		table {
			font-size:xx-small;
			font-family:verdana;
		}
	</style>
</head>
<body>
	<cfset test = createObject("component", "com.rocketboots.rocketunit.Test")>
	<cfset test.runTestPackage("test.com.rocketboots.sample")>
	<cfoutput>#test.HTMLFormatTestResults()#</cfoutput>
</body>
</html>