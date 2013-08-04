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
        files:
          '<%= outputDir %>/app.css': ['stylus/*.stylus']


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-lsc'

  grunt.registerTask 'default', [
    'init', 'clean', 'copy'
    'lsc', 'jade', 'stylus'
  ]
  grunt.registerTask 'init', () ->
    grunt.file.mkdir grunt.config('outputDir')
