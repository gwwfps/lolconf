angular.module \lolconf .directive \lcConfigEditor, ($compile, LC-data) ->
  {find} = require 'lodash'
  definition = LC-data.load 'gameConfig'
  find-setting = (id) ->
    find definition.settings, {id: id}

  {
    scope: true
    link: !(scope, element, attrs) ->
      scope.setting = find-setting attrs.lc-config-editor
      html = '<span lc-config-editor-' + scope.setting.type + '></span>'
      inner = angular.element html
      element.append inner
      ($compile inner) scope
  }

angular.module \lolconf .directive \lcConfigEditorToggle, ($compile, LC-game-config) -> 
  link: !(scope, element, attrs) ->
    scope.value = (LC-game-config.get scope.setting.key) === '1'
    element.html '<div class="ui toggle checkbox"><input type="checkbox" ng-model="value" /><label></label></div>'
    ($compile element.contents!) scope

    checkbox = element.find 'input'
    element.find '.checkbox' .on \click, ->
      checkbox.trigger \click

    scope.$watch 'value', (new-value) ->
      LC-game-config.set scope.setting.key, if new-value is true then '1' else '0'

angular.module \lolconf .directive \lcConfigEditorResolution, ($compile, LC-game-config, LC-probe) -> 
  link: !(scope, element, attrs) ->
    {map, zip, zip-object} = require 'lodash'

    element.html '<select ng-model="value" ng-options="label for (label, resolution) in resolutions"></select>' 
    
    select = element.find 'select'

    saved-value = {
      width: LC-game-config.get scope.setting.width-key
      height: LC-game-config.get scope.setting.height-key
    }

    resolution-to-label = (resolution) ->
      resolution.width + 'x' + resolution.height

    LC-probe.query \resolutions .then (result) ->
      scope.resolutions = zip-object.apply null, (zip.apply null, (map result.resolutions, (resolution) ->
        [(resolution-to-label resolution), resolution]
      ))

      saved-label = resolution-to-label saved-value
      if !(saved-label of scope.resolutions)
        scope.resolutions[saved-label] = saved-value
      scope.value = scope.resolutions[saved-label]
      
      ($compile element.contents!) scope

      scope.$watch 'value', (new-value) ->
        LC-game-config.set scope.setting.width-key, new-value.width
        LC-game-config.set scope.setting.height-key, new-value.height

rank-directive = (rank-keys) ->
  ($compile, LC-game-config) ->
    link: !(scope, element, attrs) ->
      {each} = require 'lodash'

      scope.value = LC-game-config.get scope.setting.key    

      inner = angular.element '<div class="ui buttons"></div>'
      each rank-keys, (key, i) ->
        inner.append '<div class="ui mini button" ng-class="{active: value === \'' + i + '\'}" ng-click="value = \'' + i + '\'">{{"' + key + '"|t}}</div>'
      element.append inner

      ($compile inner) scope

      scope.$watch 'value', (new-value) ->      
        LC-game-config.set scope.setting.key, new-value
        
angular.module \lolconf .directive \lcConfigEditorGraphics, rank-directive [
  \GAMECONFIG_GRAPHICS_LOWEST \GAMECONFIG_GRAPHICS_LOW \GAMECONFIG_GRAPHICS_MEDIUM \GAMECONFIG_GRAPHICS_HIGH \GAMECONFIG_GRAPHICS_HIGHEST
]

angular.module \lolconf .directive \lcConfigEditorFpsCap, rank-directive [
  \GAMECONFIG_FPS_CAP_STABLE \GAMECONFIG_FPS_CAP_HIGH \GAMECONFIG_FPS_CAP_BENCHMARK
  \GAMECONFIG_FPS_CAP_25 \GAMECONFIG_FPS_CAP_30 \GAMECONFIG_FPS_CAP_60 \GAMECONFIG_FPS_CAP_80
]

angular.module \lolconf .directive \lcConfigEditorWindowMode, rank-directive [
  \GAMECONFIG_WINDOW_MODE_FULL \GAMECONFIG_WINDOW_MODE_WINDOWED \GAMECONFIG_WINDOW_MODE_BORDERLESS
]

angular.module \lolconf .directive \lcConfigEditorCooldownMode, rank-directive [
  \GAMECONFIG_COOLDOWN_DISPLAY_NONE \GAMECONFIG_COOLDOWN_DISPLAY_SEC \GAMECONFIG_COOLDOWN_DISPLAY_MINSEC \GAMECONFIG_COOLDOWN_DISPLAY_SIMPLIFIED
]

angular.module \lolconf .directive \lcConfigEditorVolume, ($compile, LC-game-config) ->
  link: !(scope, element, attrs) ->
    scope.value = LC-game-config.get scope.setting.key
    element.html '{{"' + scope.setting.label-key + '"|t}}: <input type="range" ng-model="value" min="0" max="1" step="0.01" />'
    ($compile element.contents!) scope

    scope.$watch 'value', (new-value) ->
      LC-game-config.set scope.setting.key, new-value
