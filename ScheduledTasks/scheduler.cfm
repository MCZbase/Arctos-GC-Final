<!--- first, get rid of everything --->
<cfobject type="JAVA" action="Create" name="factory" class="coldfusion.server.ServiceFactory">
<cfset allTasks = factory.CronService.listAll()>  
<cfset numberOtasks = arraylen(allTasks)>
<cfloop index="i" from="1" to="#numberOtasks#">
	<cfschedule action="delete" task="#allTasks[i].task#">
</cfloop>
<!-----------------------------------   sitemaps    ------------------------------------------>
<cfschedule action = "update"
    task = "sitemap_map" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_sitemap.cfm?action=build_map"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "05:00 PM"
    interval = "weekly"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "sitemap_index" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_sitemap.cfm?action=build_index"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "05:10 PM"
    interval = "weekly"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "sitemap_spec" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_sitemap.cfm?action=build_sitemaps_spec"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "05:20 PM"
    interval = "3600"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "sitemap_tax" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_sitemap.cfm?action=build_sitemaps_tax"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "#timeformat(now())#"
    interval = "180"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "sitemap_pub" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_sitemap.cfm?action=build_sitemaps_pub"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "10:20 PM"
    interval = "3600"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "sitemap_proj" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_sitemap.cfm?action=build_sitemaps_proj"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "12:20 PM"
    interval = "3600"
    requestTimeOut = "600">
<!-----------------------------------   imaging    ------------------------------------------>
<cfschedule action = "update"
    task = "ALA_ProblemReport" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/alaImaging/ala_has_probs.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "06:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "TACC2list" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/TACC2list.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "06:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "TACC2list" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/TACC_0.5.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "06:30 AM"
    interval = "weekly"
    requestTimeOut = "600">	
<cfschedule action = "update"
    task = "TACC_1" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/TACC_1.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "04:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "TACC_1.5" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/TACC_1.5.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "04:30 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "TACC_2" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/TACC_1.5.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "05:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "TACC_3" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/TACC_1.5.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "05:20 AM"
    interval = "600"
    requestTimeOut = "600">
<!-----------------------------------   curatorial alerts    ------------------------------------------>
<cfschedule action = "update"
    task = "attention_needed" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/alaImaging/attention_needed.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "01:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "reminder" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/reminder.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "12:56 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "pendingRelations" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/pendingRelations.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "3:38 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "genbank_crawl_institution_wild2" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/genbank_crawl.cfm?action=institution_wild2"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "07:25 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "genbank_crawl_institution_wild1" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/genbank_crawl.cfm?action=institution_wild1"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "07:20 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "genbank_crawl_collection_wild2" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/genbank_crawl.cfm?action=collection_wild2"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "07:15 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "genbank_crawl_collection_wild1" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/genbank_crawl.cfm?action=collection_wild1"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "07:10 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "genbank_crawl_collection_voucher" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/genbank_crawl.cfm?action=collection_voucher"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "07:05 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "genbank_crawl_institution_voucher" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/genbank_crawl.cfm?action=institution_voucher"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "07:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<!-----------------------------------   sharing data    ------------------------------------------>
<cfschedule action = "update"
    task = "GenBank_build" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/GenBank_build.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "10:00 PM"
    interval = "daily"
    requestTimeOut = "600">	
<cfschedule action = "update"
    task = "GenBank_transfer_name" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/GenBank_transfer_name.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "10:30 PM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "GenBank_transfer_nuc" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/GenBank_transfer_nuc.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "10:35 PM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "GenBank_transfer_tax" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/GenBank_transfer_tax.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "10:40 PM"
    interval = "daily"
    requestTimeOut = "600">
<!-----------------------------------   maintenance    ------------------------------------------>
<cfschedule action = "update"
    task = "CleanTempFiles" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/CleanTempFiles.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "12:00 AM"
    interval = "daily"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "build_home" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/build_home.cfm"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "12:56 AM"
    interval = "daily"
    requestTimeOut = "600">
<!-----------------------------------   images    ------------------------------------------>
<cfschedule action = "update"
    task = "image_CheckNew" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/localToTacc.cfm?action=checkNew"
    startDate = "1-jan-2008"
    startTime = "12:30 AM"
    interval = "weekly"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "image_transfer" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/localToTacc.cfm?action=transfer"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "#timeformat(now())#"
    interval = "300"
    requestTimeOut = "300">
<cfschedule action = "update"
    task = "image_findIt" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/localToTacc.cfm?action=findIt"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "12:00 AM"
    interval = "28800"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "image_fixURI" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/localToTacc.cfm?action=fixURI"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "01:00 AM"
    interval = "28800"
    requestTimeOut = "600">
<cfschedule action = "update"
    task = "image_report" 
    operation = "HTTPRequest"
    url = "127.0.0.1/ScheduledTasks/localToTacc.cfm?action=report"
    startDate = "#dateformat(now(),'dd-mmm-yyyy')#"
    startTime = "02:34 AM"
    interval = "weekly"
    requestTimeOut = "600">