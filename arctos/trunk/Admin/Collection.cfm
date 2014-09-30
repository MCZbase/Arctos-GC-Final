<cfinclude template="/includes/_header.cfm">
<cfset title="Manage Collections">
<cfif action is "nothing">
<cfoutput>
	Find Collection:
	<cfquery name="ctcoll" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from collection order by guid_prefix
	</cfquery>
	<form name="coll" method="post" action="Collection.cfm">
		<input type="hidden" name="action" value="findColl">
		<select name="collection_id" size="1">
			<option value=""></option>
			<cfloop query="ctcoll">
				<option value="#collection_id#">#guid_prefix#</option>
			</cfloop>
		</select>
		<input type="button" value="Submit" class="lnkBtn" onclick="coll.action.value='findColl';submit();">
	</form>
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif action is "findColl">
<cfoutput>
	<cfquery name="app" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select * from cf_collection where collection_id=#collection_id#
	</cfquery>
	<cfquery name="colls" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select
			COLLECTION_CDE,
			INSTITUTION_ACRONYM,
			INSTITUTION,
			DESCR,
			COLLECTION,
			COLLECTION_ID,
			WEB_LINK,
			WEB_LINK_TEXT,
			loan_policy_url,
			guid_prefix,
			catalog_number_format,
			use_license_id,
			citation,
			preferred_taxonomy_source
 		from collection
  		where
   		collection_id = #collection_id#
	</cfquery>
	<cfquery name="CTMEDIA_LICENSE" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select MEDIA_LICENSE_ID,DISPLAY from CTMEDIA_LICENSE order by DISPLAY
	</cfquery>
	<cfquery name="cttaxonomy_source" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select source from cttaxonomy_source group by source order by source
	</cfquery>
	<h2>
		CAUTION!!
		<br>
		Misuse of this form can be very dangerous. You can break all links to and from your specimens.
		<br>If you don't know exactly what you're doing, please <a href="/contact.cfm">ask first</a>.
	</h2>
	<table border>
		<tr>
			<td valign="top">
				<form name="editCollection" method="post" action="Collection.cfm">
					<input type="hidden" name="action" value="modifyCollection">
					<input type="hidden" name="collection_id" value="#collection_id#">
					<label for="collection_cde">Collection Type</label>
					<div>
						<strong>#colls.collection_cde#</strong> <a href="##inst">why can't I change this?</a>
					</div>
					<label for="institution_acronym">Institution Acronym</label>
					<div>
						<strong>#colls.institution_acronym#</strong> <a href="##inst">why can't I change this?</a>
					</div>
					<label for="institution">Institution</label>
					<div>
						<strong>#colls.institution#</strong> <a href="##inst">why can't I change this?</a>
					</div>
					<label for="collection">Collection</label>
					<div>
						<strong>#colls.collection#</strong> <a href="##coln">why can't I change this?</a>
					</div>
					<label for="guid_prefix">GUID Prefix</label>
					<div>
						<strong>#colls.guid_prefix#</strong> <a href="##fatalchanges">why can't I change this?</a>
					</div>
					
					
					<label for="descr">Description</label>
					<textarea name="descr" id="descr" rows="3" cols="40">#colls.descr#</textarea>
					<label for="citation">Citation</label>
					<textarea name="citation" id="citation" rows="3" cols="40">#colls.citation#</textarea>


					<label for="web_link">Web Link</label>
					<cfset thisWebLink = replace(colls.web_link,"'","''",'all')>
					<input type="text" name="web_link" id="web_link" value="#colls.web_link#" size="50">
					<label for="web_link_text">Link Text</label>
					<input type="text" name="web_link_text" id="web_link_text" value='#colls.web_link_text#' size="50">
					<label for="descr">Loan Policy URL</label>
					<input type="text" name="loan_policy_url" id="loan_policy_url" value='#colls.loan_policy_url#' size="50">
					<label for="catalog_number_format">Catnum Format</label>
					<select name="catalog_number_format" id="catalog_number_format">
						<option <cfif colls.catalog_number_format is "integer">selected="selected" </cfif>value="integer">integer</option>
						<option <cfif colls.catalog_number_format is "prefix-integer-suffix">selected="prefix-integer-suffix" </cfif>value="prefix-integer-suffix">prefix-integer-suffix</option>
						<option <cfif colls.catalog_number_format is "string">selected="selected" </cfif>value="string">string</option>
					</select>
					<label for="use_license_id">License</label>
					<select name="use_license_id" id="use_license_id">
						<option value="NULL">-none-</option>
						<cfloop query="CTMEDIA_LICENSE">
							<option	<cfif colls.use_license_id is MEDIA_LICENSE_ID> selected="selected" </cfif>
								value="#MEDIA_LICENSE_ID#">#DISPLAY#</option>
						</cfloop>
					</select>
					<span class="infoLink" onclick="getCtDoc('ctmedia_license',editCollection.use_license_id.value);">Define</span>
					<label for="PREFERRED_TAXONOMY_SOURCE">Taxonomy Source</label>
					<select name="preferred_taxonomy_source" id="use_license_id">
						<cfloop query="cttaxonomy_source">
							<option	<cfif colls.preferred_taxonomy_source is cttaxonomy_source.source> selected="selected" </cfif>
								value="#source#">#source#</option>
						</cfloop>
					</select>
					<span class="infoLink" onclick="getCtDoc('cttaxonomy_source',editCollection.preferred_taxonomy_source.value);">Define</span>

					<br><input type="submit" value="Save Changes" class="savBtn">
					<input type="button" value="Quit" class="qutBtn" onClick="document.location='/Admin/Collection.cfm';">
				</form>
			</td>
<td valign="top">
	<cfquery name="contact" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		select
			collection_contact_id,
			contact_role,
			contact_agent_id,
			preferred_agent_name contact_name
		from
			collection_contacts,
			agent
		where
			contact_agent_id = agent.agent_id AND
			collection_id = #collection_id#
		ORDER BY contact_name,contact_role
	</cfquery>
	<cfquery name="ctContactRole" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
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
		<cfset i=i+1>
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
			<input type="submit" value="Create Contact" class="insBtn">
		</td>
	</tr>

	</table>
	</form>
	<form name="appearance" method="post" action="Collection.cfm">
		<input type="hidden" name="action" value="changeAppearance">
		<input type="hidden" name="collection_id" value="#collection_id#">
		<table border>
			<tr>
				<td colspan="2">Portal
					<span style="font-size:smaller">(You may need DBA help to set this up properly for new collections.
					Your settings will be ignored if you don't include enough information. With the help of a DBA, you may also create "portals"
					for things other than collections - e.g., all mammal collections, or all collections within an institution, or whatever)
					</span>
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
			<td>
				<td>
					<label for="HEADER_CREDIT">
						HEADER_CREDIT
					</label>
					<input type="text" name="HEADER_CREDIT" id="HEADER_CREDIT" class="reqdClr" value="#app.HEADER_CREDIT#">
				</td>
			</td>
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
			</tr>
		</table>
	</form>
</td>
		</tr>
	</table>
	
	<hr>
	<h2>Random Disclaimer</h2>
	<div>
		None of this is an attempt to prevent changes or assert any values over any other; we (the Arctos Advisory and Steering Committees) simply
		wish to prevent a uniform front containing unambiguous values. How we accomplish that is, as always, up to the combined efforts of the 
		Arctos community.
	</div>
	<a name="inst"></a>
	<h2>Institutional Standardization</h2>
	<div>
		Institution Acronym and Institution are set by Institutions as a whole in order to present a united front to users, and to allow
		hierarchical search controls. To change these values, coordinate the change with all collections in your institution and 
		<a href="/contact.cfm">contact us</a>
	</div>
	<a name="coln"></a>
	<h2>Collection Naming Standardization</h2>
	<div>
		Collection has been (more or less) standardized across all collections, and may only be changed with the 
		agreement of the Arctos community. <a href="/contact.cfm">Contact us</a> or send a message to the Arctos group
		to initiate changes.
	</div>
	
	<a name="fatalchanges"></a>
	<h2>Other Restrictions</h2>
	<div>
		<strong>guid_prefix</strong> is used in forming URLs to specimens. Changing it (after specimens have been "published" on the Internet) is generally a 
		bad idea, but we can accommodate changes by creating redirects to "old" URLs. <a href="/contact.cfm">Contact us</a> is a change to guid_prefix is necessary.
	</div>
	<div>
		<strong>collection_cde</strong> controls code tables and therefore acceptable data. Changing collection_cde requires data confirmation and 
		possibly migration. <a href="/contact.cfm">Contact us</a> is a change to collection_cde is necessary.
	</div>
	
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "updateContact">
	<cfoutput>
		<cfquery name="changeContact" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
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
		<cfquery name="killContact" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
			DELETE FROM collection_contacts
		WHERE
			collection_contact_id = #collection_contact_id#
		</cfquery>
		<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
	</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "changeAppearance">
<cfoutput>

	 <cfquery name="insApp" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
 		update cf_collection set
 			HEADER_COLOR='#HEADER_COLOR#',
 			HEADER_IMAGE='#HEADER_IMAGE#',
 			COLLECTION_URL='#COLLECTION_URL#',
 			COLLECTION_LINK_TEXT='#COLLECTION_LINK_TEXT#',
 			INSTITUTION_URL='#INSTITUTION_URL#',
 			INSTITUTION_LINK_TEXT='#INSTITUTION_LINK_TEXT#',
 			META_DESCRIPTION='#META_DESCRIPTION#',
 			META_KEYWORDS='#META_KEYWORDS#',
			STYLESHEET='#STYLESHEET#',
			header_credit='#header_credit#'
 		where collection_id=#collection_id#
 	</cfquery>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->
<cfif #action# is "newContact">
	<cfoutput>
	<cftransaction>
	<cfquery name="newContact" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		INSERT INTO collection_contacts (
			collection_contact_id,
			collection_id,
			contact_role,
			contact_agent_id)
		VALUES (
			sq_collection_contact_id.nextval,
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
	<cfquery name="modColl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
		UPDATE collection SET
			DESCR='#escapeQuotes(descr)#',
			web_link='#web_link#',
			web_link_text='#web_link_text#',
			loan_policy_url='#loan_policy_url#',
			catalog_number_format='#catalog_number_format#',
			use_license_id=#use_license_id#,
			citation='#escapeQuotes(citation)#',
			preferred_taxonomy_source='#preferred_taxonomy_source#'
		WHERE COLLECTION_ID = #collection_id#
	</cfquery>
	</cftransaction>
	<cflocation url="Collection.cfm?action=findColl&collection_id=#collection_id#">
</cfoutput>
</cfif>
<!------------------------------------------------------------------------------------->

<cfinclude template="/includes/_footer.cfm">