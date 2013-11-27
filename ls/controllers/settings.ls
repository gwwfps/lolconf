angular.module \lolconf .controller \SettingsCtrl, !($scope, LC-game-location) ->   
  $scope.location = {
    saved: LC-game-location.get!
    chosen: ''
  }

  $scope.promptChangeLocation = !->
    $scope.$emit \modal:show, 'gameLocation'

  $scope.confirm-change-location = !->
    if $scope.location.chosen and (LC-game-location.set $scope.location.chosen) == $scope.location.chosen
      $scope
        ..location.saved = LC-game-location.get!
        ..$emit \modal:hide
    else
      alert!
