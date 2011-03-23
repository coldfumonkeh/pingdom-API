<!---
Name: index.cfm
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


Usage: The pingdom component accepts three required parameters in the constructor;
1) emailAddress (associated with the pingdom account)
2) password associated with the account
3) applicationKey - obtainable from the pingdom site once you have an account and registered an application.

An optional fourth parameter can be set during component instantiation to determine
if the returned data will be in string format or structural format (parsed / serialized) to assist with debugging.

All methods and parameters within the monkehTweet component are documented and hints provided to assist with use.

--->

<!--- Instantiate the component --->
<cfset objPingdom = createObject(
						'component', 
						'com.coldfumonkeh.pingdom.pingdom'
					).init(
						emailAddress	=	'< emailAddress >',
						password		=	'< password >',
						applicationKey	=	'< applicationkey >',
						parse			=	true
					) />

<!---checkid=316843--->

<!--- contact 171740 --->

<!--- report id 136681 --->

<!--- shared report id 29a665cc --->

<!--- analysis id 38347894 --->

<cfset stuParams = {

				} />
				
<cfdump var="#objPingdom.makeSingleTest(host='coldfumonkeh.com',type='http')#">



