<cfcomponent>

	<cffunction name="addOne">
		<cfargument name="value" type="numeric" required="true">
		<cfreturn arguments.value>
	</cffunction>
	
	<cffunction name="squareRoot">
		<cfargument name="value" type="numeric" required="true">
		<cfreturn arguments.value/0>
	</cffunction>

	<cffunction name="squareRoot2">
		<cfargument name="value" type="numeric" required="true">
		<cfreturn sqr(arguments.value)>
	</cffunction>

</cfcomponent>