angular.module \lolconf .factory \LCStorageFactory, (LC-inicfg-parser) ->
  BACKUP_EXT = '.lc-backup'

  (path) ->
    {create-read-stream, create-write-stream, exists-sync} = require 'fs'
    {clone-deep} = require 'lodash'

    config = LC-inicfg-parser.parse path
    original = clone-deep config

    get-setting = (key) ->
      [section, real-key] = key.split '.'
      config.get-value section, real-key

    set-setting = !(key, value) ->
      [section, real-key] = key.split '.'
      config
        ..set-value section, real-key, value
        ..write-to-file!

    copy-file = !(src, dest) -->
      if exists-sync src
        read-stream = create-read-stream src
        write-stream = create-write-stream dest
        read-stream.on 'error', !(err) -> new Exception err
        write-stream.on 'error', !(err) -> new Exception err
        read-stream.pipe write-stream
      else
        throw new Exception "Cannot find file to backup: #{src}"    

    {
      get: get-setting
      set: set-setting
      backup: !-> copy-file path, path + BACKUP_EXT
      restore: !-> copy-file path + BACKUP_EXT, path
      backup-exists: -> exists-sync path + BACKUP_EXT
    }
