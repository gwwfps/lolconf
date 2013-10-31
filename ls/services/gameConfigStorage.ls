angular.module \lolconf .factory \LCGameConfigStorage, (LC-inicfg-parser, LC-game-location, LC-logger) ->
  {clone-deep} = require 'lodash'

  config = LC-inicfg-parser.parse LC-game-location.config-path!
  original = clone-deep config

  get-setting = (key) ->
    [section, real-key] = key.split '.'
    config.get-value section, real-key

  set-setting = !(key, value) ->
    [section, real-key] = key.split '.'
    config
      ..set-value section, real-key, value
      ..write-to-file!

  {
    get: get-setting
    set: set-setting
  }
