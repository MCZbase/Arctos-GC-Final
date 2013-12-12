<cfinclude template="includes/_frameHeader.cfm">
<cfquery name="ctagent_name_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
	select agent_name_type from ctagent_name_type order by agent_name_type
</cfquery>
<cfquery name="ctagent_type" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
	select agent_type from ctagent_type order by agent_type
</cfquery>
<cfquery name="ctagent_status" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
	select agent_status from ctagent_status order by agent_status
</cfquery>
<!---
 <a href="javascript:void(0);"
 	onClick="getDocs('agent'); return false;"
	onMouseOver="self.status='Click for help.';return true;"
	onmouseout="self.status='';return true;"><img src="/images/what.gif" border="0">
</a>
--->
<span class="infoLink pageHelp" onclick="getDocs('agent');">Page Help</span>
Search for an agent:
<cfoutput>
<form name="agntSearch" action="AgentGrid.cfm" method="post" target="_pick">
	<input type="hidden" name="Action" value="search">
	<!----
	<tr>
		<td>
			<label for="prefix">Prefix</label>
			<select name="prefix" size="1" id="prefix">
				<option selected value="">none</option>
      	    	<cfloop query="prefix"> 
        			<option value="#prefix.prefix#">#prefix.prefix#</option>
      				</cfloop> 
   			 </select>
		</td>
			<label for="first_name"><a href="javascript:void(0);" onClick="getDocs('agent','namesearch')">First Name</a></label>
			<input type="text" name="first_name">
		</td>
	</tr>
		<td>
			<label for="middle_name">
				<a href="javascript:void(0);" onClick="getDocs('agent','namesearch')">Middle Name</a>
			</label>
			<input type="text" name="middle_name" id="middle_name">
		</td>
		<td>
			<label for="last_name">
				<a href="javascript:void(0);" onClick="getDocs('agent','namesearch')">Last Name</a>
			</label>
			<input type="text" name="last_name" id="last_name">
		</td>
	<tr>
	<tr>
		<td>
			<label for="suffix">
				Suffix
			</label>
			<select name="suffix" size="1" id="suffix">
				<option selected value="">none</option>
	      	   	<cfloop query="suffix"> 
	        		<option value="#suffix.suffix#">#suffix.suffix#</option>
	      		</cfloop> 
	   		 </select>
		</td>
		<td>
		
		</td>
	</tr>
	<tr>
		<td>
			<label for="birthOper">
				Birth Date
			</label>
			<select name="birthOper" size="1" id="birthOper">
				<option value="<=">Before</option>
				<option selected value="=" >Is</option>
				<option value=">=">After</option>
			</select>
			<input type="text" size="6" name="birth_date" id="birth_date">
		</td>
		<td>
			<label for="deathOper">
				Death Date
			</label>
			<select name="deathOper" size="1" id="deathOper">
				<option value="<=">Before</option>
				<option selected value="=" >Is</option>
				<option value=">=">After</option>
			</select>
			<input type="text" size="6" name="death_date" id="death_date">
		</td>
	</tr>

	<tr>
		<td>
			
		</td>
		---->
			<label for="anyName">
				<a href="javascript:void(0);" onClick="getDocs('agent','anynamesearch')">Any part of any name</a>
			</label>
			<input type="text" name="anyName" id="anyName" size="50">
			<label for="agent_type">Agent Type</label>
			<select name="agent_type" size="1" id="agent_type">
				<option value=""></option>
				<cfloop query="ctagent_type">
					<option value="#agent_type#">#agent_type#</option>
				</cfloop>
			</select>
			<label for="agent_id">AgentID</label>
			<input type="text" name="agent_id" size="6" id="agent_id">
			
			<label for="agent_status">Agent Status</label>
			<select name="agent_status" size="1" id="agent_status">
				<option value=""></option>
				<cfloop query="ctagent_status">
					<option value="#agent_status#">#agent_status#</option>
				</cfloop>
			</select>
			<label for="address">
				<a href="javascript:void(0);" onClick="getDocs('agent','address')">Address</a>
			</label>
			<input type="text" name="address" id="address">
			
			<label for="status_date">
				Status Date
			</label>
			<select name="status_date_oper" size="1" id="status_date_oper">
				<option value="<=">Before</option>
				<option selected value="=" >Is</option>
				<option value=">=">After</option>
			</select>
			<input type="text" size="6" name="status_date" id="status_date">
			
			
	
			<div style="border:2px solid green;">
				<label for="agent_name_type">Agent Name Type (pairs with name below)</label>
				<select name="agent_name_type" size="1" id="agent_name_type">
					<option value=""></option>
					<cfloop query="ctagent_name_type">
						<option value="#agent_name_type#">#agent_name_type#</option>
					</cfloop>
				</select>
				<label for="agent_name">Agent Name (pairs with type above)</label>
				<input type="text" name="agent_name" id="agent_name" size="50">
				
			</div>
			<br>
			<input type="submit" 
				value="Search" 
				class="schBtn">
			<input type="reset" 
				value="Clear Form" 
				class="clrBtn">
				<br>
				<input type="button" 
					value="New Agent" 
					class="insBtn"
					onClick="window.open('editAllAgent.cfm?action=newAgent','_person');">
				

</form>
</cfoutput>	
<cfinclude template="includes/_pickFooter.cfm">