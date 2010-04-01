<cfquery name="d" datasource="uam_god">
	select * from bulkloader
</cfquery>
<cfoutput>
	<cfloop query="d">
		<hr>
		<cfloop from="1" to="12" index="i">
			<cfset thisPart=evaluate("part_name_" & i)>
			<cfset thismod=evaluate("part_modifier_" & i)>
			<cfset thispres=evaluate("preserv_method_" & i)>
			<cfset thisNewPart=thisPart>
			<cfif len(thisMod) gt 0>
				<cfset thisNewPart = thisMod & ' ' & thisNewPart>
			</cfif>
			<cfif len(thispres) gt 0>
				<cfset thisNewPart = thisNewPart & ' (' & thispres & ')'>
			</cfif>
			<cfif len(thisNewPart) gt 0>
				<br>thisPart: #thisPart#
				<br>thismod: #thismod#
				<br>thispres: #thispres#
				<br>thisNewPart: #thisNewPart#
			</cfif>
		</cfloop>
	</cfloop>
</cfoutput>