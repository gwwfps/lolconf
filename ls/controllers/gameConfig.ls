angular.module \lolconf .controller \GameConfigCtrl, !($scope, LC-game-config) -> 
  $scope.settings = {
    current: "Video"
    sections: {
      "Video":  [
        {type: \resolution, width-key: 'General.Width', height-key: 'General.Height', label: "Resolution"}
        {type: \window-mode, key: 'General.WindowMode', label: "Screen mode"}
        {type: \toggle, key: 'General.WaitForVerticalSync', label: "Vertical sync"}

        {type: \graphics, key: 'Performance.CharacterQuality', label: "Character quality"}
        {type: \graphics, key: 'Performance.EffectsQuality', label: "Effect quality"}
        {type: \graphics, key: 'Performance.EnvironmentQuality', label: "Environment quality"}
        {type: \graphics, key: 'Performance.ShadowQuality', label: "Shadow quality"}
        {type: \fps-cap, key: 'Performance.FrameCapType', label: 'Framerate cap'}
      ]
      "Floating Texts": [
        {type: \toggle, key: 'FloatingText.Absorbed_Enabled', label: "Absorption"}
        {type: \toggle, key: 'FloatingText.OMW_Enabled', label: "OMW"}
        {type: \toggle, key: 'FloatingText.SpellDamage_Enabled', label: "Spell damage"}
        {type: \toggle, key: 'FloatingText.Damage2_Enabled', label: "Damage 2"}
        {type: \toggle, key: 'FloatingText.Heal2_Enabled', label: "Heal 2"}
        {type: \toggle, key: 'FloatingText.Critical2_Enabled', label: "Critical 2"}
        {type: \toggle, key: 'FloatingText.Experience2_Enabled', label: "XP 2"}
        {type: \toggle, key: 'FloatingText.QuestReceived_Enabled', label: "Quest received"}
        {type: \toggle, key: 'FloatingText.QuestComplete_Enabled', label: "Quest complete"}
        {type: \toggle, key: 'FloatingText.Score_Enabled', label: "Score"}
        {type: \toggle, key: 'FloatingText.Critical_Enabled', label: "Critical"}
        {type: \toggle, key: 'FloatingText.EnemyCritical_Enabled', label: "Enemy critical"}
        {type: \toggle, key: 'FloatingText.LegacyCritical_Enabled', label: "Legacy crit"}
        {type: \toggle, key: 'FloatingText.Legacy_Enabled', label: "Legacy style damage"}
        {type: \toggle, key: 'FloatingText.Debug_Enabled', label: "Debug"}
      ]
      "UI & Colors": [
        {type: \toggle, key: 'Performance.EnableHUDAnimations', label: "HUD animations"}
        {type: \toggle, key: 'HUD.FlipMiniMap', label: "Minimap on the left"}
        {type: \color-palette, key: 'ColorPalette.ColorPalette', label: "Color mode"}

      ]
    }    
  }

