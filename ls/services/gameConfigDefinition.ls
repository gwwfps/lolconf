angular.module \lolconf .factory \LCGameConfigDefinition, (LC-data, LC-definition-factory) ->   
  definition-data = LC-data.load 'gameConfig'
  LC-definition-factory definition-data.settings
