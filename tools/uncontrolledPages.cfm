<cfoutput>
<cffunction name="d" returntype="query">
	<cfargument name="p" type="string">
	<cfargument name="n" type="string">
	<cfdirectory directory="#application.webDirectory#/#p#" action="list" name="#n#" sort="name" recurse="false">
	<cfreturn dir>
</cffunction>
<cfinclude template="/includes/_header.cfm">

<cfset dl=d('/',"root")>
<table border>
<cfloop query="root">
<tr>
	<td>#directory#</td>
	<td>#name#</td>
	<td>#type#</td>
</tr>
</cfloop>
</table>

</cfoutput>
<!---
<cfdump var="#dl#">
<cfdirectory directory="#application.webDirectory#" action="list" name="dir" sort="name" recurse="true">

<table width="100%" cellpadding="0" cellspacing="0" border>
	<tr>
<th>Name <a href="?sort=name" class="sort" title="Sort By Name">v</a></th>


		<th>Size (bytes) <a href="?sort=size" class="sort" title="Sort By Size">v</a></th>
		<th>Last Modified <a href="?sort=datelastmodified+desc" class="sort" title="Sort By Date">v</a></th>
	</tr>
	<cfoutput query="dir">
	<tr>
		<td><a href="#dir.name#">#dir.name#</a></td>
		<td>#dir.size#</td>
		<td>#dir.datelastmodified#</td>
	</tr>
	</cfoutput>
</table>
<p>Directory Browser by <a href="http://www.petefreitag.com/">Pete Freitag</a></p>
</body>
</html>
--->