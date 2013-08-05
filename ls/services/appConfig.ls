angular.module \lolconf .factory \LCAppConfig, -> 
  require! nconf
  nconf.file 'config.json'
  
  * game-path: ''
  |> nconf.defaults
  
  * get: nconf~get
    set: !(prop-name, value) ->
      nconf~set ...
      nconf.save! 
