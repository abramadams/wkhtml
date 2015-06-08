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
*   @dependencies wkhtmltopdf http://wkhtmltopdf.org/
* 				  for linux distros, xvfb-run must also be installed
*   @updated 6/3/2015
*   @author Abram Adams
******************************************************************************/
component accessors="true" extends="base" {
	property wkhtmltopdfPath;
	property tempDir;

	public function init( string wkhtmltopdfPath = "wkhtmltopdf", string tempDir = getTempDirectory() ){
		var tmpPath = "";
		if( server.os.name == "Unix" || server.os.name == "Linux" ){
			tmpPath = 'xvfb-run -a -s "-screen 0, 1024x768x24" ';
		}
		setWkhtmltopdfPath( tmpPath & wkhtmltopdfPath );
		setTempDir( tempDir );
	}

/**
* Global Options:
*       collate                       Collate when printing multiple copies
*                                       (default)
*       no-collate                    Do not collate when printing multiple
*                                       copies
*       cookie-jar <path>             Read and write cookies from and to the
*                                       supplied cookie jar file
*       copies <number>               Number of copies to print into the pdf
*                                       file (default 1)
*       dpi <dpi>                     Change the dpi explicitly (this has no
*                                       effect on X11 based systems)
*       extended-help                 Display more extensive help, detailing
*                                       less common command switches
*       grayscale                     PDF will be generated in grayscale
*       help                          Display help
*       htmldoc                       Output program html help
*       image-dpi <integer>           When embedding images scale them down to
*                                       this dpi (default 600)
*       image-quality <integer>       When jpeg compressing images use this
*                                       quality (default 94)
*       license                       Output license information and exit
*       lowquality                    Generates lower quality pdf/ps. Useful to
*                                       shrink the result document space
*       manpage                       Output program man page
*       margin-bottom <unitreal>      Set the page bottom margin
*       margin-left <unitreal>        Set the page left margin (default 10mm)
*       margin-right <unitreal>       Set the page right margin (default 10mm)
*       margin-top <unitreal>         Set the page top margin
*       orientation <orientation>     Set orientation to Landscape or Portrait
*                                       (default Portrait)
*       page-height <unitreal>        Page height
*       page-size <Size>              Set paper size to: A4, Letter, etc.
*                                       (default A4)
*       page-width <unitreal>         Page width
*       no-pdf-compression            Do not use lossless compression on pdf
*                                       objects
*       quiet                         Be less verbose
*       read-args-from-stdin          Read command line arguments from stdin
*       readme                        Output program readme
*       title <text>                  The title of the generated pdf file (The
*                                       title of the first document is used if not
*                                       specified)
*       version                       Output version information and exit
*
* Outline Options:
*       dump-default-toc-xsl          Dump the default TOC xsl style sheet to
*                                       stdout
*       dump-outline <file>           Dump the outline to a file
*       outline                       Put an outline into the pdf (default)
*       no-outline                    Do not put an outline into the pdf
*       outline-depth <level>         Set the depth of the outline (default 4)
*
* Page Options:
*       allow <path>                  Allow the file or files from the specified
*                                       folder to be loaded (repeatable)
*       background                    Do print background (default)
*       no-background                 Do not print background
*       cache-dir <path>              Web cache directory
*       checkbox-checked-svg <path>   Use this SVG file when rendering checked
*                                       checkboxes
*       checkbox-svg <path>           Use this SVG file when rendering unchecked
*                                       checkboxes
*       cookie <name> <value>         Set an additional cookie (repeatable),
*                                       value should be url encoded.
*       custom-header <name> <value>  Set an additional HTTP header (repeatable)
*       custom-header-propagation     Add HTTP headers specified by
*                                       custom-header for each resource request.
*       no-custom-header-propagation  Do not add HTTP headers specified by
*                                       custom-header for each resource request.
*       debug-javascript              Show javascript debugging output
*       no-debug-javascript           Do not show javascript debugging output
*                                       (default)
*       default-header                Add a default header, with the name of the
*                                       page to the left, and the page number to
*                                       the right, this is short for:
*                                       header-left='[webpage]'
*                                       header-right='[page]/[toPage]' top 2cm
*                                       header-line
*       encoding <encoding>           Set the default text encoding, for input
*       disable-external-links        Do not make links to remote web pages
*       enable-external-links         Make links to remote web pages (default)
*       disable-forms                 Do not turn HTML form fields into pdf form
*                                       fields (default)
*       enable-forms                  Turn HTML form fields into pdf form fields
*       images                        Do load or print images (default)
*       no-images                     Do not load or print images
*       disable-internal-links        Do not make local links
*       enable-internal-links         Make local links (default)
*   	disable-javascript            Do not allow web pages to run javascript
*       enable-javascript             Do allow web pages to run javascript
*                                       (default)
*       javascript-delay <msec>       Wait some milliseconds for javascript
*                                       finish (default 200)
*       load-error-handling <handler> Specify how to handle pages that fail to
*                                       load: abort, ignore or skip (default
*                                       abort)
*       load-media-error-handling <handler> Specify how to handle media files
*                                       that fail to load: abort, ignore or skip
*                                       (default ignore)
*       disable-local-file-access     Do not allowed conversion of a local file
*                                       to read in other local files, unless
*                                       explicitly allowed with allow
*       enable-local-file-access      Allowed conversion of a local file to read
*                                       in other local files. (default)
*       minimum-font-size <int>       Minimum font size
*       exclude-from-outline          Do not include the page in the table of
*                                       contents and outlines
*       include-in-outline            Include the page in the table of contents
*                                       and outlines (default)
*       page-offset <offset>          Set the starting page number (default 0)
*       password <password>           HTTP Authentication password
*       disable-plugins               Disable installed plugins (default)
*       enable-plugins                Enable installed plugins (plugins will
*                                       likely not work)
*       post <name> <value>           Add an additional post field (repeatable)
*       post-file <name> <path>       Post an additional file (repeatable)
*       print-media-type              Use print media-type instead of screen
*       no-print-media-type           Do not use print media-type instead of
*                                       screen (default)
*       proxy <proxy>                 Use a proxy
*       radiobutton-checked-svg <path> Use this SVG file when rendering checked
*                                       radiobuttons
*       radiobutton-svg <path>        Use this SVG file when rendering unchecked
*                                       radiobuttons
*       run-script <js>               Run this additional javascript after the
*                                       page is done loading (repeatable)
*       disable-smart-shrinking       Disable the intelligent shrinking strategy
*                                       used by WebKit that makes the pixel/dpi
*                                       ratio none constant
*       enable-smart-shrinking        Enable the intelligent shrinking strategy
*                                       used by WebKit that makes the pixel/dpi
*                                       ratio none constant (default)
*       stop-slow-scripts             Stop slow running javascripts (default)
*       no-stop-slow-scripts          Do not Stop slow running javascripts
*       disable-toc-back-links        Do not link from section header to toc
*                                       (default)
*       enable-toc-back-links         Link from section header to toc
*       user-style-sheet <url>        Specify a user style sheet, to load with
*                                       every page
*       username <username>           HTTP Authentication username
*       viewport-size <>              Set viewport size if you have custom
*                                       scrollbars or css attribute overflow to
*                                       emulate window size
*       window-status <windowStatus>  Wait until window.status is equal to this
*                                       string before rendering page
*       zoom <float>                  Use this zoom factor (default 1)
*
* Headers And Footer Options:
*       footer-center <text>          Centered footer text
*       footer-font-name <name>       Set footer font name (default Arial)
*       footer-font-size <size>       Set footer font size (default 12)
*       footer-html <url>             Adds a html footer
*       footer-left <text>            Left aligned footer text
*       footer-line                   Display line above the footer
*       no-footer-line                Do not display line above the footer
*                                       (default)
*       footer-right <text>           Right aligned footer text
*       footer-spacing <real>         Spacing between footer and content in mm
*                                       (default 0)
*       header-center <text>          Centered header text
*       header-font-name <name>       Set header font name (default Arial)
*       header-font-size <size>       Set header font size (default 12)
*       header-html <url>             Adds a html header
*       header-left <text>            Left aligned header text
*       header-line                   Display line below the header
*       no-header-line                Do not display line below the header
*                                       (default)
*       header-right <text>           Right aligned header text
*       header-spacing <real>         Spacing between header and content in mm
*                                       (default 0)
*       replace <name> <value>        Replace [name] with value in header and
*                                       footer (repeatable)
*
* TOC Options:
*       disable-dotted-lines          Do not use dotted lines in the toc
*       toc-header-text <text>        The header text of the toc (default Table
*                                       of Contents)
*       toc-level-indentation <width> For each level of headings in the toc
*                                       indent by this length (default 1em)
*       disable-toc-links             Do not link from toc to sections
*       toc-text-size-shrink <real>   For each level of headings in the toc the
*                                       font is scaled by this factor (default
*                                       0.8)
*       xsl-style-sheet <file>        Use the supplied xsl style sheet for
*                                       printing the table of content
*
*/
	public function create( string url, string html, string destination, struct options = {}, boolean writeToFile = true ){
		if( isNull( arguments.url ) && isNull( html ) ){
			throw("You need to provide either a URL or HTML string to convert to pdf");
		}
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
			options[ "header-html" ] = tmpHeaderFile;
		}
		if( structKeyExists( arguments.options, "footer-html" ) ){
			options[ "footer-html" ] = _parseHtml( options[ "footer-html" ] );
			tmpFooterFile = "#getTempDir()#_#createUUID()#-footer.html";
			fileWrite( tmpFooterFile, options[ "footer-html" ] );
			options[ "footer-html" ] = tmpFooterFile;
		}

		var args = {
			name: getWkhtmlToPdfPath() ,
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

		return writeToFile ? results : fileReadBinary( results.file );
	}

	public string function getText( required any pdfFile ){
		if( !fileExists( pdfFile ) ) {
			throw( "File #pdfFile# does not exist!");
		}
	    var pdfReader = createObject( "java", "com.lowagie.text.pdf.PdfReader" ).init( pdfFile );
	    var PRTokeniser = createObject( "java", "com.lowagie.text.pdf.PRTokeniser" );
	    var buff = createObject( "java","java.lang.StringBuffer" ).init();

	    for( var i = 1; i <= pdfReader.getNumberOfPages(); i++ ){
		    var streamBytes = pdfReader.getPageContent( i );
		    var token = PRTokeniser.init( streamBytes );
		    while (true) {
				if ( !token.nextToken() ){
					token.close();
					break;
				}
				if( token.getTokenType() == PRTokeniser.TK_STRING ){
					buff.append( token.getStringValue() );
				}
			}
		}
		return buff.toString();
	}

	public array function getPagedText( required any pdfFile ){
		if( !fileExists( pdfFile ) ) {
			throw( "File #pdfFile# does not exist!");
		}
	    var pdfReader = createObject( "java", "com.lowagie.text.pdf.PdfReader" ).init( pdfFile );
	    var PRTokeniser = createObject( "java", "com.lowagie.text.pdf.PRTokeniser" );
	    var pages = [];
	    for( var i = 1; i <= pdfReader.getNumberOfPages(); i++ ){
		    var streamBytes = pdfReader.getPageContent( i );
		    var token = PRTokeniser.init( streamBytes );
		    while (true) {
				if ( !token.nextToken() ){
					token.close();
					break;
				}
				if( token.getTokenType() == PRTokeniser.TK_STRING ){
					arrayAppend( pages, token.getStringValue() );
				}
			}
		}
		return pages;
	}
	public function getInfo( required any pdfFile ){
		if( !fileExists( pdfFile ) ) {
			throw( "File #pdfFile# does not exist!");
		}
	    var pdfReader = createObject("java", "com.lowagie.text.pdf.PdfReader").init( pdfFile );
	    var pages = [];
	    for( var i = 1; i <= pdfReader.getNumberOfPages(); i++) {
	    	arrayAppend( pages, {
	    			"pageSize": {
	    							"height": pdfReader.getPageSize( i ).getHeight(),
	    							"width": pdfReader.getPageSize( i ).getWidth()
	    						},
	    			"pageRotation": pdfReader.getpageRotation( i ),
	    			"pageSizeWithRotation": {
	    				"height": pdfReader.getPageSizeWithRotation( i ).getHeight(),
	    				"width": pdfReader.getPageSizeWithRotation( i ).getWidth()
	    			}
	    		});
	    }
		return {
			"info": pdfReader.getInfo(),
			"pageCount": pdfReader.getNumberOfPages(),
			"pages": pages
		};
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
}