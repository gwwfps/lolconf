angular.module \lolconf .factory \LCProbe, ($q, LC-logger) ->
  {exec-file} = require 'child_process'
  {once} = require 'lodash'
  require! 'readline'

  probe-process = exec-file 'lolconf-probe.exe', []

  rl = readline.createInterface {
    input: probe-process.stdout
    output: probe-process.stdin
  }

  rl.on \line, (line) ->
    LC-logger.info "Received data from probe process.", line

  {
    query: (command) ->
      deferred = $q.defer!

      rl.on \line, (once (line) ->
        message = JSON.parse line
        if message.errorMsg
          deferred.reject message.errorMsg
        else
          deferred.resolve message
      ) 

      probe-process.stdin.write command

      deferred.promise
  }