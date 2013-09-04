angular.module \lolconf .factory \LCProbe, ($q) ->
  {spawn} = require 'child_process'
  {once} = require 'lodash'

  probe-process = spawn 'lolconf-probe.exe', [], {stdio: [\ipc]}

  process.on 'exit', ->
    probe-process.kill!

  {
    query: (command) ->
      deferred = $q.defer!

      probe-process.on \message, (once (message) ->
        if message.errorMsg
          deferred.reject message.errorMsg
        else
          deferred.resolve message
      ) 

      probe-process.send command

      deferred.promise
  }