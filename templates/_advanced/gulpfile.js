var args = require('yargs').argv;
var clean = require('gulp-clean');
var connect = require('gulp-connect');
var fs = require('fs');
var gulp = require('gulp');
var less = require('gulp-less');
var path = require('path');
var rename = require("gulp-rename");
 
var serverport = 8080;

// Set the path to the resume you are building a theme for
var filepath = args.resume || 'test/resume.html';
var resume = path.resolve(__dirname, '../../', filepath);

// Make sure the resume file exists
if (!fs.existsSync(resume)) {
  throw new Error(resume + ' does not exists. Stopping...');
}

gulp.task('clean', function(cb){
  return gulp.src('.tmp/index.html', {read: false})
    .pipe(clean());
});

gulp.task('less', function() {
  return gulp.src('assets/less/resume.less')
    .pipe(less())
    .on('error', console.log)
    .pipe(gulp.dest('.tmp'))
    .pipe(connect.reload());
});

gulp.task('html', function() {
  return gulp.src(resume)
    .pipe(rename('index.html'))
    .pipe(gulp.dest('.tmp'))
    .pipe(connect.reload());
});

gulp.task('watch', ['html','less'], function() {
  gulp.watch('assets/less/{*,/}*.less', ['less']);
  gulp.watch(resume, ['html']);
});

gulp.task('connect', function() {
  return connect.server({
    root: [__dirname + '/.tmp'],
    port: serverport,
    livereload: true
  });
});

gulp.task('serve', ['watch', 'connect']);

