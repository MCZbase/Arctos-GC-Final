<cfif not isdefined("action")>
	<cfset action="nothing">
</cfif>
<link rel="stylesheet" type="text/css" href="/includes/style.css" >
<script type='text/javascript' src='http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'></script>
<script type='text/javascript' src='/ajax/core/engine.js'></script>
<script type='text/javascript' src='/ajax/core/util.js'></script>
<script type='text/javascript' src='/ajax/core/settings.js'></script>
<script language="JavaScript" src="/includes/_overlib.js" type="text/javascript"></script>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
<script type="text/javascript">_uacct = "<cfoutput>#Application.Google_uacct#</cfoutput>";urchinTracker();</script>