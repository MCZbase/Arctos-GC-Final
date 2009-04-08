<cfinclude template="/includes/_header.cfm">
<cfoutput>
	<p>
		The page you tried to access does not exist.
	</p>
	<cfif len(cgi.SCRIPT_NAME) gt 0>
		<cfset rUrl=cgi.SCRIPT_NAME>
	</cfif>
	<cfif len(cgi.REDIRECT_URL) gt 0>
		<cfset rUrl=cgi.REDIRECT_URL>
	</cfif>
	<p>
		If you followed a link from Arctos, please <
	 	containing any information that might help us resolve this issue.
	</p>
	<p>
		If you followed an external link, please use your back button and tell the webmaster that
		something is broken, or <a href="/info/bugs.cfm">submit a bug report</a> telling us how you got this error.
	</p>
	<p>
		If you're trying to find specimens, you may:
			<ul>
				<li><a href="/SpecimenSearch.cfm">Search for them</a></li>
				<li>Access them by URLs of the format:
					<ul>
						<li>
							#Application.serverRootUrl#/SpecimenDetail.cfm?guid={institution}:{collection}:{catnum}
							<br>Example: #Application.serverRootUrl#/SpecimenDetail.cfm?guid=UAM:Mamm:1
						</li>
						<li>
							#Application.serverRootUrl#/guid/{institution}:{collection}:{catnum}
							<br>Example: #Application.serverRootUrl#/guid/UAM:Mamm:1
						</li>
						<li>
							#Application.serverRootUrl#/specimen/{institution}/{collection}/{catnum}
							<br>Example: #Application.serverRootUrl#/specimen/UAM/Mamm/1
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
		 	Use the tabs in the header to navigate Arctos.
		 </p>
</cfoutput>
-------------->
<cfinclude template="/includes/_footer.cfm">