<cfoutput>
	<cftransaction>
		<cftry>
			<cfquery name="attr" datasource="uam_god">
				select distinct(attribute_type) from attributes order by attribute_type	
			</cfquery>
			<cfquery name="cleanup" datasource="uam_god">
				delete from cf_spec_res_cols where category='attribute'	
			</cfquery>
			<cfquery name="nid" datasource="uam_god">
				select max(disp_order) cid from cf_spec_res_cols	
			</cfquery>
			<cfset n=nid.cid + 1>
			<cfloop query="attr">
				<cfset cname=replace(attribute_type," ","_","all")>
				<cfset cname=replace(cname,"-","_","all")>
				<cfset cname=left(cname,36)>
				<cfquery name="ins" datasource="uam_god">
					insert into cf_spec_res_cols (
						COLUMN_NAME,
						SQL_ELEMENT,
						CATEGORY,
						DISP_ORDER
					) values (
						'#cname#',
						ConcatAttributeValue(flatTableName.collection_object_id,'#attribute_type#'),
						'attribute',
						#n#
					)
				</cfquery>
				<cfset n=n+1>
			</cfloop>
		<cfcatch>
			<cftransaction action="rollback" />
			<cfmail to="#Application.PageProblemEmail#" subject="cf_spec_res_cols job fail" from="scheduler@#Application.fromEmail#" type="html">
				<cfdump var=#cfcatch#>
			</cfmail>
		</cfcatch>
		</cftry>
	</cftransaction>
</cfoutput>