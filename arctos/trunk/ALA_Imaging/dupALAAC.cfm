<cfinclude template="/includes/_header.cfm">
	<cfoutput>
		<cffunction name="getRec">
			<cfargument name="dv" type="string" required="yes">
			<cfargument name="minmax" type="string" required="yes">
			<cfquery name="rec" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
				select
					cataloged_item.collection_object_id,
					cat_num,
					collection.collection,
					scientific_name,
					concatEncumbrances(cataloged_item.collection_object_id) encumbrances,
					ConcatOtherId(cataloged_item.collection_object_id) otherids,
					concatRelations(cataloged_item.collection_object_id) relations,
					getMediaBySpecimen('cataloged_item',cataloged_item.collection_object_id) media,
					higher_geog,
					spec_locality,
					verbatim_date
				from
					cataloged_item,
					collection,
					identification,
					collecting_event,
					locality,
					geog_auth_rec,
					media_relations
				where
					cataloged_item.collection_object_id=identification.collection_object_id and
					cataloged_item.collection_id=collection.collection_id and
					identification.accepted_id_fg=1 and
					cataloged_item.collecting_event_id=collecting_event.collecting_event_id and
					collecting_event.locality_id=locality.locality_id and
					locality.geog_auth_rec_id=geog_auth_rec.geog_auth_rec_id and
					cataloged_item.collection_object_id.media_relations.related_primary_key and
					media_relations.media_relationship like '% cataloged_item' and 
					cataloged_item.collection_object_id=
					(
						select #minmax#(collection_object_id) from coll_obj_other_id_num where
						other_id_type='ALAAC' and
						display_value='#dv#'
					)
			</cfquery>
			<cfset tnList="">
			<cfif len(rec.media) gt 0>
				<cfquery name="tn" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
					select preview_uri from media where media_id in (#rec.media#)
				</cfquery>
				<cfloop query="tn">
					<cfset tnList=tnList & '<img src="#preview_uri#" alt="NO PREVIEW">'>
				</cfloop>
			</cfif>
			<cfsavecontent variable="theTable">
				<table border>
					<tr>
						<td>
							<a href="/SpecimenDetail.cfm?collection_object_id=#rec.collection_object_id#">
								#rec.collection# #rec.cat_num#
							</a>
						</td>
					</tr>
					<tr>
						<td>scientific_name: #rec.scientific_name#</td>
					</tr>
					<tr>
						<td>encumbrances: #rec.encumbrances#</td>
					</tr>
					<tr>
						<td>otherids: #rec.otherids#</td>
					</tr>
					<tr>
						<td>relations: #rec.relations#</td>
					</tr>							
					<tr>
						<td>higher_geog: #rec.higher_geog#</td>
					</tr>							
					<tr>
						<td>spec_locality: #rec.spec_locality#</td>
					</tr>							
					<tr>
						<td>verbatim_date: #rec.verbatim_date#</td>
					</tr>							
					<tr>
						<td>media: #tnList#</td>
					</tr>					
				</table>
			</cfsavecontent>
			<cfreturn theTable>
		</cffunction>
		<cfset limit=20>
		<cfquery name="dupRec" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select * from (	
				select 
					count(*) cnt,
					display_value 
				from 
					coll_obj_other_id_num
				where
					other_id_type='ALAAC'
				having
					count(*) > 1
				group by
					display_value
			) where rownum < #limit#
		</cfquery>
		Showing first #limit# rows:
		<table border>
		<cfloop query="dupRec">
			<tr>
				<td>
					#display_value#
				</td>
				<td>
					<cfset recOne=getRec('#display_value#','min')>
					#recOne#
				</td>
				<td>
					<cfset recTwo=getRec('#display_value#','max')>
					#recTwo#
				</td>
			</tr>
		</cfloop>
		</table>

	</cfoutput>

<cfinclude template="/includes/_footer.cfm">
