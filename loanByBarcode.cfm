<cfinclude template="/includes/_header.cfm">
<cfif action is "nothing">
	<cfoutput>
		<cfquery name="l" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select 
				loan_number,
				loan_type,
				loan_status,
				loan_instructions,
				loan_description,
				nature_of_material,
				trans_remarks,
				return_due_date,
				trans.collection_id,
				collection.collection,
				concattransagent(trans.transaction_id,'entered by') enteredby
			 from 
				loan, 
				trans,
				collection
			where 
				loan.transaction_id = trans.transaction_id AND
				trans.collection_id=collection.collection_id and
				trans.transaction_id = #transaction_id#
		</cfquery> 
		Adding parts to loan #l.collection# #l.loan_number#.
		
		<br>loan_status: #l.loan_status#
		<br>loan_instructions: #l.loan_instructions#
		<br>nature_of_material: #l.nature_of_material#
		
		<cfquery name="getPartLoanRequests" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select 
				cat_num, 
				cataloged_item.collection_object_id,
				collection,
				part_name,
				condition,
				 sampled_from_obj_id,
				 item_descr,
				 item_instructions,
				 loan_item_remarks,
				 coll_obj_disposition,
				 scientific_name,
				 Encumbrance,
				 agent_name,
				 loan_number,
				 specimen_part.collection_object_id as partID,
				concatSingleOtherId(cataloged_item.collection_object_id,'#session.CustomOtherIdentifier#') AS CustomID,
				p1.barcode	 			 
			 from 
				loan_item, 
				loan,
				specimen_part, 
				coll_object,
				cataloged_item,
				coll_object_encumbrance,
				encumbrance,
				agent_name,
				identification,
				collection,
				coll_obj_cont_hist,
				container p,
				container p1
			WHERE
				loan_item.collection_object_id = specimen_part.collection_object_id AND
				loan.transaction_id = loan_item.transaction_id AND
				specimen_part.derived_from_cat_item = cataloged_item.collection_object_id AND
				specimen_part.collection_object_id = coll_object.collection_object_id AND
				coll_object.collection_object_id = coll_object_encumbrance.collection_object_id (+) and
				coll_object_encumbrance.encumbrance_id = encumbrance.encumbrance_id (+) AND
				encumbrance.encumbering_agent_id = agent_name.agent_id (+) AND
				cataloged_item.collection_object_id = identification.collection_object_id AND
				identification.accepted_id_fg = 1 AND
				cataloged_item.collection_id=collection.collection_id AND
				specimen_part.collection_object_id = coll_obj_cont_hist.collection_object_id (+) AND
				coll_obj_cont_hist.container_id=p.container_id (+) and
				p.parent_container_id=p1.container_id (+) and
			  	loan_item.transaction_id = #transaction_id#
			ORDER BY cat_num
		</cfquery>
		<cfif getPartLoanRequests.recordcount is 0>
			<br>This loan contains no parts.
		<cfelse>
			<br>Existing Parts (use <a href="/a_loanItemReview.cfm?transaction_id=#transaction_id#">Loan Item Review</a> to adjust):
			<table border>
				<tr>
					<th>Barcode</th>
					<th>Specimen</th>
					<th>ID</th>
					<th>#session.CustomOtherIdentifier#</th>
					<th>Part</th>
					<th>SS?</th>
					<th>PartCondition</th>
					<th>ItemDescr</th>
				</tr>
				<cfloop query="getPartLoanRequests">
					<tr>
						<td>#barcode#</td>
						<td>
							<a href="/SpecimenDetail.cfm?collection_object_id=#collection_object_id#">
								#collection# #cat_num#
							</a>
						</td>
						<td>#scientific_name#</td>
						<td>#CustomID#</td>
						<td>#part_name#</td>
						<td>#condition#</td>
						<td>
							<cfif len(sampled_from_obj_id) gt 0>yes<cfelse>no</cfif>
						</td>
						<td>item_descr</td>
					</tr>
				</cfloop>
			</table>
		</cfif>
		<br>Add Parts by Barcode
		<script>
			function getPartByContainer(i){
				$.getJSON("/component/functions.cfc",
					{
						method : "getPartByContainer",
						barcode : $("#barcode_" + i).val(),
						i : i,
						returnformat : "json",
						queryformat : 'column'
					},
					function(r) {
						console.log(r);
						if (r.DATA.RECCOUNT[0] == 1){
							alert('woot: ' + r.DATA.RECCOUNT[0]);	
						} else {
							alert('fail: ' + r.DATA.RECCOUNT[0]);
						}
					}
				);
			}
		</script>
		<form name="f" method="post" action="loanByBarcode.cfm">
			<input type="hidden" name="action" value="saveParts">
			<table border>
				<tr>
					<th>Barcode</th>
					<th>Specimen</th>
					<th>ID</th>
					<th>#session.CustomOtherIdentifier#</th>
					<th>Part</th>
					<th>SS?</th>
					<th>PartCondition</th>
					<th>ItemDescr</th>
				</tr>
				<cfloop from="1" to="100" index="i">
					<tr id="tr_#i#">
						<td>
							<input type="text" id="barcode_#i#" onchange="getPartByContainer(this.value)">
						</td>
					</tr>
				</cfloop>
		</form>
	</cfoutput>
</cfif>
<!----------------->
<cfinclude template="/includes/_footer.cfm">
