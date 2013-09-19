angular.module \lolconf .factory \LCProbe, ($q, LC-logger) ->
  {exec-file} = require 'child_process'
  {once} = require 'lodash'
  require! 'readline'

  probe-process = exec-file 'lolconf-probe.exe', []

  rl = readline.createInterface {
    input: probe-process.stdout
    output: probe-process.stdin
  }

  queue = {}
  seq-no = 0

  rl.on \line, (line) ->
    LC-logger.info "Received data from probe process.", line
    message = JSON.parse line
    deferred = delete queue[message.seq-no]

    if message.errorMsg
      deferred.reject message.errorMsg
    else
      deferred.resolve message


  {
    query: (command) ->
      deferred = $q.defer!

      queue[seq-no] = deferred
      rl.write command

      deferred.promise
  }