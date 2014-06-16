#!/usr/bin/env node

fs = require 'fs'
path = require 'path'
program = require 'commander'
lib  = path.join path.dirname(fs.realpathSync(__filename)), '../lib'
md2resume = require path.join(lib, 'markdown-resume')

# Executable options
program
  .usage('[options] [source markdown file]')
  .option('--pdf', 'Output as PDF')
  .option('-t, --templateDir <templateDir>', 'Specify the template directory', path.join(__dirname, '../templates/default'))
  .parse(process.argv)

  # Filename
  sourceFile = program.args[0]

  if !sourceFile?
    console.log "No source file specified"
    console.log program.help()
    process.exit()

  # Get the basename of the source file
  sourceFileBasename = path.basename sourceFile, path.extname(sourceFile)

  sourceFileDir = path.dirname sourceFile

  # Make the output filename
  outputFileName = path.join sourceFileDir, sourceFileBasename + '.html'

  input = fs.readFileSync sourceFile, 'utf8'

  # Need to write these files async
  if program.pdf
    pdfOutputFileName = path.join sourceFileDir, sourceFileBasename + '.pdf'

    md2resume.generate input, { format: 'pdf', templateDir: program.templateDir }, (err, out) ->
      if err?
        return console.log err

      #console.log "OUT", pdfOutput

      fs.writeFile pdfOutputFileName, out, 'binary', (err) ->
        console.log "Wrote pdf to: #{pdfOutputFileName}"
  else
    md2resume.generate input, { templateDir: program.templateDir }, (err, out) ->
      if err?
        return console.log err

      # Write the file contents
      fs.writeFile outputFileName, out, (err) ->
       console.log "Wrote html to: #{outputFileName}"

