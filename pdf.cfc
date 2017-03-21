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
*   @dependencies wkhtmltopdf http://wkhtmltopdf.org/
* 				  for linux distros, xvfb-run must also be installed
*   @updated 7/22/2016
*   @author Abram Adams
******************************************************************************/
component accessors="true" extends="base" {
	property binaryPath;
	property tempDir;
	property _MISSING_URL_IMAGE_MESSAGE;

	public function init( string binaryPath = "", string tempDir = getTempDirectory() ){
		var tmpPath = "";
		if( server.os.name == "Unix" || server.os.name == "Linux" ){
			tmpPath = 'xvfb-run -a -s "-screen 0, 1024x768x24" ';
		}
		// Setup default binaryPath if not provided.
		if( !len( trim( binaryPath ) ) ){
			if( server.os.arch contains "64" ){
				binaryPath = server.os.name contains "nix"
					? expandPath('./com/wkhtml/bin/wkhtmltox/bin/wkhtmltopdf')
					: expandPath('./com/wkhtml/bin/win64/wkhtmltopdf-amd64.exe');
			}else{
				binaryPath = server.os.name contains "nix"
					? expandPath('./com/wkhtml/bin/wkhtmltopdf-i386')
					: expandPath('./com/wkhtml/bin/win64/wkhtmltopdf-i386.exe');
			}
		}
		// If binary path doesn't exist, pass the binary name and assume
		// it is in the computer's "PATH"
		binaryPath = fileExists( binaryPath )
					? binaryPath
					: "wkhtmltopdf";
		setBinaryPath( tmpPath & BinaryPath );
		setTempDir( tempDir );
		set_MISSING_URL_IMAGE_MESSAGE( "You need to provide either a URL or HTML string to convert to image" );
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
	public function create(
		string url,
		string html,
		string destination,
		struct options = {},
		boolean writeToFile = true
	){
		return super.create( argumentCollection:arguments );
	}

	public string function getText( required any pdfFile ){
		if( !fileExists( pdfFile ) ) {
			throw( "File #pdfFile# does not exist!");
		}
		var pdfReader = createObject( "java", "com.lowagie.text.pdf.PdfReader" ).init( pdfFile );
		var PRTokeniser = createObject( "java", "com.lowagie.text.pdf.PRTokeniser" );
		var buff = createObject( "java","java.lang.StringBuffer" ).init();
		var pageCount = pdfReader.getNumberOfPages();
		for( var i = 1; i <= pageCount; i++ ){
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
		var pageCount = pdfReader.getNumberOfPages();
		for( var i = 1; i <= pageCount; i++ ){
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
		var pageCount = pdfReader.getNumberOfPages();
		for( var i = 1; i <= pageCount; i++) {
			arrayAppend( pages,
				{
					"pageSize": {
						"height": pdfReader.getPageSize( i ).getHeight(),
						"width": pdfReader.getPageSize( i ).getWidth()
					},
					"pageRotation": pdfReader.getpageRotation( i ),
					"pageSizeWithRotation": {
						"height": pdfReader.getPageSizeWithRotation( i ).getHeight(),
						"width": pdfReader.getPageSizeWithRotation( i ).getWidth()
					}
				}
			);
		}
		return {
			"info": pdfReader.getInfo(),
			"pageCount": pdfReader.getNumberOfPages(),
			"fileInfo": GetFileInfo( pdfFile ),
			"pages": pages
		};
	}


	/**
	*	string source required="true" hint="Path to the pdf you want to add content to.
	*	string destination required="false" default="" hint="Path to the pdf you want to save as.
	*	string image required="true" hint="Path to the image you want to add to the source pdf.
	*	string pages required="false" default="1" hint="List of page numbers to add image to.
	*	numeric bottom required="false" default="0" hint="Number of pixels from the bottom of the PDF to the bottom of the image.
	*	numeric left required="false" default="0" hint="Number of pixels from the left of the PDF to the left of the image.
	**/
	public function addImage(
		required string source,
		string destination = "",
		required string image,
		string pages = 1,
		numeric bottom = 0,
		numeric left = 0,
		string pdfPathString = ""
	){

		var LOCAL = {};

		if( !len(trim(arguments.destination)) ){
			 // Default to saving back to the original file
			arguments.destination = arguments.source;
		}


		// We'll write the changes to a temporary file, then copy it back to the original file later.
		// This prevents file access errors.
		var fileName = createUUID() & '-' & getFileFromPath(arguments.destination);

		LOCAL.tmpDestination = getTempDirectory() & fileName;

		if( pdfPathString == "" ){
			LOCAL.fullPathToInputFile = arguments.source;
		} else {
			//This is done because the path changes at the end of the process for the previous image.
			LOCAL.fullPathToInputFile = pdfPathString;
		}

		LOCAL.savedErrorMessage = "";
		LOCAL.fullPathToWatermark = arguments.image;
		LOCAL.fullPathToOutputFile = LOCAL.tmpDestination;

		try{

			// create PdfReader instance to read in source pdf
			LOCAL.pdfReader = createObject("java", "com.lowagie.text.pdf.PdfReader").init(LOCAL.fullPathToInputFile);
			LOCAL.totalPages = pdfReader.getNumberOfPages();

			// create PdfStamper instance to create new watermarked file
			LOCAL.outStream = createObject("java", "java.io.FileOutputStream").init(LOCAL.fullPathToOutputFile);
			LOCAL.pdfStamper = createObject("java", "com.lowagie.text.pdf.PdfStamper").init(LOCAL.pdfReader, LOCAL.outStream);

			// Read in the watermark image
			LOCAL.img = createObject("java", "com.lowagie.text.Image").getInstance(LOCAL.fullPathToWatermark);

				// adding content to specific page
			for( var pageNumber = 1; pageNumber <= pages; pageNumber++ ){
				LOCAL.content = pdfStamper.getOverContent( javacast("int", pageNumber ) );
				LOCAL.img.setAbsolutePosition(arguments.left, arguments.bottom); // (horizontal position, vertical position)
				LOCAL.content.addImage(LOCAL.img);
			}

			// closing PdfStamper will generate the new PDF file
			if( isDefined("LOCAL.pdfStamper") ){
				LOCAL.pdfStamper.close();
			}

			if( isDefined("LOCAL.outStream") ){
				LOCAL.outStream.close();
			}

			LOCAL.img = "";
			lock timeout="3" name="#arguments.source#" type="exclusive"{
				fileMove(LOCAL.tmpDestination,arguments.destination);
			}
			// writeDump(local);abort;
		} catch( any e ){
			LOCAL.savedErrorMessage = e.message ;
			writeDump( cfcatch );abort;
		}
		return arguments.destination;
	}
}
