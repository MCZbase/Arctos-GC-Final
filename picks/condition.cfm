<cfinclude template="/includes/_pickHeader.cfm">
<cfoutput>
<cfif #action# is "nothing">
<!---- see what we're getting a condition of ---->
<cfquery name="itemDetails" datasource="#Application.web_user#">
	select 
		'cataloged item' part_name,
		cat_num,
		collection.collection_cde,
		institution_acronym,
		scientific_name
	FROM
		cataloged_item,
		collection,
		identification
	WHERE
		cataloged_item.collection_object_id = identification.collection_object_id AND
		accepted_id_fg=1 AND
		cataloged_item.collection_id = collection.collection_id AND
		cataloged_item.collection_object_id = #collection_object_id#
</cfquery>
<cfif len(#itemDetails.cat_num#) is 0>
	<!--- didn't get a cataloged_item, assume it's a part ---->
	<cfquery name="itemDetails" datasource="#Application.web_user#">
		select 
			part_name,
			cat_num,
			collection.collection_cde,
			institution_acronym,
			scientific_name
		FROM
			cataloged_item,
			collection,
			identification,
			specimen_part
		WHERE
			cataloged_item.collection_object_id = identification.collection_object_id AND
			accepted_id_fg=1 AND
			cataloged_item.collection_id = collection.collection_id AND
			cataloged_item.collection_object_id = specimen_part.derived_from_cat_item AND
			specimen_part.collection_object_id = #collection_object_id#
	</cfquery>
</cfif>
<i><font size="-1">Changes made on this form may not show up on the form you came from until you refresh that form.</font></i>
<br>
<strong>Condition History of #itemDetails.institution_acronym# #itemDetails.collection_cde# #itemDetails.cat_num#
(<i>#itemDetails.scientific_name#</i>) #itemDetails.part_name#</strong>
<br>Insert a condition determination:
<table border="1" class="newRec">
<form name="newCondition" method="post" action="condition.cfm">
		<input type="hidden" name="action" value="newEntry">
		<input type="hidden" name="collection_object_id" value="#collection_object_id#">
		<tr>
			<td valign="top">
				<font size="-2">Determined By<br>
				</font>				<input type="hidden" name="determined_agent_id"
				
				<input type="text" name="agent_name"class="reqdClr" 
		onchange="getAgent('determined_agent_id','agent_name','newCondition',this.value); return false;"
		 onKeyPress="return noenter(event);">
				
		  </td>
			<td valign="top">
				<font size="-2">Determined Date<br>
				</font>
				<input type="text" name="determined_date"  size="9">
			</td>
			<td>
				<font size="-2">Condition<br>
				</font>
				<textarea name="condition" rows="2" cols="40" class="reqdClr"></textarea>
			</td>
		</tr>
		
		<tr>
			<td colspan="4" align="center">
			 <input type="submit" 
	value="Save Condition" 
	class="insBtn"
   	onmouseover="this.className='insBtn btnhov'" 
   	onmouseout="this.className='insBtn'">	</td>
		</tr>
	</form>
	</table>
	
Condition History:
<cfquery name="cond" datasource="#Application.web_user#">
	select 
		object_condition_id,
		determined_agent_id,
		agent_name,
		 determined_date,
		 condition
		from object_condition,preferred_agent_name
		where determined_agent_id = agent_id (+) and
		collection_object_id = #collection_object_id#
		order by determined_date DESC
</cfquery>
<cfquery name="currentCond" datasource="#Application.web_user#">
	select condition from coll_object where collection_object_id = #collection_object_id#
</cfquery>



<table border>
	<tr>
		<td><strong>Determined By</strong></td>
		<td><strong>Date</strong></td>
		<td><strong>Condition</strong></td>
	</tr>
	<tr>
		<td>
			unknown
		</td>
		<td>
			Current
		</td>
		<td>
			#currentCond.condition#
		</td>
	</tr>
	<cfset i=1>
	<form name="condn" method="post" action="condition.cfm">
		<input type="hidden" name="action" value="saveEdits">
		<input type="hidden" name="collection_object_id" value="#collection_object_id#">
		<input type="hidden" name="object_condition_id">
	<cfloop query="cond">
		<input type="hidden" name="object_condition_id_#i#" value="#object_condition_id#">
			
		<tr>
			<td>
				<cfif len(#agent_name#) gt 0>
					<cfset thisAgent = #agent_name#>
				<cfelse>
					<cfset thisAgent = "unknown">
				</cfif>
				<input type="hidden" name="determined_agent_id_#i#" value="#determined_agent_id#">
				
				<input type="text" name="agent_name_#i#" value="#thisAgent#"
		onchange="getAgent('determined_agent_id_#i#','agent_name_#i#','',this.value); return false;"
		 onKeyPress="return noenter(event);">
				
			</td>
			<td>
				<cfif len(#determined_date#) gt 0>
					<cfset thisDate = #dateformat(determined_date,"dd mmm yyyy")#>
				<cfelse>
					<cfset thisDate = "unknown">
				</cfif>
				<input type="text" name="determined_date_#i#"  size="9" value="#thisDate#">
			</td>
			<td>
				<textarea name="condition_#i#" rows="2" cols="40">#condition#</textarea>
			</td>
			<td>
				<input type="button" 
					value="Delete" 
					class="delBtn"
   					onmouseover="this.className='delBtn btnhov'" 
					onmouseout="this.className='delBtn'"
   					onclick="condn.action.value='deleteCondn';condn.object_condition_id.value='#object_condition_id#';confirmDelete('condn');">
			
			</td>
		</tr>
		
	<cfset i=#i#+1>
	</cfloop>
		<tr>
			<td colspan="4" align="center">
			<cfset numrecs=#i#-1>
			<input type="hidden" name="numRecs" value="#numrecs#">
			 <input type="submit" 
	value="Save Changes" 
	class="savBtn"
   	onmouseover="this.className='savBtn btnhov'" 
   	onmouseout="this.className='savBtn'">	</td>
		</tr>
	</form>
</table>



</cfif>
<!---------------------------------------------------------------------->
<cfif #action# is "deleteCondn">
	<cfoutput>
		<cfquery name="killCondn" datasource="#Application.uam_dbo#">
			delete from object_condition where object_condition_id = #object_condition_id#
		</cfquery>
		<cflocation url="condition.cfm?collection_object_id=#collection_object_id#">
	</cfoutput>
</cfif>

<!---------------------------------------------------------------------->
<cfif #action# is "newEntry">
	<cfoutput>
		<cftransaction>
			<cfquery name="nid" datasource="#Application.uam_dbo#">
				select max(object_condition_id) + 1 nid from object_condition
			</cfquery>
			<cfquery name="newObjCond" datasource="#Application.uam_dbo#">
				INSERT INTO object_condition (
					 OBJECT_CONDITION_ID,
					 COLLECTION_OBJECT_ID ,
					  CONDITION 
					  <cfif len(#DETERMINED_AGENT_ID#) gt 0>
					  	,DETERMINED_AGENT_ID
					  </cfif>
					  <cfif len(#DETERMINED_DATE#) gt 0>
					  	,DETERMINED_DATE
					  </cfif>
					  ) VALUES (
					   #nid.nid#,
					 #COLLECTION_OBJECT_ID# ,
					  '#CONDITION#'
					  <cfif len(#DETERMINED_AGENT_ID#) gt 0>
					  	,#DETERMINED_AGENT_ID#
					  </cfif>
					  <cfif len(#DETERMINED_DATE#) gt 0>
					  	,'#DETERMINED_DATE#'
					  </cfif>
					  ) 
				</cfquery>
			<cfquery name="upCollObj" datasource="#Application.uam_dbo#">
				UPDATE coll_object SET condition='#condition#' where
				COLLECTION_OBJECT_ID = #COLLECTION_OBJECT_ID#
			</cfquery>
		</cftransaction>
		
		<cflocation url="condition.cfm?collection_object_id=#collection_object_id#">
</cfoutput>
</cfif>
<!---------------------------------------------------------------------->
<cfif #action# is "saveEdits">
	<cfoutput>
		<cfloop from="1" to="#numrecs#" index="n">
			<cfset thisobject_condition_id = #evaluate("object_condition_id_" & n)#>
			<cfset thisdetermined_agent_id = #evaluate("determined_agent_id_" & n)#>
			<cfset thisdetermined_date = #evaluate("determined_date_" & n)#>
			<cfset thiscondition = #evaluate("condition_" & n)#>
			<cfquery name="update" datasource="#Application.uam_dbo#">
				update object_condition set
				<cfif len(#thisdetermined_agent_id#) gt 0>
					determined_agent_id = #thisdetermined_agent_id#,
				</cfif>
				<cfif len(#thisdetermined_date#) gt 0 AND #thisdetermined_date# is not "unknown">
					determined_date = '#thisdetermined_date#',
				</cfif>
		 		condition = '#thiscondition#'
				WHERE OBJECT_CONDITION_ID = #thisobject_condition_id#
			</cfquery>
		</cfloop>
		<cflocation url="condition.cfm?collection_object_id=#collection_object_id#">
</cfoutput>
</cfif>
<!----
<cfif #action# is "saveEdits">
<cfquery name="upColl" datasource="#Application.uam_dbo#">
	update coll_object set condition = '#condition#' where collection_object_id = #collection_object_id#
</cfquery>
Condition have been saved. Reload the page you came from to see the changes.
<p align="right">
<a href="javascript:void(0);" onClick="self.close();">Close this window</a>
</p>
</cfif>
---->

</cfoutput>

<cfinclude template="/includes/_pickFooter.cfm">