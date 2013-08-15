module.exports = (grunt) ->
  path = require 'path'

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    outputDir: path.join(__dirname, 'build')

    clean: ['<%= outputDir %>']

    copy:      
      main:
        files: [
          expand: true
          cwd: 'static/'
          src: '**'
          dest: '<%= outputDir %>/'
        ]        

    lsc: 
      app:
        files:
          '<%= outputDir %>/app.js': ['ls/**/*.ls']
        options:
          join: true      

    jade:
      main:
        options:
          pretty: true
        files: [
          expand: true
          cwd: 'jade/'
          src: '**'
          dest: '<%= outputDir %>/'
          filter: 'isFile'
          ext: '.html'
        ]
 
    stylus:
      main:
        options:
          use: [
            require 'nib'
          ]
        files:
          '<%= outputDir %>/app.css': ['stylus/app.styl']

    watch:
      ls:
        files: 'ls/**/*.ls'
        tasks: ['lsc']
      jade:
        files: 'jade/**/*.jade'
        tasks: ['jade']
      stylus:
        files: 'stylus/**/*.styl'
        tasks: ['stylus']


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-lsc'

  grunt.registerTask 'default', [
    'init', 'clean', 'copy', 'debug'
    'lsc', 'jade', 'stylus'
    'watch'
  ]
  grunt.registerTask 'init', () ->
    grunt.file.mkdir grunt.config('outputDir')

  grunt.registerTask 'debug', () ->
    nwPkgPath = path.join(grunt.config('outputDir'), 'package.json')
    nwPkg = grunt.file.readJSON nwPkgPath
    nwPkg.window.toolbar = true
    grunt.file.write nwPkgPath, JSON.stringify(nwPkg)
