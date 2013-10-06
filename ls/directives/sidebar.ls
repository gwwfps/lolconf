angular.module \lolconf .directive \lcSidebar, ->
  template-url: 'templates/sidebar.html'
  scope: true
  controller: !($scope, $location) ->
    {find} = require 'lodash'

    $scope.sections = [
      {page: '/index', title-key: \SIDEBAR_INDEX}
      {page: '/gameConfig', title-key: \SIDEBAR_GAME_CONFIG}
      {page: '/keybinds', title-key: \SIDEBAR_KEYBINDS, disabled: true}
      {page: '/latency', title-key: \SIDEBAR_LATENCY}
      {page: '/appConfig', title-key: \SIDEBAR_APP_CONFIG, disabled: true}
    ]

    $scope.selected = find $scope.sections, {page: $location.path!}
                   or $scope.sections[0]

    $scope.navigate = !(section) ->
      if !section.disabled
        $scope.selected = section
        $location.path section.page
