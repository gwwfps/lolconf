angular.module \lolconf .controller \HotkeysCtrl, !($scope) ->   
    $scope.$on 'hotkey:bound', !(event, key) ->
      $scope.$broadcast 'hotkey:unbind', key, event.target-scope