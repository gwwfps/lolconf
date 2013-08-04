angular.module \lolconf .factory 'LCAppConfig', (LC-Logger) -> 
  require! nconf
  nconf.file 'config.json'
  
  * game-path: ''
  |> nconf.defaults
  
  * get: nconf~get
    set: !(prop-name, value) ->
      nconf.set ...
      nconf.save! 
