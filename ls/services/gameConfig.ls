angular.module \lolconf .factory \LCGameConfig, (LC-game-location) -> 
  require! {
    read: fs.read-file-sync
    write: fs.write-file-sync
  }
  {first, last, tail, initial, split, each, join, apply} = require 'prelude-ls'
  {clone-deep} = require 'lodash'

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
    lines = read LC-game-location.config-path!
    each lines, (line) ->
      line = line.trim!
      if first line == '[' and last line == ']'
        section := initial tail line
      else if '=' in line
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
