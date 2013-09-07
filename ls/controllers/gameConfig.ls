angular.module \lolconf .controller \GameConfigCtrl !($scope, LC-game-config) -> 
  {keys} = require 'prelude-ls'

  $scope.settings = {
    "Video": [
      {type: \resolution width-key: 'General.Width' height-key: 'General.Height' label: "Resolution"}
      {type: \window-mode key: 'General.WindowMode' label: "Screen mode"}
      {type: \toggle key: 'General.WaitForVerticalSync' label: "Vertical sync"}
      {type: \graphics key: 'Performance.CharacterQuality' label: "Character quality"}
      {type: \graphics key: 'Performance.EffectsQuality' label: "Effect quality"}
      {type: \graphics key: 'Performance.EnvironmentQuality' label: "Environment quality"}
      {type: \graphics key: 'Performance.ShadowQuality' label: "Shadow quality"}
      {type: \fps-cap key: 'Performance.FrameCapType' label: 'Framerate cap'}
    ]
    "UI & Colors": [
      {type: \toggle key: 'HUD.EnableLineMissileVis' label: "Line missile display"}
      {type: \toggle key: 'HUD.LockCamera' label: "Lock camera"}
      {type: \toggle key: 'Performance.EnableHUDAnimations' label: "HUD animations"}
      {type: \toggle key: 'HUD.FlipMiniMap' label: "Minimap on the left"}
      {type: \color-palette key: 'ColorPalette.ColorPalette' label: "Color mode"}
      {type: \toggle key: 'HUD.ShowAllChannelChat' label: "Show [All] chat"}
    ]
    "Controls": [

    ]
    "Sound": [
      {type: \volume key: 'Volume.MasterVolume' label: "Master voulme"}
      {type: \volume key: 'Volume.AnnouncerVolume' label: "Announcer voulme"}
      {type: \volume key: 'Volume.VoiceVolume' label: "Voice voulme"}
      {type: \volume key: 'Volume.MusicVolume' label: "Music voulme"}
    ]
    "Floating Texts": [
      {type: \toggle key: 'FloatingText.Absorbed_Enabled' label: "Absorption"}
      {type: \toggle key: 'FloatingText.OMW_Enabled' label: "OMW"}
      {type: \toggle key: 'FloatingText.SpellDamage_Enabled' label: "Spell damage"}
      {type: \toggle key: 'FloatingText.Damage2_Enabled' label: "Damage 2"}
      {type: \toggle key: 'FloatingText.Heal2_Enabled' label: "Heal 2"}
      {type: \toggle key: 'FloatingText.Critical2_Enabled' label: "Critical 2"}
      {type: \toggle key: 'FloatingText.Experience2_Enabled' label: "XP 2"}
      {type: \toggle key: 'FloatingText.QuestReceived_Enabled' label: "Quest received"}
      {type: \toggle key: 'FloatingText.QuestComplete_Enabled' label: "Quest complete"}
      {type: \toggle key: 'FloatingText.Score_Enabled' label: "Score"}
      {type: \toggle key: 'FloatingText.Critical_Enabled' label: "Critical"}
      {type: \toggle key: 'FloatingText.EnemyCritical_Enabled' label: "Enemy critical"}
      {type: \toggle key: 'FloatingText.LegacyCritical_Enabled' label: "Legacy-style crits"}
      {type: \toggle key: 'FloatingText.Legacy_Enabled' label: "Legacy-style damage"}
      {type: \toggle key: 'FloatingText.Debug_Enabled' label: "Debug"}
    ]
  }

  $scope.tabs = ((names) ->
    {
      names: names
      current: names[0] 
    }) (keys $scope.settings)

