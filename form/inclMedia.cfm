<cfinclude template = "/includes/functionLib.cfm">
<cfif not isdefined("typ")>
	<cfabort>
</cfif>
<cfif not isdefined("q") or len(q) eq 0>
	<cfabort>
</cfif>
<cfif not isdefined("tgt") or len(tgt) eq 0>
	<cfabort>
</cfif>
<cfif not isdefined("rpp") or len(rpp) eq 0>
	<cfset rpp=10>
</cfif>
<cfif not isdefined("o") or len(o) eq 0>
	<cfset o=0>
</cfif>

<cfoutput>
	<cfif typ is "taxon">
		<cfset sql="select * from (
			   	select
			   		 media_id,
				     media_uri,
				     mime_type,
				     media_type,
				     preview_uri,
				     related_primary_key
				from (
			   		select  
				        media.media_id,
				        media.media_uri,
				        media.mime_type,
				        media.media_type,
				        media.preview_uri,
				        media_relations.related_primary_key
				     from
				        media,
				        media_relations,
				        identification,
				        identification_taxonomy
				     where
				        media.media_id=media_relations.media_id and
				        media_relations.media_relationship like '% cataloged_item' and
				        identification.accepted_id_fg=1 and
				        media_relations.related_primary_key = identification.collection_object_id and
				        identification.identification_id=identification_taxonomy.identification_id and
				        --media.preview_uri is not null and
				        identification_taxonomy.taxon_name_id=#q#
				    UNION
				    select 
				        media.media_id,
				        media.media_uri,
				        media.mime_type,
				        media.media_type,
				        media.preview_uri,
				        media_relations.related_primary_key
				     from
				         media,
				         media_relations
				     where
				         media.media_id=media_relations.media_id and
				         media_relations.media_relationship like '%taxonomy' and
				         media_relations.related_primary_key = #q#
				 ) group by
				 	media_id,
				    media_uri,
				    mime_type,
				    media_type,
				    preview_uri,
				    related_primary_key
			) 
			--where rownum <= 500">
	</cfif>
	<cfquery name="d" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#" cachedwithin="#createtimespan(0,0,60,0)#">
	   	#preservesinglequotes(sql)#
	</cfquery>
	<cfif d.recordcount gt 0>
		<cfsavecontent variable="pager">
			<cfset Result_Per_Page=10>
			<cfset Total_Records=d.recordcount> 
			<cfparam name="offset" default="0"> 
			<cfparam name="limit" default="1">
			<cfset limit=offset+Result_Per_Page> 
			<cfset start_result=offset+1> 
			<cfif d.recordcount gt 1>
				<div style="width:100%;text-align:center;" id="imgBrowserCtlDiv">
				Showing Media results #start_result# - 
				<cfif limit GT Total_Records> #Total_Records# <cfelse> #limit# </cfif> of #Total_Records# 
				<cfset offset=offset+1> 
				<cfif Total_Records GT Result_Per_Page> 
					<br> 
					<cfif offset GT Result_Per_Page> 
						<cfset prev_link=offset-Result_Per_Page-1> 
						<span class="likeLink" onclick="mediaPage('#prev_link#','#Result_Per_Page#','#q#','#type#');">&lt;&lt;PREVIOUS&nbsp;&nbsp;&nbsp;</span>
					</cfif> 
					<cfset Total_Pages=ceiling(Total_Records/Result_Per_Page)> 
					<cfloop index="i" from="1" to="#Total_Pages#"> 
						<cfset j=i-1> 
						<cfset offset_value=j*Result_Per_Page> 
					</cfloop> 
					<cfif limit LT Total_Records> 
						<cfset next_link=offset+Result_Per_Page-1> 
						<span class="likeLink" onclick="npPage('#next_link#','#Result_Per_Page#','#q#');">&nbsp;&nbsp;&nbsp;NEXT&gt;&gt;</span>

					</cfif> 
				</cfif>
			</div>
			</cfif>
		</cfsavecontent>
		<cfset rownum=1>
		<cfif offset is 0><cfset offset=1></cfif>
		<div class="thumbs">
			#pager#
			<div class="thumb_spcr">&nbsp;</div>
			<cfloop query="d" startrow="#offset#" endrow="#limit#">
            	<cfquery name="labels"  datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
					select
						media_label,
						label_value
					from
						media_labels
					where
						media_id=#media_id#
				</cfquery>
				<cfquery name="desc" dbtype="query">
					select label_value from labels where media_label='description'
				</cfquery>
				<cfset alt="Media Preview Image">
				<cfif desc.recordcount is 1>
					<cfset alt=desc.label_value>
				</cfif>
				<cfif len(alt) gt 50>
					<cfset aTxt=REReplaceNoCase(left(alt,50) & "...","<[^>]*>","","ALL")>
				<cfelse>
					<cfset aTxt=alt>
				</cfif>
               <div class="one_thumb">
	               <a href="#media_uri#" target="_blank"><img src="#getMediaPreview(preview_uri,media_type)#" alt="#alt#" class="theThumb"></a>
                   	<p>
						#media_type# (#mime_type#)
	                   	<br><a href="/media/#media_id#" target="_blank">Media Details</a>
						<br>#aTxt#
					</p>
				</div>
			</cfloop>
			<div class="thumb_spcr">&nbsp;</div>
		</div>
	</cfif>
</cfoutput>