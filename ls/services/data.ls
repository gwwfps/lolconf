angular.module \lolconf .factory \LCData, (LC-logger) -> 
  {read-file-sync} = require 'fs'
  {load} = require 'js-yaml'
  require! 'path'

  {
    load: (name) ->
      yaml = read-file-sync (path.join 'data', (name + '.yaml')) .to-string!
      if !yaml
        return void
      load yaml
  }
