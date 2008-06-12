<cfinclude template="/includes/alwaysInclude.cfm">
<cfoutput>
<cfset sel="select 
		cat_num,
		collection.collection,
		cataloged_item.collection_object_id,
		concatSingleOtherId(cataloged_item.collection_object_id,'#session.customOtherIdentifier#') CustomID">
<cfset frm=" FROM
		cataloged_item,
		collection">		
<cfset whr=" WHERE cataloged_item.collection_id = collection.collection_id">	
<cfset grp=" GROUP BY
		cat_num,
		collection.collection,
		cataloged_item.collection_object_id,
		concatSingleOtherId(cataloged_item.collection_object_id,'#session.customOtherIdentifier#') CustomID">
		
<cfif isdefined("transaction_id") and len(#transaction_id#) gt 0>
	<cfset frm="#frm# ,loan_item,specimen_part">
	<cfset whr="#whr# AND cataloged_item.collection_object_id = specimen_part.derived_from_cat_item and
			specimen_part.collection_object_id = loan_item.collection_object_id and
			loan_item.transaction_id = #transaction_id#">
<cfelseif isdefined("container_id") and len(#container_id#) gt 0>
	<cfset frm="#frm# ,coll_obj_cont_hist,specimen_part">
	<cfset whr="#whr# AND cataloged_item.collection_object_id = specimen_part.derived_from_cat_item and
			specimen_part.collection_object_id = coll_obj_cont_hist.collection_object_id and
			coll_obj_cont_hist.container_id in (#container_id#)">
<cfelseif isdefined("collection_object_id") and len(#collection_object_id#) gt 0>
	<cfset whr="#whr# AND cataloged_item.collection_object_id in (#container_id#)">
</cfif>		
<cfset sql="#sel# #frm# #whr# #grp#">
<cfquery name="allCatItems" datasource="#Application.web_user#">
	#preservesinglequotes(sql)#
</cfquery>
<cfset a=1>
<table border="1">
	<th>
		Cataloged Item
	</th>
	<th>
		#Client.customOtherIdentifier#
	</th>
	<th>
		Part Name
	</th>
	<th>
		Location
	</th>
<cfloop query="allCatItems">
	 <tr	#iif(a MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#	>
		<cfquery name="thisItems" datasource="#Application.web_user#">
			select
				part_name,
				coll_obj_cont_hist.container_id,
				decode(loan_item.collection_object_id,
					NULL,'no',
					'yes') is_loan_item,
				decode(SAMPLED_FROM_OBJ_ID,
					NULL,'no',
					'yes') is_subsample			
			FROM
				specimen_part,
				coll_obj_cont_hist,
				(select collection_object_id,transaction_id from loan_item where transaction_id = #transaction_id#) loan_item
			WHERE
				specimen_part.collection_object_id = coll_obj_cont_hist.collection_object_id AND
				specimen_part.collection_object_id = loan_item.collection_object_id (+) AND
				specimen_part.derived_from_cat_item = #collection_object_id#	
		</cfquery>
	
		<td rowspan="#thisItems.recordcount#">
			#collection# #cat_num#
		</td>
		<td rowspan="#thisItems.recordcount#">
			#CustomID#
		</td>
		<cfset i=1>
		<cfloop query="thisItems">
			<cfquery name="freezer" datasource="#Application.web_user#">
				select 
					CONTAINER_ID,
					PARENT_CONTAINER_ID,
					CONTAINER_TYPE,
					DESCRIPTION,
					PARENT_INSTALL_DATE,
					CONTAINER_REMARKS,
					label,
					level
					 from container
					start with container_id=#container_id#
					connect by prior parent_container_id = container_id 
					order by level DESC
			</cfquery>
			<cfif #i# gt 1>
				<tr	#iif(a MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#	>
			</cfif>
				<cfif #is_loan_item# is "yes">
					<cfset thisStyle = "">
				<cfelse>
					<cfset thisStyle = 'style="font-size:small;font-style:italic;"'>
				</cfif>
				<td>
					<span #thisStyle#>
						#part_name# <cfif #is_subsample# is "yes">subsample</cfif>
					</span>
				</td>
				<td>
					<span #thisStyle#>
			<cfloop query="freezer">
				
					<cfif #CONTAINER_TYPE# is "position">
						<span style="font-weight:bold;">
					</cfif>
							[#label#]
					<cfif #CONTAINER_TYPE# is "position">
						</span>
					</cfif>
				
			</cfloop>
				</span>
			</td>
			<cfif #i# gt 1>
				</tr>
			</cfif>
			<cfset i=#i#+1>
		</cfloop>
	</tr>
	<cfset a=#a#+1>
</cfloop>
</table>
	</cfoutput>
	
