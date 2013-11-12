angular.module \lolconf .factory \LCGameConfigStorage, (LC-storage-factory, LC-game-location) ->
  LC-storage-factory LC-game-location.config-path!
