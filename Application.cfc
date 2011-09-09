<cfcomponent output="false">
	
	<cfset this.name = Hash(GetDirectoryFromPath(GetCurrentTemplatePath()))>
	<!--- RocketUnit does not require a mapping. this is just here for development --->
	<cfset this.mappings["/"] = GetDirectoryFromPath(GetCurrentTemplatePath())>

</cfcomponent>