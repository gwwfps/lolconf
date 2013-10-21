angular.module \lolconf .factory \LCGameConfig, (LC-game-config-storage) -> 
  unprocessed = (setting, value) -> value

  parsers =
    toggle: (setting, raw-value) ->
      switch raw-value
      | '1' => !setting.reverse
      | '0' => !!setting.reverse
    
  printers =
    toggle: (setting, value) ->
      switch value
      | !setting.reverse  => '1'
      | !!setting.reverse => '0'
  
  single-key-retriever = (setting) -> LC-game-config-storage.get setting.key

  retrievers =
    toggle: single-key-retriever

  single-key-storer = (setting, printed-value) -> LC-game-config-storage.set setting.key, printed-value

  storers =
    toggle: single-key-storer

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

