<cfoutput>

<cfset escapeGoofyInstall=replace(cgi.SCRIPT_NAME,"/cfusion","","all")>
<!--- check password --->
<cfif (isdefined("session.roles") and session.roles contains "coldfusion_user") and (isdefined("session.force_password_change") and 
	#session.force_password_change# is "yes" and 
	#escapeGoofyInstall# is not "/ChangePassword.cfm")>
	<cflocation url="/ChangePassword.cfm">	
</cfif>



<!---  --->
<cfquery name="isValid" datasource="#Application.web_user#" cachedWithin="#CreateTimeSpan(0,1,0,0)#">
	select ROLE_NAME from cf_form_permissions 
	where form_path = '#escapeGoofyInstall#'
</cfquery>
<cfif #isValid.recordcount# is 0>
	trying with cgi.REDIRECT_URL: #cgi.REDIRECT_URL#
	<cfquery name="isValid" datasource="#Application.web_user#" cachedWithin="#CreateTimeSpan(0,1,0,0)#">
		select ROLE_NAME from cf_form_permissions 
		where form_path = '#cgi.REDIRECT_URL#'
	</cfquery>
</cfif>

<cfif #isValid.recordcount# is 0>
	This form is not controlled. Add it to Form Permissions or get ready to see it go bye-bye.
	<cfmail subject="Uncontrolled Form" to="#Application.technicalEmail#" from="Security@#Application.fromEmail#" type="html">
		Form #escapeGoofyInstall# needs some control. Found by #session.username# (#cgi.HTTP_X_Forwarded_For# - #remote_host#)
	</cfmail>
<cfelseif valuelist(isValid.role_name) is not "public">
	<cfloop query="isValid">
		<cfif not listfindnocase(session.roles,role_name)>
			<cfset badYou = "yes">
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("badyou")>
	<cfset logfile = "#Application.webDirectory#/log/UnauthAccess.log">
	<cfset badguy = "#cgi.HTTP_X_Forwarded_For##chr(9)##remote_host##chr(9)##cgi.SCRIPT_NAME##chr(9)##dateformat(now(),'dd-mmm-yyyy')# #TimeFormat(Now(),'HH:mm:ss')#">
	<cffile action='append' file='#logfile#' addnewline='yes' output='#badguy#'>
    <cfmail subject="Access Violation" to="#Application.technicalEmail#" from="Security@#Application.fromEmail#" type="html">
		IP address (#cgi.HTTP_X_Forwarded_For# - #remote_host#) tried to access
		#escapeGoofyInstall#
		<p>
			The log entry is:
			<br>
			#badguy#
		</p>
		<br>This message was generated by /CustomTags/rolecheck.cfm.
	</cfmail>
	<!--- make sure they're really logged out --->
	<p>&nbsp;
	<table cellpadding="10">
	<tr><td valign="top"><img src="/images/oops.gif" alt="[ unauthorized access ]"></td>
	<td><font color="##FF0000" size="+1">
			You tried to visit a form for which you are not authorized,
			or your login has expired. 
			<br>
			If this message is in error, please <a href="/info/bugs.cfm">file a bug report</a> or contact the Arctos team.
			<br>
			Click <a href="/home.cfm">here</a> to visit the Arctos home page, or log in below.
	</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<form name="logIn" method="post" action="/login.cfm">
	<input type="hidden" name="action" value="signIn">
	<input type="hidden" name="gotopage" value="#escapeGoofyInstall#">
	<div style="border: 2px solid ##0066FF; padding:2px; width:25%; ">
	<table cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td align="right">
				Username:&nbsp;
			</td>
			<td>
				<input type="text" name="username">
			</td>
		</tr>
		<tr>
			<td align="right">
				Password:&nbsp;
			</td>
			<td>
				 <input type="password" name="password">
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="submit" value="Log In" class="lnkBtn"
   					onmouseover="this.className='lnkBtn btnhov'" onmouseout="this.className='lnkBtn'">	
				<input type="button" value="Create Account" class="lnkBtn"
   					onmouseover="this.className='lnkBtn btnhov'" onmouseout="this.className='lnkBtn'"
					onClick="logIn.action.value='newUser';submit();">
					<span class="infoLink" 
						onclick="pageHelp('customize');">What's this?</span>
			</td>
		</tr>
		<tr>
			
			<td colspan="2">
				<div class="infoBox">
					Logging in enables you to turn on, turn off, or otherwise customize many features of this database. To create an account and log in, simply supply a username and password here and click Create Account.
				</div>
			</td>
		</tr>
	</table>
	</div>
	</form>
		</td>
	</tr>
	</table>
	<cfabort>
</cfif>
</cfoutput>