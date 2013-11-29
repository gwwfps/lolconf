angular.module \lolconf .controller \SettingsCtrl, !($scope, LC-game-location, LC-game-config) ->   
  $scope.location = {
    saved: LC-game-location.get!
    chosen: ''
  }

  $scope.backup = !-> LC-game-config.backup!
  $scope.restore = !-> LC-game-config.restore!

  $scope.promptChangeLocation = !->
    $scope.$emit \modal:show, 'gameLocation'

  $scope.confirm-change-location = !->
    if $scope.location.chosen and (LC-game-location.set $scope.location.chosen) == $scope.location.chosen
      $scope
        ..location.saved = LC-game-location.get!
        ..$emit \modal:hide
    else
      alert!
