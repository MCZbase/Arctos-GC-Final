<cfoutput>
			

<CFDIRECTORY ACTION="List" DIRECTORY="#Application.webDirectory#/temp" NAME="dir_listing" recurse="true">

<cfdump var=#dir_listing#> 
<cfloop query="dir_listing">
	
	 	<cffile action="DELETE" file="#Application.webDirectory#/temp/#name#">
</cfloop> 

</cfoutput>