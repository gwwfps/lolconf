angular.module \lolconf .directive \lcConfigEditor, ($compile) ->
  scope: true,
  link: !(scope, element, attrs) ->
    scope.setting = scope.$eval attrs.lc-config-editor
    html = '<span lc-config-editor-' + scope.setting.type + '></span>'
    inner = angular.element html
    element.append inner
    ($compile inner) scope

angular.module \lolconf .directive \lcConfigEditorToggle, ($compile, LC-game-config) -> 
  link: !(scope, element, attrs) ->
    scope.value = (LC-game-config.get scope.setting.key) === '1'
    element.html '<input type="checkbox" ng-model="value" />'
    ($compile element.contents!) scope

    scope.$watch 'value', (new-value) ->
      LC-game-config.set scope.setting.key, if new-value is true then '1' else '0'

angular.module \lolconf .directive \lcConfigEditorResolution, ($compile, LC-game-config) -> 
  link: !(scope, element, attrs) ->
    scope.value = (LC-game-config.get scope.setting.width-key) + 'x' + (LC-game-config.get scope.setting.height-key)
    element.html '<input type="text" ng-model="value" />'
    ($compile element.contents!) scope
