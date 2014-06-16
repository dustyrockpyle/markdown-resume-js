# Advanced Base Theme for Markdown-Resume-JS

This is an unstyled theme using gulp to automatically compile less and livereload the browser when files change. This is useful for theme development and made for more advanced users who are familiar with gulp. If you are not familiar with gulp, it is probably better to use the basic "_unstyled" theme.

## Getting Started
1. Copy this theme directory
2. Run ```$ npm install``` to install all node dependencies
3. Run ```$ gulp serve --resume resume.html``` to start the server and tell grunt which file in the resumes directory to load. The resumes directory should be at the top level of markdown-resume-js. If it is not, create it and put your resume files in there.

## Dependencies
- [LESS](http://lesscss.org/)
- [Gulp](http://gulpjs.com/)