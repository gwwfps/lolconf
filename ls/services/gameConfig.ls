angular.module \lolconf .factory \LCGameConfig, (LC-game-config-storage) ->
  unprocessed = (setting, value) -> value
  single-key-retriever = (setting) -> LC-game-config-storage.get setting.key
  single-key-storer = !(setting, printed-value) -> LC-game-config-storage.set setting.key, printed-value


  retrievers =
    toggle: single-key-retriever
    range: single-key-retriever
    volume: (setting) ->
      volume: LC-game-config-storage.get setting.key
      muted: LC-game-config-storage.get setting.mute-key
    resolution: (setting) ->
      width: LC-game-config-storage.get setting.width-key
      height: LC-game-config-storage.get setting.height-key
    graphics: single-key-retriever
    'fps-cap': single-key-retriever
    'window-mode': single-key-retriever
    'cooldown-mode': single-key-retriever
    'color-palette': single-key-retriever

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

  storers =
    toggle: single-key-storer
    range: single-key-storer
    volume: !(setting, printed-value) ->
      LC-game-config-storage.set setting.key, printed-value.volume
      LC-game-config-storage.set setting.mute-key, printed-value.muted  
    resolution: !(setting, printed-value) ->
      LC-game-config-storage.set setting.width-key, printed-value.width
      LC-game-config-storage.set setting.height-key, printed-value.height
    graphics: single-key-storer
    'fps-cap': single-key-storer
    'window-mode': single-key-storer
    'cooldown-mode': single-key-storer
    'color-palette': single-key-storer

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

