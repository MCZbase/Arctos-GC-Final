<script src="/includes/jquery/jquery-autocomplete/jquery.autocomplete.pack.js" language="javascript" type="text/javascript"></script>
	
<script>
		jQuery(document).ready(function() {
			jQuery("#t1").autocomplete("/ajax/scientific_name.cfm", {
				width: 320,
				max: 50,
				autofill: false,
				multiple: false,
				scroll: true,
				scrollHeight: 300,
				matchContains: true,
				minChars: 1,
				selectFirst:false
			});
			jQuery("#t2").autocomplete("/ajax/scientific_name.cfm", {
				width: 320,
				max: 50,
				autofill: false,
				multiple: false,
				scroll: true,
				scrollHeight: 300,
				matchContains: true,
				minChars: 1,
				selectFirst:false
			});
			
			$( "#theForm" ).submit(function( event ) {
				event.preventDefault();

				console.log('hello');
				var formula=$("#taxa_formula").val();
				var s;
				var t1v=$("#t1").val();
				var t2v=$("#t2").val();

				if (formula=='A'){
					s=t1v;
				} else if (formula=='A / B intergrade'){
					s=t1v + ' / ' + t2v + ' intergrade';
				} else if (formula=='A ?'){
					s=t1v + ' ?';
				} else if (formula=='A aff.'){
					s=t1v + ' aff.';
				} else if (formula=='A cf.'){
					s=t1v + ' cf.';
				} else if (formula=='A ssp.'){
					s=t1v + ' ssp.';
				} else if (formula=='A sp.'){
					s=t1v + ' sp.';
				} else if (formula=='A and B'){
					s=t1v + ' and ' + t2v;
				} else if (formula=='A x B'){
					s=t1v + ' x ' + t2v;
				} else if (formula=='A or B'){
					s=t1v + ' or ' + t2v;
				} else if (formula=='A {string}'){
					s=t1v + ' {' + ids + '}';
				}
				$("#taxon_name").val(s);
				$("#dialog").dialog('close');
			});
			$( "#taxa_formula" ).change(function() {
				var formula=$("#taxa_formula").val();
				if (formula=='A' || formula=='A ?' || formula=='A aff.' || formula=='A cf.' || formula=='A ssp.' || formula=='A cspf.'){
					$("#dt1").show();
					$("#dt2").hide();
					$("#dts").hide();
				} else if (formula=='A / B intergrade' || formula=='A and B' || formula=='A x B' || formula=='A or B'){
					$("#dt1").show();
					$("#dt2").show();
					$("#dts").hide();
				} else if (formula=='A {string}'){
					$("#dt1").show();
					$("#dt2").hide();
					$("#dts").show();

				} else {
					alert('That taxa formula is not handled. File a bug report.');
					$("#dt1").hide();
					$("#dt2").hide();
					$("#dts").shhideow();
				}
			});

		});
		
	</script>

	<cfoutput>
		<cfquery name="cttaxa_formula" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	       	select taxa_formula,DESCRIPTION from cttaxa_formula order by taxa_formula
	    </cfquery>
	    <p>
	    	Build a Taxon Name
	    </p>
		<form name="theForm" id="theForm">
			<input type="hidden" name="nothing" id="nothing">
			
			<label for="taxa_formula">Pick a Formula to get started</label>
			<select name="taxa_formula" id="taxa_formula" size="1"  required>
				<option value=""></option>
				<cfloop query="cttaxa_formula">
					<option value="#cttaxa_formula.taxa_formula#">#cttaxa_formula.taxa_formula#</option>
				</cfloop>
			</select>
			<div id="dt1" style="display:none;">
				<label for="t1">Type to pick Taxon Name A</label>
				<input type="text" name="t1" class="reqdClr" size="40" id="t1">
			</div>
			<div id="dt2" style="display:none;">
				<label for="t2">Type to pick Taxon Name B</label>
				<input type="text" name="t2" class="reqdClr" size="40" id="t2">
			</div>
			<div id="dts" style="display:none;">
				<label for="ids">Type the Identification string</label>
				<input type="text" name="ids" class="reqdClr" size="40" id="ids">
			</div>
			<input type="submit" value="Save To Form">
		</form>
		
		
		<hr>Documentation
		<div style="width: 600px;height:400px; overflow:scroll;">
		<table border width="100%">
			<tr>
				<th>Taxa_Formula</th>
				<th>Documentation</th>
			</tr>
			<cfloop query="cttaxa_formula">
				<tr>
					<td>#taxa_formula#</td>
					<td>#DESCRIPTION#</td>
				</tr>
			</cfloop>
		</table>
		</div>
	</cfoutput>
