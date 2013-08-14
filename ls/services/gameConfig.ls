angular.module \lolconf .factory \LCGameConfig, (LC-game-location) -> 
  require! {
    stream: fs.create-read-stream
    write: fs.write-file-sync
    lazy
  }
  {first, last, tail, initial, split, each, join, apply} = require 'prelude-ls'
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
    set-value = (section, key, value) ->
      if !config[section]
        config[section] = {}
      config[section][key] = value

    section = ''
    lines = lazy (stream LC-game-location.config-path!) .lines
    lines.for-each (line) ->
      line = line.to-string!trim!
      if (first line) == '[' and (last line) == ']'
        section := initial tail line
      else if contains line, '='
        if !section
          parse-error!
        apply set-value, (split config[section])
      else if line
        parse-error!

    config

  config = parse!
  original = clone-deep config

  write-to-file = ->
    lines = []
    for values, section in config
      lines.push '[' + section + ']'
      for value, key in values
        lines.push key + '=' + value
    write LC-game-location.config-path!, (join '\n', lines)  

  {
    supported-settings: supported-settings
  }
