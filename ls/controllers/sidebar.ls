angular.module \lolconf .controller \SidebarCtrl, !($scope) ->   
  $scope.sections = [
    {page: 'index', title: "Welcome"}
    {page: 'gameConfig', title: "Game settings"}
    {page: 'keybinds', title: "Key bindings"}
    {page: 'appConfig', title: "App settings"}
  ]
