<cfif not isdefined("fld")>bad call<cfabort></cfif>
<cfset fld=trim(fld)>
<cfif left(fld,1) is "_">
	<cfset fld=right(fld,len(fld)-1)>
</cfif>
<cfparam name="action" default="nothing">
<cfparam name="addCtl" default="1">
<cfif action is "nothing">
	<!--- this should be hard-coded - all installations should call the same docs, arctos.database.museum hosts everything --->
	<cfhttp url="http://arctos.database.museum/doc/get_short_doc.cfm" charset="utf-8" method="get">
		<cfhttpparam type="url" name="action" value="getDoc">
		<cfhttpparam type="url" name="fld" value="#fld#">
		<cfhttpparam type="url" name="addCtl" value="#addCtl#">
	</cfhttp>
<cfoutput>#cfhttp.fileContent#</cfoutput>
</cfif>
<cfif action is "getDoc">
	<!---
		This part runs ONLY on arctos.database.museum, the one and only source of this information.
	--->
	<cfquery name="d" datasource="user_login" username="cf_dbuser">
		select * from short_doc where  lower(colname) = '#lcase(fld)#'
	</cfquery>
	<cfset r='<div position="relative">'>
	<cfif addCtl is 1>
		<cfset r=r & '<span class="docControl" onclick="removeHelpDiv()">X</span>'>
	</cfif>
	<cfif d.recordcount is 1>
		<cfset r=r & '<div class="docTitle">#d.display_name#</div><div class="docDef">#d.definition#</div><div class="docSrchTip">#d.search_hint#</div>'>
		<cfif len(d.more_info) gt 0>
			<cfhttp url="#d.more_info#" method="head" timeout="2"></cfhttp>
			<cfif cfhttp.Statuscode is '200 OK'>
				<cfset r=r & '<a class="docMoreInfo" href="#d.more_info#"'>
				<cfif addCtl is 1>
					<cfset r=r & 'target="_docMoreWin" onclick="removeHelpDiv()"'>
				</cfif>
				<cfset r=r & '>[ More Information ]</div>'>
			<cfelse>
				<cfmail subject="docs: bad moreinfo" to="#Application.PageProblemEmail#" from="badlink@#Application.fromEmail#" type="html">
					#fld#: #d.more_info# not found
				</cfmail>
			</cfif>
		<cfelse>
			<cfset r=r & '<div class="docTitle">No documentation is available for #fld#.</div>'>
			
			
			<cfmail subject="doc not found" to="#Application.PageProblemEmail#" from="docMIA@#Application.fromEmail#" type="html">
				short doc not found for #fld#
			</cfmail>	
		</cfif>
		<cfset r=r & '</div>'>
		<cfsavecontent variable="response">#r#</cfsavecontent>
		<cfscript>
	        getPageContext().getOut().clearBuffer();
	        writeOutput(response);
		</cfscript>
	</cfif>
</cfif>
<!----
<cfparam name="addCtl" default="0">
<cfif #action# is "nothing">
<!--- include search hint --->
<!---
<cfhttp url="http://arctos.database.museum/service/doc_rest.cfm" charset="utf-8" method="get">
	<cfhttpparam type="url" name="action" value="getDefinition">
	<cfhttpparam type="url" name="fld" value="#fld#">
	<cfhttpparam type="url" name="addCtl" value="#addCtl#">
</cfhttp>
<cfoutput>
		#cfhttp.fileContent#</cfoutput>
--->
</cfif>

<cfhttp url="http://g-arctos.appspot.com/ws" charset="utf-8" method="get">
	<!--- some fields are prefixed with _ (underscore) to create unique IDs - strip that crap off... --->
	<cfif left(fld,1) is "_">
		<cfset fld=right(fld,len(fld)-1)>
	</cfif>
	<cfhttpparam type="url" name="q" value="#fld#">
	<cfhttpparam type="url" name="c" value="#addCtl#">
</cfhttp>
<cfoutput>
		#cfhttp.fileContent#</cfoutput>
        
<cfif #action# is "noHint">
<!--- include search hint --->
<cfhttp url="http://arctos.database.museum/service/doc_rest.cfm" charset="utf-8" method="get">
	<cfhttpparam type="url" name="action" value="getDefinition_noHint">
	<cfhttpparam type="url" name="fld" value="#fld#">
	<cfhttpparam type="url" name="addCtl" value="#addCtl#">
</cfhttp>
<cfoutput>
		#cfhttp.fileContent#</cfoutput>
</cfif>
---->