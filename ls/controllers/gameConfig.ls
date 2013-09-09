angular.module \lolconf .controller \GameConfigCtrl !($scope, LC-game-config, LC-data) -> 
  {pluck, find} = require 'lodash'

  definition = LC-data.load 'gameConfig'

  $scope.tabs = ((titles) ->
    {
      names: titles
      current: titles[0] 
    }) (pluck definition.sections, 'title')

  $scope.currentSection = ->
    find definition.sections, {title: $scope.tabs.current}

