angular.module \lolconf .factory \LCInicfgParser, (LC-logger) ->
  require! {
    read: fs.read-file-sync
    write: fs.write-file-sync
  }
  {each, first, last, tail, initial, clone-deep, contains} = require 'lodash'

  parse-error = ->
    throw new Error 'Error parsing game configuration file.'

  class ParsedConfig
    (@path) ->
      @sections = {}    
    set-value: !(section, key, value) -->
      if !@sections[section]
        @sections[section] = {}
      @sections[section][key] = value
    get-value: (section, key) ->
      if section of @sections then @sections[section][key] else void
    write-to-file: !->
      lines = []
      for section, values of @sections
        lines.push '[' + section + ']'
        for key, value of values
          lines.push key + '=' + value
      LC-logger.debug "Writing to config file @ %s", @path
      write @path, (lines.join '\n')  

  parse = (path) ->
    config = new ParsedConfig path
    section = ''
    lines = read path .to-string! .split '\n'
    each lines, !(line) ->
      line = line.trim!
      if (first line) == '[' and (last line) == ']'
        section := (initial tail line).join ''
      else if contains line, '='
        if !section
          parse-error!
        (config.set-value section).apply config, (line.split '=')
      else if line
        parse-error!
    config

  {
    parse: parse
  }

