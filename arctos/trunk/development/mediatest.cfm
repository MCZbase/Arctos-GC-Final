<cfinclude template="/includes/_header.cfm">
<script type='text/javascript' language="javascript" src='/development/jQuery.jPlayer.2.1.0/jquery.jplayer.min.js'></script>

http://web.corral.tacc.utexas.edu/MVZ/audio/mp3/D6229_Cicero_26Jun2006_Pmaculatus1_CC3215.mp3

<script>
	$(document).ready(function(){
	 $("#sd").jPlayer({
	  ready: function () {
	   $(this).jPlayer("setMedia", {
	    mp3: "http://web.corral.tacc.utexas.edu/MVZ/audio/mp3/D6229_Cicero_26Jun2006_Pmaculatus1_CC3215.mp3"
	   });
	  },
	  swfPath: "/development/jQuery.jPlayer.2.1.0",
	  supplied: "mp3"
	 });
	});
</script>


<div id="sd">im here</div>
<cfinclude template="/includes/_footer.cfm">
