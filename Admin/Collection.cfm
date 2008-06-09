<cfinclude template="/includes/_header.cfm">
<cfset title="Manage Collections">
<cfif #action# is "nothing">
<cfoutput>
	Find Collection:
	<cfquery name="ctcoll" datasource="#Application.web_user#">
		select * from collection
	</cfquery>
	<form name="coll" method="post" action="Collection.cfm">
		<input type="hidden" name="action">
		<select name="collection_id" size="1">
			<option value=""></option>
			<cfloop query="ctcoll">
				<option value="#collection_id#">#institution_acronym# #collection_cde#</option>
			</cfloop>
		</select>
		<input type="button" value="Submit" class="lnkBtn"
   						onmouseover="this.className='lnkBtn btnhov'" onmouseout="this.className='lnkBtn'"
						onclick="coll.action.value='findColl';submit();">	
		<input type="button" value="New Collection" class="insBtn"
   						onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'"
						onclick="coll.action.value='newColl';submit();">	
	</form>
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "newColl">
<cfoutput>
<form name="addCollection" method="post" action="Collection.cfm">
<input type="hidden" name="action" value="makeNewCollection">
	<cfquery name="ctCollCde" datasource="#Application.web_user#">
		select collection_cde from ctcollection_cde
	</cfquery>
	<table>
		<tr>
			<td align="right">
			Collection Code:&nbsp;
			</td>
			<td nowrap="nowrap">
			<select name="collection_cde" size="1">
		<cfloop query="ctCollCde">
			<option value="#collection_cde#">#collection_cde#</option>
		</cfloop>
	</select>
			</td>
		</tr>
		<tr>
			<td align="right">
			Institution Acronym:&nbsp;
			</td>
			<td>
			<input type="text" name="institution_acronym">
			</td>
		</tr>
		
		<tr>
			<td align="right">
			Collection:&nbsp;
			</td>
			<td>
			<input type="text" name="collection">
			</td>
		</tr>
		<tr>
			<td align="right">
			Description:&nbsp;
			</td>
			<td>
			<input type="text" name="descr">
			</td>
		</tr>
		<tr>
			<td align="right">
			Web Link:&nbsp;
			</td>
			<td>
			<input type="text" name="web_link">
			</td>
		</tr>
		<tr>
			<td align="right">
			Link Text:&nbsp;
			</td>
			<td>
			<input type="text" name="web_link_text" >
			</td>
		</tr>
		<tr>
			<td colspan="2">
			<input type="submit" value="Create Collection" class="insBtn"
   						onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'">	
			<input type="button" value="Quit" class="qutBtn"
   						onmouseover="this.className='qutBtn btnhov'" onmouseout="this.className='qutBtn'" 
						onClick="document.location='/Admin/Collection.cfm';">	
			</td>
		</tr>
		
		
	</table>
	
</form>
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "makeNewCollection">
<cfoutput>
	<cftransaction>
	<cfquery name="nextCollCde" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
		select max(collection_id) + 1 as newID from collection
	</cfquery>
	<cfquery name="newColl" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
		INSERT INTO collection (
			 COLLECTION_CDE,
			 INSTITUTION_ACRONYM,
			 DESCR,
			 COLLECTION,
			 COLLECTION_ID
			 <cfif len(#web_link#) gt 0>
			 	,web_link
			 </cfif>
			  <cfif len(#web_link_text#) gt 0>
			 	,web_link_text
			 </cfif>)
		VALUES (
			'#collection_cde#',
			'#institution_acronym#',
			'#descr#',
			'#collection#',
			#nextCollCde.newID#
			 <cfif len(#web_link#) gt 0>
			 	,'#web_link#'
			 </cfif>
			 <cfif len(#web_link_text#) gt 0>
			 	,'#web_link_text#'
			 </cfif>)			
	</cfquery>
	</cftransaction>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#nextCollCde.newID#">
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "findColl">
<cfoutput>
	<cfquery name="app" datasource="#Application.web_user#">
		select * from cf_collection_appearance where collection_id=#collection_id#
	</cfquery>
	<cfquery name="colls" datasource="#Application.web_user#">
		select  
			COLLECTION_CDE,
			INSTITUTION_ACRONYM,
			DESCR,
			COLLECTION,
			COLLECTION_ID,
			WEB_LINK,
			WEB_LINK_TEXT
 		from collection
  		where
   		collection_id = #collection_id#
	</cfquery>
	<table border>
		<tr>
			<td>
			
	<form name="editCollection" method="post" action="Collection.cfm">
<input type="hidden" name="action" value="modifyCollection">
<input type="hidden" name="collection_id" value="#collection_id#">
	<cfquery name="ctCollCde" datasource="#Application.web_user#">
		select collection_cde from ctcollection_cde
	</cfquery>
	<table>
		<tr>
			<td align="right">
			Collection Code:&nbsp;
			</td>
			<td>
			<select name="collection_cde" size="1">
		<cfloop query="ctCollCde">
			<option 
				<cfif #collection_cde# is "#colls.collection_cde#"> selected </cfif>
			value="#collection_cde#">#collection_cde#</option>
		</cfloop>
	</select>
			</td>
		</tr>
		<tr>
			<td align="right">
			Institution Acronym:&nbsp;
			</td>
			<td>
			<input type="text" name="institution_acronym" value="#colls.institution_acronym#">
			</td>
		</tr>
		
		<tr>
			<td align="right">
			Collection:&nbsp;
			</td>
			<td>
			<input type="text" name="collection" value="#colls.collection#">
			</td>
		</tr>
		<tr>
			<td align="right">
			Description:&nbsp;
			</td>
			<td>
			<input type="text" name="descr" value="#colls.descr#">
			</td>
		</tr>
		<tr>
			<td align="right">
			Web Link:&nbsp;
			</td>
			<td>
			<cfset thisWebLink = replace(colls.web_link,"'","''",'all')>
			<input type="text" name="web_link" value="#colls.web_link#" size="50">
			</td>
		</tr>
		<tr>
			<td align="right">
			Link Text:&nbsp;
			</td>
			<td>
			<input type="text" name="web_link_text" value='#colls.web_link_text#' size="50">
			</td>
		</tr>
		<tr>
			<td colspan="2">
			
			<input type="submit" value="Save Changes" class="savBtn"
   						onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'">	
			<input type="button" value="Quit" class="qutBtn"
   						onmouseover="this.className='qutBtn btnhov'" onmouseout="this.className='qutBtn'" 
						onClick="document.location='/Admin/Collection.cfm';">	
			
			</td>
		</tr>
		
		
	</table>
	
</form>
</td>
<td valign="top">
	<cfquery name="contact" datasource="#Application.web_user#">
		select 
			collection_contact_id,
			contact_role,
			contact_agent_id,
			agent_name contact_name
		from
			collection_contacts,
			preferred_agent_name
		where
			contact_agent_id = agent_id AND
			collection_id = #collection_id#
		ORDER BY contact_name,contact_role
	</cfquery>
	<cfquery name="ctContactRole" datasource="#Application.web_user#">
		select contact_role from ctcoll_contact_role
	</cfquery>
	<cfset i=1>
	<table>
		<cfif #contact.recordcount# gt 0>
		<tr>
			<td><strong>Contact Name</strong></td>
			<td><strong>Contact Role</strong></td>
		</tr>
		</cfif>
	<cfloop query="contact">
		<form name="contact#i#" method="post" action="Collection.cfm">
			<input type="hidden" name="action" value="">
			<input type="hidden" name="collection_id" value="#collection_id#">
			<input type="hidden" name="collection_contact_id" value="#collection_contact_id#">
			<tr>
			<td>
				<input type="hidden" name="contact_agent_id" value="#contact_agent_id#">
				<input type="text" name="contact" class="reqdClr" value="#contact_name#"
					onchange="getAgent('contact_agent_id','contact','contact#i#',this.value); return false;"
			 		onKeyPress="return noenter(event);">
			</td>
		
			<td>
				<select name="contact_role" size="1" class="reqdClr">
					<cfset thisContactRole = #contact_role#>
					<cfloop query="ctContactRole">
						<option 
							<cfif #thisContactRole# is #contact_role#> selected </cfif>
							value="#contact_role#">#contact_role#</option>
					</cfloop>
				</select>
			</td>
			<td colspan="2" align="center" nowrap>
				<input type="button" value="Save" class="savBtn"
   					onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'"
					onClick="contact#i#.action.value='updateContact';submit();">	
				<input type="button" value="Delete" class="delBtn"
   					onmouseover="this.className='delBtn btnhov'" onmouseout="this.className='delBtn'"
					onClick="contact#i#.action.value='deleteContact';confirmDelete('contact#i#');">
			</td>
		</tr>
		</form>
		<cfset i=#i#+1>
	</cfloop>
	</table>
	<form name="newContact" method="post" action="Collection.cfm">
		<input type="hidden" name="action" value="newContact">
		<input type="hidden" name="collection_id" value="#collection_id#">
	<table class="newRec">
	<tr>
		<td colspan="3">
			<strong>New Contact</strong>
		</td>
	</tr>
	<tr>
		<td>
			<label for ="contact_agent_id">Contact Name</label>
			<input type="hidden" name="contact_agent_id" id="contact_agent_id">
			<input type="text" name="contact" class="reqdClr"
				onchange="getAgent('contact_agent_id','contact','newContact',this.value); return false;"
	 			onKeyPress="return noenter(event);">
		</td>
		<td>
			<label for="contact_role">Contact Role</label>
			<select name="contact_role" id="contact_role" size="1" class="reqdClr">
				<cfloop query="ctContactRole">
					<option value="#contact_role#">#contact_role#</option>
				</cfloop>
			</select>
		</td>
		<td>
			<label for="">&nbsp;</label>
			<input type="submit" value="Create Contact" class="insBtn"
   				onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'">	
		</td>
	</tr>
		
	</table>
	</form>
	<form name="appearance" method="post" action="Collection.cfm">
		<input type="hidden" name="action" value="changeAppearance">
		<input type="hidden" name="collection_id" value="#collection_id#">
		<table border>
			<tr>
				<td colspan="2">Collection Appearance
				<span style="font-size:small">You must specify all values if you specify any.</span>
				</td>
			</tr>
			<tr>
				<td>
					<label for="HEADER_COLOR">
						<a href="http://www.google.com/search?q=html+color+picker" target="_blank">HEADER_COLOR</a>
					</label>
					<input type="text" name="HEADER_COLOR" id="HEADER_COLOR" class="reqdClr" value="#app.HEADER_COLOR#">
				</td>
				<td>
					<label for="HEADER_IMAGE">
						<a href="/tools/imageList.cfm" target="_blank">HEADER_IMAGE</a>
					</label>
					<input type="text" name="HEADER_IMAGE" id="HEADER_IMAGE" class="reqdClr" value="#app.HEADER_IMAGE#">
				</td>
			</tr>
			<tr>
				<td>
					<label for="COLLECTION_URL">COLLECTION_URL</label>
					<input type="text" name="COLLECTION_URL" id="COLLECTION_URL" class="reqdClr" value="#app.COLLECTION_URL#">
				</td>
				<td>
					<label for="COLLECTION_LINK_TEXT">COLLECTION_LINK_TEXT</label>
					<input type="text" name="COLLECTION_LINK_TEXT" id="COLLECTION_LINK_TEXT" class="reqdClr" value="#app.COLLECTION_LINK_TEXT#">
				</td>
			</tr>
			<tr>
				<td>
					<label for="INSTITUTION_URL">INSTITUTION_URL</label>
					<input type="text" name="INSTITUTION_URL" id="INSTITUTION_URL" class="reqdClr" value="#app.INSTITUTION_URL#">
				</td>
				<td>
					<label for="INSTITUTION_LINK_TEXT">INSTITUTION_LINK_TEXT</label>
					<input type="text" name="INSTITUTION_LINK_TEXT" id="INSTITUTION_LINK_TEXT" class="reqdClr" value="#app.INSTITUTION_LINK_TEXT#">
				</td>
			</tr>
			<tr>
				<td>
					<label for="META_DESCRIPTION">META_DESCRIPTION</label>
					<input type="text" name="META_DESCRIPTION" id="META_DESCRIPTION" class="reqdClr" value="#app.META_DESCRIPTION#">
				</td>
				<td>
					<label for="META_KEYWORDS">META_KEYWORDS</label>
					<input type="text" name="META_KEYWORDS" id="META_KEYWORDS" class="reqdClr" value="#app.META_KEYWORDS#">
				</td>
			</tr>
			<cfdirectory action="list" directory="#Application.webDirectory#/includes/css" name="sheets" filter="*.css">
			<tr>
				<td>
					<label for="STYLESHEET">STYLESHEET</label>
					<select name="STYLESHEET" size="1">
						<option value=" ">none</option>
						<cfloop query="sheets">
							<option <cfif #name# is #app.STYLESHEET#> selected="selected" </cfif>value="#name#">#name#</option>
						</cfloop>
					</select>
				</td>
				<td>
					&nbsp;
				</td>
			</tr>
			<tr>
				<td>
					<input type="submit" value="Save" class="savBtn"
   					onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'">
				</td>
				<td>
					<input type="button" value="Delete Customizations" class="delBtn"
   					onmouseover="this.className='delBtn btnhov'" onmouseout="this.className='delBtn'"
					onclick="document.appearance.action.value='deleteAppearance';submit();">
				</td>
			</tr>
		</table>
	</form>
</td>
		</tr>
	</table>
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "updateContact">
	<cfoutput>
		<cfquery name="changeContact" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
		UPDATE collection_contacts SET
			contact_role = '#contact_role#',
			contact_agent_id = #contact_agent_id#
		WHERE
			collection_contact_id = #collection_contact_id#
		</cfquery>
		<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
	</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "deleteContact">
	<cfoutput>
		<cfquery name="killContact" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
			DELETE FROM collection_contacts
		WHERE
			collection_contact_id = #collection_contact_id#
		</cfquery>
		<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
	</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->

<cfif #action# is "deleteAppearance">
<cfoutput>
	 <cfquery name="killOld" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
	 	delete from cf_collection_appearance where collection_id = #collection_id#
	 </cfquery>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
</cfoutput>
</cfif>
<cfif #action# is "changeAppearance">
<cfoutput>
	 <cfquery name="killOld" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
	 	delete from cf_collection_appearance where collection_id = #collection_id#
	 </cfquery>
	 <cfquery name="insApp" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
 		INSERT INTO cf_collection_appearance (
 			collection_id,
 			HEADER_COLOR,
 			HEADER_IMAGE,
 			COLLECTION_URL,
 			COLLECTION_LINK_TEXT,
 			INSTITUTION_URL,
 			INSTITUTION_LINK_TEXT,
 			META_DESCRIPTION,
 			META_KEYWORDS,
			STYLESHEET
 		) values (
 			#collection_id#,
 			'#HEADER_COLOR#',
 			'#HEADER_IMAGE#',
 			'#COLLECTION_URL#',
 			'#COLLECTION_LINK_TEXT#',
 			'#INSTITUTION_URL#',
 			'#INSTITUTION_LINK_TEXT#',
 			'#META_DESCRIPTION#',
 			'#META_KEYWORDS#',
			'#STYLESHEET#'
		)    
 	</cfquery>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "newContact">
	<cfoutput>
	<cftransaction>
	<cfquery name="nid" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
		select max(collection_contact_id) nxid from collection_contacts
	</cfquery>
	<cfset nextID = #nid.nxid# + 1>
	<cfquery name="newContact" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
		INSERT INTO collection_contacts (
			collection_contact_id,
			collection_id,
			contact_role,
			contact_agent_id)
		VALUES (
			#nextID#,
			#collection_id#,
			'#contact_role#',
			#contact_agent_id#)
	</cfquery>
	</cftransaction>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
	</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "modifyCollection">
<cfoutput>
	<cftransaction>
	
	<cfquery name="modColl" datasource="user_login" username="#session.username#" password="#decrypt(session.epw,cfid)#">
		UPDATE collection SET 
		COLLECTION_CDE = '#collection_cde#'
		,COLLECTION = '#collection#'
		<cfif len(#institution_acronym#) gt 0>
			,INSTITUTION_ACRONYM='#institution_acronym#'
		</cfif>
		<cfif len(#descr#) gt 0>
			,DESCR='#descr#'
		</cfif>
		<cfif len(#web_link#) gt 0>
			,web_link='#web_link#'
		<cfelse>
			,web_link=NULL
		</cfif>
		<cfif len(#web_link_text#) gt 0>
			,web_link_text='#web_link_text#'
		<cfelse>
			,web_link_text=NULL
		</cfif>
		WHERE COLLECTION_ID = #collection_id#
	</cfquery>
	</cftransaction>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->

<cfinclude template="/includes/_footer.cfm">