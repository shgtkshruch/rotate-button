'use strict';

gulp = require 'gulp'
$ = require('gulp-load-plugins')()
browserSync = require 'browser-sync'

config = 
  src: './src'
  dest: './dest'

gulp.task 'browser-sync', ->
  browserSync
    watchOptions:
      debounceDelay: 0
    server:
      baseDir: config.dest
    notify: false
    reloadDelay: 0

gulp.task 'jade', ->
  gulp.src config.src + '/index.jade'
    .pipe $.plumber()
    .pipe $.jade
      pretty: true
    .pipe gulp.dest config.dest
    .pipe browserSync.reload
      stream: true

gulp.task 'sass', ->
  gulp.src config.src + '/styles/**/*.scss'
    .pipe $.plumber()
    .pipe $.filter '**/style.scss'
    .pipe $.rubySass
      style: 'expanded'
      require: ['bourbon', 'breakpoint']
      bundleExec: true
    .pipe $.autoprefixer 'last 2 version', 'ie 8', 'ie 7'
    .pipe gulp.dest config.dest + '/styles'
    .pipe browserSync.reload
      stream: true

gulp.task 'coffee', ->
  gulp.src config.src + '/scripts/*.coffee'
    .pipe $.plumber()
    .pipe $.changed config.dest,
      extension: '.js'
    .pipe $.coffee()
    .pipe gulp.dest config.dest + '/scripts'
    .pipe browserSync.reload
      stream: true

gulp.task 'default', ['build', 'browser-sync'], ->
  gulp.watch config.src + '/index.jade', ['jade']
  gulp.watch config.src + '/styles/*.scss', ['sass']
  gulp.watch config.src + '/scripts/*.coffee', ['coffee']

gulp.task 'build', ['jade', 'sass', 'coffee']
