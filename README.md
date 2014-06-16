markdown-resume.js
==================

Turn a simple markdown document into a resume in HTML and PDF.

This module was inspired by the PHP script [markdown-resume](https://github.com/there4/markdown-resume).

## Features

* PDF generation via wkhtmltopdf
* Simple Markdown formatting
* Multiple Templates

## Quickstart

The generated files will be put in the same directory as your source file.

    # Generate HTML file
    md2resume ../resumes/2014-06-06.md

    # Generate HTML file and specify a template
    md2resume ../resumes/2014-06-06.md -t ../templates/_advanced

    # Generate PDF file
    md2resume --pdf my-resume-file.md

    # Generate PDF file and specify a template
    md2resume --pdf my-resume-file.md -t ../templates/_advanced

## Use as a node module

    var md2resume = require('markdown-resume')

    # Generate HTML
    md2resume.generate('my-resume-file.md', function(err, out) {
        # ... do something with 'out'
    });

    # Same as a above
    md2resume.generate('my-resume-file.md', { format: 'html' }, function(err, out) { ... });

    # Generate PDF
    md2resume.generate('my-resume-file.md', { format: 'pdf' }, function(err, pdf) {
        # ... do something with pdf
    });

## Building your own Template

The recommended way of building your own template is to copy one of the following directories ```templates/_unstyled``` or ```templates/_advanced```, rename it, and then start hacking away. 

```templates/_unstyled``` is a barebones HTML/LESS starter template. Nothing tricky in there.

```templates/_advanced``` is also a barebones HTML/LESS starter template, however it includes a Gulp build process to make template development dead simple. You tell it which resume file to load at runtime and Gulp takes care of live-reloading your resume if you change your template LESS files. See the **README.md** file in ```templates/_advanced``` for more information.

## Acknowledgments

This library was forked from [markdown-resume-js](https://github.com/c0bra/markdown-resume-js).