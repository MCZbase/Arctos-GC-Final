<cfinclude template="/includes/_header.cfm">
<cfset title="BulkloaderBuilder">
<cfif action is "nothing">
<cfquery name="blt" datasource="uam_god">
	select column_name from user_tab_cols where table_name='BULKLOADER'
	order by internal_column_id
</cfquery>
<cfoutput>
	<cfset everything=valuelist(blt.column_name)>
	<cfset required="COLLECTION_OBJECT_ID,ENTEREDBY,ACCN,TAXON_NAME,NATURE_OF_ID,ID_MADE_BY_AGENT,MADE_DATE,VERBATIM_DATE,BEGAN_DATE,ENDED_DATE,HIGHER_GEOG,SPEC_LOCALITY,VERBATIM_LOCALITY,COLLECTION_CDE,INSTITUTION_ACRONYM,COLL_OBJ_DISPOSITION,CONDITION,COLLECTOR_AGENT_1,COLLECTOR_ROLE_1,PART_NAME_1,PART_CONDITION_1,PART_LOT_COUNT_1,PART_DISPOSITION_1,COLLECTING_METHOD,COLLECTING_SOURCE">
	<cfset basicCoords="ORIG_LAT_LONG_UNITS, DATUM,LAT_LONG_REF_SOURCE,MAX_ERROR_DISTANCE,MAX_ERROR_UNITS,GEOREFMETHOD,DETERMINED_BY_AGENT,DETERMINED_DATE,LAT_LONG_REMARKS,VERIFICATIONSTATUS,GPSACCURACY,EXTENT,DATUM">
	<cfset dms="LATDEG,LATMIN,LATSEC,LATDIR,LONGDEG,LONGMIN,LONGSEC,LONGDIR">
	<cfset ddm="LATDEG,DEC_LAT_MIN,LATDIR,LONGDEG,DEC_LONG_MIN,LONGDIR">
	<cfset dd="DEC_LAT,DEC_LONG">
	<cfset utm="UTM_ZONE,UTM_EW,UTM_NS">
	<cfset n=5>
	<cfset oid="CAT_NUM"> 
	<cfloop from="1" to="#n#" index="i">
		<cfset oid=listappend(oid,"OTHER_ID_NUM_" & i)>
		<cfset oid=listappend(oid,"OTHER_ID_NUM_TYPE_" & i)>	
	</cfloop>
	<cfset n=8>
	<cfset coll=""> 
	<cfloop from="1" to="#n#" index="i">
		<cfset coll=listappend(coll,"COLLECTOR_AGENT_" & i)>
		<cfset coll=listappend(coll,"COLLECTOR_ROLE_" & i)>	
	</cfloop>
	<cfset n=12>
	<cfset part=""> 
	<cfloop from="1" to="#n#" index="i">
		<cfset part=listappend(part,"PART_NAME_" & i)>
		<cfset part=listappend(part,"PART_MODIFIER_" & i)>
		<cfset part=listappend(part,"PRESERV_METHOD_" & i)>
		<cfset part=listappend(part,"PART_CONDITION_" & i)>
		<cfset part=listappend(part,"PART_BARCODE_" & i)>
		<cfset part=listappend(part,"PART_CONTAINER_LABEL_" & i)>
		<cfset part=listappend(part,"PART_LOT_COUNT_" & i)>
		<cfset part=listappend(part,"PART_DISPOSITION_" & i)>
		<cfset part=listappend(part,"PART_REMARK_" & i)>	
	</cfloop>
	
	<cfset n=10>
	<cfset attr=""> 
	<cfloop from="1" to="#n#" index="i">
		<cfset attr=listappend(attr,"ATTRIBUTE_" & i)>
		<cfset attr=listappend(attr,"ATTRIBUTE_VALUE_" & i)>
		<cfset attr=listappend(attr,"ATTRIBUTE_UNITS_" & i)>
		<cfset attr=listappend(attr,"ATTRIBUTE_REMARKS_" & i)>
		<cfset attr=listappend(attr,"ATTRIBUTE_DATE_" & i)>
		<cfset attr=listappend(attr,"ATTRIBUTE_DET_METH_" & i)>
		<cfset attr=listappend(attr,"ATTRIBUTE_DETERMINER_" & i)>
	</cfloop>
	
	<cfset n=6>
	<cfset geol=""> 
	<cfloop from="1" to="#n#" index="i">
		<cfset geol=listappend(geol,"GEOLOGY_ATTRIBUTE_" & i)>
		<cfset geol=listappend(geol,"GEO_ATT_VALUE_" & i)>
		<cfset geol=listappend(geol,"GEO_ATT_DETERMINER_" & i)>
		<cfset geol=listappend(geol,"GEO_ATT_DETERMINED_DATE_" & i)>
		<cfset geol=listappend(geol,"GEO_ATT_DETERMINED_METHOD_" & i)>
		<cfset geol=listappend(geol,"GEO_ATT_REMARK_" & i)>
	</cfloop>
											  
<p>
	Build your own Bulkloader template.	Toggle anything on or off in the table below. Use these links to get started.
</p>
<table border>
	<tr>
		<td>
			on<input type="radio" oncheck="checkList('#everything#')">
			off<input type="radio" oncheck="uncheckList('#everything#')">
			
		</td>
	</tr>
</table>

<span class="likeLink" onclick="uncheckList('#everything#')">Clear All</span>
<br>
<br><span class="likeLink" onclick="checkList('#required#')">Add Required</span>
<br><span class="likeLink" onclick="checkList('#basicCoords#')">Add basic coordinate info</span>
<br><span class="likeLink" onclick="checkList('#dms#')">Add DMS coordinate info</span>
<br><span class="likeLink" onclick="checkList('#ddm#')">Add DM.m coordinate info</span>
<br><span class="likeLink" onclick="checkList('#dd#')">Add D.d coordinate info</span>
<br><span class="likeLink" onclick="checkList('#utm#')">Add UTM coordinate info</span>
<br><span class="likeLink" onclick="checkList('#oid#')">Add Identifiers</span>
<br><span class="likeLink" onclick="checkList('#coll#')">Add Agents</span>
<br><span class="likeLink" onclick="checkList('#part#')">Add Parts</span>
<br><span class="likeLink" onclick="checkList('#attr#')">Add Attributes</span>
<br><span class="likeLink" onclick="checkList('#geol#')">Add Geology</span>
<br><span class="likeLink" onclick="checkList('#everything#')">Add All</span>
<script>
function uncheckList(list) {
	var a = list.split(',');
	for (i=0; i<a.length; ++i) {
		//alert(eid);
		if (document.getElementById(a[i])) {
			//alert(eid);
			document.getElementById(a[i]).checked=false;
		}
	}
}
function checkList(list) {
	var a = list.split(',');
	for (i=0; i<a.length; ++i) {
		//alert(eid);
		if (document.getElementById(a[i])) {
			//alert(eid);
			document.getElementById(a[i]).checked=true;
		}
	}
}
</script>
	<form name="f" method="post" action="bulkloaderBuilder.cfm">
		<input type="hidden" name="action" value="getTemplate">
		<label for="fileFormat">Format</label>
		<select name="fileFormat" id="fileFormat">
			<option value="txt">Tab-delimited text</option>
		</select>
		<input type="submit" value="Download Template">
		<table border>
		<cfloop query="blt">
			<tr>
				<td><input type="checkbox" name="fld" id="#column_name#" value="#column_name#" checked="checked"></td>
				<td>#column_name#</td>
			</tr> 
		</cfloop>
		</table>
	</form>
</cfoutput>
</cfif>
<cfif action is 'getTemplate'>
<cfoutput>
	<cfset fileDir = "#Application.webDirectory#">
		<cfif #fileFormat# is "csv">
			<cfset fileName = "CustomBulkloaderTemplate.csv">
			<cfset header=#trim(fld)#>
			<cffile action="write" file="#Application.webDirectory#/download/#fileName#" addnewline="yes" output="#header#">
			<cflocation url="/download.cfm?file=#fileName#" addtoken="false">
			<a href="/download/#fileName#">Click here if your file does not automatically download.</a>
		<cfelseif #fileFormat# is "txt">
			<cfset fileName = "CustomBulkloaderTemplate.txt">
			<cfset header = replace(fld,",","#chr(9)#","all")>
			<cfset header=#trim(header)#>
			<cffile action="write" file="#Application.webDirectory#/download/#fileName#" addnewline="yes" output="#header#">
			<cflocation url="/download.cfm?file=#fileName#" addtoken="false">
			<a href="/download/#fileName#">Click here if your file does not automatically download.</a>
		<cfelse>
			That file format doesn't seem to be supported yet!
		</cfif>
</cfoutput>
</cfif>