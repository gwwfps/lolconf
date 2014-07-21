module.exports = (grunt) ->
  path = require 'path'
  _ = grunt.util._

  dependencies = _.map _.keys(grunt.file.readJSON('package.json').dependencies), (name) ->
    path.join 'node_modules', name, '**'

  grunt.initConfig
    outputDir: path.join(__dirname, 'build')
    appDir: path.join(__dirname, 'build/resources/app')

    clean: ['<%= appDir %>', 'images/generated']

    compress:
      nw:
        files: [
          src: ['**/*']
          dest: ''
          cwd: '<%= outputDir %>/'
          expand: true
        ]
        options:
          archive: 'lolconf.zip'
          mode: 'zip'

    copy:
      main:
        files: [
          expand: true
          src: _.union ['package.json', 'fonts/*', 'bower_components/**', 'data/*'], dependencies
          dest: '<%= appDir %>/'
        ]
      probe:
        files: [
          expand: true
          flatten: true
          src: path.join process.env.GOPATH, 'bin/lolconf-probe*'
          dest: '<%= appDir %>/'
        ]
      images:
        files: [
          expand: true
          src: ['images/**']
          dest: '<%= appDir %>/'
        ]

    coffee:
      node:
        expand: true
        flatten: true
        cwd: 'coffee/node'
        src: ['*.coffee']
        dest: '<%= appDir %>'
        ext: '.js'

    lsc:
      app:
        files:
          '<%= appDir %>/app.js': ['ls/**/*.ls']
        options:
          join: true
      spriteCrop:
        expand: true
        cwd: 'stylus/helpers'
        src: ['*.ls']
        dest: 'stylus/helpers'
        ext: '.js'
        options:
          bare: true

    jade:
      main:
        options:
          pretty: true
        files: [
          expand: true
          cwd: 'jade/'
          src: '**'
          dest: '<%= appDir %>/'
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
          '<%= appDir %>/app.css': ['stylus/app.styl']

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

    'download-atom-shell':
      version: '0.13.3'
      outputDir: '<%= outputDir %>/'
      downloadDir: 'atom_shell_download'
      rebuild: false


  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-compress'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-lsc'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-download-atom-shell'

  grunt.registerTask 'default', [
    'build', 'debug'
  ]

  grunt.registerTask 'build', [
    'clean', 'download-atom-shell', 'init', 'copy:main'
    'lsc', 'coffee:node', 'stylus', 'jade'
    'shell:probe', 'copy:probe', 'copy:images'
  ]

  grunt.registerTask 'build:pack', [
    'build', 'compress'
  ]

  grunt.registerTask 'build:watch', [
    'build', 'debug', 'watch'
  ]

  grunt.registerTask 'init', () ->
    grunt.file.mkdir grunt.config('appDir')

  grunt.registerTask 'debug', () ->
    appMetaPath = path.join(grunt.config('appDir'), 'package.json')
    appMetaData = grunt.file.readJSON appMetaPath
    appMetaData.debug = true
    grunt.file.write appMetaPath, JSON.stringify(appMetaData)
