
fs = require('fs')
path = require('path')
exec = require('child_process').exec
program = require('commander')
marked = require('marked')
cheerio = require("cheerio")
mustache = require('mustache')
less = require('less')
temp = require('temp')

installDir = path.join(__dirname, '..');

lessParser = null

# Set the Markdown processor options
marked.setOptions
  breaks: true # Use Github-flavored-markdown (GFM) which uses linebreaks differently

Object.defineProperty Object::, "extend",
  enumerable: false
  value: (from) ->
    props = Object.getOwnPropertyNames(from)
    dest = this
    props.forEach (name) ->
      if name of dest
        destination = Object.getOwnPropertyDescriptor(from, name)
        Object.defineProperty dest, name, destination

    return this

compileLess = (templateDir, file, callback) ->
  contents = fs.readFileSync path.join(templateDir, 'assets', 'less', file), 'utf8'
  lessParser.parse contents, (err, tree) ->
    css = ''
    
    if !err?
      css = tree.toCSS compress: true

    callback err, css

generate = (sourceFile, userOpts, callback) ->
  opts =
    format: 'html'
    templateDir: path.join(installDir, 'templates', 'default')

  opts.template = path.join(opts.templateDir, 'index.html')

  # No third argument, callback must be in the second position
  if !callback?
    callback = userOpts

  opts.extend userOpts

  # Setup the LESS Parser
  lessParser = new less.Parser
    # Specify search paths for @import directives
    paths: [path.join(opts.templateDir, 'assets/less'), path.join(opts.templateDir, 'assets/less/_partials')]

    # Specify a filename, for better error messages
    filename: 'resume.less' 

  if !sourceFile?
     return callback "Source not specified"

  # Default to treating the sourceFile argument as the contents of the file
  sourceContents = sourceFile

  # If the sourceFile argument IS an actual file, read it in
  if fs.existsSync(sourceFile)
    sourceContents = fs.readFileSync sourceFile, 'utf8'

  if !sourceContents? || sourceContents is ""
    return callback "Source is empty"

  # Load the template file
  template = fs.readFileSync opts.template, 'utf8'

  compileLess opts.templateDir, 'resume.less', (err, css) ->
    if err?
      return callback "Error processing resume.less: #{err}"

    # Convert the file to HTML
    resume = marked sourceContents

    # Get the title of the document
    $ = cheerio.load(resume)
    title = $('h1').first().text() + ' | ' + $('h2').first().text()

    # Use mustache to turn the generated html into a pretty document with Mustache
    rendered = mustache.render template,
      title  : title
      style  : css
      resume : resume
      nopdf  : opts.format != 'pdf'

    # Write the PDF if we're told to
    if opts.format is 'html'
      return callback undefined, rendered
    else if opts.format is 'pdf'
      # Alter the body class in the resume document in order to make it render right in PDF format
      pdfRendered = rendered.replace('body class=""', 'body class="pdf"')

      # Create temporary file to HTML source to
      pdfSourceFilename = temp.path({suffix: '.html'})

      # Create temporary file to write the PDF to
      pdfOutputFilename = temp.path({suffix: '.pdf'})

      fs.writeFileSync pdfSourceFilename, pdfRendered
      
      exec 'wkhtmltopdf ' + pdfSourceFilename + ' ' + pdfOutputFilename, (err, stdout, stderr) ->
        if err?
          return callback "Error writing pdf: #{err}"

        pdfContents = fs.readFileSync pdfOutputFilename, 'binary'

        return callback undefined, pdfContents

# Export module
module.exports =
  generate: generate
