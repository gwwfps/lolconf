angular.module \lolconf .factory \LCGameConfigDefinition, (LC-data) -> 
  {find} = require 'lodash'

  definition = LC-data.load 'gameConfig'
  find-setting = (id) -> find definition.settings, {id: id}

  {
    find: find-setting
  }