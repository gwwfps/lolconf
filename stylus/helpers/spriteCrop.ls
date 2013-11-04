module.exports = ->
  !(style) ->
    nodes = @nodes
    style.define 'extract', (id, x, y, w, h) ->
      {exists-sync, mkdir-sync} = require 'fs'
      require! 'gm'

      base-dir = "#{__dirname}/../.."
      output-dir = "images/generated"
      output-filename = "#{output-dir}/#{id}_#{x}_#{y}_#{w}_#{h}.png"

      "#{base-dir}/#{output-dir}" |> (dir) ->
        if not exists-sync dir
          mkdir-sync dir

      gm "#{base-dir}/images/FoundryOptions_#{id}.png"
        .crop w, h, x, y
        .write "#{base-dir}/#{output-filename}", (err) ->
          if err
            throw new Error err
      
      new nodes.String output-filename
