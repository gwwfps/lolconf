angular.module \lolconf .factory \LCGameConfig, (LC-game-location, LC-logger) -> 
  require! {
    read: fs.read-file-sync
    write: fs.write-file-sync
  }
  {first, last, tail, initial, split, each, join, apply, obj-to-pairs, find} = require 'prelude-ls'
  {clone-deep, contains, has} = require 'lodash'

  parse-error = ->
    throw new Error 'Error parsing game configuration file.'

  parse = ->
    config = {}
    set-value = !(section, key, value) -->
      if !config[section]
        config[section] = {}
      config[section][key] = value

    section = ''
    lines = read LC-game-location.config-path! .to-string! .split '\n'
    each (!(line) ->
      line = line.to-string!trim!
      if (first line) == '[' and (last line) == ']'
        section := initial tail line
      else if contains line, '='
        if !section
          parse-error!
        apply (set-value section), (split '=' line)
      else if line
        parse-error!), lines

    config

  config = parse!
  original = clone-deep config

  write-to-file = ->
    lines = []
    for section, values of config
      lines.push '[' + section + ']'
      for key, value of values
        lines.push key + '=' + value
    LC-logger.debug "Writing to config file @ %s", LC-game-location.config-path!
    write LC-game-location.config-path!, (join '\n', lines)

  get-setting = (key) ->
    [section, real-key] = split '.', key    
    if has config, section then config[section][real-key] else undefined

  set-setting = !(key, value) ->
    [section, real-key] = split '.', key
    if !(has config, section)
      config[section] = {}
    config[section][real-key] = value
    write-to-file!

  {
    get: get-setting
    set: set-setting
  }
