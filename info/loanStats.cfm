<cfinclude template="/includes/_header.cfm">
<script src="/includes/sorttable.js"></script>
<cfset title="Loan and Citation statistics">
<cfparam name="loanto" default="">
<cfparam name="loantype" default="">
<cfparam name="loanstatus" default="">
<cfparam name="collectionid" default="">
<cfparam name="citations" default="">

<cfquery name="ctLoanStatus" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select loan_status from ctloan_status order by loan_status
</cfquery>

<cfquery name="ctcollection" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select * from collection order by collection
</cfquery>
<cfquery name="ctLoanType" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select loan_type from ctloan_type order by loan_type
</cfquery>
<cfquery name="ctStatus" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#" cachedwithin="#createtimespan(0,0,60,0)#">
	select loan_status from ctloan_status order by loan_status
</cfquery>


<cfoutput>
<form name="f" method="get" action="loanStats.cfm">
	<label for="collectionid">Collection
						</label>
						<select name="collectionid" size="1" id="collectionid">
			<option value=""></option>
							<cfloop query="ctcollection">
								<option <cfif collectionid is ctcollection.collection_id> selected="selected" </cfif> value="#ctcollection.collection_id#">#ctcollection.collection#</option>
							</cfloop>
						</select>
						
	<label for="loanto">Loaned To Person</label>
	<input type="text" name="loanto" id="loanto" value="#loanto#">
	
		<label for="loantype">Loan Type</label>
		<select name="loantype" id="loantype" class="reqdClr">
			<option value=""></option>
			<cfloop query="ctLoanType">
				<option <cfif loantype is ctLoanType.loan_type> selected="selected" </cfif>value="#ctLoanType.loan_type#">#ctLoanType.loan_type#</option>
			</cfloop>
		</select>
		<label for="loanstatus">Loan Status</label>
		<select name="loanstatus" id="loanstatus" class="reqdClr">
			<option value=""></option>
			<cfloop query="ctLoanStatus">
				<option  <cfif loanstatus is ctLoanStatus.loan_status> selected="selected" </cfif> value="#ctLoanStatus.loan_status#">#ctLoanStatus.loan_status#</option>
			</cfloop>
		</select>			
		<label for="citations">Citations</label>
		
		<select name="citations" id="citations" class="reqdClr">
			<option value="">whatever</option>
			<option <cfif citations is 0> selected="selected" </cfif> value="0">has none</option>
			<option <cfif citations is 1> selected="selected" </cfif> value="1">has some</option>
		</select>	
		
		
		
	<br><input type="submit" value="filter">
</form>
<cfquery name="loanData" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,session.sessionKey)#">
	select 
	collection,
	collection_id,
	TRANSACTION_ID,
	loan_number,
	loan_type,
	loaned_to,
	LOAN_STATUS,
	RETURN_DUE_DATE,
	TRANS_DATE,
	count(distinct(derived_from_cat_item)) CntCatNum,
	count(distinct(citationID)) cntCited
	from (
		select 
			collection,
			collection.collection_id,
			loan.TRANSACTION_ID,
			loan.loan_number,
			loan_type,
			concattransagent(loan.TRANSACTION_ID,'received by') loaned_to,
			LOAN_STATUS,
			RETURN_DUE_DATE,
			TRANS_DATE,
			specimen_part.derived_from_cat_item,
			citation.collection_object_id citationID
		from
			loan,
			trans,
			loan_item,
			specimen_part,
			citation,
			collection
		where
			loan.transaction_id = trans.transaction_id and
			trans.collection_id=collection.collection_id and
			loan.transaction_id=loan_item.transaction_id (+) and
			loan_item.collection_object_id=specimen_part.collection_object_id (+) and
			specimen_part.derived_from_cat_item=citation.collection_object_id (+)	union
		select 
			collection,
			collection.collection_id,
			loan.TRANSACTION_ID,
			loan.loan_number,
		loan_type,
			concattransagent(loan.TRANSACTION_ID,'received by') loaned_to,
			LOAN_STATUS,
			RETURN_DUE_DATE,
			TRANS_DATE,
			specimen_part.derived_from_cat_item,
			citation.collection_object_id citationID
		from
			loan,
			trans,
			loan_item,
			specimen_part,
			citation,
			collection
		where
			loan.transaction_id = trans.transaction_id and
			trans.collection_id=collection.collection_id and
			loan.transaction_id=loan_item.transaction_id (+) and
			loan_item.collection_object_id=specimen_part.derived_from_cat_item (+) and
			loan_item.collection_object_id=citation.collection_object_id (+)
	) 
	where 1=1
	<cfif len(loanto) gt 0>
		and upper(loaned_to) like '%#ucase(loanto)#%'
	</cfif>
	<cfif len(loantype) gt 0>
		and loan_type='#loantype#'
	</cfif>
	<cfif len(loanstatus) gt 0>
		and loan_status='#loanstatus#'
	</cfif>
	<cfif len(collectionid) gt 0>
		and collection_id=#collectionid#
	</cfif>
	<cfif len(citations) gt 0>
		<cfif citations is 0>
			and count(distinct(citationID))=0
		<cfelse>
			and count(distinct(citationID))>0
		</cfif>
	</cfif>
	group by
		collection,
		collection_id,
		TRANSACTION_ID,
		loan_number,
		loan_type,
		loaned_to,
		LOAN_STATUS,
		RETURN_DUE_DATE,
		TRANS_DATE
</cfquery>
	<h2>Loan Statistics</h2>
<div style="background-color:lightgray;font-size:small;padding:1em; width:50%; align:center;margin-left:3em;margin:1em;">
	Citations apply to cataloged items and do not reflect activity resulting from any particular loan.
	<p>
		Each line is one loan/collection/citation combination; information may be repeated. Showing #loanData.recordcount# rows.
	</p>
	<p>
		Click headers to sort.
	</p>
</div>
<table border id="t" class="sortable">
	<tr>
		<th>Collection</th>
		<th>Loan</th>
		<th>Type</th>
		<th>Loaned To</th>
		<th>Status</th>
		<th>Trans Date</th>
		<th>Due Date</th>
		<th>Items Loaned</th>
		<th>Citations</th>
	</tr>
	<cfloop query="loanData">
		<tr>
			<td nowrap="nowrap">#collection#</td>
			<td nowrap="nowrap"><a href="/Loan.cfm?action=editLoan&TRANSACTION_ID=#TRANSACTION_ID#">#loan_number#</a></td>
			<td nowrap="nowrap">#loan_type#</td>
			<td nowrap="nowrap">#loaned_to#</td>
			<td>#LOAN_STATUS#</td>
			<td nowrap="nowrap">#dateformat(TRANS_DATE,"dd mmm yyyy")#&nbsp;</td>
			<td nowrap="nowrap">#dateformat(RETURN_DUE_DATE,"dd mmm yyyy")#&nbsp;</td>
			<td>
				<a href="/SpecimenResults.cfm?loan_trans_id=#loanData.TRANSACTION_ID#&collection_id=#loanData.collection_id#">#CntCatNum#</a>
			</td>
			<td><a href="/SpecimenResults.cfm?loan_trans_id=#loanData.TRANSACTION_ID#&collection_id=#loanData.collection_id#&type_status=any">
					#cntCited#</a>&nbsp;
			</td>
		</tr>
	</cfloop>
</table>


</cfoutput>
<cfinclude template="/includes/_footer.cfm">