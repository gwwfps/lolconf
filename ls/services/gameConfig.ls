angular.module \lolconf .factory \LCGameConfig, (LC-storage-factory, LC-game-location) ->
  require! {path.resolve}

  game-cfg = LC-storage-factory LC-game-location.config-path!
  input-ini = LC-storage-factory (resolve LC-game-location.get!, 'Config', 'Input.ini')

  unprocessed = (setting, value) -> value
  single-key-retriever = (setting) -> @storage.get setting.key
  single-key-storer = !(setting, printed-value) -> @storage.set setting.key, printed-value


  processors =
    toggle:
      storage: game-cfg
      retrieve: single-key-retriever
      parse: (setting, raw-value) ->
        switch raw-value
        | '1' => !setting.reverse
        | '0' => !!setting.reverse
      print: (setting, value) ->
        switch value
        | !setting.reverse  => '1'
        | !!setting.reverse => '0'
      store: single-key-storer
    range:
      storage: game-cfg
      retrieve: single-key-retriever
      parse: (setting, raw-value) -> parse-float raw-value
      print: (setting, value) -> value.to-string!
      store: single-key-storer
    volume:
      storage: game-cfg
      retrieve: (setting) ->
        volume: @storage.get setting.key
        muted: @storage.get setting.mute-key
      parse: (setting, raw-value) ->
        volume: processors.range.parse {}, raw-value.volume
        muted: processors.toggle.parse {}, raw-value.muted
      print: (setting, value) ->
        volume: processors.range.print {}, value.volume
        muted: processors.toggle.print {}, value.muted
      store: !(setting, printed-value) ->
        @storage.set setting.key, printed-value.volume
        @storage.set setting.mute-key, printed-value.muted
    resolution:
      storage: game-cfg
      retrieve: (setting) ->
        width: @storage.get setting.width-key
        height: @storage.get setting.height-key
      parse: (setting, raw-value) ->
        width: parse-int raw-value.width
        height: parse-int raw-value.height
      print: (setting, value) ->
        width: value.width.to-string!
        height: value.height.to-string!
      store: !(setting, printed-value) ->
        @storage.set setting.width-key, printed-value.width
        @storage.set setting.height-key, printed-value.height
    graphics:
      storage: game-cfg
      retrieve: single-key-retriever
      parse: unprocessed
      print: unprocessed
      store: single-key-storer
    'fps-cap':
      storage: game-cfg
      retrieve: single-key-retriever
      parse: unprocessed
      print: unprocessed
      store: single-key-storer
    'window-mode':
      storage: game-cfg
      retrieve: single-key-retriever
      parse: unprocessed
      print: unprocessed
      store: single-key-storer
    'cooldown-mode':
      storage: game-cfg
      retrieve: single-key-retriever
      parse: unprocessed
      print: unprocessed
      store: single-key-storer
    'color-palette':
      storage: game-cfg
      retrieve: single-key-retriever
      parse: unprocessed
      print: unprocessed
      store: single-key-storer
    version:
      storage: game-cfg
      retrieve: single-key-retriever
      parse: (setting, raw-value) ->
        [major, minor, revision] = raw-value.split '.'
        {major, minor, revision}
    smartcast:
      storage: input-ini
      retrieve: (setting) ->
        bind: @storage.get setting.bind-key
        toggle: @storage.get setting.toggle-key
      parse: (setting, raw-value) ->
        bind: raw-value.bind
          |> (s) -> s.substring 1, s.length - 1
          |> (s) ->
            | s == '<Unbound>' => ''
            | otherwise        => s
        toggle: switch raw-value.toggle
          | '1' => true
          | '0' => false
      print: (setting, value) ->
        bind: value.bind
          |> (s) ->
            | s == ''   => '<Unbound>'
            | otherwise => s
          |> (s) -> "[#{s}]"
        toggle: switch value.toggle
          | true  => '1'
          | false => '0'
      store: !(setting, printed-value) ->
        @storage.set setting.bind-key, printed-value.bind
        @storage.set setting.toggle-key, printed-value.toggle


  get-value = (setting) ->
    processor = processors[setting.type]
    
    raw-value = processor.retrieve setting
    if raw-value is void
      if setting.default-value is void
        throw new Error "Attempted to get setting '#{setting.id}' with no value and no default."
      else
        return setting.default-value
    
    parsed-value = processor.parse setting, raw-value
    if parsed-value is void
      throw new Error "Setting '#{setting.id}' with raw-value '#{raw-value}' cannot be parsed."
    parsed-value

  set-value = !(setting, value) ->
    processor = processors[setting.type]
    
    if processor.print is void
      throw new Error "Setting '#{setting.id}' cannot be changed."
    
    printed-value = processor.print setting, value
    if printed-value is void
      throw new Error "Setting '#{setting.id}' with value '#{value}' cannot be printed into cfg file format."
    
    processor.store setting, printed-value


  {
    get-value: get-value
    set-value: set-value
  }

