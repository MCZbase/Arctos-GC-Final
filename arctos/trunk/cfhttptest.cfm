	<cfoutput>

	<!--- Get the starting time. --->

	<cfset intStartTime = GetTickCount() />

	<cfhttp method="GET" url="http://www.tacc.utexas.edu/"/>


	          #now()#: Single request GET of http://www.tacc.utexas.edu/: Results in

	          #NumberFormat(((GetTickCount() - intStartTime) / 1000),",.00")#

	</cfoutput>
