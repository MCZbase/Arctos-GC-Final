<cfinclude template="/includes/_frameHeader.cfm">
<cfif action is "nothing">
	<cfoutput>
		<cfif collecting_event_name is "undefined">
			<cfset collecting_event_name=''>
		</cfif>
		<script>
		jQuery(document).ready(function() {
			if ('#collecting_event_name#'.length > 0) {
				console.log('got something');
				$("##collecting_event_name").val('#collecting_event_name#');
				$("##findCollEvent").submit();
			}
		});
		</script>
		
		
		<cfset showLocality=1>
		<cfset showEvent=1>
		<form name="findCollEvent" id="findCollEvent" method="post" action="findCollEvent.cfm">
			<input type="hidden" name="action" value="findem">
			<input type="hidden" name="dispField" value="#dispField#">
			<input type="hidden" name="formName" value="#formName#">
			<input type="hidden" name="collIdFld" value="#collIdFld#">
		 	<cfinclude template="/includes/frmFindLocation_guts.cfm">
		</form>
	</cfoutput>
</cfif>
<!----------------------------------------------------------------------->
<cfif action is "findem">
<cfoutput>
	<cf_findLocality>
	<table border>
		<tr>
			<th>Geog</th>
			<th>Locality</th>
			<th>Event</th>
			<th>ctl</th>
		</tr>
		<cfset i = 1>
		<cfquery name="d" dbtype="query">
			select
				verbatim_date,
				began_date,
				ended_date,
				higher_geog,
				geog_auth_rec_id,
				spec_locality,
				locality_id,
				DEC_LAT,
				DEC_LONG,
				verbatim_locality,
				collecting_event_name
			from
				localityResults
			group by
				verbatim_date,
				began_date,
				ended_date,
				higher_geog,
				geog_auth_rec_id,
				spec_locality,
				locality_id,
				DEC_LAT,
				DEC_LONG,
				verbatim_locality,
				collecting_event_name		
		</cfquery>
		<cfloop query="d">
			<cfif (verbatim_date is began_date) AND (verbatim_date is ended_date)>
					<cfset thisDate = began_date>
			<cfelseif (
						(verbatim_date is not began_date) OR
			 			(verbatim_date is not ended_date)
					)
					AND
					began_date is ended_date>
					<cfset thisDate = "#verbatim_date# (#began_date#)">
			<cfelse>
					<cfset thisDate = "#verbatim_date# (#began_date# - #ended_date#)">
			</cfif>
		 	<tr #iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#>
		 		<td>
					<span style="font-size:x-small">
						#higher_geog#
						(<a href="/Locality.cfm?Action=editGeog&geog_auth_rec_id=#geog_auth_rec_id#" 
						target="_blank">#geog_auth_rec_id#</a>)
					</span>
				</td>
				<td>
					<table>
						<tr>
							<td valign="top">
								<span style="font-size:x-small">
									#spec_locality#
									(<a href="/Locality.cfm?Action=editLocality&locality_id=#locality_id#" 
									target="_blank">#locality_id#</a>)
								</span>
							</td>
							<td>
								<cfif len(DEC_LAT) gt 0>
									<cfset iu="http://maps.google.com/maps/api/staticmap?center=#DEC_LAT#,#DEC_LONG#">
									<cfset iu=iu & "&markers=color:red|size:tiny|#DEC_LAT#,#DEC_LONG#&sensor=false&size=150x150&zoom=2&maptype=roadmap">
									<a href="/bnhmMaps/bnhmPointMapper.cfm?locality_id=#locality_id#" target="_blank"><img src="#iu#" alt="Google Map"></a>
								</cfif>
							</td>
						</tr>
					</table>
				</td>
				<td>
					#verbatim_locality#
					<br>collecting_event_name: #collecting_event_name#
					<br>#thisDate#
				</td>
				<td>
					<input type="button" value="UseThis" class="savBtn"
						onclick="javascript: opener.document.#formName#.#collIdFld#.value='#collecting_event_id#'; 
							opener.document.#formName#.#dispField#.value='#jsescape(verbatim_locality)#';
							self.close();">
				</td>
			</tr>
		<cfset i=i+1>
		</cfloop>
	</table>
	</cfoutput>
</cfif>
<!----------------------------------------------------------------------->