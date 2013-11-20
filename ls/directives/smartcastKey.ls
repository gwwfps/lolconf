angular.module \lolconf .directive \lcSmartcastKey, (LC-game-config, LC-data, LC-definition-factory, LC-char-code-translator) ->  
  template-url: 'templates/smartcastKey.html'
  transclude: true
  scope: true
  link: !(scope, element, attrs) ->
    definition-data = LC-data.load 'hotkeys'
    smartcast-definitions = LC-definition-factory definition-data.smartcast

    scope.definition = smartcast-definitions.find attrs.lc-smartcast-key
    scope.value = LC-game-config.get-value scope.definition

    scope.prompt-bind = !->
      scope.$emit 'modal:show', "<div>{{'HOTKEYS_BIND_INSTRUCTION'|t}}<input ng-keypress='bindKey($event)' /></div>"

    scope.bindKey = !($event) ->
      scope.value.bind = LC-char-code-translator.translate $event.char-code
      scope.$emit 'modal:hide'

    scope.$watch 'value', !(new-value, old-value) ->
      if new-value != old-value
        LC-game-config.set-value scope.definition, new-value
    , true

    scope.$on 'smartcast:smart-all', !->
      scope.value.toggle = true

    scope.$on 'smartcast:normal-all', !->
      scope.value.toggle = false
