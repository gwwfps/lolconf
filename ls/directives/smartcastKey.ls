angular.module \lolconf .directive \lcSmartcastKey, (LC-game-config, LC-data, LC-definition-factory) ->  
  template-url: 'templates/smartcastKey.html'
  transclude: true
  scope: true
  link: !(scope, element, attrs) ->
    definition-data = LC-data.load 'hotkeys'
    smartcast-definitions = LC-definition-factory definition-data.smartcast

    scope.definition = smartcast-definitions.find attrs.lc-smartcast-key
    scope.value = LC-game-config.get-value scope.definition

    console.log scope.value

    scope.$watch 'value', !(new-value, old-value) ->
      if new-value != old-value
        LC-game-config.set-value scope.definition, new-value
    , true
