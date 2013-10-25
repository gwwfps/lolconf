angular.module \lolconf .directive \lcConfigEditor, ($compile, LC-game-config-definition, LC-game-config) ->
  scope: true
  link: !(scope, element, attrs) ->
    scope.setting = LC-game-config-definition.find attrs.lc-config-editor
    scope.value = LC-game-config.get-value scope.setting

    html = '<div class="config-editor config-editor-' + scope.setting.type + '" lc-config-editor-' + scope.setting.type + '></div>'
    inner = angular.element html
    element.append inner
    ($compile inner) scope
    element.add-class 'config-editor-container'

    scope.$watch 'value', !(new-value, old-value) ->
      if new-value != old-value
        LC-game-config.set-value scope.setting, new-value
    , true


angular.module \lolconf .directive \lcConfigEditorToggle, ($compile) -> 
  link: !(scope, element, attrs) ->
    element
      ..html ''
      ..append '<div class="toggle-checkbox" ng-class="{checked: value}" ng-click="value = !value"></div>'
      ..append '<div class="config-editor-label toggle-label" ng-click="value = !value">{{"' + scope.setting.label-key + '"|t}}</div>'
    if scope.setting.tooltip-key
      element.find '.toggle-checkbox' .attr 'lc-tooltip', "'" + scope.setting.tooltip-key + "'|t"
    ($compile element.contents!) scope


angular.module \lolconf .directive \lcConfigEditorResolution, ($compile, LC-probe) -> 
  link: !(scope, element, attrs) ->
    {map, zip, zip-object} = require 'lodash'

    element
      ..html ''
      ..append '<div class="config-editor-label">{{"' + scope.setting.label-key + '"|t}}</div>'
      ..append '<select ng-model="value" ng-options="label for (label, resolution) in resolutions"></select>' 
    
    select = element.find 'select'

    resolution-to-label = (resolution) ->
      resolution.width + 'x' + resolution.height

    LC-probe.query \resolutions .then (result) ->
      scope.resolutions = zip-object.apply null, (zip.apply null, (map result.resolutions, (resolution) ->
        [(resolution-to-label resolution), resolution]
      ))

      label = resolution-to-label scope.value
      scope.resolutions[label] = scope.value
      
      ($compile element.contents!) scope


rank-directive = (rank-keys) ->
  ($compile, LC-game-config-storage) ->
    link: !(scope, element, attrs) ->
      {each} = require 'lodash'

      ranks = angular.element '<ul></ul>'
      each rank-keys, (key, i) ->
        ranks.append '<li ng-class="{selected: value === \'' + i + '\'}" ng-click="value = \'' + i + '\'">{{"' + key + '"|t}}</li>'

      element
        ..html ''
        ..add-class 'config-editor-rank'
        ..append '<div class="config-editor-label">{{"' + scope.setting.label-key + '"|t}}</div>'
        ..append ranks

      ($compile element.contents!) scope
        
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

angular.module \lolconf .directive \lcConfigEditorColorPalette, rank-directive [
  \GAMECONFIG_COLOR_PALETTE_REGULAR \GAMECONFIG_COLOR_PALETTE_ALTERNATIVE \GAMECONFIG_COLOR_PALETTE_COLOR_BLIND
]

angular.module \lolconf .directive \lcConfigEditorRange, ($compile) ->
  link: !(scope, element, attrs) ->
    min = scope.setting.min or 0
    max = scope.setting.max or 1
    increment = scope.setting.increment or 0.01
    
    scope.display = -> Math.round scope.value / max * 100

    element
      ..html ''
      ..append '<div class="range-number" ng-bind="display()"></div>'
      ..append '<div class="config-editor-label range-label">{{"' + scope.setting.label-key + '"|t}}</div>'
      ..append '<div class="range-slider"><input type="range" ng-model="value" min="' + min + '" max="' + max + '" step="' + increment + '" /></div>'
    ($compile element.contents!) scope

angular.module \lolconf .directive \lcConfigEditorVolume, ($compile, $root-scope, LC-game-config-storage) ->
  link: !(scope, element, attrs) ->    
    element
      ..html ''
      ..append '<div class="volume-mute" ng-class="{muted: value.muted}" ng-click="value.muted = !value.muted"></div>'      
    ($compile element.contents!) scope

    volume-range = $ '<div lc-config-editor-range class="config-editor-range"></div>'
    volume-scope = (scope.$new true) <<<
      setting:
        label-key: scope.setting.label-key
      value: scope.value.volume
    element.append volume-range
    ($compile element.contents!) volume-scope
    volume-scope.$watch 'value', !(new-value)->
      scope.value.volume = new-value

    if scope.setting.master
      element.add-class 'config-editor-volume-master'
    # else    
    #   $root-scope.$on \game-config:master-mute, !(event, master-value) ->
    #     scope.muted = master-value

    scope.$watch 'value.volume', !(new-value, old-value) ->
      if new-value != old-value
        scope.value.muted = false

    # scope.$watch 'muted', !(new-value) ->
      # if scope.setting.master
      #   scope.$emit \game-config:master-mute, new-value      
