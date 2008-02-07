uam> 
uam>   SELECT DBMS_METADATA.GET_DDL('TRIGGER',trigger_name) FROM user_triggers where trigger_name like '%FLAT%';

  CREATE OR REPLACE PROCEDURE update_flat (collobjid IN number)
 IS BEGIN
     update flat set (
         began_date,
         ended_date,
         verbatim_date ,
         higher_geog ,
         continent_ocean ,
         country ,
         state_prov ,
         county ,
         feature ,
         island ,
         island_group ,
         spec_locality ,
         dec_lat ,
         dec_long  ,
         datum ,
         orig_lat_long_units ,
         VERBATIMLATITUDE,
         VERBATIMLONGITUDE,
        lat_long_ref_source ,
        COORDINATEUNCERTAINTYINMETERS,
         lat_long_remarks ,
         min_elev_in_m,
         max_elev_in_m ,
         collecting_event_id,
         locality_id,
         geog_auth_rec_id
         ) =  (select
             began_date,
             ended_date,
             verbatim_date ,
             higher_geog ,
             continent_ocean ,
             country ,
             state_prov ,
             county ,
             feature ,
             island ,
             island_group ,
             spec_locality ,
             dec_lat,
             dec_long,
             datum ,
             orig_lat_long_units ,
             decode(orig_lat_long_units,
                    'decimal degrees',to_char(dec_lat) || 'd',
                    'deg. min. sec.', to_char(lat_deg) || 'd ' || to_char(lat_min) || 'm ' || to_char(lat_sec) || 's ' || lat_dir,
                    'degrees dec. minutes', to_char(lat_deg) || 'd ' || to_char(dec_lat_min) || 'm ' || lat_dir
                ),
             decode(orig_lat_long_units,
                'decimal degrees',to_char(dec_long) || 'd',
                'deg. min. sec.', to_char(long_deg) || 'd ' || to_char(long_min) || 'm ' || to_char(long_sec) || 's ' || long_dir,
                'degrees dec. minutes', to_char(long_deg) || 'd ' || to_char(dec_long_min) || 'm ' || long_dir
                ),
            lat_long_ref_source ,
            decode(max_error_units,
                'm',max_error_distance,
                'ft',max_error_distance * .3048,
                'km',max_error_distance * 1000,
                'mi',max_error_distance * 1609.344,
                'yd',max_error_distance * .9144),
             lat_long_remarks ,
            decode(orig_elev_units,
                'm',minimum_elevation,
                'ft',minimum_elevation * .3048),
            decode(orig_elev_units,
                'm',maximum_elevation,
                'ft',maximum_elevation * .3048),               
         collecting_event.collecting_event_id,
         locality.locality_id,
         geog_auth_rec.geog_auth_rec_id
     FROM
         collecting_event,
         locality,
         geog_auth_rec,
         accepted_lat_long
     WHERE
         collecting_event.locality_id = locality.locality_id and
         locality.geog_auth_rec_id = geog_auth_rec.geog_auth_rec_id and
         locality.locality_id = accepted_lat_long.locality_id (+) and
         collecting_event.collecting_event_id = flat.collecting_event_id)
     WHERE
         collection_object_id = collobjid;
        
 UPDATE flat SET (
           last_edit_date,
           COLLECTORS,
           field_num,
         scientific_name ,
         identification_id,
         IDENTIFIEDBY,
         made_date,
         TYPESTATUS,
         sex,
         parts,
         OTHERCATALOGNUMBERS,
         RELATEDCATALOGEDITEMS,
         INDIVIDUALCOUNT,
         REMARKS,
         GENBANKNUM
     ) = (
     SELECT        
         last_edit_date,
         concatColls('collection_object_id', coll_object.collection_object_id, 'agent_name','coll_names'),
         ConcatSingleOtherId(coll_object.collection_object_id,'Field Num'),        
        identification.scientific_name ,
        identification.identification_id ,
        idby.agent_name,
         identification.made_date,
         concattypestatus(coll_object.collection_object_id),
         ConcatAttributeValue(coll_object.collection_object_id,'sex'),
         concatparts(coll_object.collection_object_id),
         concatotherid(coll_object.collection_object_id),
         concatrelations(coll_object.collection_object_id),
         lot_count,
         coll_object_remarks,
         concatgenbank(coll_object.collection_object_id)
     from
         coll_object,
         collectornumber,
         identification,
         taxonomy,
         identification_taxonomy,
         preferred_agent_name idby,
         coll_object_remark,
         encumbrance,
         coll_object_encumbrance
     where
         coll_object.collection_object_id = collectornumber.collection_object_id (+) and
         coll_object.collection_object_id = identification.collection_object_id and
         identification.identification_id = identification_taxonomy.identification_id and
         identification_taxonomy.taxon_name_id = taxonomy.taxon_name_id and
         identification.id_made_by_agent_id = idby.agent_id (+) and
         identification.accepted_id_fg=1 AND
         coll_object.collection_object_id = coll_object_remark.collection_object_id (+) AND
         coll_object.collection_object_id = coll_object_encumbrance.collection_object_id (+) AND
         coll_object_encumbrance.encumbrance_id = encumbrance.encumbrance_id (+) AND
         coll_object.collection_object_id = collobjid   
     )
     where collection_object_id = collobjid;
    
     update flat set (collection_cde,institution_acronym) =
     (select collection_cde,institution_acronym
     from collection where
     collection_id = flat.collection_id)
     where
     collection_object_id = collobjid
     ;
    
     update flat set (accession) =
     (select institution_acronym || ' ' || accn_number
     from accn,trans where
     accn.transaction_id = trans.transaction_id
     and trans.transaction_id = flat.ACCN_ID)
     where
     collection_object_id = collobjid
     ;
    
 END;
/
show err
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_ACCN                                                     
AFTER insert or update ON accn                                                                      
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.transaction_id;                             
end;                                                                                                
/
sho err
/*
	-- to update accn:
	update flat set accession = (select accn_number
	from accn where flat.accn_id = accn.transaction_id)
	;
	
*/                                                                                                    
      
CREATE OR REPLACE PROCEDURE update_flat_locid (locid IN number)
 IS
 BEGIN
   UPDATE flat SET (
   			spec_locality,
			min_elev_in_m,
			max_elev_in_m,
			DEC_LAT,
			DEC_LONG,
			DATUM,
			ORIG_LAT_LONG_UNITS,
			VERBATIMLATITUDE,
			VERBATIMLONGITUDE,
			LAT_LONG_REF_SOURCE,
			COORDINATEUNCERTAINTYINMETERS,
			GEOREFMETHOD,
			LAT_LONG_REMARKS
			)
		=
		( select		
			spec_locality,
			decode(orig_elev_units,
				'm',minimum_elevation,
				'ft',minimum_elevation  * .3048) ,
			decode(orig_elev_units,
				'm',maximum_elevation,
				'ft',maximum_elevation  * .3048),
			dec_lat,
			dec_long,
			datum,
			ORIG_LAT_LONG_UNITS,
			decode(orig_lat_long_units,
		'decimal degrees',to_char(dec_lat) || 'd',
		'deg. min. sec.', to_char(lat_deg) || 'd ' || to_char(lat_min) || 'm ' || to_char(lat_sec) || 's ' || lat_dir,
		'degrees dec. minutes', to_char(lat_deg) || 'd ' || to_char(dec_lat_min) || 'm ' || lat_dir
	),
		decode(orig_lat_long_units,
		'decimal degrees',to_char(dec_long) || 'd',
		'deg. min. sec.', to_char(long_deg) || 'd ' || to_char(long_min) || 'm ' || to_char(long_sec) || 's ' || long_dir,
		'degrees dec. minutes', to_char(long_deg) || 'd ' || to_char(dec_long_min) || 'm ' || long_dir
	),
	LAT_LONG_REF_SOURCE,
	decode(max_error_units,
		'm',max_error_distance,
		'ft',max_error_distance * .3048,
		'km',max_error_distance * 1000,
		'mi',max_error_distance * 1609.344,
		'yd',max_error_distance * .9144),
		GEOREFMETHOD,
			LAT_LONG_REMARKS
			FROM
				locality,
				accepted_lat_long
			WHERE
				locality.locality_id = accepted_lat_long.locality_id(+) AND
				locality.locality_id = locid)
			WHERE
				locality_id = locid
			;
end;
/
      
              
                                                                              
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_COLLECTOR                                               
after insert or update or delete ON collector                                                       
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET COLLECTORS =                                                            
            concatcoll(collection_object_id)                                                        
	 		where collection_object_id = state_pkg.newRows(i)                                               
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_COLLECTOR after delete ON collector                     
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.collection_object_id;                                                                                             
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_COLLECTOR                                                
AFTER insert or update ON collector                                                                 
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_COLLECTOR                                                
BEFORE insert or update or delete ON collector                                                      
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_RELN                                                    
 after insert or update or delete ON BIOL_INDIV_RELATIONS                                           
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET RELATEDCATALOGEDITEMS                                                   
            = concatrelations(collection_object_id)                                                 
            where collection_object_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_RELN                                                    
 after delete ON BIOL_INDIV_RELATIONS                                                               
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.collection_object_id;                                                                                             
    	end;                                                                                           
/
sho err
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_RELN                                                     
AFTER insert or update ON BIOL_INDIV_RELATIONS                                                      
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_RELN                                                     
BEFORE insert or update or delete ON BIOL_INDIV_RELATIONS                                           
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_PART                                                    
 after insert or update or delete ON specimen_part                                                  
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET parts                                                                   
            = concatparts(collection_object_id)                                                     
            where collection_object_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_PART                                                    
 after delete ON specimen_part                                                                      
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.derived_from_cat_item;                                                                                            
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_PART                                                     
AFTER insert or update ON specimen_part                                                             
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.derived_from_cat_item;                      
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_PART                                                     
BEFORE insert or update or delete ON specimen_part                                                  
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_COLLOBJ                                                 
 after insert or update  ON coll_object                                                             
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET                                                                         
            	(last_edit_date,                                                                       
            	INDIVIDUALCOUNT,                                                                       
 				COLL_OBJ_DISPOSITION)                                                                          
            	 = (select                                                                             
            	 	LAST_EDIT_DATE,                                                                      
            	 	lot_count,                                                                           
            	 	COLL_OBJ_DISPOSITION                                                                 
            	 from coll_object                                                                      
            	 where collection_object_id = state_pkg.newRows(i))                                    
            where collection_object_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_COLLOBJ                                                  
AFTER insert or update ON coll_object                                                               
FOR EACH ROW                                                                                        
 WHEN (new.COLL_OBJECT_TYPE = 'CI') BEGIN                                                           
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_COLLOBJ                                                  
BEFORE insert or update or delete ON coll_object                                                    
FOR EACH ROW                                                                                        
 WHEN (new.COLL_OBJECT_TYPE = 'CI') BEGIN                                                           
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_ACCN                                                     
BEFORE update ON accn                                                                               
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_COLLEVNT                                                
 after update  ON collecting_event                                                                  
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
        	UPDATE flat SET (                                                                          
        	 LOCALITY_ID,                                                                              
        	 BEGAN_DATE,                                                                               
        	 ENDED_DATE,                                                                               
        	 VERBATIM_DATE) =                                                                          
        	 ( select                                                                                  
        	 	LOCALITY_ID,                                                                             
        		 BEGAN_DATE,                                                                              
        		 ENDED_DATE,                                                                              
        	 	VERBATIM_DATE                                                                            
        	 FROM collecting_event                                                                     
        	 WHERE collecting_event_id = state_pkg.newRows(i))                                         
            where collecting_event_id = state_pkg.newRows(i)                                        
            ;                                                                                       
            for r in (select locality_id from flat where collecting_event_id = state_pkg.newRows(i)                                                                                 
     		group by locality_id) loop                                                                   
     			update_flat_locid(r.locality_id);                                                           
     		end loop;                                                                                    
     	end loop;                                                                                     
                                                                                                    
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                         
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_ACCN                                                    
 after insert or update  ON accn                                                                    
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET                                                                         
            	(accession)                                                                            
            	 = (select                                                                             
            	 	trans.INSTITUTION_ACRONYM || ' ' || accn_number                                                                                 
            	 from trans,accn                                                                       
            	 where trans.transaction_id = accn.transaction_id AND                                  
            	 accn.transaction_id = state_pkg.newRows(i))                                           
            where accn_id = state_pkg.newRows(i)                                                    
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_COLLEVNT                                                 
AFTER update ON collecting_event                                                                    
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	update flat set locality_id = :new.locality_id where collecting_event_id = :old.collecting_event_id;                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collecting_event_id;                        
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_COLLEVNT                                                 
BEFORE update ON collecting_event                                                                   
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_SEX after insert or update or delete                    
 ON attributes                                                                                      
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
    	UPDATE flat SET sex = ConcatAttributeValue(collection_object_id,'sex')                         
            where collection_object_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_SEX after delete ON attributes                          
	for each row                                                                                       
	 WHEN (old.attribute_type='sex') begin                                                             
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.collection_object_id;                                                                                             
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_SEX                                                      
AFTER insert or update ON attributes                                                                
FOR EACH ROW                                                                                        
 WHEN (new.attribute_type='sex') BEGIN                                                              
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_SEX                                                      
BEFORE insert or update or delete ON attributes                                                     
FOR EACH ROW                                                                                        
 WHEN (new.attribute_type='sex') BEGIN                                                              
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER TI_FLAT_CATITEM AFTER insert ON cataloged_it                    
em                                                                                                  
FOR EACH ROW                                                                                        
BEGIN                                                                                               
INSERT INTO flat (                                                                                  
	collection_object_id,                                                                              
	cat_num,                                                                                           
	accn_id,                                                                                           
	COLLECTING_EVENT_ID,                                                                               
	COLLECTION_ID                                                                                      
	) values (                                                                                         
	:new.collection_object_id,                                                                         
	:new.cat_num,                                                                                      
	:new.accn_id,                                                                                      
	:new.collecting_event_id,                                                                          
	:new.collection_id                                                                                 
);                                                                                                  
update_flat(:new.collection_object_id);                                                             
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_CATITEM                                                 
after update ON cataloged_item                                                                      
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            update_flat(state_pkg.newRows(i));                                                      
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_CATITEM                                                 
after delete ON cataloged_item                                                                      
	for each row                                                                                       
   		begin                                                                                          
           DELETE FROM flat WHERE collection_object_id=:old.collection_object_id                    
;                                                                                                   
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_CATITEM                                                  
AFTER update ON cataloged_item                                                                      
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	update flat set                                                                                    
		collecting_event_id = :new.collecting_event_id,                                                   
		collection_id = :new.collection_id,                                                               
		cat_num = :new.cat_num,                                                                           
		accn_id = :new.accn_id,                                                                           
		collection_cde = :new.collection_cde                                                              
  where                                                                                             
	collection_object_id = :old.collection_object_id                                                   
	;                                                                                                  
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_CATITEM                                                  
BEFORE update ON cataloged_item                                                                     
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_GEOG                                                    
 after update on geog_auth_rec                                                                      
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
        	UPDATE flat SET (                                                                          
        		higher_geog,                                                                              
        		continent_ocean ,                                                                         
        		country ,                                                                                 
        		state_prov ,                                                                              
        		county ,                                                                                  
        		feature ,                                                                                 
        		island ,                                                                                  
        		island_group,                                                                             
        		quad,                                                                                     
        		sea)                                                                                      
        	= (select                                                                                  
        		higher_geog,                                                                              
        		continent_ocean,                                                                          
        		country,                                                                                  
        		state_prov,                                                                               
        		county,                                                                                   
        		feature,                                                                                  
        		island,                                                                                   
        		island_group,                                                                             
        		quad,                                                                                     
        		sea                                                                                       
        		FROM                                                                                      
        		geog_auth_rec                                                                             
        		WHERE geog_auth_rec_id = state_pkg.newRows(i))                                            
        	WHERE geog_auth_rec_id = state_pkg.newRows(i);                                             
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_GEOG                                                     
AFTER update ON geog_auth_rec                                                                       
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.geog_auth_rec_id;                           
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_GEOG                                                     
BEFORE update ON geog_auth_rec                                                                      
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_LAT_LONG                                                
 after insert or update or delete on LAT_LONG                                                       
 begin                                                                                              
   	for i in 1 .. state_pkg.newRows.count loop                                                      
		update flat SET                                                                                   
			(dec_lat,                                                                                        
			dec_long,                                                                                        
			datum,                                                                                           
			orig_lat_long_units,                                                                             
			VERBATIMLATITUDE,                                                                                
			VERBATIMLONGITUDE,                                                                               
			GEOREFMETHOD,                                                                                    
			COORDINATEUNCERTAINTYINMETERS,                                                                   
			lat_long_remarks,                                                                                
			lat_long_determiner)                                                                             
			= (select                                                                                        
				dec_lat,                                                                                        
				dec_long,                                                                                       
				datum,                                                                                          
				orig_lat_long_units,                                                                            
				decode(orig_lat_long_units,                                                                     
					'decimal degrees',to_char(dec_lat) || 'd',                                                     
					'deg. min. sec.', to_char(lat_deg) || 'd ' || to_char(lat_min) || 'm ' || to_char(lat_sec) || 's ' || lat_dir,                                                                 
					'degrees dec. minutes', to_char(lat_deg) || 'd ' || to_char(dec_lat_min) ||                    
 'm ' || lat_dir                                                                                    
					),                                                                                             
				decode(orig_lat_long_units,                                                                     
			 		'decimal degrees',to_char(dec_long) || 'd',                                                   
					'deg. min. sec.', to_char(long_deg) || 'd ' || to_char(long_min) || 'm ' ||                    
 to_char(long_sec) || 's ' || long_dir,                                                             
					'degrees dec. minutes', to_char(long_deg) || 'd ' || to_char(dec_long_min)                     
|| 'm ' || long_dir                                                                                 
					),                                                                                             
				GEOREFMETHOD,                                                                                   
				decode(max_error_units,                                                                         
					'm',max_error_distance,                                                                        
					'ft',max_error_distance * .3048,                                                                
					'km',max_error_distance * 1000,                                                                
					'mi',max_error_distance * 1609.344,                                                              
					'yd',max_error_distance * .9144) ,                                                             
  				lat_long_remarks,                                                                             
  				agent_name                                                                                    
 				FROM                                                                                           
 				lat_long,                                                                                      
 				preferred_agent_name                                                                           
 				WHERE                                                                                          
 				accepted_lat_long_fg=1 AND                                                                     
 				lat_long.DETERMINED_BY_AGENT_ID = preferred_agent_name.agent_id AND                            
 				locality_id = state_pkg.newRows(i))                                                            
 			WHERE locality_id = state_pkg.newRows(i)                                                        
 			;                                                                                               
   	end loop;                                                                                       
 end;                                                                                               
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_LAT_LONG                                                
AFTER DELETE ON LAT_LONG                                                                            
FOR EACH ROW                                                                                        
 WHEN (old.accepted_lat_long_fg = 1) BEGIN                                                          
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.locality_id;                                
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_LAT_LONG                                                 
AFTER update or INSERT ON LAT_LONG                                                                  
FOR EACH ROW                                                                                        
 WHEN (new.accepted_lat_long_fg = 1) BEGIN                                                          
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.locality_id;                                
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_LAT_LONG                                                 
BEFORE update or INSERT or DELETE ON LAT_LONG                                                       
FOR EACH ROW                                                                                        
 WHEN (new.accepted_lat_long_fg = 1) BEGIN                                                          
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_LOCALITY                                                
 after update on locality                                                                           
 begin                                                                                              
   	for i in 1 .. state_pkg.newRows.count loop                                                      
		update_flat_locid(state_pkg.newRows(i))	;                                                         
		update_flat_geoglocid(state_pkg.newRows(i))	;                                                     
   	end loop;                                                                                       
 end;                                                                                               
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_LOCALITY                                                 
AFTER update ON locality                                                                            
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.locality_id;                                
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_LOCALITY                                                 
BEFORE update ON locality                                                                           
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_AGENTNAME                                               
 after insert or update or delete ON agent_name                                                     
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET COLLECTORS                                                              
            = concatcoll(collection_object_id)                                                      
            where collection_object_id IN                                                           
            	( select collection_object_id FROM                                                     
            	collector where agent_id = state_pkg.newRows(i)                                        
            	)                                                                                      
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_AGENTNAME                                               
 after delete ON agent_name                                                                         
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.agent_id;                         
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_AGENTNAME                                                
AFTER insert or update ON agent_name                                                                
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.agent_id;                                   
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_AGENTNAME                                                
BEFORE insert or update or delete ON agent_name                                                     
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_OTHERIDS after insert or update or delete ON coll_obj_other_id_num                                                                      
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET                                                                         
            GENBANKNUM = concatgenbank(collection_object_id),                                       
            OTHERCATALOGNUMBERS = concatotherid(collection_object_id),                              
            field_num = ConcatSingleOtherId(collection_object_id,'Field Num')                       
            where collection_object_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_OTHERIDS after delete ON coll_obj_other_id_num                                                                                          
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.collection_object_id;                                                                                             
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_OTHERIDS                                                 
AFTER insert or update ON coll_obj_other_id_num                                                     
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_OTHERIDS                                                 
BEFORE insert or update or delete ON coll_obj_other_id_num                                          
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_CITATION                                                
 after insert or update or delete ON citation                                                       
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET                                                                         
            TYPESTATUS =concattypestatus(collection_object_id)                                      
            where collection_object_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_CITATION                                                
 after delete ON citation                                                                           
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.collection_object_id;                                                                                             
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_CITATION                                                 
AFTER insert or update ON citation                                                                  
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_CITATION                                                 
BEFORE insert or update or delete ON CITATION                                                       
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                       
 drop trigger B_FLAT_ID;
 drop trigger A_FLAT_ID;
 /* 
 replaced by UP_FLAT_ID
 CREATE OR REPLACE TRIGGER B_FLAT_ID                                                       
BEFORE insert or update ON identification                                                           
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
CREATE OR REPLACE TRIGGER A_FLAT_ID                                                      
AFTER insert or update ON identification                                                           
FOR EACH ROW                                                                                       
 BEGIN                                                               
     UPDATE flat SET                                                                       
        scientific_name = :NEW.scientific_name,                                                                               
        IDENTIFIEDBY = CONCATIDRBYIDID(:NEW.identification_id),                                                                                 
        made_date = :NEW.made_date,
        identification_id = :NEW.identification_id
    WHERE
        collection_object_id = :NEW.collection_object_id
    ;     
end;                                                                                               
/
*/                                                                                                 
CREATE OR REPLACE TRIGGER UP_FLAT_ID                                                      
 after insert OR update ON identification  
 for each row                                                         
    begin                                                                                           
            UPDATE flat SET                                                                        
				scientific_name = :NEW.scientific_name,                                                                             
				made_date = :NEW.made_date
			WHERE collection_object_id = :NEW.collection_object_id;                 
    end;                                                                                            
/
 CREATE OR REPLACE TRIGGER B_FLAT_agnt_ID                                                       
BEFORE insert or update ON identification_agent                                                           
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
CREATE OR REPLACE TRIGGER a_FLAT_AGNT_ID                                                 
AFTER insert or update ON identification_agent                                                                  
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.identification_id;                       
end;                                                                                                
/
sho err
    
  CREATE OR REPLACE TRIGGER UP_FLAT_AGNT_ID
 after insert or update or delete ON identification_agent                                                       
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET                                                                         
            IDENTIFIEDBY = CONCATIDRBYIDID(state_pkg.newRows(i))                           
            where identification_id = state_pkg.newRows(i)                                       
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
      
      
      
      
      
      
                                                                                               
                                                                                                    
  CREATE OR REPLACE TRIGGER UP_FLAT_REMARK                                                  
 after insert or update or delete ON coll_object_remark                                             
    begin                                                                                           
    	for i in 1 .. state_pkg.newRows.count loop                                                     
            UPDATE flat SET                                                                         
            	(REMARKS,                                                                              
            	habitat,                                                                               
            	associated_species)                                                                    
            	= (select                                                                              
            		COLL_OBJECT_REMARKS,                                                                  
            		habitat,                                                                              
            		associated_species                                                                    
            	from coll_object_remark                                                                
           		where collection_object_id = state_pkg.newRows(i))                                     
           where collection_object_id = state_pkg.newRows(i)                                        
            ;                                                                                       
     	end loop;                                                                                     
    end;                                                                                            
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER B_FLAT_REMARK                                                   
BEFORE insert or update or delete ON coll_object_remark                                             
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows := state_pkg.empty;                                                              
end;                                                                                                
/
sho err
                                                                                                    
                                                                                                    
                                                                                                    
  CREATE OR REPLACE TRIGGER AD_FLAT_REMARK                                                  
 after delete ON coll_object_remark                                                                 
	for each row                                                                                       
   		begin                                                                                          
           state_pkg.newRows( state_pkg.newRows.count+1 ) := :old.collection_object_id;                                                                                             
    	end;                                                                                           
/
sho err
                                                                                                    
                                                                                                    
                                         
                                         
                                         
                                                                                                    
  CREATE OR REPLACE TRIGGER A_FLAT_REMARK                                                   
AFTER insert or update ON coll_object_remark                                                        
FOR EACH ROW                                                                                        
BEGIN                                                                                               
	state_pkg.newRows( state_pkg.newRows.count+1 ) := :new.collection_object_id;                       
end;                                                                                                
/
sho err
