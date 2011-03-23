<!---
Name: pingdom.cfc
Author: Matt Gifford AKA coldfumonkeh (http://www.mattgifford.co.uk)
Date: 23.03.2011

Copyright 2011 Matt Gifford AKA coldfumonkeh. All rights reserved.
Product and company names mentioned herein may be
trademarks or trade names of their respective owners.

Subject to the conditions below, you may, without charge:

Use, copy, modify and/or merge copies of this software and
associated documentation files (the 'Software')

Any person dealing with the Software shall not misrepresent the source of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Revision history
================

23/03/2011 - Version 1.1

	- initial release of pingdom API ColdFusion wrapper
	
--->
<cfcomponent displayname="pingdomAPI" output="false" hint="I am the pingdomAPI Class.">
	
	<cfproperty name="endpoint" 		type="string" default="" />
	<cfproperty name="applicationKey" 	type="string" default="" />
	<cfproperty name="version" 			type="string" default="" />
	
	<cfset variables.instance = structNew() />
	<cfset variables.instance.endpoint			=	'https://api.pingdom.com/' />
	<cfset variables.instance.version			=	'2.0' />
	
	<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the pingdomAPI Class.">
		<cfargument name="emailAddress" 	required="true" 	type="String" 						hint="I am the email address associated with the account." />
		<cfargument name="password" 		required="true" 	type="String" 						hint="I am the password associated with the account." />
		<cfargument name="applicationKey" 	required="true" 	type="String" 						hint="I am the application key." />
		<cfargument name="parse" 			required="false" 	type="Boolean"	default="false" 	hint="If set to true, I will return all data in structural output to help make debugging easier." />
			<cfscript>
				variables.instance.emailAddress 	= arguments.emailAddress;
				variables.instance.password 		= arguments.password;
				variables.instance.applicationKey 	= arguments.applicationKey;
				variables.instance.parse 			= arguments.parse;
			</cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- PUBLIC METHODS --->
	
	<!--- ACTIONS --->
	
	<cffunction name="getActions" access="public" output="false" hint="Returns a list of actions (alerts) that have been generated for your account.">		
		<cfargument name="from" 		required="false" type="Numeric" 				hint="Only include actions generated later than this timestamp. Format is UNIX time." />
		<cfargument name="to" 			required="false" type="Numeric" 				hint="Only include actions generated prior to this timestamp. Format is UNIX time." />
		<cfargument name="limit" 		required="false" type="Numeric" default="100" 	hint="Limits the number of returned results to the specified quantity." />
		<cfargument name="offset" 		required="false" type="Numeric" default="0"		hint="Offset for listing." />
		<cfargument name="checkids" 	required="false" type="String" 					hint="Comma-separated list of check identifiers. Limit results to actions generated from these checks." />
		<cfargument name="contactids" 	required="false" type="String" 					hint="Comma-separated list of contact identifiers. Limit results to actions sent to these contacts." />
		<cfargument name="status" 		required="false" type="String" 					hint="Comma-separated list of statuses. Limit results to actions with these statuses. (sent, delivered, error, not_delivered, no_credits)" />
		<cfargument name="via" 			required="false" type="String" 					hint="Comma-separated list of via mediums. Limit results to actions with these mediums. (email, sms, twitter, iphone)" />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'actions?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END ACTIONS --->
	
	<!--- ANALYSIS --->
	
	<cffunction name="getErrorAnalysisResultsList" access="public" output="false" hint="Returns a list of the latest error analysis results for a specified check.">
		<cfargument name="checkid" 	required="true" 	type="String" 					hint="The specific checkid to return details for." />
		<cfargument name="limit" 	required="false" 	type="Numeric" default="100" 	hint="Limits the number of returned results to the specified quantity." />
		<cfargument name="offset" 	required="false" 	type="Numeric" default="0"		hint="Offset for listing." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
			<cfset var stuParams	=	structCopy(arguments) />
				<cfset structDelete(stuParams, 'checkid') />
				<cfset strURL		=	'analysis/#arguments.checkid#?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getRawAnalysisResults" access="public" output="false" hint="Returns the raw result for a specified error analysis. This data is primarily intended for internal use, but you might be interested in it as well. However, there is no real documentation for this data at the moment. In the future, we may add a new API method that provides a more user-friendly format.">
		<cfargument name="checkid" 		required="true" 	type="String" hint="The specific checkid to return details for." />
		<cfargument name="analysisid" 	required="true" 	type="String" hint="The id of the specific analysis to return details for." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'analysis/#arguments.checkid#/#arguments.analysisid#' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END ANALYSIS --->
	
	
	<!--- CHECKS --->
	
	<cffunction name="getCheckList" access="public" output="false" hint="Returns a list overview of all checks.">
		<cfargument name="limit" 	required="false" 	type="Numeric" default="500" 	hint="Limits the number of returned probes to the specified quantity. (Max value is 25000)" />
		<cfargument name="offset" 	required="false" 	type="Numeric" default="0"		hint="Offset for listing." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'checks?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getCheckDetail" access="public" output="false" hint="Returns a detailed description of a specified check.">
		<cfargument name="checkid" required="true" type="String" hint="The specific checkid to return details for." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'checks/#arguments.checkid#' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
		
	<cffunction name="createCheck" access="public" output="false" hint="Creates a new check with settings specified by provided parameters.">
		<cfargument name="name" 					required="true" 	type="String" 								hint="Check name." />
		<cfargument name="host" 					required="true" 	type="String" 								hint="Target host." />
		<cfargument name="type" 					required="true" 	type="String" 								hint="Type of check (http, httpcustom, tcp, ping, dns, udp, smtp, pop3, imap).)" />
		<cfargument name="paused" 					required="false" 	type="Boolean" 								hint="Paused." />
		<cfargument name="resolution" 				required="false" 	type="Numeric" 								hint="Check resolution (1, 5, 15, 30, 60)." />
		<cfargument name="contactids" 				required="false" 	type="String" 								hint="Contact identifiers. For example contactids=154325,465231,765871." />
		<cfargument name="sendtoemail" 				required="false" 	type="Boolean" 								hint="Send alerts as email." />
		<cfargument name="sendtosms" 				required="false" 	type="Boolean" 								hint="Send alerts as SMS." />
		<cfargument name="sendtotwitter" 			required="false" 	type="Boolean" 								hint="Send alerts through Twitter." />
		<cfargument name="sendtoiphone" 			required="false" 	type="Boolean" 								hint="Send alerts to iPhone." />
		<cfargument name="sendnotificationwhendown" required="false" 	type="Numeric" 								hint="Send notification when down n times." />
		<cfargument name="notifyagainevery" 		required="false" 	type="Numeric" 								hint="Notify again every n result. 0 means that no extra notifications will be sent." />
		<cfargument name="notifywhenbackup" 		required="false" 	type="Boolean" 								hint="Notify when back up again." />
		<cfargument name="params" 					required="true" 	type="Struct"	default="#StructNew()#" 	hint="A structure containing parameters specific for the request." />
			<cfset var subFuncParams 	= 	'' />
			<cfset var stuParams		=	structCopy(arguments) />
			<cfset var stuSubParams		=	arguments.params />
			<cfset var strURL			=	'' />
			<cfset var returnData		=	'' />
			
				<!--- Remove the subParam from the main argument struct --->
				<cfset structDelete(stuParams, 'params') />
				<cfset structAppend(stuParams, paramHandler(arguments.type, stuSubParams)) />
				
				<cfset strURL		=	'checks?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'POST',
												params	=	clearEmptyParams(stuParams)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="modifyCheck" access="public" output="false" hint="Modify settings for a check. The provided settings will overwrite previous values. Settings not provided will stay the same as before the update. To clear an existing value, provide an empty value. Please note that you cannot change the type of a check once it has been created.">
		<cfargument name="checkid" 					required="true" 	type="Numeric" 								hint="Check identifier." />
		<cfargument name="type" 					required="true" 	type="String" 								hint="Type of check (http, httpcustom, tcp, ping, dns, udp, smtp, pop3, imap).)" />
		<cfargument name="name" 					required="false" 	type="String" 								hint="Check name." />
		<cfargument name="host" 					required="false" 	type="String" 								hint="Target host." />
		<cfargument name="paused" 					required="false" 	type="Boolean" 								hint="Paused." />
		<cfargument name="resolution" 				required="false" 	type="Numeric" 								hint="Check resolution (1, 5, 15, 30, 60)." />
		<cfargument name="contactids" 				required="false" 	type="String" 								hint="Contact identifiers. For example contactids=154325,465231,765871." />
		<cfargument name="sendtoemail" 				required="false" 	type="Boolean" 								hint="Send alerts as email." />
		<cfargument name="sendtosms" 				required="false" 	type="Boolean" 								hint="Send alerts as SMS." />
		<cfargument name="sendtotwitter" 			required="false" 	type="Boolean" 								hint="Send alerts through Twitter." />
		<cfargument name="sendtoiphone" 			required="false" 	type="Boolean" 								hint="Send alerts to iPhone." />
		<cfargument name="sendnotificationwhendown" required="false" 	type="Numeric" 								hint="Send notification when down n times." />
		<cfargument name="notifyagainevery" 		required="false" 	type="Numeric" 								hint="Notify again every n result. 0 means that no extra notifications will be sent." />
		<cfargument name="notifywhenbackup" 		required="false" 	type="Boolean" 								hint="Notify when back up again." />
		<cfargument name="params" 					required="true" 	type="Struct"	default="#StructNew()#" 	hint="A structure containing parameters specific for the request." />
			<cfset var subFuncParams 	= 	'' />
			<cfset var stuParams		=	structCopy(arguments) />
			<cfset var stuSubParams		=	arguments.params />
			<cfset var stuRequestParam	=	'' />
			<cfset var strURL			=	'' />
			<cfset var returnData		=	'' />
				<!--- Remove the subParam from the main argument struct --->
				<cfset structDelete(stuParams, 'params') />
				<cfset structAppend(stuParams, paramHandler(arguments.type, stuSubParams)) />
				<!--- Remove the type and checkid from the param string --->
				<cfset structDelete(stuParams, 'type') />
				<cfset structDelete(stuParams, 'checkid') />

				<cfset strURL		=	'checks/#arguments.checkid#?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'PUT',
												params	=	clearEmptyParams(stuParams)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="deleteCheck" 	access="public" output="false" hint="Deletes a check. THIS METHOD IS IRREVERSIBLE! You will lose all collected data. Be careful!">
		<cfargument name="checkid" required="true" type="Numeric" hint="Check identifier." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'checks/#arguments.checkid#' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'DELETE'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END CHECKS --->
	
	
	<!--- CONTACTS --->
	
	<cffunction name="getContactsList" access="public" output="false" hint="Returns a list of all contacts.">
		<cfargument name="limit" 	required="false" 	type="Numeric" default="100" 	hint="Limits the number of returned contacts to the specified quantity." />
		<cfargument name="offset" 	required="false" 	type="Numeric" default="0"		hint="Offset for listing." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'contacts?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="createContact" access="public" output="false" hint="Create a new contact.">
		<cfargument name="name" 				required="true" 	type="String" 							hint="Name." />
		<cfargument name="email" 				required="false" 	type="String" 							hint="Email." />
		<cfargument name="cellphone" 			required="false" 	type="String" 							hint="Cellphone number, without the country code part. In some countries you are supposed to exclude leading zeroes. (Requires countrycode and countryiso)." />
		<cfargument name="countrycode" 			required="false" 	type="String" 							hint="Cellphone country code (Requires cellphone and countryiso)." />
		<cfargument name="countryiso" 			required="false" 	type="String" 							hint="Cellphone country ISO code. For example: US (USA), GB (Britain) or SE (Sweden) (Requires cellphone and countrycode)." />
		<cfargument name="defaultsmsprovider" 	required="false" 	type="String"	default="clickatell" 	hint="Default SMS provider." />
		<cfargument name="directtwitter" 		required="false" 	type="Boolean" 	default="true"			hint="Send twitter messages as Direct Messages." />
		<cfargument name="twitteruser" 			required="false" 	type="String" 							hint="Twitter user." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'contacts' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'POST',
												params	=	clearEmptyParams(arguments)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="modifyContact" access="public" output="false" hint="Modify a contact.">
		<cfargument name="contactid"			required="true" 	type="Numeric"							hint="The ID of the contact you wish to modify." />
		<cfargument name="name" 				required="false" 	type="String" 							hint="Name." />
		<cfargument name="email" 				required="false" 	type="String" 							hint="Email." />
		<cfargument name="cellphone" 			required="false" 	type="String" 							hint="Cellphone number, without the country code part. In some countries you are supposed to exclude leading zeroes. (Requires countrycode and countryiso)." />
		<cfargument name="countrycode" 			required="false" 	type="String" 							hint="Cellphone country code (Requires cellphone and countryiso)." />
		<cfargument name="countryiso" 			required="false" 	type="String" 							hint="Cellphone country ISO code. For example: US (USA), GB (Britain) or SE (Sweden) (Requires cellphone and countrycode)." />
		<cfargument name="defaultsmsprovider" 	required="false" 	type="String"	default="clickatell" 	hint="Default SMS provider." />
		<cfargument name="directtwitter" 		required="false" 	type="Boolean" 	default="true"			hint="Send twitter messages as Direct Messages." />
		<cfargument name="twitteruser" 			required="false" 	type="String" 							hint="Twitter user." />
		<cfargument name="paused" 				required="false" 	type="Boolean" 							hint="Pause contact." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
			<cfset var stuParams	=	structCopy(arguments) />
				<cfset structDelete(stuParams, 'contactid') />
				<cfset strURL		=	'contacts/#arguments.contactid#?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'PUT',
												params	=	clearEmptyParams(stuParams)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="deleteContact" access="public" output="false" hint="Deletes a contact.">
		<cfargument name="contactid" required="true" type="Numeric"	hint="The ID of the contact you wish to delete." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'contacts/#arguments.contactid#'/>
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'DELETE'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END CONTACTS --->
	
	
	<!--- PROBES --->
	
	<cffunction name="getProbeServerList" access="public" output="false" hint="Returns a list of all Pingdom probe servers.">
		<cfargument name="limit" 			required="false" 	type="Numeric" 	default="100" 	hint="Limits the number of returned probes to the specified quantity." />
		<cfargument name="offset" 			required="false" 	type="Numeric" 	default="0"		hint="Offset for listing." />
		<cfargument name="onlyactive" 		required="false" 	type="String" 	default="false"	hint="Return only active probes." />
		<cfargument name="includedeleted" 	required="false" 	type="String" 	default="false"	hint="Include old probes that are no longer in use." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'probes?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END PROBES --->
	
	<!--- REFERENCE --->
	
	<cffunction name="getReference" access="public" output="false" hint="Get a reference of regions, timezones and date/time/number formats and their identifiers.">
		<cfset var strURL		=	'' />
		<cfset var returnData	=	'' />
			<cfset strURL		=	'reference' />
			<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END REFERENCE --->
	
	<!--- REPORTS --->
	
	<cffunction name="getEmailReportSubscriptionList" access="public" output="false" hint="Returns a list of email report subscriptions.">
		<cfset var strURL		=	'' />
		<cfset var returnData	=	'' />
			<cfset strURL		=	'reports.email' />
			<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="createEmailReport" access="public" output="false" hint="Creates a new email report.">
		<cfargument name="name" 			required="true" 	type="String" 						hint="Name." />
		<cfargument name="checkid" 			required="false" 	type="Numeric" 						hint="Check identifier. If omitted, this will be an overview report." />
		<cfargument name="frequency" 		required="false" 	type="String"	default="monthly" 	hint="Report frequency (monthly, weekly, daily)." />
		<cfargument name="contactids" 		required="false" 	type="String" 						hint="Comma separated list of receiving contact identifiers." />
		<cfargument name="additionalemails" required="false" 	type="String" 						hint="Comma separated list of additional receiving emails." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'reports.email' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'POST',
												params	=	clearEmptyParams(arguments)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="modifyEmailReport" access="public" output="false" hint="Modify an email report.">
		<cfargument name="reportid" 		required="true" 	type="Numeric" 	hint="The ID of the report you wish to modify." />
		<cfargument name="name" 			required="false" 	type="String" 	hint="Name." />
		<cfargument name="checkid" 			required="false" 	type="Numeric" 	hint="Check identifier. If omitted, this will be an overview report." />
		<cfargument name="frequency" 		required="false" 	type="String"	hint="Report frequency (monthly, weekly, daily)." />
		<cfargument name="contactids" 		required="false" 	type="String" 	hint="Comma separated list of receiving contact identifiers." />
		<cfargument name="additionalemails" required="false" 	type="String" 	hint="Comma separated list of additional receiving emails." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
			<cfset var stuParams	=	structCopy(arguments) />
				<cfset structDelete(stuParams, 'reportid') />
				<cfset strURL		=	'reports.email/#arguments.reportid#?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'PUT',
												params	=	clearEmptyParams(stuParams)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="deleteEmailReport" access="public" output="false" hint="Deletes an email report..">
		<cfargument name="reportid"  required="true" type="Numeric" hint="The ID of the report you wish to delete." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'reports.email/#arguments.reportid#'/>
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'DELETE'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getPublicReportList" access="public" output="false" hint="Returns a list of public (web-based) reports.">
		<cfset var strURL		=	'' />
		<cfset var returnData	=	'' />
			<cfset strURL		=	'reports.public' />
			<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="publishPublicReport" access="public" output="false" hint="Activate public report for a specified check.">
		<cfargument name="checkid" 	required="true" type="Numeric" hint="Check identifier for the report you wish to make public." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'reports.public/#arguments.checkid#' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'PUT'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="withdrawPublicReport" access="public" output="false" hint="Deactivate public report for a specified check.">
		<cfargument name="checkid" 	required="true" type="Numeric" hint="Check identifier for the report you wish to withdraw from public." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'reports.public/#arguments.checkid#' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'DELETE'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getSharedReportList" access="public" output="false" hint="Returns a list of shared reports (banners).">
		<cfset var strURL		=	'' />
		<cfset var returnData	=	'' />
			<cfset strURL		=	'reports.shared' />
			<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="createSharedReport" access="public" output="false" hint="Create a shared report (banner).">
		<cfargument name="sharedtype" 	required="true" 	type="String" 	default="banner"	hint="Shared report type. For now, only 'banner' is valid." />
		<cfargument name="checkid" 		required="true" 	type="Numeric" 						hint="Identifier of target check." />
		<cfargument name="auto" 		required="false" 	type="Boolean"	default="true" 		hint="Automatic period (If false, requires: fromyear, frommonth, fromday, toyear, tomonth, today)." />
		<cfargument name="fromyear" 	required="false" 	type="Numeric" 						hint="Period start: year." />
		<cfargument name="frommonth" 	required="false" 	type="Numeric" 						hint="Period start: month." />
		<cfargument name="fromday" 		required="false" 	type="Numeric" 						hint="Period start: day." />
		<cfargument name="toyear" 		required="false" 	type="Numeric" 						hint="Period end: year." />
		<cfargument name="tomonth" 		required="false" 	type="Numeric" 						hint="Period end: month." />
		<cfargument name="today" 		required="false" 	type="Numeric" 						hint="Period end: day." />
		<cfargument name="type" 		required="false" 	type="String" 	default="uptime"	hint="Banner type (uptime, response)." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'reports.shared' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'POST',
												params	=	clearEmptyParams(arguments)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="deleteSharedReport" access="public" output="false" hint="Delete a shared report (banner).">
		<cfargument name="reportid" required="true" type="String" hint="ID for the report you wish to delete." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'reports.shared/#arguments.reportid#' />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'DELETE'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END REPORTS --->
	
	
	<!--- RESULTS --->
	
	<cffunction name="getRawCheckResults" access="public" output="false" hint="Return a list of raw test results for a specified check.">
		<cfargument name="checkid" 				required="true" 	type="Numeric" 							hint="Identifier of target check." />
		<cfargument name="to" 					required="false" 	type="Numeric" 							hint="End of period. Format is UNIX timestamp." />
		<cfargument name="from" 				required="false" 	type="Numeric" 							hint="Start of period. Format is UNIX timestamp." />
		<cfargument name="probes" 				required="false" 	type="String" 							hint="Filter to only show results from a list of probes. Format is a comma separated list of probe identifiers." />
		<cfargument name="status" 				required="false" 	type="String" 							hint="Filter to only show results with specified statuses. Format is a comma separated list of (down, up, unconfirmed, unknown)." />
		<cfargument name="limit" 				required="false" 	type="Numeric" 	default="100" 			hint="Number of results to show (Will be set to 100 if the provided value is greater than 100)." />
		<cfargument name="offset" 				required="false" 	type="Numeric" 	default="0"				hint="Number of results to skip (Max value is 43200)." />
		<cfargument name="includeanalysis" 		required="false" 	type="Boolean" 							hint="Attach available error analysis identifiers to corresponding results." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
			<cfset var stuParams	=	structCopy(arguments) />
				<cfset structDelete(stuParams, 'checkid') />
				<cfset strURL		=	'results/#arguments.checkid#?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
													url		=	strURL,
													method	=	'GET'
												) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END RESULTS --->
	
	
	<!--- SERVERTIME --->
	
	<cffunction name="getCurrentServerTime" access="public" output="false" hint="Get the current time of the API server.">
		<cfset var strURL		=	'' />
		<cfset var returnData	=	'' />
			<cfset strURL		=	'servertime' />
			<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END SERVERTIME --->
	
	<!--- ACCOUNT SETTINGS --->
	
	<cffunction name="getAccountSettings" access="public" output="false" hint="Returns all account-specific settings.">
		<cfset var strURL		=	'' />
		<cfset var returnData	=	'' />
			<cfset strURL		=	'settings' />
			<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="modifyAccountSettings" access="public" output="false" hint="Modify account-specific settings.">
		<cfargument name="firstname" 			required="false" type="String" 	hint="First name." />
		<cfargument name="lastname" 			required="false" type="String" 	hint="Last name." />
		<cfargument name="company" 				required="false" type="String" 	hint="Company." />
		<cfargument name="email" 				required="false" type="String" 	hint="Email (Please note that your email is used for authentication purposes such as using this API or logging into the Pingdom Panel)." />
		<cfargument name="cellphone" 			required="false" type="String" 	hint="Cellphone (without country code) (Requires cellcountrycode and cellcountryiso)." />
		<cfargument name="cellcountrycode" 		required="false" type="Numeric" hint="Cellphone country code, for example 1 (USA) or 46 (Sweden)." />
		<cfargument name="cellcountryiso" 		required="false" type="String" 	hint="Cellphone country ISO code, for example US (USA) or SE (Sweden)." />
		<cfargument name="phone" 				required="false" type="String" 	hint="Phone (without country code) (Requires phonecountrycode and phonecountryiso)." />
		<cfargument name="phonecountrycode" 	required="false" type="Numeric" hint="Phone country code, for example 1 (USA) or 46 (Sweden)." />
		<cfargument name="phonecountryiso" 		required="false" type="String"	hint="Phone country ISO code, for example US (USA) or SE (Sweden)." />
		<cfargument name="address" 				required="false" type="String" 	hint="Address line 1." />
		<cfargument name="address2" 			required="false" type="String" 	hint="Address line 2." />
		<cfargument name="zip" 					required="false" type="String" 	hint="Zip, postal code or equivalent." />
		<cfargument name="location" 			required="false" type="String" 	hint="City / location." />
		<cfargument name="state" 				required="false" type="String" 	hint="State, province or equivalent." />
		<cfargument name="autologout" 			required="false" type="Boolean" hint="Enable auto-logout." />
		<cfargument name="regionid" 			required="false" type="Numeric" hint="Region identifier. See the API resource 'Reference' for more information." />
		<cfargument name="timezoneid" 			required="false" type="Numeric" hint="Time zone identifier. See the API resource 'Reference' for more information." />
		<cfargument name="datetimeformatid" 	required="false" type="Numeric" hint="Date/time format identifier. See the API resource 'Reference' for more information." />
		<cfargument name="numberformatid" 		required="false" type="Numeric" hint="Number format identifier. See the API resource 'Reference' for more information." />
		<cfargument name="pubrcustomdesign" 	required="false" type="Boolean" hint="Use custom design for public reports." />
		<cfargument name="pubrtextcolor" 		required="false" type="String" 	hint="Public reports, custom text color (Example: FEFFFE or 99CC00)." />
		<cfargument name="pubrbackgroundcolor" 	required="false" type="String" 	hint="Public reports, background color (Example: FEFFFE or 99CC00)." />
		<cfargument name="pubrlogourl" 			required="false" type="String" 	hint="Public reports, URL to custom logotype (Example: stats.pingdom.com/images/logo.png)." />
		<cfargument name="pubrmonths" 			required="false" type="String" 	hint="Public reports, number of months to show (none, all, 3)." />
		<cfargument name="pubrshowoverview" 	required="false" type="Boolean" hint="Public reports, enable overview." />
		<cfargument name="pubrcustomdomain" 	required="false" type="Boolean" hint="Public reports, custom domain. Must be a DNS CNAME with target stats.pingdom.com." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'settings?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'PUT',
												params	=	clearEmptyParams(arguments)
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END ACCOUNT SETTINGS --->
	
	
	<!--- SUMMARY --->
	
	<cffunction name="getResponseTime" access="public" output="false" hint="Get a summarized response time / uptime value for a specified check and time period.">
		<cfargument name="checkid" 			required="true" 	type="Numeric" 	hint="Identifier of target check." />
		<cfargument name="from" 			required="false" 	type="Numeric" 	hint="Start time of period. Format is UNIX timestamp." />
		<cfargument name="to" 				required="false" 	type="Numeric" 	hint="End time of period. Format is UNIX timestamp." />
		<cfargument name="probes" 			required="false" 	type="String" 	hint="Filter to only use results from a list of probes. Format is a comma separated list of probe identifiers." />
		<cfargument name="includeuptime" 	required="false" 	type="Boolean" 	hint="Include uptime information." />
		<cfargument name="bycountry" 		required="false" 	type="Boolean" 	hint="Split response times into country groups." />
		<cfargument name="byprobe" 			required="false" 	type="Boolean" 	hint="Split response times into probe groups." />	
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
			<cfset var stuParams	=	structCopy(arguments) />
				<cfset structDelete(stuParams, 'checkid') />
				<cfset strURL		=	'summary.average/#arguments.checkid#?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getOutagesList" access="public" output="false" hint="Get a list of status changes for a specified check and time period.">
		<cfargument name="checkid" 	required="true" 	type="Numeric" 	hint="Identifier of target check." />
		<cfargument name="from" 	required="false" 	type="Numeric" 	hint="Start time of period. Format is UNIX timestamp." />
		<cfargument name="to" 		required="false" 	type="Numeric" 	hint="End time of period. Format is UNIX timestamp." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'summary.outage/#arguments.checkid#?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getAvgResponseIntervals" access="public" output="false" hint="Get the average response time and uptime for a list of intervals. Useful for generating graphs.">
		<cfargument name="checkid" 			required="true" 	type="Numeric" 	hint="Identifier of target check." />
		<cfargument name="from" 			required="false" 	type="Numeric" 	hint="Start time of period. Format is UNIX timestamp." />
		<cfargument name="to" 				required="false" 	type="Numeric" 	hint="End time of period. Format is UNIX timestamp." />
		<cfargument name="resolution" 		required="false" 	type="String" 	hint="Interval size (hour, day, week)." />
		<cfargument name="includeuptime" 	required="false" 	type="Boolean" 	hint="Include uptime information." />
		<cfargument name="probes" 			required="false" 	type="String" 	hint="Filter to only use results from a list of probes. Format is a comma separated list of probe identifiers. Can not be used if includeuptime is set to true. Also note that this can cause intervals to be omitted, since there may be no results from the desired probes in them." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'summary.performance/#arguments.checkid#?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<cffunction name="getActiveProbesForPeriod" access="public" output="false" hint="Get a list of probes that performed tests for a specified check during a specified period.">
		<cfargument name="checkid" 			required="true" 	type="Numeric" 	hint="Identifier of target check." />
		<cfargument name="from" 			required="true" 	type="Numeric" 	hint="Start time of period. Format is UNIX timestamp." />
		<cfargument name="to" 				required="false" 	type="Numeric" 	hint="End time of period. Format is UNIX timestamp." />
			<cfset var strURL		=	'' />
			<cfset var returnData	=	'' />
				<cfset strURL		=	'summary.probes/#arguments.checkid#?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END SUMMARY --->
	
	
	<!--- SINGLE --->
	
	<cffunction name="makeSingleTest" access="public" output="false" hint="Performs a single test using a specified Pingdom probe against a specified target. Please note that this method is meant to be used sparingly, not to set up your own monitoring solution.">
		<cfargument name="host" 				required="true" 	type="String" 								hint="Target host." />
		<cfargument name="type" 				required="true" 	type="String" 								hint="Type of test (http, httpcustom, tcp, ping, dns, udp, smtp, pop3, imap)." />
		<cfargument name="probeid" 				required="false" 	type="Numeric" 								hint="Probe identifier." />
		<cfargument name="params" 				required="true" 	type="Struct"	default="#StructNew()#" 	hint="A structure containing parameters specific for the request." />
			<cfset var stuParams		=	structCopy(arguments) />
			<cfset var stuSubParams		=	arguments.params />
			<cfset var strURL			=	'' />
			<cfset var returnData		=	'' />
			
				<!--- Remove the subParam from the main argument struct --->
				<cfset structDelete(stuParams, 'params') />
				<cfset structAppend(stuParams, paramHandler(arguments.type, stuSubParams)) />

						
				<cfset strURL		=	'single?' & buildParamString(stuParams) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />			
	</cffunction>
		
	<!--- END SINGLE --->
	
	<!--- TRACEROUTE --->
	
	<cffunction name="makeTraceroute" access="public" output="false" hint="Perform a traceroute to a specified target from a specified Pingdom probe.">
		<cfargument name="host" 	required="true" 	type="String" 	hint="Target host." />
		<cfargument name="probeid" 	required="false" 	type="Numeric" 	hint="Probe identifier." />
			<cfset var strURL			=	'' />
			<cfset var returnData		=	'' />
				<cfset strURL		=	'traceroute?' & buildParamString(arguments) />
				<cfset returnData	=	makeCall(
												url		=	strURL,
												method	=	'GET'
											) />
		<cfreturn handleReturnFormat(returnData) />
	</cffunction>
	
	<!--- END TRACEROUTE --->
	
	<!--- PRIVATE METHODS --->
	
	<cffunction name="makeCall" access="private" output="false" hint="I make the request to the API.">
		<cfargument name="url" 		required="true" 	type="String" 							hint="I am the trailing URL complete with any query parameters for the request." />
		<cfargument name="method" 	required="true" 	type="String" 							hint="I am the method of the request." />
		<cfargument name="params" 	required="false" 	type="Struct"	default="#structNew()#" hint="I am the structure containing parameters to be used in PUT / POST requests." />
			<cfset var strURL	=	'#variables.instance.endpoint#api/#variables.instance.version#/' & arguments.url />
			<cfset var cfhttp	=	'' />			
				<!---
					Authentication is basic, 
					so the email address and password
					are sent through in the header.
				--->
				<cfhttp url="#strURL#" 
						method="#arguments.method#" 
						username="#variables.instance.emailAddress#" 
						password="#variables.instance.password#">
					<!--- Application key is sent through as header --->
					<cfhttpparam type="header" 
								name="App-Key" 
								value="#variables.instance.applicationKey#" />
								
					<cfif NOT structIsEmpty(arguments.params)>
					<cfloop collection="#arguments.params#" item="key">
					<cfhttpparam type="formfield" name="#key#" value="#arguments.params[key]#" />
					</cfloop>
					</cfif>
								
				</cfhttp>
		<cfreturn cfhttp.FileContent />
	</cffunction>
	
	<cffunction name="buildParamString" access="private" output="false" returntype="string" hint="I loop through a struct to convert to query params for the URL">
		<cfargument name="argScope" required="true" type="struct" hint="I am the struct containing the method params" />
			<cfset var strURLParam 	= '' />
			<cfloop collection="#arguments.argScope#" item="key">
				<cfif len(arguments.argScope[key])>
					<cfif listLen(strURLParam)>
						<cfset strURLParam = strURLParam & '&' />
					</cfif>	
					<cfset strURLParam = strURLParam & lcase(key) & '=' & arguments.argScope[key] />
				</cfif>
			</cfloop>			
		<cfreturn strURLParam />
	</cffunction>
	
	<cffunction name="clearEmptyParams" access="private" output="false" hint="I accept the structure of arguments and remove any empty / nulls values before they are sent to the OAuth processing.">
		<cfargument name="paramStructure" required="true" type="Struct" hint="I am a structure containing the arguments / parameters you wish to filter." />
			<cfset var stuRevised = {} />
				<cfloop collection="#arguments.paramStructure#" item="key">
					<cfif len(arguments.paramStructure[key])>
						<cfset structInsert(stuRevised, lcase(key), arguments.paramStructure[key], true) />
					</cfif>
				</cfloop>
		<cfreturn stuRevised />
	</cffunction>
	
	<cffunction name="handleReturnFormat" access="private" output="false" hint="I determine if the output is parsed.">
		<cfargument name="data" required="true" type="Any" hint="I am the data from the API response." />
			<cfset var returnData	=	arguments.data />
				<cfif variables.instance.parse>
					<cfset returnData	=	deserializeJSON(arguments.data) />
				</cfif>
		<cfreturn returnData />
	</cffunction>
	
	<cffunction name="paramHandler" access="private" output="false" hint="I manage parameters and arguments for methods that have variations on what's expected.">
		<cfargument name="type" 	required="true" type="String" 	hint="Type of check (http, httpcustom, tcp, ping, dns, udp, smtp, pop3, imap).)" />
		<cfargument name="params" 	required="true" type="Struct"	hint="A structure containing parameters specific for the request." />
			<cfset var subFuncParams 	= 	'' />
			<cfset var stuSubParams		=	arguments.params />
				<cfswitch expression="#arguments.type#">
						<cfcase value="http">
							<cfset subFuncParams = checkHTTPParams(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="httpcustom">
							<cfset subFuncParams = checkHTTPCustomParams(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="tcp">
							<cfset subFuncParams = checkTCPParams(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="ping">
							<cfset subFuncParams = stuSubParams />
						</cfcase>
						<cfcase value="dns">
							<cfset subFuncParams = checkDNSParams(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="udp">
							<cfset subFuncParams = checkUDPParams(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="smtp">
							<cfset subFuncParams = checkSMTPParams(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="pop3">
							<cfset subFuncParams = checkPOP3Params(argumentCollection=stuSubParams) />
						</cfcase>
						<cfcase value="imap">
							<cfset subFuncParams = checkIMAPParams(argumentCollection=stuSubParams) />
						</cfcase>
					</cfswitch>
		<cfreturn subFuncParams />
	</cffunction>
	
	<cffunction name="checkHTTPParams" access="private" output="false" hint="I hold all arguments for an HTTP-specific request.">
		<!--- Type-specific parameters for HTTP tests --->
		<cfargument name="url" 					required="false" 	type="String" 	default="/"					hint="Target path on the server." />
		<cfargument name="encryption" 			required="false" 	type="Boolean" 	default="false"				hint="Connection encryption." />
		<cfargument name="port" 				required="false" 	type="Numeric" 	default="80"				hint="Target port." />
		<cfargument name="auth" 				required="false" 	type="String" 								hint="Username and password for target HTTP authentication. Example: user:password" />
		<cfargument name="shouldcontain"	 	required="false" 	type="String" 								hint="Target site should contain this string." />
		<cfargument name="shouldnotcontain" 	required="false" 	type="String"								hint="Target site should NOT contain this string." />
		<cfargument name="postdata" 			required="false" 	type="String" 								hint="Data that should be posted to the web page, for example submission data for a sign-up or login form. The data needs to be formatted in the same way as a web browser would send it to the web server." />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkHTTPCustomParams" access="private" output="false" hint="I hold all arguments for an HTTPCustom-specific request.">
		<!--- Type-specific parameters for HTTP Custom tests --->
		<cfargument name="url" 					required="true" 	type="String" 					hint="Target path to XML file on server." />
		<cfargument name="encryption" 			required="false" 	type="Boolean" 	default="false"	hint="Connection encryption." />
		<cfargument name="port" 				required="false" 	type="Numeric" 	default="80"	hint="Target port." />
		<cfargument name="auth" 				required="false" 	type="String" 					hint="Username and password for target HTTP authentication. Example: user:password" />
		<cfargument name="additionalurls"	 	required="false" 	type="String" 					hint=";-separated list of addidional URLs with hostname included. Example: additionalurls=www.mysite.com;www.myothersite.com" />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkTCPParams" access="private" output="false" hint="I hold all arguments for an TCP-specific request.">
		<!--- Type-specific parameters for TCP tests --->
		<cfargument name="port" 				required="true" 	type="Numeric" 	hint="Target port." />
		<cfargument name="stringtosend" 		required="false" 	type="String" 	hint="String to send." />
		<cfargument name="stringtoexpect"	 	required="false" 	type="String" 	hint="String to expect in response." />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkDNSParams" access="private" output="false" hint="I hold all arguments for a DNS-specific request.">
		<!--- Type-specific parameters for DNS tests --->
		<cfargument name="expectedip" 			required="true" 	type="String" 	hint="Expected IP." />
		<cfargument name="nameserver"	 		required="true" 	type="String" 	hint="Nameserver." />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkUDPParams" access="private" output="false" hint="I hold all arguments for a UDP-specific request.">
		<!--- Type-specific parameters for UDP tests --->
		<cfargument name="port" 				required="true" 	type="Numeric" 	hint="Target port." />
		<cfargument name="stringtosend" 		required="true" 	type="String" 	hint="String to send." />
		<cfargument name="stringtoexpect"	 	required="true" 	type="String" 	hint="String to expect in response." />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkSMTPParams" access="private" output="false" hint="I hold all arguments for an SMTP-specific request.">
		<!--- Type-specific parameters for SMTP tests --->
		<cfargument name="port" 				required="false" 	type="Numeric"	default="25" 	hint="Target port." />
		<cfargument name="auth" 				required="false" 	type="String" 					hint="Username and password for target SMTP authentication. Example: user:password" />
		<cfargument name="stringtoexpect"	 	required="false" 	type="String" 					hint="String to expect in response." />
		<cfargument name="encryption" 			required="false" 	type="Boolean" 					hint="Connection encryption." />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkPOP3Params" access="private" output="false" hint="I hold all arguments for a POP3-specific request.">
		<!--- Type-specific parameters for POP3 tests --->
		<cfargument name="port" 				required="false" 	type="Numeric"	default="110" 	hint="Target port." />
		<cfargument name="stringtoexpect"	 	required="false" 	type="String" 					hint="String to expect in response." />
		<cfargument name="encryption" 			required="false" 	type="Boolean" 					hint="Connection encryption." />
		<cfreturn arguments />
	</cffunction>
	
	<cffunction name="checkIMAPParams" access="private" output="false" hint="I hold all arguments for an IMAP-specific request.">
		<!--- Type-specific parameters for IMAP tests --->
		<cfargument name="port" 				required="false" 	type="Numeric"	default="143" 	hint="Target port." />
		<cfargument name="stringtoexpect"	 	required="false" 	type="String" 					hint="String to expect in response." />
		<cfargument name="encryption" 			required="false" 	type="Boolean" 					hint="Connection encryption." />
		<cfreturn arguments />
	</cffunction>
	
</cfcomponent>