<cfinclude template="/includes/_helpHeader.cfm">
<cfset title = "Bulk-loading, an Overview">

<font size="-2"><a href="../">Help</a> >> <strong>Bulk-loading, an Overview</strong> </font><br />
<strong><font size="+1">Bulk-loading, an Overview</font></strong>
<div align="center">
  <table width="100%" border="0">
    <tr> 
      <td valign="top" width="20%"><a href="setup.cfm">Setting up data</a><br/>
	  <a href="tutorial.cfm">Tutorial</a><br/><br />
	  &nbsp;<br/>
        <a href="bulkloader_fields.cfm">Fields in the Bulk-loader Template</a> (a list)<br/>
		&nbsp;<br/>
		<!--- evil....
        Download template:
        <ul>
          <li><a href="BulkloaderTemplate.txt">Template text file</a></li>
          <li><a href="BulkloaderTemplate.mdb">Template MS Access </a></li>
	      <li><a href="AccessCreateBulkloader.sql">Create-table script for MS Access</a></li>
        </ul>
		--->
		</td>
		<td>&nbsp;</td>
      <td valign="top">
	  <p>New specimen records are created from a single "flat file,"
	  usually a text file in which all data for a single cataloged item are in a single row.
	  This file can be created with any convenient client-side application (often Microsoft Access).
	  The file is then loaded into a similarly structured table on the server,
	  and a server-side application (the bulk-loader) parses each row 
	  into the relational structure of the database.</p>
	  
	  <p>This approach makes keyboarding of data a client-side process,
	  and thereby allows easy customization of data-entry applications. 
	  The process provides an independent layer of data checking before new information is 
	  incorporated into the database proper. 
	  Original data that are received in electronic format may require minimal 
	  manipulation; you can sometimes merely add the necessary columns to build a file
	  in the bulk-loading format.</p>
	  
	  <strong>What the bulk-loader does:</strong>
	  <ul>
	  	<li>The bulk-loader expects to find pre-existing values in the database for
	  	taxonomy, agent names, and higher geography.
	  	Data of these types that are not already in the system must be added prior
	  	to bulk-loading by a user who is priviliged to modify those tables.</li>
		
	  	<li>The content of several data fields is controlled by "code tables"
	  	which restrict the acceptable values for those fields.
	  	(The values you see in dropdowns in the editting screens come from these code tables.)</li>
	  
	    <li>The bulk-loader evaluates each row in the submitted table.
	  If the locality already exists in the database, then the bulk-loader
	  uses the existing locality.
	  If the locality does not exist, then (assuming that the row is otherwise acceptable)
	  the bulk-loader creates the new locality and parses the row into the appropriate
	  tables.</li>
	  
	  	<li>If no catalog number is provided by the submitted table,
	  	then bulkloader provides the next sequential catalog number from the indicated collection.</li>
	  </ul>
	  
	  <p>The template for this flat file handles the most common data but has limitations. 
	  For example, if a specimen has five collectors, you could load the specimen and the 
	  first three collectors with the bulk-loader, 
      then add the other collectors by editting the online record. 
      Or, you could request a change to the structure of the template.
	  (Ask <a href="mailto:%20fndlm@uaf.edu">Dusty</a> nicely.)
        
		  

      </td>
    </tr>
  </table>
</div>
<cfinclude template="/includes/_helpFooter.cfm">