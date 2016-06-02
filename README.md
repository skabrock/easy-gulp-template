# Gulp & Bower Start KIT

Simple gulp project for quick start.

## QUICK START

Clone repository to your local machine

      git clone git@git.dowell.com.ua:shared/gulp-template.git

Install global dependencies:

      npm install -g gulp bower

Install packages:

      bower install
      npm install

All your source files located in assets directory by default.

Run to build application:

      gulp

You can see 'build/' directory in the root of your project.

Open **index.html** file in your browser to make sure everything is alright

## COMMANDS

All build commands:

      gulp slim:build
      gulp html:build
      gulp styles:build
      gulp js:build
      gulp coffee:build
      gulp fonts:build
      gulp img:build

Run all above functions:

      gulp build

Run  livereload server:

      gulp lr:listen

Remove generated folder with files inside:

      gulp clean

Generate favicon files for various devises from source file **assets/img/favicon.svg**

      gulp generate-favicon

Remove all favicon generated files

      gulp clean-favicon

The same as the build command but delete generated folder at first:

      gulp refresh

Watch changes in assets and build application:

      gulp watch

Main function which builds and watches all your assets. In most you need only this function:

      gulp


### NOTICE

* If you want to use html instead/with slim, just create **html** folder inside your assets.
* Use **@** as first symbol in js/coffee and css/sass/scss files for choosing only files you want to be compiled.
* Use **@** for mark your custom font folder.

**Designed in [Dowell](http:dowell.com.ua "Dowell")**
