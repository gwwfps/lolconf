angular.module \lolconf .controller \SettingsCtrl, !($scope, LC-game-location, LC-game-config) ->   
  $scope.location = {
    saved: LC-game-location.get!
    chosen: ''
  }

  $scope.backup = !-> LC-game-config.backup!
  $scope.restore = !-> LC-game-config.restore!

  $scope.$watch 'location.chosen', !(path) ->
    if path 
      if (LC-game-location.set path) == path
        $scope.location.saved = LC-game-location.get!
      else
        alert!
    
