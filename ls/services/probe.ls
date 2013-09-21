angular.module \lolconf .factory \LCProbe, ($q, LC-logger) ->
  {exec-file} = require 'child_process'
  {once} = require 'lodash'

  probe-process = exec-file 'lolconf-probe.exe', []

  queue = {}
  seq-no = 0

  data-buffer = ''
  probe-process.stdout.on \data, (data) ->
    LC-logger.info "Received data from probe process.", data.to-string!
    data-buffer := data-buffer + data.to-string!    
    try
      message = JSON.parse data-buffer
      data-buffer := ''
      deferred = delete queue[message.seq-no]

      if message.result.errorMsg
        deferred.reject message.result.errorMsg
      else
        deferred.resolve message.result

  {
    query: (command) ->
      deferred = $q.defer!

      queue[seq-no] = deferred
      query = JSON.stringify {
        command: command
        seq-no: seq-no.to-string!
      }
      seq-no++

      probe-process.stdin.write query + '\n'

      deferred.promise
  }