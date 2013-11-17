angular.module \lolconf .controller \IndexCtrl, !($scope, LC-game-location, LC-probe, LC-official-news, LC-version-check) ->   
  {defer} = require 'lodash'

  $scope.official-news = LC-official-news.list!

  if !LC-game-location.get!
    defer !->
      $scope.$emit \modal:show, \choose-location

  $scope.confirm-location = !->
    if LC-game-location.set $scope.game-location == $scope.game-location
      $scope.$emit \modal:hide
    else
      alert "Invalid location."

  $scope.match = LC-version-check.match!
  