<cfinclude template="/includes/_header.cfm">
<!--------------------------------------------------------------------------------------------------->
<cfif #Action# is "nothing">
<cfset title = "Edit Collectors">
<cfoutput> 
	<cfquery name="getColls" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		SELECT 
			flat.guid,
			concatSingleOtherId(flat.collection_object_id,'#session.CustomOtherIdentifier#') AS CustomID,
			flat.scientific_name,
			flat.higher_geog,
			flat.spec_locality,
			flat.verbatim_date,
			agent_name,
			collector_role,
			COLL_ORDER
		FROM 
			flat,
			#table_name#,
			collector,
			preferred_agent_name
		WHERE 
			flat.collection_object_id = #table_name#.collection_object_id and
			flat.collection_object_id = collector.collection_object_id (+) and
			collector.agent_id=preferred_agent_name.agent_id (+)
	</cfquery>
	<cfquery name="ci" dbtype="query">
		select
			guid,
			CustomID,
			scientific_name,
			higher_geog,
			spec_locality,
			verbatim_date
		from
			getColls
		group by
			guid,
			CustomID,
			scientific_name,
			higher_geog,
			spec_locality,
			verbatim_date
		order by
			guid
	</cfquery>
	<h2>
		Add/Remove collectors for all specimens listed below
	</h2>
	Pick an agent, a role, and an order to insert or delete an agent for all records listed below. 
	<br>Order is ignored for deletion.
	<br>
  	<form name="tweakColls" method="post" action="multiAgent.cfm">
		<input type="hidden" name="table_name" value="#table_name#">
		<input type="hidden" name="action" value="">
		<label for="name">Name</label>
		<input type="text" name="name" class="reqdClr" 
			onchange="getAgent('agent_id','name','tweakColls',this.value); return false;"
		 	onKeyPress="return noenter(event);">
		<input type="hidden" name="agent_id">
		<label for="collector_role">Role</label>		
        <select name="collector_role" size="1"  class="reqdClr">
			<option value="c">collector</option>
			<option value="p">preparator</option>
		</select>
		<label for="coll_order">Order</label>
		<select name="coll_order" size="1" class="reqdClr">
			<option value="first">First</option>
			<option value="last">Last</option>
		</select>
		<br>       
		<input type="button" 
			value="Insert Agent" 
			class="insBtn"
   			onclick="tweakColls.action.value='insertColl';submit();">
		<input type="button" 
			value="Remove Agent" 
			class="delBtn"
   			onclick="tweakColls.action.value='deleteColl';submit();">
	</form>
		
		
  
<br><b>Specimens:</b>

<table border="1">
<tr>
	<th>GUID</th>
	<th>#session.CustomOtherIdentifier#</th>
	<th>Accepted ID</th>
	<th>Collectors</th>
	<th>Preparators</th>
	<th>Geog</th>
</tr>
<cfloop query="ci">
	<cfquery name="c" dbtype="query">
		select agent_name from getColls where collector_role='c' and guid='#guid#' order by COLL_ORDER
	</cfquery>
	<cfquery name="p" dbtype="query">
		select agent_name from getColls where collector_role='p' and guid='#guid#' order by COLL_ORDER
	</cfquery>
    <tr>
	  <td>
	  	<a href="/guid/#guid#">#guid#</a>
	  </td>
	<td>
		#CustomID#&nbsp;
	</td>
	<td><i>#Scientific_Name#</i></td>
	<td>
		<cfloop query="c">
			<div>
				#agent_name#
			</div>
		</cfloop>
	</td>
	<td>
		<cfloop query="p">
			<div>
				#agent_name#
			</div>
		</cfloop>
	</td>
	<td>#higher_geog#&nbsp;</td>
</tr>
</cfloop>
</table>
</cfoutput>
</cfif>
<!----------------------------------------------------------------------------------->
<cfif action is "insertColl">
	<cfoutput>
	<cfquery name="cids" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select collection_object_id from #table_name#
	</cfquery>
		<cftransaction>
			<cfif coll_order is "first" and collector_role is 'c'>
				<!--- bump everything up a notch --->
				<cfquery name="bumpAll" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update 
						collector 
					set 
						coll_order=coll_order + 1 
					where
						collection_object_id IN (select collection_object_id from #table_name#)
				</cfquery>
				<cfloop query="cids">
					<cfquery name="insOne" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collector (
							collection_object_id,
							agent_id,
							collector_role,
							coll_order
						) values (
							#collection_object_id#,
							#agent_id#,
							'c',
							1
						)
					</cfquery>				
				</cfloop>
			<cfelseif coll_order is "last" and collector_role is 'c'>
				<cfquery name="bumpAll" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update 
						collector 
					set 
						coll_order=coll_order + 1 
					where
						collector_role='p' and
						collection_object_id IN (select collection_object_id from #table_name#)
				</cfquery>			
				<cfloop query="cids">
					<cfquery name="max" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						select max(coll_order) +1 m from collector where 
						collection_object_id=#collection_object_id# and
						collector_role='c'
					</cfquery>
					<cfquery name="insOne" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collector (
							collection_object_id,
							agent_id,
							collector_role,
							coll_order
						) values (
							#collection_object_id#,
							#agent_id#,
							'c',
							#max.m#
						)
					</cfquery>
				</cfloop>
			<cfelseif coll_order is "first" and collector_role is 'p'>
				<cfquery name="bumpAll" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					update 
						collector 
					set 
						coll_order=coll_order + 1 
					where
						collector_role='p' and
						collection_object_id IN (select collection_object_id from #table_name#)
				</cfquery>			
				<cfloop query="cids">
					<cfquery name="max" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						select max(coll_order) +1 m from collector where 
						collection_object_id=#collection_object_id# and
						collector_role='c'
					</cfquery>
					<cfquery name="insOne" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collector (
							collection_object_id,
							agent_id,
							collector_role,
							coll_order
						) values (
							#collection_object_id#,
							#agent_id#,
							'p',
							#max.m#
						)
					</cfquery>
				</cfloop>
			<cfelseif coll_order is "last" and collector_role is 'p'>
				<cfloop query="cids">
					<cfquery name="max" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						select max(coll_order) +1 m from collector where 
						collection_object_id=#collection_object_id#
					</cfquery>
					<cfquery name="insOne" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						insert into collector (
							collection_object_id,
							agent_id,
							collector_role,
							coll_order
						) values (
							#collection_object_id#,
							#agent_id#,
							'p',
							#max.m#
						)
					</cfquery>
				</cfloop>				
			</cfif>
		</cftransaction>
		<cflocation url="multiAgent.cfm?table_name=#table_name#">
	</cfoutput>
</cfif>
<!----------------------------------------------------------------------------------->
<cfif action is "deleteColl">
	<cfoutput>
	<cfquery name="cids" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select collection_object_id from #table_name#
	</cfquery>

		<cftransaction>
			<cfloop query="cids">
				<cfquery name="max" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
					select 
						collection_object_id,
						coll_order 
					from 
						collector 
					where 
						collection_object_id=#collection_object_id# and
						agent_id=#agent_id# and
						collector_role='#collector_role#'
				</cfquery>
				<cfif max.collection_object_id gt 0>
					<cfquery name="die" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						delete from 
							collector 
						where 
							collection_object_id=#collection_object_id# and
							agent_id=#agent_id# and
							collector_role='#collector_role#'
					</cfquery>
					<cfquery name="inc" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
						update 
							collector 
						set
							coll_order=coll_order -1
						where	 
							collection_object_id=#collection_object_id# and
							coll_order > #max.coll_order#
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>
		<cflocation url="multiAgent.cfm?table_name=#table_name#">
	</cfoutput>
</cfif>
<!----------------------------------------------------------------------------------->
<cfinclude template="includes/_footer.cfm">