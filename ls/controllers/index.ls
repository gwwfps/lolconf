angular.module \lolconf .controller \IndexCtrl, !($scope, LC-game-location, LC-probe) ->   
  {defer} = require 'lodash'

  if !LC-game-location.get!
    defer !->
      $scope.$emit \modal:show, \choose-location

  $scope.confirm-location = !->
    if LC-game-location.set $scope.game-location == $scope.game-location
      $scope.$emit \modal:hide
    else
      alert "Invalid location."
