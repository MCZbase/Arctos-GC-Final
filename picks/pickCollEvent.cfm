<cfinclude template="/includes/_frameHeader.cfm">
<cfif #action# is "nothing">
<cfoutput>
<cfquery name="ctFeature" datasource="#Application.web_user#">
	select distinct(feature) from geog_auth_rec order by feature
</cfquery>
<cfquery name="ctcollecting_source" datasource="#Application.web_user#">
	select distinct(collecting_source) from ctcollecting_source order by collecting_source
</cfquery>
<form name="findCollEvent" method="post" action="pickCollEvent.cfm">
	<input type="hidden" name="action" value="findem">
	<input type="hidden" name="collection_object_id" value="#collection_object_id#">
	<input type="hidden" name="formName" value="#formName#">
	<input type="hidden" name="collIdFld" value="#collIdFld#">
 	<cfinclude template="/includes/frmFindLocation_guts.cfm">
</form>
</cfoutput>
</cfif>
<!----------------------------------------------------------------------->
<cfif #action# is "findem">

<cfoutput>
	 <cfset sql = "select 
	 					geog_auth_rec.geog_auth_rec_id,
						higher_geog,
						locality.locality_id,
						spec_locality,
						collecting_event.collecting_event_id,
						decode(orig_lat_long_units,
							'decimal degrees',to_char(dec_lat) || '&deg; ',
							'deg. min. sec.', to_char(lat_deg) || '&deg; ' || to_char(lat_min) || '&acute; ' || to_char(lat_sec) || '&acute;&acute; ' || lat_dir,
							'degrees dec. minutes', to_char(lat_deg) || '&deg; ' || to_char(dec_lat_min) || '&acute; ' || lat_dir
						)  VerbatimLatitude,
						decode(orig_lat_long_units,
							'decimal degrees',to_char(dec_long) || '&deg;',
							'deg. min. sec.', to_char(long_deg) || '&deg; ' || to_char(long_min) || '&acute; ' || to_char(long_sec) || '&acute;&acute; ' || long_dir,
							'degrees dec. minutes', to_char(long_deg) || '&deg; ' || to_char(dec_long_min) || '&acute; ' || long_dir
						)  VerbatimLongitude,
						lat_long_ref_source,
						max_error_units,
						max_error_distance,
						began_date,
						ended_date,
						verbatim_date,
						verbatim_locality,
						feature,
						island
					from 
						locality, 
						geog_auth_rec, 
						collecting_event,
						accepted_lat_long
					where 
						collecting_event.locality_id = locality.locality_id and
		 				locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id and
						locality.locality_id = accepted_lat_long.locality_id (+)">
	
	
		
		
		<cfif len(#BEGAN_DATE#) gt 0>
			<cfset sql = "#sql# AND upper(BEGAN_DATE) #begDateOper# '#BEGAN_DATE#'">
		</cfif>
		<cfif len(#spec_locality#) gt 0>
			<cfset sql = "#sql# AND upper(spec_locality) like '%#ucase(replace(spec_locality,"'","''","all"))#%'">
		</cfif>
		<cfif len(#feature#) gt 0>
		<cfset sql = "#sql# AND feature = '#feature#'">
	</cfif>
	<cfif len(#island#) gt 0>
		<cfset sql = "#sql# AND upper(island) LIKE '%#ucase(island)#%'">
	</cfif>
	<cfif len(#locality_id#) gt 0>
		<cfset sql = "#sql# AND locality.locality_id = #locality_id#">
	</cfif>
	<cfif len(#state_prov#) gt 0>
		<cfset sql = "#sql# AND upper(state_prov) LIKE '%#ucase(state_prov)#%'">
	</cfif>
	<cfif len(#collecting_source#) gt 0>
		<cfset sql = "#sql# AND upper(collecting_source) LIKE '%#ucase(collecting_source)#%'">
	</cfif>
		<!----
		<cfif len(#ENDED_DATE#) gt 0>
			<cfset sql = "#sql# AND upper(ENDED_DATE) #endDateOper# '#ENDED_DATE#'">
		</cfif>
		
		<cfif len(#VERBATIM_DATE#) gt 0>
			<cfset sql = "#sql# AND upper(VERBATIM_DATE) like '%#ucase(VERBATIM_DATE)#%'">
		</cfif>
		
		<cfif len(#VERBATIM_LOCALITY#) gt 0>
			<cfset sql = "#sql# AND upper(VERBATIM_LOCALITY) like '%#ucase(VERBATIM_LOCALITY)#%'">
		</cfif>
		<cfif len(#COLL_EVENT_REMARKS#) gt 0>
			<cfset sql = "#sql# AND upper(COLL_EVENT_REMARKS) like '%#ucase(COLL_EVENT_REMARKS)#%'">
		</cfif>
		<cfif len(#VALID_DISTRIBUTION_FG#) gt 0>
			<cfset sql = "#sql# AND VALID_DISTRIBUTION_FG =  #VALID_DISTRIBUTION_FG#">
		</cfif>
		<cfif len(#COLLECTING_SOURCE#) gt 0>
			<cfset sql = "#sql# AND upper(COLLECTING_SOURCE) like '%#ucase(COLLECTING_SOURCE)#%'">
		</cfif>
		
		<cfif len(#COLLECTING_METHOD#) gt 0>
			<cfset sql = "#sql# AND upper(COLLECTING_METHOD) like '%#ucase(COLLECTING_METHOD)#%'">
		</cfif>
		
		<cfif len(#HABITAT_DESC#) gt 0>
			<cfset sql = "#sql# AND upper(HABITAT_DESC) like '%#ucase(HABITAT_DESC)#%'">
		</cfif>
		
	<cfif len(#MAXIMUM_ELEVATION#) gt 0>
		<cfset sql = "#sql# AND MAXIMUM_ELEVATION maxElevOper #MAXIMUM_ELEVATION#">
	</cfif>
	<cfif len(#MINIMUM_ELEVATION#) gt 0>
		<cfset sql = "#sql# AND MINIMUM_ELEVATION minElevOper #MINIMUM_ELEVATION#">
	</cfif>
	<cfif len(#ORIG_ELEV_UNITS#) gt 0>
		<cfset sql = "#sql# AND ORIG_ELEV_UNITS = '#ORIG_ELEV_UNITS#'">
	</cfif>
	<cfif len(#LOCALITY_REMARKS#) gt 0>
		<cfset sql = "#sql# AND upper(LOCALITY_REMARKS) like '%#ucase(LOCALITY_REMARKS)#%'">
	</cfif>
	<cfif len(#continent_ocean#) gt 0>
		<cfset sql = "#sql# AND upper(continent_ocean) LIKE '%#ucase(continent_ocean)#%'">
	</cfif>
	<cfif len(#country#) gt 0>
		<cfset sql = "#sql# AND upper(country) LIKE '%#ucase(country)#%'">
	</cfif>
	
	<cfif len(#county#) gt 0>
		<cfset sql = "#sql# AND upper(county) LIKE '%#ucase(county)#%'">
	</cfif>
	<cfif len(#quad#) gt 0>
		<cfset sql = "#sql# AND upper(quad) LIKE '%#ucase(quad)#%'">
	</cfif>
	
	<cfif len(#island_group#) gt 0>
		<cfset sql = "#sql# AND island_group = '#island_group#'">
	</cfif>
	
	<cfif len(#sea#) gt 0>
		<cfset sql = "#sql# AND upper(sea) LIKE '%#ucase(sea)#%'">
	</cfif>
	<cfif len(#valid_catalog_term_fg#) gt 0>
		<cfset sql = "#sql# AND valid_catalog_term_fg = #valid_catalog_term_fg#">
	</cfif>
	<cfif len(#source_authority#) gt 0>
		<cfset srcAuth = #replace(source_authority,"'","''")#>
		<cfset sql = "#sql# AND source_authority = '#srcAuth#'">
	</cfif>
	---->
	<cfset sql = "#sql# ORDER BY state_prov,verbatim_locality,VerbatimLatitude">
	<cfquery name="getCollEvent" datasource="#Application.web_user#">
		#preservesinglequotes(sql)#
	</cfquery>
	
	<table border>
		<tr>
						
			<tr>
			<td rowspan="3"> <b>Geog</b></td>
			<td rowspan="3"><b>Locality</b></td>
			<td rowspan="3">&nbsp;
			
			</td>
			<td><b>Verb. Loc.</b></td>
			<td><strong>Coll Date</strong></td>
			</tr>
		<tr>
			
			<td>
				<strong>Feature</strong>
			</td>
			<td>
				<strong>Island</strong>
			</td>
		</tr>
		<tr>
			
			<td colspan="2">
				<strong>Coordinates</strong>
			</td>
		</tr>
		
		
		
	<cfset i = 1>
	<cfloop query="getCollEvent">
		 <tr	#iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#	>
			<td rowspan="3"> 
				<font size="-2">
					#higher_geog# 
					(<a href="/Locality.cfm?Action=editGeog&geog_auth_rec_id=#geog_auth_rec_id#" 
						target="_blank">#geog_auth_rec_id#</a>)
				</font></td>
			<td rowspan="3">
				<font size="-2">
					#spec_locality# 
					(<a href="/Locality.cfm?Action=editLocality&locality_id=#locality_id#" 
						target="_blank">#locality_id#</a>)
				</font>
</td>
			<td rowspan="3">
			<form name="coll#i#" method="post" action="pickCollEvent.cfm">
				<input type="hidden" name="collection_object_id" value="#collection_object_id#">
				<input type="hidden" name="formName" value="#formName#">
				<input type="hidden" name="collIdFld" value="#collIdFld#">
				<input type="hidden" name="collecting_event_id" value="#collecting_event_id#">
				<input type="hidden" name="action" value="updateCollEvent">
				<table cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<input type="button" 
							value="Select" 
							class="savBtn"
							onmouseover="this.className='savBtn btnhov'" 
							onmouseout="this.className='savBtn'"
							onclick="javascript: opener.document.#formName#.#collIdFld#.value='#collecting_event_id#'; opener.document.#formName#.submit();self.close();">
					</td>
				</tr>
				<tr>
					<td>
						<input type="button" 
							value="Clone" 
							class="insBtn"
							onmouseover="this.className='insBtn btnhov'" 
							onmouseout="this.className='insBtn'"
							onclick="coll#i#.action.value='cloneCollEvent';submit();">
					</td>
				</tr>
			</table>
			
						
						
			</form>
			</td>
			<td>#verbatim_locality#</td>
			<cfif (#verbatim_date# is #began_date#) AND
			 		(#verbatim_date# is #ended_date#)>
					<cfset thisDate = #dateformat(began_date,"dd mmm yyyy")#>
			<cfelseif (
						(#verbatim_date# is not #began_date#) OR
			 			(#verbatim_date# is not #ended_date#)
					)
					AND
					#began_date# is #ended_date#>
					<cfset thisDate = "#verbatim_date# (#dateformat(began_date,"dd mmm yyyy")#)">
			<cfelse>
					<cfset thisDate = "#verbatim_date# (#dateformat(began_date,"dd mmm yyyy")# - #dateformat(ended_date,"dd mmm yyyy")#)">
			</cfif>
			
			<td>#thisDate#</td>
			</tr>
		<tr	#iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#	>
			
			<td>
				#feature#
			</td>
			<td>
				#island#
			</td>
		</tr>
		<tr	#iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#	>
			
			<td colspan="2">
				<font size="-1">
					#VerbatimLatitude# / #verbatimLongitude# &plusmn; #max_error_distance# #max_error_units# <em><strong>Ref:</strong></em> #lat_long_ref_source#
				</font>
			</td>
		</tr>
	<cfset i=#i#+1>
	</cfloop>
		
	</table>
	</cfoutput>
</cfif>
<!----------------------------------------------------------------------->
<!----------------------------------------------------------------------->
<cfif #action# is "cloneCollEvent">
	<cfoutput>
		<cfquery name="ctCollecting_Source" datasource="#Application.web_user#">
			select collecting_source from ctCollecting_Source
		</cfquery>
		<cfquery name="details" datasource="#Application.web_user#">
			select 
				decode(orig_lat_long_units,
					'decimal degrees',to_char(dec_lat) || '&deg; ',
					'deg. min. sec.', to_char(lat_deg) || '&deg; ' || to_char(lat_min) || '&acute; ' || 
						to_char(lat_sec) || '&acute;&acute; ' || lat_dir,
							'degrees dec. minutes', to_char(lat_deg) || '&deg; ' || to_char(dec_lat_min) || '&acute; ' || lat_dir
					)  VerbatimLatitude,
				decode(orig_lat_long_units,
					'decimal degrees',to_char(dec_long) || '&deg;',
					'deg. min. sec.', to_char(long_deg) || '&deg; ' || to_char(long_min) || '&acute; ' || 
						to_char(long_sec) || '&acute;&acute; ' || long_dir,
						'degrees dec. minutes', to_char(long_deg) || '&deg; ' || to_char(dec_long_min) || '&acute; ' || long_dir
					)  VerbatimLongitude,
				higher_geog,
				spec_locality,
				verbatim_locality,
				verbatim_date,
				began_date,
				ended_date,
				locality.locality_id,
				COLL_EVENT_REMARKS,
				Collecting_Source,
				COLLECTING_METHOD,
				HABITAT_DESC,
				dateDet.agent_name as date_determiner,
				dateDet.agent_id AS DATE_DETERMINED_BY_AGENT_ID
			 from collecting_event
			inner join locality on (collecting_event.locality_id = locality.locality_id)
			inner join geog_auth_rec on (locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id)
			left outer join accepted_lat_long on (locality.locality_id = accepted_lat_long.locality_id)
			left outer join preferred_agent_name dateDet on (collecting_event.DATE_DETERMINED_BY_AGENT_ID = dateDet.agent_id)
			where collecting_event.collecting_event_id = #collecting_event_id#
		</cfquery>
		Edit below to create collecting event for this specimen:
		<table>
		<tr>
			<td colspan="2">
				Higher geog: <strong>#details.higher_geog#</strong>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Spec Locality: <strong>#details.spec_locality#</strong>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				Coordinates: <strong>#details.VerbatimLatitude# #details.VerbatimLongitude#</strong>
			</td>
		</tr>
		
		<form name="newCollEvent" method="post" action="pickCollEvent.cfm">
			<input type="hidden" name="collection_object_id" value="#collection_object_id#">
			<input type="hidden" name="formName" value="#formName#">
			<input type="hidden" name="collIdFld" value="#collIdFld#">
			<input type="hidden" name="collecting_event_id" value="#collecting_event_id#">
			<input type="hidden" name="action" value="makeCollEvent" />
			<input type="hidden" name="locality_id" value="#details.locality_id#" />
			<tr>
				<td>
					<label for="verbatim_locality">Verbatim Locality</label>
					<input type="text" 
						name="verbatim_locality" id="verbatim_locality" 
						value='#preservesinglequotes(details.verbatim_locality)#' />
				</td>
				<td>
					<label for="verbatim_date">Verbatim Date</label>
			<input type="text" name="verbatim_date" id="verbatim_date" value='#preservesinglequotes(details.verbatim_date)#' />
			
				</td>
			</tr>
			<tr>
				<td><label for="began_date">Began Date</label>
			<input type="text" name="began_date" id="began_date" value="#dateformat(details.began_date,'dd-mmm-yyyy')#" />
			</td>
				<td><label for="ended_date">Ended Date</label>
			<input type="text" name="ended_date" id="ended_date" value="#dateformat(details.ended_date,'dd-mmm-yyyy')#" />
			</td>
			</tr>
			<tr>
				<td><label for="date_determiner">Date Determiner</label>
			<input type="hidden" name="DATE_DETERMINED_BY_AGENT_ID" value="#details.DATE_DETERMINED_BY_AGENT_ID#" />
			<input type="text" name="date_determiner" id="date_determiner" value="#details.date_determiner#" 
			onchange="getAgent('DATE_DETERMINED_BY_AGENT_ID','date_determiner','newCollEvent',this.value);" />
			</td>
				<td><label for="COLL_EVENT_REMARKS">Remarks</label>
			<input type="text" name="COLL_EVENT_REMARKS" id="COLL_EVENT_REMARKS" value="#details.COLL_EVENT_REMARKS#" />
		</td>
			</tr>
			<tr>
				<td><label for="COLLECTING_SOURCE">Source</label>
			<select name="COLLECTING_SOURCE" size="1" id="COLLECTING_SOURCE">
						<cfloop query="ctCollecting_Source">
							<option 
								<cfif #ctCollecting_Source.Collecting_Source# is #details.collecting_source#> selected </cfif>
								value="#ctCollecting_Source.Collecting_Source#">#ctCollecting_Source.Collecting_Source#</option>
						</cfloop>
					</select></td>
				<td><label for="COLLECTING_METHOD">Collecting Method</label>
			<input type="text" name="COLLECTING_METHOD" id="COLLECTING_METHOD" value="#details.COLLECTING_METHOD#" />
			</td>
			</tr>
			<tr>
				<td><label for="HABITAT_DESC">Macrohabitat</label>
			<input type="text" name="HABITAT_DESC" id="HABITAT_DESC" value="#details.HABITAT_DESC#" />
		</td>
				<td>
					<input type="submit" 
							value="Save and Select" 
							class="savBtn"
							onmouseover="this.className='savBtn btnhov'" 
							onmouseout="this.className='savBtn'">
					
				</td>
			</tr>
		</form>	
		</table>			
	</cfoutput>
</cfif>
<!----------------------------------------------------------------->
<cfif #action# is "makeCollEvent">
	<cfoutput>
		<cftransaction>
		<!--- create a coll event --->
			<cfquery name="n" datasource="#Application.uam_dbo#">
				select max(collecting_event_id) + 1 as nid from collecting_event
			</cfquery>
			<cfquery name="newCollEvent" datasource="#Application.uam_dbo#">
				INSERT INTO collecting_event (
				collecting_event_id,
				LOCALITY_ID
				,BEGAN_DATE
				,ENDED_DATE
				,VERBATIM_DATE
				,COLLECTING_SOURCE
				,DATE_DETERMINED_BY_AGENT_ID
				<cfif len(#VERBATIM_LOCALITY#) gt 0>
					,VERBATIM_LOCALITY
				</cfif>
				<cfif len(#COLL_EVENT_REMARKS#) gt 0>
					,COLL_EVENT_REMARKS
				</cfif>
				<cfif len(#COLLECTING_METHOD#) gt 0>
					,COLLECTING_METHOD
				</cfif>
				<cfif len(#HABITAT_DESC#) gt 0>
					,HABITAT_DESC
				</cfif>
				)
			VALUES (
				#n.nid#,
				#LOCALITY_ID#
				,'#BEGAN_DATE#'
				,'#ENDED_DATE#'
				,'#VERBATIM_DATE#'
				,'#COLLECTING_SOURCE#'
				,#DATE_DETERMINED_BY_AGENT_ID#
				<cfif len(#VERBATIM_LOCALITY#) gt 0>
					,'#VERBATIM_LOCALITY#'
				</cfif>
				<cfif len(#COLL_EVENT_REMARKS#) gt 0>
					,'#COLL_EVENT_REMARKS#'
				</cfif>
				<cfif len(#COLLECTING_METHOD#) gt 0>
					,'#COLLECTING_METHOD#'
				</cfif>
				<cfif len(#HABITAT_DESC#) gt 0>
					,'#HABITAT_DESC#'
				</cfif>
				)
			</cfquery>
		</cftransaction>
		<script>
			opener.document.#formName#.#collIdFld#.value='#n.nid#';
			opener.document.#formName#.submit();
			self.close();
		</script>
	</cfoutput>
</cfif>