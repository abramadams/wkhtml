#WKHTML - CFC wrapper for wkhtmlto[pdf/image]
This library is a simple wrapper for the [wkhtmltopdf](http://wkhtmltopdf.org/) command line tool. Currently only the _wkhtmltopdf_ tool is supported, but I plan to support wkhtmltoimage soon.
##Installation
First you need to install __wkhtmltopdf__.  The instructions will vary depending on your OS, but for those lucky enough to run Ubuntu servers, just do:

` sudo apt-get install wkhtmltopdf xvfb`

Chances are, if you are on linux you already have wkhtmltopdf installed, however [xvfb - A virtual framebuffer X server for X](http://www.x.org/archive/X11R7.6/doc/man/man1/Xvfb.1.xhtml) is generally not.
For other OS installation instructions, see http://wkhtmltopdf.org/.

__Note__: Windows servers do not require additional software (other than wkhtmltopdf)

Once you have wkhtmltopdf (_and xvfb if needed_), simply copy the com/wkhtml folder to wherever your components live.

##Usage
Check out the `index.cfm` file for a basic sample usage. It looks something like:
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