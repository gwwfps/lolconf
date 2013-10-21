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
    parser setting, raw-value

  set-value = !(setting, value) ->
    printer = printers[setting.type]
    storer = storers[setting.type]
    printed-value = printer setting, value
    storer setting, printed-value

  {
    get-value: get-value
    set-value: set-value
  }

