angular.module \lolconf .directive \lcSelectize, ($root-scope) -> 
  !(scope, element, attrs) ->
    {defer} = require 'lodash'

    defer ->
      element.selectize {
        sortField: \text
      }