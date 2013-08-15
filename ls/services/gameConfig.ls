angular.module \lolconf .factory \LCGameConfig, (LC-game-location, LC-logger) -> 
  require! {
    read: fs.read-file-sync
    write: fs.write-file-sync
  }
  {first, last, tail, initial, split, each, join, apply, obj-to-pairs, find} = require 'prelude-ls'
  {clone-deep, contains} = require 'lodash'

  supported-settings = {
    FloatingText: <[ Absorbed_Enabled OMW_Enabled SpellDamage_Enabled Damage2_Enabled
                     Heal2_Enabled Critical2_Enabled Experience2_Enabled QuestReceived_Enabled
                     QuestComplete_Enabled Score_Enabled Critical_Enabled EnemyCritical_Enabled
                     LegacyCritical_Enabled Legacy_Enabled Debug_Enabled ]>
    Performance: <[ EnableHUDAnimations ]>
  }

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

  find-section = (key) ->
    sections-and-keys = obj-to-pairs supported-settings
    in-section = (pair) -> key in pair[1]
    (find in-section, sections-and-keys)[0]

  get-setting = (key) ->
    config[find-section key][key]

  set-setting = !(key, value) ->
    config[find-section key][key] = value
    write-to-file!

  {
    supported-settings: supported-settings
    get: get-setting
    set: set-setting
  }
