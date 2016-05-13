'use strict'

gulp = require('gulp')
rigger = require('gulp-rigger')
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

path =
  src:
    styles: ['assets/stylesheets/application.{sass,scss}', 'assets/stylesheets/admin.{sass,scss}']
    js: ['assets/javascripts/application.coffee', 'assets/javascripts/admin.coffee']
    js_vendor: 'assets/javascripts/*-vendor.{coffee,js}'
    fonts: 'assets/fonts/**/*.{eot,ttf,woff,woff2,svg}'
    iconfont: 'assets/interface_font'
    img: 'assets/img/**/*.{jpg,png,gif,svg}'
  build:
    styles: 'build/'
    js: 'build/'
    js_vendor: 'assets/javascripts/*-vendor.{coffee,js}'
    fonts: 'build/fonts'
    iconfont: 'build/fonts/interface'
    img: 'build/img'
  watch:
    styles: 'assets/stylesheets/**/*.{sass,scss,css}'
    js: ['assets/javascripts/**/*.{coffee,js}', '!assets/javascripts/*-vendor.{coffee,js}']
    js_vendor: 'assets/javascripts/*-vendor.{coffee,js}'
    fonts: 'assets/fonts/**/*.{eot,ttf,woff,woff2,svg}'
    iconfont: 'assets/'
    img: 'assets/img/**/*.{jpg,png,gif,svg}'
  clean: './build'

gulp.task 'styles:build', ->
  return gulp.src path.src.styles
    .pipe sass().on('error', gutil.log)
    .pipe cssnano()
    .pipe gulp.dest(path.build.styles)
    .pipe livereload()

gulp.task 'js:build', ->
  return gulp.src path.src.js
    .pipe rigger()
    .pipe coffee({bare: true}).on('error', gutil.log)
    .pipe babel({presets: ['es2015']})
    .pipe uglify()
    .pipe gulp.dest(path.build.js)
    .pipe livereload()

gulp.task 'js_vendor:build', ->
  return gulp.src path.src.js_vendor
    .pipe rigger()
    .pipe babel({presets: ['es2015']})
    .pipe uglify()
    .pipe gulp.dest(path.build.js)
    .pipe livereload()

gulp.task 'fonts:build', ->
  return gulp.src path.src.fonts
    .pipe gulp.dest(path.build.fonts)
    .pipe livereload()

gulp.task 'iconfont:build', ->
  return gulp.src path.src.iconfont
    .pipe iconfont({fontName: 'interface-font',prependUnicode: true,normalize: true,fontHeight: 1001,formats: ['ttf', 'eot', 'woff', 'woff2', 'svg']}).on 'glyphs', (glyphs)->
      console.log(glyphs)
    .pipe gulp.dest(path.build.iconfont)
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
  gulp.watch path.watch.styles, ['styles:build']
  gulp.watch path.watch.js, ['js:build']
  gulp.watch path.watch.js_vendor, ['js_vendor:build']
  gulp.watch path.watch.fonts, ['fonts:build']
  gulp.watch path.watch.iconfont, ['iconfont:build']
  gulp.watch path.watch.img, ['img:build']

gulp.task 'build', ['styles:build', 'js:build', 'js_vendor:build', 'fonts:build', 'iconfont:build', 'img:build']

gulp.task 'refresh', ['clean', 'build']

gulp.task 'default', ['lr:listen', 'build', 'watch']
