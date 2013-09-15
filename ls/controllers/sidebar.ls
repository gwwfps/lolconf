angular.module \lolconf .controller \SidebarCtrl, !($scope, $t, $filter) ->   
  $scope.sections = [
    {page: 'index', title-key: \SIDEBAR_INDEX}
    {page: 'gameConfig', title-key: \SIDEBAR_GAME_CONFIG}
    {page: 'keybinds', title-key: \SIDEBAR_KEYBINDS}
    {page: 'latency', title-key: \SIDEBAR_LATENCY}
    {page: 'appConfig', title-key: \SIDEBAR_APP_CONFIG}
  ]
