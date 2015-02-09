var resume = require('./lib/markdown-resume');
var gulp = require('gulp');
var connect = require('gulp-connect');
var watch = require('gulp-watch');
var path = require('path');
var fs = require('fs');
var config;

var configName = 'config.json';

var makeConfig = function(){
	config = JSON.parse(fs.readFileSync(configName));
};


gulp.task('watch', function(){
	var inputWatch;
	var outputWatch;
	makeConfig();	
	connect.server({
		root: path.dirname(config.input),
		livereload: true,
		port: config.port
	});
	gulp.src(configName)
	    .pipe(watch(configName, function(file){
	    	makeConfig();
	    	if(false && inputWatch) {
	    		inputWatch.emit('end');
	    		outputWatch.emit('end');
	    	}
	    	var sources = [config.input, path.join(config.templateDir, "**", "*")];
	    	inputWatch = gulp.src(sources)
	    	    .pipe(watch(sources, function(files){
	    	    	resume.generate(config.input, {templateDir: config.templateDir}, function(err, out){
	    	    		fs.writeFile(config.output, out);
	    	    	});
	    	    }));
	    	outputWatch = gulp.src(config.output)
	    	    .pipe(watch(config.output))
	    	    .pipe(connect.reload());
	    }));
});
