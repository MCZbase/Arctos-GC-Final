<cfinclude template="/includes/_header.cfm">
<!---
create table cf_dup_agent (
	cf_dup_agent_id number not null,
	AGENT_ID number not null,
	RELATED_AGENT_ID number not null,
	agent_pref_name varchar2(255) not null,
	rel_agent_pref_name varchar2(255) not null,
	detected_date timestamp not null,
	last_date timestamp,
	status varchar2(255)
);

ALTER TABLE cf_dup_agent MODIFY resolved_date NULL;
ALTER TABLE cf_dup_agent rename column resolved_date to last_date;


CREATE OR REPLACE TRIGGER tr_cf_dup_agent_key
BEFORE INSERT ON cf_dup_agent
FOR EACH ROW
BEGIN
        IF :new.cf_dup_agent_id IS NULL THEN
        	SELECT somerandomsequence.nextval
    		INTO :new.cf_dup_agent_id
    		FROM dual;
        END IF;
END;
/


--->

<!------------------------------------------------------------------------>
<cfif action is "merge">
	<cfoutput>
		<cfquery name="findDups" datasource="uam_god">
			select 
				cf_dup_agent.cf_dup_agent_id,
				agent_relations.AGENT_ID,
				agent_relations.RELATED_AGENT_ID,
				cf_dup_agent.agent_pref_name,
				cf_dup_agent.rel_agent_pref_name,
				detected_date,
				round(detected_date - sysdate)
			from
				agent_relations,
				cf_dup_agent
			where
				AGENT_RELATIONSHIP='bad duplicate of' and 
				agent_relations.AGENT_ID=cf_dup_agent.AGENT_ID and
				agent_relations.RELATED_AGENT_ID=cf_dup_agent.RELATED_AGENT_ID and
				status='email_sent'
		</cfquery>
		<cfdump var=#findDups#>
	</cfoutput>
</cfif>
<!------------------------------------------------------------------------>
<cfif action is "findDups">
	<cfquery name="findDups" datasource="uam_god">
		select 
			agent_relations.AGENT_ID,
			agent_relations.RELATED_AGENT_ID
		from
			agent_relations,
			cf_dup_agent
		where
			AGENT_RELATIONSHIP='bad duplicate of' and 
			agent_relations.AGENT_ID=cf_dup_agent.AGENT_ID (+) and
			 agent_relations.RELATED_AGENT_ID=cf_dup_agent.RELATED_AGENT_ID (+) and
			cf_dup_agent.AGENT_ID is null and
			cf_dup_agent.RELATED_AGENT_ID is null	
	</cfquery>
	<cfloop query="findDups">
		<cfquery name="findedDups" datasource="uam_god">
			insert into cf_dup_agent (
				AGENT_ID,
				RELATED_AGENT_ID,
				agent_pref_name,
				rel_agent_pref_name,
				detected_date,
				status
			) values (
				#AGENT_ID#,
				#RELATED_AGENT_ID#,
				(select agent_name from preferred_agent_name where agent_id=#AGENT_ID#),
				(select agent_name from preferred_agent_name where agent_id=#RELATED_AGENT_ID#),
				systimestamp,
				'new'
			)
		</cfquery>
	</cfloop>
</cfif>
<!------------------------------------------------------------------------>
<cfif action is "notify">
	<cfoutput>
		<cfquery name="findDups" datasource="uam_god">
			select 
				cf_dup_agent.cf_dup_agent_id,
				agent_relations.AGENT_ID,
				agent_relations.RELATED_AGENT_ID,
				cf_dup_agent.agent_pref_name,
				cf_dup_agent.rel_agent_pref_name,
				detected_date
			from
				agent_relations,
				cf_dup_agent
			where
				AGENT_RELATIONSHIP='bad duplicate of' and 
				agent_relations.AGENT_ID=cf_dup_agent.AGENT_ID and
				 agent_relations.RELATED_AGENT_ID=cf_dup_agent.RELATED_AGENT_ID and
				 status='new'
		</cfquery>
		<cfloop query="findDups">
			<cfset theseAgents="#findDups.AGENT_ID#,#findDups.RELATED_AGENT_ID#">
			<cfquery name="colns" datasource="uam_god">
				select 
					agent_name,
					ADDRESS
				from
					collection_contacts,
					electronic_address,
					preferred_agent_name
				where
					collection_contacts.CONTACT_AGENT_ID=preferred_agent_name.agent_id and
					collection_contacts.CONTACT_AGENT_ID=electronic_address.agent_id and
					electronic_address.address_type='e-mail' and
					collection_contacts.collection_id in  (
				select 
					collection_id 
				from 
					cataloged_item,
					citation,
					publication_agent
				where
					cataloged_item.collection_object_id=citation.collection_object_id and
					citation.publication_id=publication_agent.publication_id and
					publication_agent.agent_id in (#theseAgents#)
				union
				select 
					cataloged_item.collection_id
				from 
					collector,
					cataloged_item
				where 
					collector.collection_object_id = cataloged_item.collection_object_id AND
					agent_id in (#theseAgents#)
				union
				select 
					collection_id
				from 
					coll_object,
					cataloged_item
				where 
					coll_object.collection_object_id = cataloged_item.collection_object_id and
					ENTERED_PERSON_ID in (#theseAgents#)
				union
				select 
					collection_id
				from 
					coll_object,
					cataloged_item
				where 
					coll_object.collection_object_id = cataloged_item.collection_object_id and
					LAST_EDITED_PERSON_ID in (#theseAgents#)
				union
					select 
						collection_id
					from
						attributes,
						cataloged_item
					where
						cataloged_item.collection_object_id=attributes.collection_object_id and
						determined_by_agent_id in (#theseAgents#)
				union
					select 
							collection_id
						 from 
						 	encumbrance,
						 	coll_object_encumbrance,
						 	cataloged_item
						 where
						 	encumbrance.encumbrance_id = coll_object_encumbrance.encumbrance_id and
						 	coll_object_encumbrance.collection_object_id=cataloged_item.collection_object_id and
						 	encumbering_agent_id in (#theseAgents#)
				union
					select 
						collection_id
					from 
			        	identification,
			        	identification_agent,
						cataloged_item
			        where 
						cataloged_item.collection_object_id=identification.collection_object_id and
						identification.identification_id=identification_agent.identification_id and
			        	identification_agent.agent_id in (#theseAgents#)
				union
					select 
						collection_id
					from 
						cataloged_item,
						collecting_event,
						lat_long 
					where 
						cataloged_item.collecting_event_id=collecting_event.collecting_event_id and
						collecting_event.locality_id=lat_long.locality_id and
						determined_by_agent_id in (#theseAgents#)
				union
					select 
							collection_id
						from
							shipment,
							loan,
							trans
						where
							shipment.transaction_id=loan.transaction_id and
							loan.transaction_id =trans.transaction_id and
							PACKED_BY_AGENT_ID in (#theseAgents#)
				union
					select 
										collection_id
						from
							shipment,
							addr,
							loan,
							trans
						where
							shipment.transaction_id=loan.transaction_id and
							loan.transaction_id =trans.transaction_id and
							shipment.SHIPPED_TO_ADDR_ID=addr.addr_id and
							addr.agent_id in (#theseAgents#)
				union
						select 							collection_id
						from
							shipment,
							addr,
							loan,
							trans
						where
							shipment.transaction_id=loan.transaction_id and
							loan.transaction_id =trans.transaction_id and
							shipment.SHIPPED_FROM_ADDR_ID=addr.addr_id and
							addr.agent_id in (#theseAgents#)
				union
						select 
							collection_id
						from
							trans_agent,
							loan,
							trans
						where
							trans_agent.transaction_id=loan.transaction_id and
							loan.transaction_id=trans.transaction_id and
							AGENT_ID in (#theseAgents#)
				union
						select 
							collection_id
						from
							trans_agent,
							accn,
							trans
						where
							trans_agent.transaction_id=accn.transaction_id and
							accn.transaction_id=trans.transaction_id and
							AGENT_ID in (#theseAgents#)
				union
						select 
							collection_id
						from
							trans,
							loan,
							loan_item
						where
							trans.transaction_id=loan.transaction_id and
							loan.transaction_id=loan_item.transaction_id and
							RECONCILED_BY_PERSON_ID in (#theseAgents#)
							)
			</cfquery>
				
			<br>to: #Application.DataProblemReportEmail#,#valuelist(colns.address)#
			<br>Subject: Agents marked for merge
			
			<br>The following agents are scheduled for merger on #dateformat(dateadd("d",7,detected_date),"yyyy-mm-dd")#.
			
			<br>To allow this, do nothing.
			
			<br>To stop this merger, remove the "bad duplicate of" relationship.
			
			<br>You are receiving this notification because one of more of the agents may have activities pertaining to
			your collections. See Agent Activity for complete information.
			<br>Log in to Arctos before clicking the links below.
			
			<br>
			
			<a href="/Admin/ActivityLog.cfm?action=search&sql=#findDups.AGENT_ID#&object=agent_relations">search audit logs for whodunit</a>
			
			<br>Good Agent: <a href="/agents.cfm?agent_id=#findDups.RELATED_AGENT_ID#">#findDups.rel_agent_pref_name#</a>
			<br>Duplicate Agent: <a href="/agents.cfm?agent_id=#findDups.AGENT_ID#">#findDups.agent_pref_name#</a>
			<br>Marked As Dup On: #dateformat(detected_date,"yyyy-mm-dd")#
			<cfquery name="sentEmail" datasource="uam_god">
				update 
					cf_dup_agent
				set 
					status='email_sent',
					last_date=systimestamp 
				where
					cf_dup_agent_id=#cf_dup_agent_id#
			</cfquery>
		</cfloop>
	</cfoutput>
</cfif>

<cfinclude template="/includes/_footer.cfm">