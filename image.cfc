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
*   @version 0.0.1
*   @dependencies wkhtmltoimage http://wkhtmltopdf.org/
* 				  http://madalgo.au.dk/~jakobt/wkhtmltoxdoc/wkhtmltoimage_0.10.0_rc2-doc.html
* 				  for linux distros, xvfb-run must also be installed
*   @updated 7/19/2016
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
					? expandPath('./com/wkhtml/bin/wkhtmltox/bin/wkhtmltoimage')
					: expandPath('./com/wkhtml/bin/win64/wkhtmltoimage-amd64.exe');
			}else{
				binaryPath = server.os.name contains "nix"
					? expandPath('./com/wkhtml/bin/wkhtmltoimage-i386')
					: expandPath('./com/wkhtml/bin/win64/wkhtmltoimage-i386.exe');
			}
		}
		// If binary path doesn't exist, pass the binary name and assume
		// it is in the computer's "PATH"
		binaryPath = fileExists( binaryPath )
					? binaryPath
					: "wkhtmltoimage";

		setBinaryPath( tmpPath & binaryPath );
		setTempDir( tempDir );
		set_MISSING_URL_IMAGE_MESSAGE( "You need to provide either a URL or HTML string to convert to image" );
	}
// General Options
// --allow							<path>						Allow the file or files from the specified folder to be loaded (repeatable)
// --checkbox-checked-svg			<path>						Use this SVG file when rendering checked checkboxes
// --checkbox-svg					<path>						Use this SVG file when rendering unchecked checkboxes
// --cookie							<name> <value>				Set an additional cookie (repeatable)
// --cookie-jar						<path>						Read and write cookies from and to the supplied cookie jar file
// --crop-h							<int>						Set height for croping
// --crop-w							<int>						Set width for croping
// --crop-x							<int>						Set x coordinate for croping
// --crop-y							<int>						Set y coordinate for croping
// --custom-header					<name> <value>				Set an additional HTTP header (repeatable)
// --custom-header-propagation									Add HTTP headers specified by --custom-header for each resource request.
// --no-custom-header-propagation								Do not add HTTP headers specified by --custom-header for each resource request.
// --debug-javascript											Show javascript debugging output
// --no-debug-javascript										Do not show javascript debugging output (default)
// --encoding						<encoding>					Set the default text encoding, for input
// -H,								--extended-help				Display more extensive help, detailing less common command switches
// -f,								--format	<format>		Output file format (default is jpg)
// --height							<int>						Set screen height (default is calculated from page content) (default 0)
// -h,								--allow--help				Display help
// --htmldoc													Output program html help
// --images														Do load or print images (default)
// --no-images													Do not load or print images
// -n,								--disable-javascript		Do not allow web pages to run javascript
// --enable-javascript											Do allow web pages to run javascript (default)
// --javascript-delay				<msec>						Wait some milliseconds for javascript finish (default 200)
// --load-error-handling			<handler>					Specify how to handle pages that fail to load: abort, ignore or skip (default abort)
// --disable-local-file-access									Do not allowed conversion of a local file to read in other local files, unless explecitily allowed with --allow
// --enable-local-file-access									Allowed conversion of a local file to read in other local files. (default)
// --manpage													Output program man page
// --minimum-font-size				<int>						Minimum font size
// --password						<password>					HTTP Authentication password
// --disable-plugins											Disable installed plugins (default)
// --enable-plugins												Enable installed plugins (plugins will likely not work)
// --post							<name> <value>				Add an additional post field (repeatable)
// --post-file						<name> <path>				Post an additional file (repeatable)
// -p,								--proxy	<proxy>				Use a proxy
// --quality						<int>						Output image quality (between 0 and 100) (default 94)
// --radiobutton-checked-svg		<path>						Use this SVG file when rendering checked radiobuttons
// --radiobutton-svg				<path>						Use this SVG file when rendering unchecked radiobuttons
// --readme														Output program readme
// --run-script						<js>						Run this additional javascript after the page is done loading (repeatable)
// -0,								--disable-smart-width*		Use the specified width even if it is not large enough for the content
// --stop-slow-scripts											Stop slow running javascripts (default)
// --no-stop-slow-scripts										Do not Stop slow running javascripts (default)
// --transparent*												Make the background transparent in pngs
// --user-style-sheet				<url>						Specify a user style sheet, to load with every page
// --username						<username>					HTTP Authentication username
// -V,								--version					Output version information an exit
// --width							<int>						Set screen width (default is 1024) (default 1024)
// --window-status					<windowStatus>				Wait until window.status is equal to this string before rendering page
// --zoom							<float>						Use this zoom factor (default 1)

	public function create(
			string url,
			string html,
			string destination = "#getTempDirectory()#wkhtmltoimage-#hash(createUUID())#.png",
			struct options = {},
			boolean writeToFile = true
	){
		return super.create( argumentCollection:arguments );
	}

}