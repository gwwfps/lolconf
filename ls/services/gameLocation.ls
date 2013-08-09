angular.module \lolconf .factory \LCGameLocation, (LC-app-config) -> 
  require! {
    exists: fs.exists-sync
    path.resolve
    'windows/lib/registry'
  }
  {join} = require 'prelude-ls'

  const CONFIG_KEY = 'game_location'
  const IS_64BIT = process.arch == 'x64' || process.env.has-own-property 'PROCESSOR_ARCHITEW6432'

  get-location = ->
    location = LC-app-config.get CONFIG_KEY
    if validate location
      return location
    set-location auto-detect!

  set-location = !(location) ->
    if validate location
      LC-app-config.set CONFIG_KEY, location
      return location
    
  auto-detect = !->
    rads-key-name =  join '\\' [
      'HKEY_LOCAL_MACHINE' 'SOFTWARE'
      'Wow6432Node' if IS_64BIT
      'Riot Games' 'RADS' ]
    try
      rads-key = registry rads-key-name
      if \LocalRootFolder of rads-key
        return resolve rads-key[\LocalRootFolder].value, '..'

  launcher-path = (location) ->
    if location
      resolve location, 'lol.launcher.exe'

  config-path = (location) ->
    if location
      resolve location, 'Config', 'Game.cfg'

  validate = (location) ->
    if !location
      return false
    (exists location) && (exists launcher-path location) && (exists config-path location)
  
  {
    get: get-location
    set: set-location
    config-path: config-path
  }
