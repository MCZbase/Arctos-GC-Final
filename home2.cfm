<cfset title="Arctos Home">
<cfset metaDesc="Frequently-asked questions (FAQ), Arctos description, participation guidelines, usage policies, suggestions, and requirements for using Arctos or participating in the Arctos community.">
<cfinclude template="/includes/_header.cfm">
<cfoutput>
	<cfquery  name="raw" datasource="uam_god">
		select 
			cf_collection.cf_collection_id,
			collection.collection,
			collection.collection_id,
			descr,
			web_link,
			web_link_text,
			loan_policy_url,
			portal_name,
			count(cat_num) as cnt
		from 
			cf_collection,
			collection,
			cataloged_item
		where 
			cf_collection.collection_id=collection.collection_id (+) and
			collection.collection_id=cataloged_item.collection_id (+) and
			PUBLIC_PORTAL_FG = 1 
		group by
			cf_collection.cf_collection_id,
			collection.collection,
			collection.collection_id,
			descr,
			web_link,
			web_link_text,
			loan_policy_url,
			portal_name
		order by collection.collection
	</cfquery>
	<cfquery name="coll" dbtype="query">
		select * from raw where collection is not null
	</cfquery>
	<cfquery name="portal" dbtype="query">
		select * from raw where collection is null
	</cfquery>
	<!--- hard-code some collections in for special treatment, but leave a default "the rest" query too --->
	<cfquery name="uam" dbtype="query">
		select * from coll where collection like 'UAM %' order by collection
	</cfquery>
	<cfset gotem=''>
	<cfset gotem=listappend(gotem,valuelist(uam.cf_collection_id))>
	<cfquery name="msb" dbtype="query">
		select * from coll where collection like 'MSB %' order by collection
	</cfquery>
	<cfset gotem=listappend(gotem,valuelist(msb.cf_collection_id))>
	<cfquery name="mvz" dbtype="query">
		select * from coll where collection like 'MVZ %' and lower(portal_name) != 'mvz_all' order by collection
	</cfquery>
	<cfset gotem=listappend(gotem,valuelist(mvz.cf_collection_id))>
	<cfquery name="mvz_all" dbtype="query">
		select * from coll where collection like 'MVZ %' and lower(portal_name) = 'mvz_all' order by collection
	</cfquery>
	<cfset gotem=listappend(gotem,valuelist(mvz_all.cf_collection_id))>
	<cfquery name="wnmu" dbtype="query">
		select * from coll where collection like 'WNMU %' order by collection
	</cfquery>
	<cfset gotem=listappend(gotem,valuelist(wnmu.cf_collection_id))>
	<cfquery name="dmns" dbtype="query">
		select * from coll where collection like 'DMNS %' order by collection
	</cfquery>
	<cfset gotem=listappend(gotem,valuelist(dmns.cf_collection_id))>
	<cfset gotem=replace(gotem,',,',',','all')>
	<cfquery name="rem" dbtype="query">
		select * from coll where cf_collection_id not in (#gotem#)
	</cfquery>
	Following the search links below will set your preferences to filter by a specific collection or portal. You may click 
	<a href="/all_all">[ search all collections ]</a> at any time to re-set your preferences. 
	<ul>
		<cfif isdefined("uam") and uam.recordcount gt 0>
			<li class="institution"><a href="http://www.uaf.edu/museum/" target="_blank" class="external">University of Alaska Museum</a>
				<ul>
					<cfloop query="uam">
						<cfset coll_dir_name = "#lcase(portal_name)#">
						<li>
							<div class="collnTitle">
								#collection# Collection
							</div>
							<cfif len(descr) gt 0>
								<div class="collnDescr">
									#descr#
								</div>
							</cfif>
							<a href="/#coll_dir_name#" target="_top">[ Search #cnt# Specimens ]</a>
							<cfif len(web_link) gt 0>
								<a href="#web_link#"  class="external" target="_blank">[ Collection Home Page ]</a>
							</cfif>
							<cfif len(loan_policy_url) gt 0>
								<br><a href="#loan_policy_url#" class="external" target="_blank">[ Collection Loan Policy ]</a>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</li>
		</cfif>
		<cfif isdefined("msb") and msb.recordcount gt 0>
			<li><a href="http://www.msb.unm.edu/" target="_blank" class="external">Museum of Southwestern Biology</a>
				<ul>
					<cfloop query="msb">
						<cfset coll_dir_name = "#lcase(portal_name)#">
						<li>
							<a href="/#coll_dir_name#" target="_top">#collection#</a>
							<cfif len(descr) gt 0>
							<span id="plus_minus_#cf_collection_id#" 
								class="infoLink"
								onclick="showDet('#cf_collection_id#')" >
								more...
							</span>
							<div id="det_div_#cf_collection_id#" class="noshow">
								#descr#
								<cfif len(#WEB_LINK#) gt 0>
									<br><a href="#WEB_LINK#" target="_blank">Collection Home Page <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
								<cfif len(#loan_policy_url#) gt 0>
									<br><a href="#loan_policy_url#" target="_blank">Collection Loan Policy <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
							</div>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</li>
		</cfif>
		<cfif isdefined("mvz") and mvz.recordcount gt 0>
			<li><a href="http://mvz.berkeley.edu/" target="_blank" class="external">Museum of Vertebrate Zoology</a>
				<ul>
					<cfif isdefined("mvz_all") and mvz_all.recordcount gt 0>
						<cfloop query="mvz_all">
							<cfset coll_dir_name = "#lcase(portal_name)#">
							<li>
								<a href="/#coll_dir_name#" target="_top">#collection#</a>
								<cfif len(descr) gt 0>
								<span id="plus_minus_#cf_collection_id#" 
									class="infoLink"
									onclick="showDet('#cf_collection_id#')" >
									more...
								</span>
								<div id="det_div_#cf_collection_id#" class="noshow">
									#descr#
									<cfif len(#WEB_LINK#) gt 0>
										<br><a href="#WEB_LINK#" target="_blank">Collection Home Page <img src="/images/linkOut.gif" border="0"></a>
									</cfif>
									<cfif len(#loan_policy_url#) gt 0>
										<br><a href="#loan_policy_url#" target="_blank">Collection Loan Policy <img src="/images/linkOut.gif" border="0"></a>
									</cfif>
								</div>
								</cfif>
							</li>
						</cfloop>
					</cfif>
					<cfloop query="mvz">
						<cfset coll_dir_name = "#lcase(portal_name)#">
						<li>
							<a href="/#coll_dir_name#" target="_top">#collection#</a>
							<cfif len(descr) gt 0>
							<span id="plus_minus_#cf_collection_id#" 
								class="infoLink"
								onclick="showDet('#cf_collection_id#')" >
								more...
							</span>
							<div id="det_div_#cf_collection_id#" class="noshow">
								#descr#
								<cfif len(#WEB_LINK#) gt 0>
									<br><a href="#WEB_LINK#" target="_blank">Collection Home Page <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
								<cfif len(#loan_policy_url#) gt 0>
									<br><a href="#loan_policy_url#" target="_blank">Collection Loan Policy <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
							</div>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</li>
		</cfif>
		<cfif isdefined("dmns") and dmns.recordcount gt 0>
			<li><a href="http://www.dmns.org/" target="_blank" class="external">Denver Museum of Nature & Science</a>
				<ul>
					<cfloop query="dmns">
						<cfset coll_dir_name = "#lcase(portal_name)#">
						<li>
							<a href="/#coll_dir_name#" target="_top">#collection#</a>
							<cfif len(descr) gt 0>
							<span id="plus_minus_#cf_collection_id#" 
								class="infoLink"
								onclick="showDet('#cf_collection_id#')" >
								more...
							</span>
							<div id="det_div_#cf_collection_id#" class="noshow">
								#descr#
								<cfif len(#WEB_LINK#) gt 0>
									<br><a href="#WEB_LINK#" target="_blank">Collection Home Page <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
								<cfif len(#loan_policy_url#) gt 0>
									<br><a href="#loan_policy_url#" target="_blank">Collection Loan Policy <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
							</div>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</li>
		</cfif>
		<cfif isdefined("wnmu") and wnmu.recordcount gt 0>
			<li><a href="http://www.wnmu.edu/univ/museum.htm" target="_blank" class="external">Western New Mexico University</a>
				<ul>
					<cfloop query="wnmu">
						<cfset coll_dir_name = "#lcase(portal_name)#">
						<li>
							<a href="/#coll_dir_name#" target="_top">#collection#</a>
							<cfif len(descr) gt 0>
							<span id="plus_minus_#cf_collection_id#" 
								class="infoLink"
								onclick="showDet('#cf_collection_id#')" >
								more...
							</span>
							<div id="det_div_#cf_collection_id#" class="noshow">
								#descr#
								<cfif len(#WEB_LINK#) gt 0>
									<br><a href="#WEB_LINK#" target="_blank">Collection Home Page <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
								<cfif len(#loan_policy_url#) gt 0>
									<br><a href="#loan_policy_url#" target="_blank">Collection Loan Policy <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
							</div>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</li>
		</cfif>
		<cfif isdefined("rem") and rem.recordcount gt 0>
			<li>Other Collections
				<ul>
					<cfloop query="rem">
						<cfset coll_dir_name = "#lcase(portal_name)#">
						<li>
							<a href="/#coll_dir_name#" target="_top">#collection#</a>
							<cfif len(descr) gt 0>
							<span id="plus_minus_#cf_collection_id#" 
								class="infoLink"
								onclick="showDet('#cf_collection_id#')" >
								more...
							</span>
							<div id="det_div_#cf_collection_id#" class="noshow">
								#descr#
								<cfif len(#WEB_LINK#) gt 0>
									<br><a href="#WEB_LINK#" target="_blank">Collection Home Page <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
								<cfif len(#loan_policy_url#) gt 0>
									<br><a href="#loan_policy_url#" target="_blank">Collection Loan Policy <img src="/images/linkOut.gif" border="0"></a>
								</cfif>
							</div>
							</cfif>
						</li>
					</cfloop>
				</ul>
			</li>
		</cfif>
	</ul>
</cfoutput>
<cfinclude template="/includes/_footer.cfm">