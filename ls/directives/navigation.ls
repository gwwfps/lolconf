angular.module \lolconf .directive \lcNavigation, ->
  template-url: 'templates/navigation.html'
  scope: true
  controller: !($scope, $location) ->
    {find} = require 'lodash'

    $scope.sections = [
      # {page: '/index', title-key: \SIDEBAR_INDEX}
      {page: '/hotkeys', title-key: \SIDEBAR_HOTKEYS}
      {page: '/video', title-key: \SIDEBAR_VIDEO}
      {page: '/sound', title-key: \SIDEBAR_SOUND}
      {page: '/interface', title-key: \SIDEBAR_INTERFACE}
      {page: '/game', title-key: \SIDEBAR_GAME}
      {page: '/hidden', title-key: \SIDEBAR_HIDDEN}
      # {page: '/latency', title-key: \SIDEBAR_LATENCY, disabled: true}
      {page: '/settings', title-key: \SIDEBAR_SETTINGS}
    ]

    $scope.selected = find $scope.sections, {page: $location.path!}
                   or $scope.sections[0]

    $scope.navigate = !(section) ->
      if !section.disabled
        $scope.selected = section
        $location.path section.page
