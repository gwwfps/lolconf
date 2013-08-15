angular.module \lolconf .directive \lcConfigEditor, ($compile) ->
  scope: true,
  link: !(scope, element, attrs) ->
    scope.key = attrs.key
    html = '<span lc-config-editor-' + attrs.type + '></span>'
    inner = angular.element html
    element.append inner
    ($compile inner) scope

angular.module \lolconf .directive \lcConfigEditorToggle, ($compile, LC-game-config) -> 
  link: !(scope, element, attrs) ->
    scope.value = (LC-game-config.get scope.key) === '1'
    element.html '<input type="checkbox" ng-model="value" />'
    ($compile element.contents!) scope

    scope.$watch 'value', (new-value) ->
      LC-game-config.set scope.key, if new-value is true then '1' else '0'
