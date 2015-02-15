module.exports = (grunt) ->
  path = require 'path'
  _ = grunt.util._

  nwModules = _.map _.keys(grunt.file.readJSON('package.json').dependencies), (name) ->
    path.join 'node_modules', name, '**'

  grunt.initConfig
    outputDir: path.join(__dirname, 'build')

    clean: ['<%= outputDir %>', 'images/generated']

    nodewebkit:
      options:
        platforms: ['win']
        buildDir: './release'
      src: ['./build/**/*']

    copy:
      main:
        files: [
          expand: true
          src: _.union ['package.json', 'fonts/*', 'bower_components/**', 'data/*'], nwModules
          dest: '<%= outputDir %>/'
        ]
      probe:
        files: [
          '<%= outputDir %>/lolconf-probe.exe':  path.join process.env.GOPATH, 'bin', 'lolconf-probe.exe'
        ]
      images:
        files: [
          expand: true
          src: ['images/**']
          dest: '<%= outputDir %>/'
        ]

    lsc:
      app:
        files:
          '<%= outputDir %>/app.js': ['ls/**/*.ls']
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


  (require 'load-grunt-tasks') grunt

  grunt.registerTask 'default', [
    'build', 'debug', 'watch'
  ]

  grunt.registerTask 'build', [
    'init', 'clean', 'copy:main'
    'lsc', 'stylus', 'jade'
    'shell:probe', 'copy:probe', 'copy:images'
  ]

  grunt.registerTask 'build:nw', [
    'build', 'nodewebkit'
  ]

  grunt.registerTask 'init', () ->
    grunt.file.mkdir grunt.config('outputDir')

  grunt.registerTask 'debug', () ->
    nwPkgPath = path.join(grunt.config('outputDir'), 'package.json')
    nwPkg = grunt.file.readJSON nwPkgPath
    nwPkg.window.toolbar = true
    nwPkg.window.height += 34
    grunt.file.write nwPkgPath, JSON.stringify(nwPkg)
