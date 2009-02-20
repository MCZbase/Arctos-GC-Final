<cfinclude template = "includes/_header.cfm">
<cfif len(#session.username#) is 0>
	<cflocation url="/login.cfm">
</cfif>
<script type='text/javascript' src='/includes/_myArctos.js'></script>
<span class="infoLink pageHelp" onclick="pageHelp('customize');">Page Help</span>
<script>
	function pwc(p,u){
		var r=orapwCheck(p,u);
		var elem=document.getElementById('pwstatus');
		if (r=='Password is acceptable'){
			var clas='goodPW';
		} else {
			var clas='badPW';
		}
		elem.innerHTML=r;
		elem.className=clas;
	}
</script>
<!------------------------------------------------------------------->
<cfif action is "makeUser">
	<cfdump var=#form#>
</cfif>

<cfif #action# is "nothing">
	<cfquery name="getPrefs" datasource="cf_dbuser">
		select * from cf_users, user_loan_request
		where  cf_users.user_id = user_loan_request.user_id (+) and
		username = '#session.username#' order by cf_users.user_id
	</cfquery>
	<cfif getPrefs.recordcount is 0>
		<cflocation url="login.cfm?action=signOut">
	</cfif>
	<cfquery name="isInv" datasource="uam_god">
		select allow from temp_allow_cf_user where user_id=#getPrefs.user_id#
	</cfquery>
	<cfoutput query="getPrefs" group="user_id">
	<h2>Welcome back, <b>#getPrefs.username#</b>!</h2>
	<ul>
		<li>
			<a href="ChangePassword.cfm">Change your password</a>
			<cfset pwtime =  round(now() - getPrefs.pw_change_date)>
			<cfset pwage = Application.max_pw_age - pwtime>
			<cfif pwage lte 0>
				<cfset session.force_password_change = "yes">
				<cflocation url="ChangePassword.cfm">
			<cfelseif pwage lte 10>
				<span style="color:red;font-weight:bold;">
					Your password expires in #pwage# days.
				</span>
			</cfif>
		</li>
		<li>
			Review some <a href="http://g-arctos.appspot.com/arctosdoc/search_examples_TOC.html" target="_blank">sample searches</a> to learn about the power of Arctos.
		</li>
	</ul>
	<cfif #isInv.allow# is 1>
		<div style="background-color:##FF0000; border:2px solid black; width:75%;">
			You've been invited to become an Operator. Password restrictions apply.
			This form does not change your password,
			but will provide information about the suitability of your password. You may need to change your password 
			in order to successfully complete this form.
			<form name="getUserData" method="post" action="myArctos.cfm">
				<input type="hidden" name="action" value="makeUser">
				<label for="pw">Enter your password:</label>
				<input type="password" name="pw" id="pw" onkeyup="pwc(this.value,'#session.username#')">
				<span id="pwstatus"></span>
				<br><input type="submit" value="Authenticate">
			</form>
		</div>
	<cfelseif #isInv.allow# is 2>
		<div style="background-color:##00FF00; border:2px solid black; width:75%;">
			You have successfully authenticated your Arctos username. We'll take care of the rest. Thank you!
		</div>
		<cfmail to="dustymc@gmail.com" from="oracleuser@#Application.fromEmail#" subject="account needed">
			#session.username# has set up an Oracle account and awaits blessings.
		</cfmail>			
	</cfif>
	<cfquery name="getUserData" datasource="cf_dbuser">
		SELECT   
			cf_users.user_id,
			first_name,
	        middle_name,
	        last_name,
	        affiliation,
			email
		FROM 
			cf_user_data,
			cf_users
		WHERE
			cf_users.user_id = cf_user_data.user_id (+) AND
			username = '#session.username#'
	</cfquery>
	<form method="post" action="myArctos.cfm" name="dlForm">
		<input type="hidden" name="user_id" value="#getUserData.user_id#">
		<input type="hidden" name="action" value="saveProfile">
		<table style="border:2px solid black; margin:10px;">
			<tr>
				<td colspan="2">
					<strong>Personal Profile:</strong>
					<img src="/images/info.gif" class="likeLink" onclick="alert('A profile is required to download data. \n You cannot recover a lost password unless you enter an email address. \n These data will never be shared with anyone.');" />
					<span style="font-size:small;">
						<br>
						To download data, please tell us more about yourself. 
						This information will not be shared with others.
					</span>
				</td>
			</tr>
			<tr>
				<td align="right">First Name</td>
				<td><input type="text" name="first_name" value="#getUserData.first_name#" class="reqdClr"></td>
			</tr>
			<tr>
				<td align="right">Middle Name</td>
				<td><input type="text" name="middle_name" value="#getUserData.middle_name#"></td>
			</tr>
			<tr>
				<td align="right">Last Name</td>
				<td><input type="text" name="last_name" value="#getUserData.last_name#" class="reqdClr"></td>
			</tr>	
			<tr>
				<td align="right">Affiliation</td>
				<td><input type="text" name="affiliation" value="#getUserData.affiliation#" class="reqdClr"></td>
			</tr>
			<tr>
				<td align="right">Email</td>
				<td><input type="text" name="email" value="#getUserData.email#"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" value="Save" class="savBtn">
				</td>
			</tr>
		</table>
	</form>
	<cfquery name="loan" datasource="cf_dbuser">
		select * from cf_user_loan
		inner join cf_users on (cf_user_loan.user_id = cf_users.user_id)
		where username='#session.username#'
		order by IS_ACTIVE DESC
	</cfquery>
	<table style="border:2px solid black; margin:10px;">
		<tr>
			<td>
				<a href="user_loan_request.cfm"><strong>Loans</strong></a>
				<ul>
					<cfif #loan.recordcount# gt 0>
						<cfloop query="loan">
							<li>
								<cfif #IS_ACTIVE# is 1>
									<span>
								<cfelse>
									<span style="color:##666666">
								</cfif>
									#PROJECT_TITLE#
								</span>
							</li>
						</cfloop>
					<cfelse>
						<li>None</li>
					</cfif>
				</ul>
			</td>
		</tr>
	</table>
</cfoutput>
</cfif>
<!----------------------------------------------------------------------------------------------->
<!----------------------------------------------------------------------------------------------->
<cfif #action# is "saveProfile">
	<!--- get the values they filled in --->
	<cfif len(#first_name#) is 0 OR
		len(#last_name#) is 0 OR
		len(#affiliation#) is 0>
		You haven't filled in all required values! Please use your browser's back button to try again.
		<cfabort>
	</cfif>
	<cfset thisDate = #dateformat(now(),"dd-mmm-yyyy")#>
	
	<cfquery name="isUser" datasource="cf_dbuser">
		select * from cf_user_data where user_id=#user_id#
	</cfquery>
		<!---- already have a user_data entry --->
		<cfif #isUser.recordcount# is 1>
			<cfquery name="upUser" datasource="cf_dbuser">
				UPDATE cf_user_data SET
					first_name = '#first_name#',
					last_name = '#last_name#',
					affiliation = '#affiliation#'
					<cfif len(#middle_name#) gt 0>
						,middle_name = '#middle_name#'
					<cfelse>
						,middle_name = NULL
					</cfif>
					<cfif len(#email#) gt 0>
						,email = '#email#'
					<cfelse>
						,email = NULL
					</cfif>
				WHERE
					user_id = #user_id#
			</cfquery>
		</cfif>
		<cfif #isUser.recordcount# is not 1>
			<cfquery name="newUser" datasource="cf_dbuser">
				INSERT INTO cf_user_data (
					user_id,
					first_name,
					last_name,
					affiliation
					<cfif len(#middle_name#) gt 0>
						,middle_name
					</cfif>
					<cfif len(#email#) gt 0>
						,email
					</cfif>
					)
				VALUES (
					#user_id#,
					'#first_name#',
					'#last_name#',
					'#affiliation#'
					<cfif len(#middle_name#) gt 0>
						,'#middle_name#'
					</cfif>
					<cfif len(#email#) gt 0>
						,'#email#'
					</cfif>
					)
			</cfquery>
		</cfif>
	<cflocation url="/myArctos.cfm">
</cfif>
<!---------------------------------------------------------------------->
<cfif isdefined("redir") AND #redir# is "true">

	<!---<cflocation url="#startApp#">--->
	<cfoutput>
	<!---- 
		replace cflocation with JavaScript below so I'll always break
		out of frames (ie, agents) when using the nav button 
	--->
	<script language="JavaScript">
		parent.location.href="#startApp#"
	</script>
	</cfoutput>
</cfif>

<cfinclude template = "includes/_footer.cfm">