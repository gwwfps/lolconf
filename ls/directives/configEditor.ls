angular.module \lolconf .directive \lcConfigEditor, ($compile, LC-game-config-definition) ->
  scope: true
  link: !(scope, element, attrs) ->
    scope.setting = LC-game-config-definition.find attrs.lc-config-editor
    html = '<div class="config-editor" lc-config-editor-' + scope.setting.type + '></div>'
    inner = angular.element html
    element.append inner
    ($compile inner) scope
    element.add-class 'config-editor-container'

angular.module \lolconf .directive \lcConfigEditorToggle, ($compile, LC-game-config-storage) -> 
  link: !(scope, element, attrs) ->
    checked-val = if scope.setting.reverse then '0' else '1'
    unchecked-val = if scope.setting.reverse then '1' else '0'

    scope.value = (LC-game-config-storage.get scope.setting.key) == checked-val
    element
      ..html ''
      ..add-class 'config-editor-toggle'
      ..append '<div class="toggle-checkbox" ng-class="{checked: value}" ng-click="value = !value"></div>'
      ..append '<div class="config-editor-label toggle-label">{{"' + scope.setting.label-key + '"|t}}</div>'
    if scope.setting.tooltip-key
      element.find '.toggle-checkbox' .attr 'lc-tooltip', "'" + scope.setting.tooltip-key + "'|t"
    ($compile element.contents!) scope

    scope.$watch 'value', (new-value) ->
      LC-game-config-storage.set scope.setting.key, if new-value then checked-val else unchecked-val

angular.module \lolconf .directive \lcConfigEditorResolution, ($compile, LC-game-config-storage, LC-probe) -> 
  link: !(scope, element, attrs) ->
    {map, zip, zip-object} = require 'lodash'

    element.html '<select ng-model="value" ng-options="label for (label, resolution) in resolutions"></select>' 
    
    select = element.find 'select'

    saved-value = {
      width: LC-game-config-storage.get scope.setting.width-key
      height: LC-game-config-storage.get scope.setting.height-key
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
        LC-game-config-storage.set scope.setting.width-key, new-value.width
        LC-game-config-storage.set scope.setting.height-key, new-value.height

rank-directive = (rank-keys) ->
  ($compile, LC-game-config-storage) ->
    link: !(scope, element, attrs) ->
      {each} = require 'lodash'

      scope.value = LC-game-config-storage.get scope.setting.key    

      inner = angular.element '<div>{{"' + scope.setting.label-key + '"|t}}:<div class="ui buttons"></div></div>'
      each rank-keys, (key, i) ->
        inner.children '.buttons' .append '<div class="ui mini button" ng-class="{active: value === \'' + i + '\'}" ng-click="value = \'' + i + '\'">{{"' + key + '"|t}}</div>'
      element.append inner

      ($compile inner) scope

      scope.$watch 'value', (new-value) ->      
        LC-game-config-storage.set scope.setting.key, new-value
        
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

angular.module \lolconf .directive \lcConfigEditorRange, ($compile, LC-game-config-storage) ->
  link: !(scope, element, attrs) ->
    min = scope.setting.min or 0
    max = scope.setting.max or 1
    increment = scope.setting.increment or 0.01

    scope.value = parse-float (LC-game-config-storage.get scope.setting.key)
    scope.display = -> Math.round scope.value / max * 100

    element
      ..html ''
      ..add-class 'config-editor-range'
      ..append '<div class="range-number" ng-bind="display()"></div>'
      ..append '<div class="config-editor-label range-label">{{"' + scope.setting.label-key + '"|t}}</div>'
      ..append '<div class="range-slider"><input type="range" ng-model="value" min="' + min + '" max="' + max + '" step="' + increment + '" /></div>'
    ($compile element.contents!) scope

    scope.$watch 'value', !(new-value, old-value) ->
      if new-value != old-value
        LC-game-config-storage.set scope.setting.key, new-value

angular.module \lolconf .directive \lcConfigEditorVolume, ($compile, $root-scope, LC-game-config-storage) ->
  link: !(scope, element, attrs) ->
    scope.muted = (LC-game-config-storage.get scope.setting.mute-key) == '1'
    element
      ..html ''
      ..add-class 'config-editor-volume'
      ..append '<div class="volume-mute" ng-class="{muted: muted}" ng-click="muted = !muted"></div>'
      ..append '<div lc-config-editor-range></div>'
    ($compile element.contents!) scope

    if scope.setting.master
      element.add-class 'config-editor-volume-master'
    # else    
    #   $root-scope.$on \game-config:master-mute, !(event, master-value) ->
    #     scope.muted = master-value

    scope.$watch 'value', !(new-value, old-value) ->
      if new-value != old-value
        scope.muted = false

    scope.$watch 'muted', !(new-value) ->
      LC-game-config-storage.set scope.setting.mute-key, (if new-value then '1' else '0')
      # if scope.setting.master
      #   scope.$emit \game-config:master-mute, new-value      
