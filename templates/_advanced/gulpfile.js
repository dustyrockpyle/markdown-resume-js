var args = require('yargs').argv;
var connect = require('gulp-connect');
var gulp = require('gulp');
var less = require('gulp-less');
var path = require('path');
var rename = require("gulp-rename");
 
var serverport = 8080;

// Set the path to the resume you are building a theme for
// var resume = "./test/resume.html";
var filename = args.resume || 'resume.html';
var resume = path.resolve(__dirname, '../../resumes/', filename);

console.log(resume);

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
    .pipe(gulp.dest('.tmp/'))
    .pipe(connect.reload());
});

gulp.task('watch', ['less'], function() {
  gulp.watch('assets/less/{*,/}*.less', ['less']);
});

gulp.task('connect', function() {
  return connect.server({
    root: [__dirname + '/.tmp'],
    port: serverport,
    livereload: true
  });
});

gulp.task('serve', ['html', 'watch', 'connect']);

