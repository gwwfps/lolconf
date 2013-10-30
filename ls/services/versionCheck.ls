angular.module \lolconf .factory \LCVersionCheck, (LC-game-config-storage) -> 
  package-info = require './package.json'

  ver = LC-game-config-storage.get 'General.CfgVersion'
  [major, minor, revision] = ver.split '.'
  [target-major, target-minor] = package-info.lol-version.split '.'

  {
    match: -> major == target-major and minor == target-minor
  }
