angular.module \lolconf .factory \LCVersionCheck, (LC-game-config) -> 
  package-info = require './package.json'
  setting = 
    type: \version
    key: \General.CfgVersion
  {major, minor, revision} = LC-game-config.get-value setting  
  [target-major, target-minor] = package-info.lol-version.split '.'

  {
    match: -> major == target-major and minor == target-minor
  }
