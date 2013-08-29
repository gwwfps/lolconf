angular.module \lolconf .factory \LCProbe, (LC-logger) ->
  {exec-file} = require 'child_process'
  {create-write-stream} = require 'fs'

  probe-process = exec-file 'lolconf-probe.exe'

  process.on 'exit', ->
    probe-process.kill!

  {}