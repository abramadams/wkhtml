<cfscript>
	// example init for windows server
	// wkhtmltopdf = new com.wkhtml.wkhtmltopdf( expandPath('./bin/win64/wkhtmltoimage.exe') );
	// Linux servers (at least ubuntu servers) need to run wkhtmltopdf through xvfb-run to get a simulated screen
	wkhtmltopdf = new com.wkhtml.pdf( '/usr/local/bin/wkhtmltopdf' );
	html = new http( url = 'https://wikidocs.adobe.com/wiki/display/coldfusionen/Home', resolveurl = true, charset = "utf-8" ).send().getPrefix();
	results = wkhtmltopdf.create(
			// url = 'https://wikidocs.adobe.com/wiki/display/coldfusionen/Home', // uncomment to test with url
			html = trim(html.fileContent),
			options = {
				"viewport-size":"1200x1080"
				,"image-quality":100
				,"margin-bottom": 0
				,"margin-left": "5mm"
				,"margin-right": "5mm"
				,"margin-top": 5
				,"orientation": "portrait"
				,"encoding": "utf-8"
				,"user-style-sheet": expandPath("print.css")
			},
			writeToFile = false, // true will write the file and return a struct containing the path (and other info)
			destination = "#expandPath('.')#test.pdf"
	);
	// if you set writeToFile to true, uncomment this and comment out the cfheader/cfcontent block below
	// writeDump(results);
</cfscript>

<cfheader name="Content-Disposition" value="inline; filename=test.pdf">
<cfcontent type="application/pdf" file="#expandPath('.')#test.pdf">