angular.module \lolconf .controller \GameConfigCtrl, !($scope, LC-game-config) -> 
  settings = {
    "Video":  [
      {type: \resolution, width-key: 'General.Width', height-key: 'General.Height', label: 'Resolution'}
      {type: \toggle, key: 'General.WaitForVerticalSync', label: 'Vertical sync'}
    ],
    "Floating text": [
      {type: \toggle, key: 'FloatingText.Absorbed_Enabled', label: 'Absorption'}
      {type: \toggle, key: 'FloatingText.OMW_Enabled', label: 'OMW'}
      {type: \toggle, key: 'FloatingText.SpellDamage_Enabled', label: 'Spell damage'}
      {type: \toggle, key: 'FloatingText.Damage2_Enabled', label: 'Damage 2'}
      {type: \toggle, key: 'FloatingText.Heal2_Enabled', label: 'Heal 2'}
      {type: \toggle, key: 'FloatingText.Critical2_Enabled', label: 'Critical 2'}
      {type: \toggle, key: 'FloatingText.Experience2_Enabled', label: 'XP 2'}
      {type: \toggle, key: 'FloatingText.QuestReceived_Enabled', label: 'Quest received'}
      {type: \toggle, key: 'FloatingText.QuestComplete_Enabled', label: 'Quest complete'}
      {type: \toggle, key: 'FloatingText.Score_Enabled', label: 'Score'}
      {type: \toggle, key: 'FloatingText.Critical_Enabled', label: 'Critical'}
      {type: \toggle, key: 'FloatingText.EnemyCritical_Enabled', label: 'Enemy critical'}
      {type: \toggle, key: 'FloatingText.LegacyCritical_Enabled', label: 'Legacy crit'}
      {type: \toggle, key: 'FloatingText.Legacy_Enabled', label: 'Legacy'}
      {type: \toggle, key: 'FloatingText.Debug_Enabled', label: 'Debug'}
    ],
    "UI": [
      {key: 'Performance.EnableHUDAnimations', type: \toggle, label: 'HUD animations'}
    ]
  }

  $scope.settings = settings["Video"]
