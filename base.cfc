<!---
/**
*	Copyright (c) 2016, Abram Adams
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
*   @version 0.1.0
*   @updated 7/22/2016
*   @author Abram Adams
******************************************************************************/
--->
<cfcomponent accessors="true">
	<cfproperty name="binaryPath" type="string"/>
	<cfproperty name="tempDir" type="string"/>
	<cfproperty name="_MISSING_URL_HTML_MESSAGE" defaut="You need to provide either a URL or HTML string to convert"/>

	<cfscript>
		public function create( string url, string html, string destination, struct options = {}, boolean writeToFile = true ){
			if( isNull( arguments.url ) && isNull( html ) ){
				throw(get_MISSING_URL_HTML_MESSAGE());
			}
			// setup some wkthmltopdf default options
			var defaults = {
				 "viewport-size":"1200x1080"
				,"image-quality":100
				,"encoding": "utf-8"
			};
			structAppend( defaults, options, false );

			if( len( trim( html ) ) ){
				var tmpFile = "#getTempDir()#_#createUUID()#.html";
				fileWrite( tmpFile, html );
				arguments.url = tmpFile;
			}
			// This adds support for inline html injected as header/footer (opposed to passing as url)
			var tmpHeaderFile = var tmpFooterFile = "";
			if( structKeyExists( arguments.options, "header-html" ) ){
				options[ "header-html" ] = _parseHtml( options[ "header-html" ] );
				tmpHeaderFile = "#getTempDir()#_#createUUID()#-header.html";
				fileWrite( tmpHeaderFile, options[ "header-html" ] );
				options[ "header-html" ] = "'#tmpHeaderFile#'";
			}
			if( structKeyExists( arguments.options, "footer-html" ) ){
				options[ "footer-html" ] = _parseHtml( options[ "footer-html" ] );
				tmpFooterFile = "#getTempDir()#_#createUUID()#-footer.html";
				fileWrite( tmpFooterFile, options[ "footer-html" ] );
				options[ "footer-html" ] = "'#tmpFooterFile#'";
			}

			var args = {
				name: getBinaryPath() ,
				arguments: _parseOptions( options ) & " '" & arguments.url & "'" ,
				destination: isNull( destination ) ? javaCast( "null", "" ) : destination,
				timeout: 99999
			};

			var results = execute( argumentCollection:args );

			// Clean up temp files
			if( len( trim( html ) ) ){
				fileDelete( tmpFile );
			}
			if( len( trim( tmpHeaderFile ) ) ){
				fileDelete( tmpHeaderFile );
			}
			if( len( trim( tmpFooterFile ) ) ){
				fileDelete( tmpFooterFile );
			}
			if( writeToFile && listLast( getFileFromPath( results.file ), '.' ) == "pdf"){
				results.metadata = getInfo( results.file );
			}else{
				results.metadata = getFileInfo( results.file );
			}
			results.metadata.html = html;
			results.metadata.url = url;
			return writeToFile ? results : fileReadBinary( results.file );
		}

		private string function _parseOptions( struct options ){
			var parsed = [];
			for( var opt in options ){
				arrayAppend( parsed, " --#opt##len( options[opt] ) ? ' #options[opt]#' : '' #" );
			}
			return arrayToList( parsed, ' ' );
		}

		// html can be inline html, or a url. This will pull down the content and properly
		// parse it for wkhtml consumption. Used for header/footer html.
		private string function _parseHtml( html ){
			if( left( html, 4 ) == "http" ){
				var remoteHtml = new Http( url = html ).send().getPrefix();
				html = '<!doctype html>' & remoteHtml.fileContent;
				if( listFirst( remoteHtml.mimeType, '/') == "image" ){
					return '<!doctype html><img src="data:#remoteHtml.mimeType#;base64,#toBase64( remoteHtml.fileContent )#"/>';
				}
			}
			return html;
		}

	</cfscript>


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
				<!--- <cfthrow message="Error converting to PDF" detail="#cfcatch.detail#"> --->
			</cfcatch>
		</cftry>

		<cfif !isNull( originalOutputFile ) && destination != originalOutputFile>
			<cffile action="move" source="#destination#" destination="#originalOutputFile#">
			<cfset results.file = originalOutputFile />
		</cfif>
		<cfreturn results />

	</cffunction>

</cfcomponent>