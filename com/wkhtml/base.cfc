<!---
/**
*	Copyright (c) 2015, Abram Adams
*
*	Licensed under the Apache License, Version 2.0 (the "License");
*	you may not use this file except in compliance with the License.
*	You may obtain a copy of the License at
*
*		http://www.apache.org/licenses/LICENSE-2.0
*
*	Unless required by applicable law or agreed to in writing, software
*	distributed under the License is distributed on an "AS IS" BASIS,
*	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*	See the License for the specific language governing permissions and
*	limitations under the License.
*
******************************************************************************
*   @version 0.0.1
*   @updated 6/3/2015
*   @author Abram Adams
******************************************************************************/
--->
<cfcomponent>

	<cffunction name="execute" access="public">
		<cfargument name="destination" default="#getTempDirectory()#wkhtmltopdf-#hash(createUUID())#.pdf"/>
		<cfset arguments.timeout = 120/>
		<cfset var originalOutputFile = arguments.destination />
		<cfset arguments.arguments &= " '" & arguments.destination & "'"/>
		<cfset var results = {}/>
		<cfset local.stdout = "" />
		<cfset local.stderr = "" />

		<cfset arguments.variable = "local.stdout" />
		<cfset arguments.errorVariable = "local.stderr" />
		<cftry>
			<cfset results.executionTime = getTickCount()/>
			<cfexecute attributeCollection="#arguments#"></cfexecute>
			<cfset results.executionTime = getTickCount() - results.executionTime/>

			<cfset results.command =  name />
			<cfset results.options =  arguments.arguments />
			<cfset results.output = trim( local.stdout ) />
			<cfset results.error = !isNull( local.stderr ) && len( trim( local.stderr ) )
										? trim( local.stderr )
										: findNoCase( "permission denied", local.stdout )
											? trim( local.stdout ) : ""/>
			<cfset results.file = destination />

			<cfif len( trim( results.error ) )>
				<cfthrow message="#results.error#">
			</cfif>
			<cfcatch type="any">
				<!--- <cfdump var="#[arguments,cfcatch]#" abort> --->
				<cfthrow message="Error converting to PDF" detail="#cfcatch.detail#">
			</cfcatch>
		</cftry>

		<cfif !isNull( originalOutputFile ) && destination != originalOutputFile>
			<cffile action="move" source="#destination#" destination="#originalOutputFile#">
			<cfset results.file = originalOutputFile />
		</cfif>
		<cfreturn results />

	</cffunction>
</cfcomponent>