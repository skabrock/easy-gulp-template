'use strict'

raw = 'assets/'
cooked = 'build/'

gulp = require('gulp')
rigger = require('gulp-rigger')
slim = require('gulp-slim')
sass = require('gulp-sass')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
es = require('event-stream')
gutil = require('gulp-util')
uglify = require('gulp-uglify')
cssnano = require('gulp-cssnano')
babel = require('gulp-babel')
livereload = require('gulp-livereload')
rimraf = require('rimraf')
iconfont = require('gulp-iconfont')
imagemin = require('gulp-imagemin')
pngquant = require('imagemin-pngquant')
rename = require('gulp-rename')
fs = require('fs')

path =
  src:
    slim: [raw + 'slim/*.slim', raw + 'slim/@*/*.slim']
    html: [raw + 'html/*.html', raw + 'html/@*/*.html']
    styles: [raw + 'stylesheets/@*.{scss,sass}', raw + 'stylesheets/**/@*.{scss,sass}']
    js: raw + 'javascripts/**/@*.js'
    coffee: raw + 'javascripts/**/@*.coffee'
    fonts: [raw + 'fonts/**/*.{eot,ttf,woff,woff2,svg}', '!' + raw + 'fonts/@*/*.svg']
    iconfont: raw + 'fonts/@*/*.{eot,ttf,woff,woff2,svg}'
    img: raw + 'img/**/*.{jpg,png,gif,svg}'
  watch:
    slim: raw + 'slim/**/*.slim'
    html: raw + 'html/**/*.html'
    styles:  raw + 'stylesheets/**/*.{sass,scss,css}'
    js: raw + 'javascripts/**/*.js'
    coffee: raw + 'javascripts/**/*.coffee'
    fonts:  raw + 'fonts/**/*.{eot,ttf,woff,woff2,svg}'
    iconfont: raw + 'fonts/@*/*.{eot,ttf,woff,woff2,svg}'
    img:  raw + 'img/**/*.{jpg,png,gif,svg}'
  build:
    html: cooked
    styles: cooked
    js: cooked
    fonts: cooked + 'fonts'
    img: cooked + 'img'
  clean: cooked


gulp.task 'slim:build', ->
  return gulp.src path.src.slim
    .pipe rigger()
    .pipe slim({pretty: true}).on('error', gutil.log)
    .pipe gulp.dest(path.build.html)
    .pipe livereload()

gulp.task 'html:build', ->
  return gulp.src path.src.html
    .pipe rigger()
    .pipe gulp.dest(path.build.html)
    .pipe livereload()

gulp.task 'styles:build', ->
  return gulp.src path.src.styles
    .pipe sass().on('error', gutil.log)
    .pipe cssnano()
    .pipe rename (path)->
      if path.basename[0] == '@'
        path.basename = path.basename.slice(1)
    .pipe gulp.dest(path.build.styles)
    .pipe livereload()

gulp.task 'coffee:build', ->
  return gulp.src path.src.coffee
    .pipe rigger()
    .pipe coffee({bare: true}).on('error', gutil.log)
    .pipe babel({presets: ['es2015']})
    .pipe uglify()
    .pipe rename (path)->
      if path.basename[0] == '@'
        path.basename = path.basename.slice(1)
    .pipe gulp.dest(path.build.js)
    .pipe livereload()

gulp.task 'js:build', ->
  return gulp.src path.src.js
    .pipe rigger()
    .pipe babel({presets: ['es2015']})
    .pipe uglify()
    .pipe rename (path)->
      if path.basename[0] == '@'
        path.basename = path.basename.slice(1)
    .pipe gulp.dest(path.build.js)
    .pipe livereload()

gulp.task 'getIconfontName', ->
  return gulp.src path.src.iconfont
    .pipe rename (file)->
      path.iconfontname = file.dirname.slice(1)

gulp.task 'iconfont:build', ['getIconfontName'], ->
  return gulp.src path.src.iconfont
    .pipe iconfont
      fontName: path.iconfontname
      prependUnicode: true
      normalize: true
      fontHeight: 1001
      formats: ['ttf', 'eot', 'woff', 'woff2', 'svg']
    .on 'glyphs', (glyphs)->
      console.log glyphs
    .pipe gulp.dest(path.build.fonts + '/' + path.iconfontname)
    .pipe livereload()

gulp.task 'fonts:build', ['iconfont:build'], ->
  return gulp.src path.src.fonts
    .pipe gulp.dest(path.build.fonts)
    .pipe livereload()

gulp.task 'img:build', ->
  return gulp.src path.src.img
    .pipe imagemin
      progressive: true
      svgoPlugins: [{removeViewBox: false}]
      use: [pngquant()]
    .pipe gulp.dest(path.build.img)
    .pipe livereload()

gulp.task 'clean', (cb)->
  return rimraf path.clean, cb

gulp.task 'lr:listen', ->
  livereload.listen()

gulp.task 'watch', ->
  gulp.watch path.watch.slim, ['slim:build']
  gulp.watch path.watch.html, ['html:build']
  gulp.watch path.watch.styles, ['styles:build']
  gulp.watch path.watch.js, ['js:build']
  gulp.watch path.watch.coffee, ['coffee:build']
  gulp.watch path.watch.fonts, ['fonts:build']
  gulp.watch path.watch.img, ['img:build']

gulp.task 'build', [
  'slim:build',
  'html:build',
  'styles:build',
  'js:build',
  'coffee:build',
  'fonts:build',
  'img:build']

gulp.task 'refresh', ['clean', 'build']

gulp.task 'default', ['lr:listen', 'build', 'watch']
