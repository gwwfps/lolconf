angular.module \lolconf .directive \lcClose, ->
  link: !(scope, element, attrs) ->
    element.on \click, !->      
      gui = require 'nw.gui'
      win = gui.Window.get!
      win.close!
