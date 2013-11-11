angular.module \lolconf .factory \LCDefinitionFactory, ->
  (definition-data) ->
    {find} = require 'lodash'
    find-setting = (id) -> find definition-data, {id: id}

    {
      find: find-setting
    }
