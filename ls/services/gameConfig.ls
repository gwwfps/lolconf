angular.module \lolconf .factory \LCGameConfig, (LC-game-location, LC-logger) -> 
  require! {
    read: fs.read-file-sync
    write: fs.write-file-sync
  }
  {each, first, last, tail, initial, clone-deep, contains, has} = require 'lodash'

  parse-error = ->
    throw new Error 'Error parsing game configuration file.'

  config = {}
  set-value = !(section, key, value) -->
    if !config[section]
      config[section] = {}
    config[section][key] = value

  parse = !->
    section = ''
    lines = read LC-game-location.config-path! .to-string! .split '\n'
    each lines, !(line) ->
      line = line.trim!
      if (first line) == '[' and (last line) == ']'
        section := (initial tail line).join ''
      else if contains line, '='
        if !section
          parse-error!
        (set-value section).apply null, (line.split '=')
      else if line
        parse-error!

  parse!

  original = clone-deep config

  write-to-file = ->
    lines = []
    for section, values of config
      lines.push '[' + section + ']'
      for key, value of values
        lines.push key + '=' + value
    LC-logger.debug "Writing to config file @ %s", LC-game-location.config-path!
    write LC-game-location.config-path!, (lines.join '\n')

  get-setting = (key) ->
    [section, real-key] = key.split '.'
    if has config, section then config[section][real-key] else void

  set-setting = !(key, value) ->
    [section, real-key] = key.split '.'
    set-value section, real-key, value
    write-to-file!

  {
    get: get-setting
    set: set-setting
  }
