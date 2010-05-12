<cfcomponent>
<!------------------------------------------->
<cffunction name="test" access="remote">
	<!---
	<cfargument name="barcode" type="string" required="yes">
	<cfargument name="parent_barcode" type="string" required="yes">
	<cfargument name="timestamp" type="string" required="yes">	
	--->
	<cfargument name="sEcho" type="any" required="no">
	<cfargument name="iColumns" type="any" required="no">
	<cfargument name="sColumns" type="any" required="no">
	<cfargument name="iDisplayStart" type="any" required="no">
	<cfargument name="iDisplayLength" type="any" required="no">
	<cfargument name="sSearch" type="any" required="no">
	<cfargument name="bEscapeRegex" type="any" required="no">
	<cfargument name="sSearch_0" type="any" required="no">
	<cfargument name="bEscapeRegex_0" type="any" required="no">
	<cfargument name="bSearchable_0" type="any" required="no">
	<cfargument name="sSearch_1" type="any" required="no">
	<cfargument name="bEscapeRegex_1" type="any" required="no">
	<cfargument name="bSearchable_1" type="any" required="no">
	<cfargument name="sSearch_2" type="any" required="no">
	<cfargument name="bEscapeRegex_2" type="any" required="no">
	<cfargument name="bSearchable_2" type="any" required="no">
	<cfargument name="iSortingCols" type="any" required="no">
	<cfargument name="iSortCol_0" type="any" required="no">
	<cfargument name="sSortDir_0" type="any" required="no">
	<cfargument name="bSortable_0" type="any" required="no">
	<cfargument name="bSortable_1" type="any" required="no">
	<cfargument name="bSortable_2" type="any" required="no">
	<cfquery name="qGetCount" datasource="uam_god">
		
		
		
		<cfset fieldlist="guid,cat_num,SCIENTIFIC_NAME">
		
		
		SELECT 58 AS fullCount
		FROM dual
	</cfquery>
	<cfquery name="d" datasource="uam_god">
		select
			guid,
			cat_num,
			SCIENTIFIC_NAME
		from
			flat
		where
			cat_num=1
	</cfquery>
<!----
http://arctos-test.arctos.database.museum/development/gData.cfc?method=test&returnformat=json&
sEcho=4&
iColumns=3&
sColumns=&
iDisplayStart=0
&iDisplayLength=10&
sSearch=&
bEscapeRegex=true&
sSearch_0=&
bEscapeRegex_0=true&
bSearchable_0=true&
sSearch_1=&
bEscapeRegex_1=true&
bSearchable_1=true&
sSearch_2=&
bEscapeRegex_2=true&
bSearchable_2=true&
iSortingCols=1&
iSortCol_0=2&
sSortDir_0=desc&
bSortable_0=true&
bSortable_1=true&
bSortable_2=true
http://arctos-test.arctos.database.museum/development/gData.cfc?method=test&returnformat=json&sEcho=4&iColumns=3&sColumns=&iDisplayStart=0&iDisplayLength=10&sSearch=&bEscapeRegex=true&sSearch_0=&bEscapeRegex_0=true&bSearchable_0=true&sSearch_1=&bEscapeRegex_1=true&bSearchable_1=true&sSearch_2=&bEscapeRegex_2=true&bSearchable_2=true&iSortingCols=1&iSortCol_0=2&sSortDir_0=desc&bSortable_0=true&bSortable_1=true&bSortable_2=true
---->
<cfset count=0>
<cfsavecontent variable="sOutput"><cfoutput>{
	"sEcho": #sEcho#,
	"iTotalRecords": #qGetCount.fullCount#,
	"iTotalDisplayRecords": #d.recordcount#,
	"aaData": [
	<cfloop query="d" startrow="#iDisplayStart+1#" endrow="#iDisplayStart+iDisplayLength#">
		<cfset count=count+1>
		[<cfloop list="#fieldlist#" index="i">
			"#d[i][d.currentRow]#"
				<cfif i is not listLast(fieldlist)>, </cfif>
		</cfloop>]
		<cfif d.recordcount LT iDisplayStart+iDisplayLength>
			<cfif count is not d.recordcount>,</cfif>
		<cfelse>
			<cfif count is not iDisplayStart+iDisplayLength>,</cfif>
		</cfif>
	</cfloop>]
</cfoutput></cfsavecontent>
<cfoutput>#sOutput#</cfoutput>


</cffunction>
</cfcomponent>