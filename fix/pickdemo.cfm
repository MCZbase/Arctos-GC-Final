<cfinclude template="/includes/_header.cfm">

<script>
	function checkThisForm(){
		checkNames('a','b');
	}
	function checkNames(v_f,i_f){
		var a=document.getElementById(v_f);
		var b=document.getElementById(i_f);
		if(a.value.length>0 && b.value.length==0){
			DWREngine._execute(_cfscriptLocation, null, 'agent_lookup', a.value,v_f,i_f, success_checkNames);
		} else {
			return 'gotboth';
			alert('submitting now....');
			//document.getElementById('test').submit();
		}
	}
	function success_checkNames(result){
		console.log('back');
		if (result>0) {
			document.getElementById('b').value=result;
			return 'spiffy';
			alert('submitting now....');
		} else {
			document.getElementById('a').className='red';
			return 'unspiffy';
			return false;
		}
	}
</script>
<cfif action is "nothing">
<cfoutput>
<form method="post" name="test" id="test" action="pickdemo.cfm" onsubmit="return noenter()">
	<input type="hidden" name="action" value="#action#">
	<input type="hidden" name="save" value="true">
	<label for="a">This is the text field</label>
	<input type="text" name="a" id="a"  onchange="getAgent('b','a','test',this.value);">
	<label for="b">This is the ID field, and is normally hidden</label>
	<input type="text" name="b" id="b">
	<br><input type="button" value="submit" onclick="checkNames()">
</form>

<cfif isdefined("save") and save is true>
<script>
	var bgDiv=document.createElement('div');
	bgDiv.id='bgDiv';
	bgDiv.className='bgDiv';
	document.body.appendChild(bgDiv);
</script>
	<cfquery datasource="uam_god" name="data">
		SELECT agent_name,agent_id
		FROM agent_name
		WHERE upper(agent_name) LIKE ('#ucase(a)#%')
		ORDER BY agent_name
	</cfquery>
	<div style="border:2px solid red; width:600px; height:400px; left:50px;top:50px;position:absolute;z-index:2001;background-color:white;">
	<cfif data.recordcount is 1>
		saving....
	<cfelse>
		pick thingee.....
	</cfif>
	</div>
</cfif>
</cfoutput>
</cfif>