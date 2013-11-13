angular.module \lolconf .factory \LCGameConfig, (LC-storage-factory, LC-game-location) ->
  require! {path.resolve}

  game-cfg = LC-storage-factory LC-game-location.config-path!
  input-ini = LC-storage-factory (resolve LC-game-location.get!, 'Config', 'Input.ini')

  unprocessed = (setting, value) -> value
  single-key-retriever = (setting) -> game-cfg.get setting.key
  single-key-storer = !(setting, printed-value) -> game-cfg.set setting.key, printed-value


  retrievers =
    toggle: single-key-retriever
    range: single-key-retriever
    volume: (setting) ->
      volume: game-cfg.get setting.key
      muted: game-cfg.get setting.mute-key
    resolution: (setting) ->
      width: game-cfg.get setting.width-key
      height: game-cfg.get setting.height-key
    graphics: single-key-retriever
    'fps-cap': single-key-retriever
    'window-mode': single-key-retriever
    'cooldown-mode': single-key-retriever
    'color-palette': single-key-retriever
    version: single-key-retriever
    smartcast: (setting) ->
      bind: input-ini.get setting.bind-key
      toggle: input-init.get setting.toggle-key

  parsers =
    toggle: (setting, raw-value) ->
      switch raw-value
      | '1' => !setting.reverse
      | '0' => !!setting.reverse
    range: (setting, raw-value) -> parse-float raw-value
    volume: (setting, raw-value) ->
      volume: parsers.range {}, raw-value.volume
      muted: parsers.toggle {}, raw-value.muted
    resolution: (setting, raw-value) ->
      width: parse-int raw-value.width
      height: parse-int raw-value.height
    graphics: unprocessed
    'fps-cap': unprocessed
    'window-mode': unprocessed
    'cooldown-mode': unprocessed
    'color-palette': unprocessed
    version: (setting, raw-value) ->
      [major, minor, revision] = raw-value.split '.'
      {major, minor, revision}
    smartcast: (setting, raw-value) ->
      bind: raw-value.bind
      toggle: switch raw-value.bind
        | '1' => true
        | '0' => false
  
  get-value = (setting) ->
    parser = parsers[setting.type]
    retriever = retrievers[setting.type]
    
    raw-value = retriever setting
    if raw-value is void
      if setting.default-value is void
        throw new Error "Attempted to get setting '#{setting.id}' with no value and no default."
      else
        return setting.default-value
    
    parsed-value = parser setting, raw-value
    if parsed-value is void
      throw new Error "Setting '#{setting.id}' with raw-value '#{raw-value}' cannot be parsed."
    parsed-value    


  printers =
    toggle: (setting, value) ->
      switch value
      | !setting.reverse  => '1'
      | !!setting.reverse => '0'
    range: (setting, value) -> value.to-string!
    volume: (setting, value) ->
      volume: printers.range {}, value.volume
      muted: printers.toggle {}, value.muted
    resolution: (setting, value) ->
      width: value.width.to-string!
      height: value.height.to-string!
    graphics: unprocessed
    'fps-cap': unprocessed
    'window-mode': unprocessed
    'cooldown-mode': unprocessed
    'color-palette': unprocessed
    version: -> void
    smartcast: (setting, value) ->
      bind: value.bind
      toggle: switch value.toggle
        | true  => '1'
        | false => '0'

  storers =
    toggle: single-key-storer
    range: single-key-storer
    volume: !(setting, printed-value) ->
      game-cfg.set setting.key, printed-value.volume
      game-cfg.set setting.mute-key, printed-value.muted  
    resolution: !(setting, printed-value) ->
      game-cfg.set setting.width-key, printed-value.width
      game-cfg.set setting.height-key, printed-value.height
    graphics: single-key-storer
    'fps-cap': single-key-storer
    'window-mode': single-key-storer
    'cooldown-mode': single-key-storer
    'color-palette': single-key-storer
    smartcast: !(setting, printed-value) ->
      input-ini.set setting.bind-key, printed-value.bind-key
      input-ini.set setting.toggle-key, printed-value.toggle-key

  set-value = !(setting, value) ->
    printer = printers[setting.type]
    storer = storers[setting.type]
    printed-value = printer setting, value
    if printed-value is void
      throw new Error "Setting '#{setting.id}' with value '#{value}' cannot be printed into cfg file format."
    storer setting, printed-value


  {
    get-value: get-value
    set-value: set-value
  }

