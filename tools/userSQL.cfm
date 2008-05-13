<cfinclude template = "/includes/_header.cfm">
    <cfif not isdefined("sql")>
        <cfset sql = "SELECT 'test' FROM dual">
    </cfif>
	    <cfoutput>
	    <form method="post" action="">
	        <input type="hidden" name="action" value="run">
	        <label for="sql">SQL</label>
	        <textarea name="sql" id="sql" rows="10" cols="80" wrap="soft">#sql#</textarea>
	        <input type="submit">
	    </form>
	
	    <cfif #action# is "run">
	        <!--- check the SQL to see if they're doing anything naughty --->
           <cfset nono="update,insert,delete,drop,create,alter,dba_,user_,all_,set,execute,exec">
           <cfloop list="#nono#" index="i">
                <cfset sql=replacenocase(sql,i,"--stripped--","all")>
            </cfloop>
            <div style="font-size:smaller;background-color:lightgray">
                #sql#
            </div>
            <cfquery name="user_sql" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
                #preservesinglequotes(sql)#
            </cfquery>
            <cfdump var=#user_sql#>
	    </cfif>
    </cfoutput>
<cfinclude template = "/includes/_footer.cfm">