angular.module \lolconf .factory \LCAppConfig, ->   
  settings = local-storage.settings = local-storage.settings || {}

  {
    get: (key) -> settings[key]
    set: !(key, value) -> settings[key] = value
  }
