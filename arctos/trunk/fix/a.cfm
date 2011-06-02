<cfif not isdefined("action") ><cfset action="nothing"></cfif>


<cfinclude template="/includes/functionLib.cfm">
<cfset stime=now()>
<cfoutput>
	<cfquery name="d" datasource="uam_god">
		select id,scientific_name from ttaxonomy where
		--ccnametry is null and
		--scientific_name is not null and
		--rownum<2
		scientific_name='#n#'
	</cfquery>
	<cfloop query="d">
			<cfhttp method="get" url="http://www.catalogueoflife.org/webservice?response=full&name=#scientific_name#"></cfhttp>
			<cfset x=xmlparse(cfhttp.filecontent)>
			<cfdump var=#x#>
			<cfloop index="r" from="1" to="#ArrayLen(x.results.result)#" step="1">
				-------------<cfdump var=#arrayLen(x.results.result[1].common_names.xmlChildren)#>----------------
				<cfloop index="i" from="1" to="#ArrayLen(x.results.result[r].common_names.xmlChildren)#" step="1">
					<br>TheName:::#x.results.result[r].common_names.common_name[i].name.xmltext#
					<cfquery name="s" datasource="uam_god">
						insert into ttccommonname (id, name) values (
						#id#,'#x.results.result[r].common_names.common_name[i].name.xmltext#')
					</cfquery>
				</cfloop>
			</cfloop>
			<br>numSyn:#ArrayLen(x.results.result[r].synonyms.xmlChildren)#
			<cfloop index="s" from="1" to="#ArrayLen(x.results.result[r].synonyms.xmlChildren)#" step="1">
				#s#
			</cfloop>
	</cfloop>
	<cfquery name="s" datasource="uam_god">
		update ttaxonomy set ccnametry=1 where id in (#valuelist(d.id)#)
	</cfquery>
	
	<cfset etime=now()>
	<br>#stime#
	<br>#etime#
	<cfset elap=stime-etime>
	<br>#elap#
</cfoutput>



<!----

create table ssynonyms (
	n1 varchar2(255),
	n2 varchar2(255)
	s varchar2(255)
);


alter table ttaxonomy add column ccnametry(number);

create unique index iu_ttid on ttaxonomy(id) tablespace uam_idx_1;


create table ttccommonname (
	id number,
	name varchar2(4000)
)

create table ttaxonomy (
id int,
AUTHOR_TEXT varchar(255),
family  varchar(255),
genus  varchar(255),
INFRASPECIFIC_AUTHOR varchar(255),
INFRASPECIFIC_RANK varchar(255),
KINGDOM varchar(255),
NOMENCLATURAL_CODE varchar(255),
PHYLCLASS varchar(255),
PHYLORDER varchar(255),
PHYLUM varchar(255),
SCIENTIFIC_NAME varchar(255),
SPECIES varchar(255),
SUBCLASS varchar(255),
SUBFAMILY varchar(255),
SUBGENUS varchar(255),
SUBORDER varchar(255),
SUBSPECIES varchar(255),
SUPERFAMILY varchar(255),
TRIBE varchar(255)
);


create table one_col (
	id number,
	parent_id number,
	rank varchar2(255),
	name_element varchar2(255),
	author_string varchar2(255)
);


create unique index ffffuuuu on ttaxonomy (
KINGDOM,
			PHYLUM,
			PHYLCLASS,
			SUBCLASS,
			PHYLORDER,
			SUBORDER,
			SUPERFAMILY,
			family,
			SUBFAMILY,
			TRIBE,
			genus,
			SUBGENUS,
			SPECIES,
			SUBSPECIES) tablespace uam_idx_1;
			
			
create index temp_onecol_id on one_col(id) tablespace uam_idx_1;
create index temp_onecol_pid on one_col(parent_id) tablespace uam_idx_1;

insert into one_col (
	id,
	parent_id,
	rank,
	name_element,
	author_string
) (
select 
		taxon_name_element.taxon_id,
		taxon_name_element.parent_id,
		taxonomic_rank.rank,
		scientific_name_element.name_element,
		author_string.string		
from 
		taxon_name_element,
		scientific_name_element,
		taxon,
		taxon_detail,
		taxonomic_rank,
		author_string
	where 
		taxon_name_element.scientific_name_element_id=scientific_name_element.id and 
		taxon_name_element.taxon_id=taxon.id and
		taxonomic_rank_id=taxonomic_rank.id and	
		taxon.id=taxon_detail.taxon_id (+) and
		taxon_detail.author_string_id=author_string.id (+)
);


update one_col set rank='phylclass' where rank='class';

update one_col set rank='phylorder' where rank='order';

---->

<!----
<cfif action is "lamtest">
<cfquery name="lamtest" datasource="uam_god">
	select * from common_name_element where id=264183
</cfquery>
<cfdump var=#lamtest#>
</cfif>








<cfif action is "nothing">
<cfoutput>
	
	
	<!-----------
	
	
--agsp.
agvar.
convar
cultivar
family
form
genus
kingdom
lusus
microgene
monster
--mutant
nm.
not assigned
nothof.
nothosp.
nothosubsp.
nothovar.
phylclass
phylorder
phylum
prole
race

status
staxon
sub-variety
subform
subspecies
subtaxon
superfamily
variety



-------->
<cfquery name="d" datasource="uam_god">
	SELECT 
		id,
		term
	FROM 
		col_cat
	where
		gotit is null and
		rownum<500
</cfquery>
<!---
<cfdump var=#d#>

--->


<!-- ignore all the bullshit made-up infranks for now - wtf, COL, W.T.F.? -->
<cfset gafr="KINGDOM,PHYLUM,PHYLCLASS,SUBCLASS,PHYLORDER,SUBORDER,SUPERFAMILY,family,SUBFAMILY,TRIBE,genus,SUBGENUS,SPECIES,SUBSPECIES">
<cfloop query="d">
	<!---
	<hr>
	--->
	<!--- clear everything out --->
	<cfset t_id=''>
	<cfset t_AUTHOR_TEXT=''>
	<cfset t_family=''>
	<cfset t_genus=''>
	<cfset t_INFRASPECIFIC_AUTHOR=''>
	<cfset t_INFRASPECIFIC_RANK=''>
	<cfset t_KINGDOM=''>
	<cfset t_NOMENCLATURAL_CODE=''>
	<cfset t_PHYLCLASS=''>
	<cfset t_PHYLORDER=''>
	<cfset t_PHYLUM=''>
	<cfset t_SCIENTIFIC_NAME=''>
	<cfset t_SPECIES=''>
	<cfset t_SUBCLASS=''>
	<cfset t_SUBFAMILY=''>
	<cfset t_SUBGENUS=''>
	<cfset t_SUBORDER=''>
	<cfset t_SUBSPECIES=''>
	<cfset t_SUPERFAMILY=''>
	<cfset t_TRIBE=''>
	
	<cfloop list="#term#" index="i" delimiters="|">
		
		<cfset t_rank=listgetat(i,1,chr(7))>
		<cfset t_name=listgetat(i,2,chr(7))>
		<!---
		<br>t_rank=#t_rank#
		<br>t_name=#t_name#
		--->
		<!--- see if we care ---->
		<cfif listfindnocase(gafr,t_rank)>
			<!--- we care --->
			<!---
			<br>docare
			--->
			<cfset "t_#t_rank#"=t_name>
			<cfif listlen(i,chr(7)) is 3>
				<cfif t_rank is "species">
					<cfset t_AUTHOR_TEXT=listgetat(i,3,chr(7))>
				<cfelseif t_rank is "subspecies">
					<cfset t_INFRASPECIFIC_AUTHOR=listgetat(i,3,chr(7))>
				</cfif>
			</cfif>
		</cfif>
		
	</cfloop>
	
	<cftry>
	<cfquery name="ins" datasource="uam_god">
		insert into ttaxonomy (
			KINGDOM,
			PHYLUM,
			PHYLCLASS,
			SUBCLASS,
			PHYLORDER,
			SUBORDER,
			SUPERFAMILY,
			family,
			SUBFAMILY,
			TRIBE,
			genus,
			SUBGENUS,
			SPECIES,
			SUBSPECIES,		
			AUTHOR_TEXT,
			INFRASPECIFIC_AUTHOR,
			INFRASPECIFIC_RANK
		) values (
			'#toProperCase(t_KINGDOM)#',
			'#toProperCase(t_PHYLUM)#',
			'#toProperCase(t_PHYLCLASS)#',
			'#toProperCase(t_SUBCLASS)#',
			'#toProperCase(t_PHYLORDER)#',
			'#toProperCase(t_SUBORDER)#',
			'#toProperCase(t_SUPERFAMILY)#',
			'#toProperCase(t_family)#',
			'#toProperCase(t_SUBFAMILY)#',
			'#toProperCase(t_TRIBE)#',
			'#toProperCase(t_genus)#',
			'#toProperCase(t_SUBGENUS)#',
			'#t_SPECIES#',
			'#t_SUBSPECIES#',		
			'#t_AUTHOR_TEXT#',
			'#t_INFRASPECIFIC_AUTHOR#',
			'#t_INFRASPECIFIC_RANK#'
		)
	</cfquery>
	<cfcatch>
		<!---<br>FAIL::#cfcatch.detail#--->
	</cfcatch>
	</cftry>
</cfloop>
<cfquery name="ff"  datasource="uam_god">
	update col_cat set gotit=1 where id in (#valuelist(d.id)#)
</cfquery>


</cfoutput>

</cfif>
---->