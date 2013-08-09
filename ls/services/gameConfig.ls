angular.module \lolconf .factory \LCGameConfig, (LC-game-location) -> 
  require! {
    stream: fs.create-read-stream
    lazy
  }
  {first, last, tail, initial, split} = require 'prelude-ls'
  {clone-deep} = require 'lodash'

  supported-keys = {}

  parse-error = ->
    throw new Error 'Error parsing game configuration file.'

  parse = ->
    config = {}
    set-value = (section, key, value) ->
      if !config[section]
        config[section] = {}
      config[section][key] = value

    section = ''
    reader = new lazy stream LC-game-location.config-path!
    reader.lines.each (line) ->
      line = line.trim!
      if first line == '[' and last line == ']'
        section := initial tail line
      else if '=' in line
        if !section
          parse-error!
        apply set-value, split config[section]
      else if line
        parse-error!

    config

  config = parse!
  original = clone-deep config

  write-to-file = ->
    ...


  {

  }
