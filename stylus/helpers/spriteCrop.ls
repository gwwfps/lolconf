module.exports = ->
  !(style) ->
    nodes = @nodes
    style.define 'extract', (id, x, y, w, h) ->
      {exists-sync, mkdir-sync} = require 'fs'
      require! gm
      Fiber = require 'fibers'
      Future = require 'fibers/future'

      base-dir = "#{__dirname}/../.."
      output-dir = "images/generated"
      output-filename = "#{output-dir}/#{id}_#{x}_#{y}_#{w}_#{h}.png"

      "#{base-dir}/#{output-dir}" |> (dir) ->
        if not exists-sync dir
          mkdir-sync dir

      img = gm "#{base-dir}/images/FoundryOptions_#{id}.png" .crop w, h, x, y
      write-img = Fiber !->
        wrapped = Future.wrap img~write, 1
        err = wrapped "#{base-dir}/#{output-filename}" .wait!
        if err
          console.log err
      write-img.run!

      new nodes.String output-filename
