#WKHTML - CFC wrapper for wkhtmlto[pdf/image]
This library is a simple wrapper for the [wkhtmltopdf](http://wkhtmltopdf.org/) command line tool. Currently only the _wkhtmltopdf_ tool is supported, but I plan to support wkhtmltoimage soon.
##Installation
First you need to install __wkhtmltopdf__.  The instructions will vary depending on your OS, but for those lucky enough to run Ubuntu servers, just do:

` sudo apt-get install wkhtmltopdf xvfb`

Chances are, if you are on linux you already have wkhtmltopdf installed, however [xvfb - A virtual framebuffer X server for X](http://www.x.org/archive/X11R7.6/doc/man/man1/Xvfb.1.xhtml) is generally not.
For other OS installation instructions, see http://wkhtmltopdf.org/.

__Note__: Windows servers do not require additional software (other than wkhtmltopdf)
__UPDATE__
> you can pass in the `binaryPath` to the init methods of `pdf.cfc`/`image.cfc`.  This repo contains various Windows/Linux versions in the `/bin/` directory.
> 
Once you have wkhtmltopdf (_and xvfb if needed_), simply copy the com/wkhtml folder to wherever your components live.

##Usage
Check out the `index.cfm` file for a basic sample usage. It looks something like:
__HTML to PDF__
```javascript
wkthmltopdf = new com.wkhtml.pdf(); 
//if wkhtmltopdf executable is not in your system path, you will need to pass it in
// like: .. new com.wkhtml.pdf('/usr/local/bin/wkhtmltopdf');
results = wkhtmltopdf.create(
            url = 'https://wikidocs.adobe.com/wiki/display/coldfusionen/Home',
            // instead of url, you can also include inline html like so:
            // html = "<h1>Some Title</h1><p>some text</p>",
            options = { // standard wkhtmltopdf options
                "viewport-size":"1200x1080" // default
                ,"image-quality":100
                ,"margin-bottom": 0
                ,"margin-left": "5mm"
                ,"margin-right": "5mm"
                ,"margin-top": 5
                ,"orientation": "portrait" // default
                ,"encoding": "utf-8"                
                ,"header-html": "http://www.sydneytripslipfallcompensation.com/images/header.jpg"
                ,"footer-html": "<footer style='text-align:center;'>This, my friend, is a cool footer.</footer>"
                ,"user-style-sheet": expandPath("print.css")
            },
            writeToFile = false, // true will write the file and return a struct containing the path (and other info)
            destination = "#expandPath('.')#test.pdf"
    );
```
With the above code, the `results` variable will contain the actual pdf binary, to which you'd use cfheader/cfcontent to stream to the browser.

__HTML to IMAGE__
```javascript
    wkhtmltoimage = new wkhtml.image( binaryPath = expandPath('./com/wkhtml/bin/wkhtmltoimage-amd64') );
    html = new http( url = 'https://www.google.com', resolveurl = true, charset = "utf-8" ).send().getPrefix();
    results = wkhtmltoimage.create(
        html = trim( html.fileContent ),
        options = {
                "quality" : 100,
                "encoding" : "utf-8",
                "transparent" : "",
                "images": ""
            },
            writeToFile = false, // true will write the file and return a struct containing the path (and other info)
            destination = "#getTempDirectory()#wkhtmltoimage-#hash(createUUID())#.png"
    );
```
Similar to the wkhtmltopdf, this will take an html string and convert it to an image (PNG).

##PDF Utilities
The `pdf.cfc` component also has methods to retrieve information about the pdf(`getInfo`), as well as add an image to the pdf (`addImage`).  This can be used to overlay custom html on top of a PDF, for example:
```javascript
public function addImageToPDF( pdfSource, html, pdfDestination ){
    var wkhtmlpdf = wkhtml.pdf();
    var wkhtmlimage = wkhtml.image();
    var imageDestination = "#getTempDirectory()#wkhtmltoimage-#hash(createUUID())#.png";        
    // Convert user provided HTML (i.e. content from an in-browser rich text editor) to a PNG
    var renderedImage = wkhtmlimage.create(
        html = html,
        options = {
                "quality" : 100,
                "encoding" : "utf-8",
                "transparent" : "", //NOTE blank values translate to commandline flags that do not accept values (i.e. --transparent --images)
                "images": "",
                "zoom": .65,
                "crop-h": 400,
                "crop-w": 400
        },
        writeToFile = true,
        destination = imageDestination
    );
    // Adds image to PDF (will create or overwrite destination)
    wkhtmlpdf.addImage(
                source = pdfSource,
                destination = pdfDestination,
                image = renderedImage.file,
                left = 10, // pixesl from left of pdf
                bottom = 100, // pixels from bottom of pdf
                pages = 1 // List of page numbers to add image to
            );
}
```

There are many options for each of these two functions.  See the `pdf.cfc` and `image.cfc` files for specific options, or visit [wkhtmltopdf](http://wkhtmltopdf.org/) documentation regarding PDF generation and [wkhtmltoimage](http://madalgo.au.dk/~jakobt/wkhtmltoxdoc/wkhtmltoimage_0.10.0_rc2-doc.html) for documentation regarding IMAGE generation.