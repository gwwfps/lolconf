angular.module \lolconf .controller \ConfigCtrl, !($scope, LC-game-config) -> 
  settings = {
    "Floating text": [
      {key: "Absorbed_Enabled", type: \toggle}
      {key: "OMW_Enabled", type: \toggle}
      {key: "SpellDamage_Enabled", type: \toggle}
      {key: "Damage2_Enabled", type: \toggle}
      {key: "Heal2_Enabled", type: \toggle}
      {key: "Critical2_Enabled", type: \toggle}
      {key: "Experience2_Enabled", type: \toggle}
      {key: "QuestReceived_Enabled", type: \toggle}
      {key: "QuestComplete_Enabled", type: \toggle}
      {key: "Score_Enabled", type: \toggle}
      {key: "Critical_Enabled", type: \toggle}
      {key: "EnemyCritical_Enabled", type: \toggle}
      {key: "LegacyCritical_Enabled", type: \toggle}
      {key: "Legacy_Enabled", type: \toggle}
      {key: "Debug_Enabled", type: \toggle}
    ],
    "UI": [
      {key: "EnableHUDAnimations", type: \toggle}
    ]
  }

  $scope.settings = settings[0]
