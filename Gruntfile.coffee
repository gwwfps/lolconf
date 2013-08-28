module.exports = (grunt) ->
  path = require 'path'
  _ = grunt.util._

  nwModules = _.map _.keys(grunt.file.readJSON('package.json').dependencies), (name) ->
    path.join 'node_modules', name, '**'

  grunt.initConfig    
    outputDir: path.join(__dirname, 'build')

    clean: ['<%= outputDir %>']

    copy:      
      main:
        files: [
          expand: true
          src: _.union ['package.json', 'fonts/*', 'bower_components/**'], nwModules
          dest: '<%= outputDir %>/'
        ]        
      probe:
        files: [
          '<%= outputDir %>/lolconf-probe.exe':  path.join process.env.GOPATH, 'bin', 'lolconf-probe.exe'
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

    shell:
      probe:
        command: 'go get github.com/gwwfps/lolconf-probe'
        options:
          stdout: true

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
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'default', [
    'init', 'clean', 'shell', 'copy', 'debug'
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
