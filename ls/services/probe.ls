angular.module \lolconf .factory \LCProbe, (LC-logger) ->
  {exec-file} = require 'child_process'
  require! 'http'

  probe-process = exec-file 'lolconf-probe.exe'

  process.on 'exit', ->
    probe-process.kill!


  {
    get: (path) ->
      opts = {
        socket-path: '\\\\.\\pipe\\lolconf'
        path: path
        method: \GET
      }
      http.request opts, (res) ->
        console.log res
  }