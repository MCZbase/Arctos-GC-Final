<cfif not isdefined("toProperCase")>
	<cfinclude template="/includes/_header.cfm">
</cfif>
<cfoutput>
<cfif cgi.redirect_url contains "/DiGIRprov/www/DiGIR.php">
	<cfheader statuscode="301" statustext="Moved permanently">
	<cfheader name="Location" value="http://arctos.database.museum/digir/DiGIR.php"> 
<cfelse>
	<cfheader statuscode="404" statustext="Not found">
	<cfset title="404: not found">
	<h2>
		404! The page you tried to access does not exist.
	</h2>
	<script type="text/javascript">
  var GOOG_FIXURL_LANG = 'en';
  var GOOG_FIXURL_SITE = 'http://arctos.database.museum/';
</script>
<script type="text/javascript" 
    src="http://linkhelp.clients.google.com/tbproxy/lh/wm/fixurl.js"></script>
	<cfif len(cgi.SCRIPT_NAME) gt 0>
		<cfset rUrl=cgi.SCRIPT_NAME>
	</cfif>
	
	<p>
		If you followed a link from within Arctos, please <a href="/info/bugs.cfm">submit a bug report</a>
	 	containing any information that might help us resolve this issue.
	</p>
	<p>
		If you followed an external link, please use your back button and tell the webmaster that
		something is broken, or <a href="/info/bugs.cfm">submit a bug report</a> telling us how you got this error.
	</p>
	<cfif len(cgi.REDIRECT_URL) gt 0 and cgi.redirect_url contains "guid" and session.dbuser is not "pub_usr_all_all">
		<cfquery name="yourcollid" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
			select collection from cf_collection where DBUSERNAME='#session.dbuser#'
		</cfquery>
		<p>
			You are accessing Arctos through the #yourcollid.collection# portal, and cannot access data in
			other collections. Try the <a href="/all_all">all-collections portal</a>.
		</p>
	</cfif>	
	<p><a href="/TaxonomySearch.cfm">Search for Taxon Names here</a></p>
	<p><a href="/SpecimenUsage.cfm">Search for Projects and Publications here</a></p>
	<p>
		If you're trying to find specimens, you may:
		<ul>
			<li><a href="/SpecimenSearch.cfm">Search for them</a></li>
			<li>Access them by URLs of the format:
				<ul>
					<li>
						#Application.serverRootUrl#/SpecimenDetail.cfm?guid={institution}:{collection}:{catnum}
						<br>Example: #Application.serverRootUrl#/SpecimenDetail.cfm?guid=UAM:Mamm:1
						<br>&nbsp;
					</li>
					<li>
						#Application.serverRootUrl#/guid/{institution}:{collection}:{catnum}
						<br>Example: #Application.serverRootUrl#/guid/UAM:Mamm:1
						<br>&nbsp;
					</li>
					<li>
						#Application.serverRootUrl#/specimen/{institution}/{collection}/{catnum}
						<br>Example: #Application.serverRootUrl#/specimen/UAM/Mamm/1
						<br>
					</li>
				</ul>
			</li>
		</ul>			
	</p>
	<cfmail subject="Dead Link" to="#Application.PageProblemEmail#" from="dead.link@#application.fromEmail#" type="html">
		A user found a dead link! The referring site was #cgi.HTTP_REFERER#.
		<cfif isdefined("CGI.script_name")>
			<br>The missing page is #Replace(CGI.script_name, "/", "")#
		</cfif>
		<cfif isdefined("cgi.REDIRECT_URL")>
			<br>cgi.REDIRECT_URL: #cgi.REDIRECT_URL#
		</cfif>
		<cfif isdefined("session.username")>
			<br>The username is #session.username#
		</cfif>
		<br>The IP requesting the dead link was #cgi.REMOTE_ADDR#
		<br>This message was generated by #cgi.CF_TEMPLATE_PATH#.
		<hr><cfdump var="#cgi#">
	</cfmail>
		 <p>A message has been sent to the site administrator.</p>
		 <p>
		 	Use the tabs in the header to continue navigating Arctos.
		 </p>
</cfif>
</cfoutput>
<cfinclude template="/includes/_footer.cfm">