
<cfinclude template="/includes/_header.cfm">

    <script src="/includes/jquery.colorbox-min.js"></script>
        <link rel="stylesheet" href="/includes/colorbox.css" />

        <script>
            jQuery(document).ready(function () {
                jQuery('a.gallery').colorbox({ opacity:0.5 , rel:'group1' });

				$(".iframe").colorbox({iframe:true, width:"80%", height:"80%"});
            });


			function closethis(a,b) {
			console.log('closing');

				$("#a").val(a);
				$("#b").val(b);
				$.colorbox.close();

			}


        </script>
   		<p><a class='iframe' href="/picks/op_findAgent.cfm?agent_name=dusty&formname=t&agentIdFld=a&agentNameFld=b">Outside Webpage (Iframe)</a></p>
	
	
	<form name="t">
		<input type="text" id="b" name="b">
		<input type="text" id="a" name="a">
	</form>