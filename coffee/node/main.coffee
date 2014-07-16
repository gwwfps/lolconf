app = require 'app'
BrowserWindow = require 'browser-window'

mainWindow = null

app.on 'window-all-closed', () ->
  if process.platform != 'darwin'
    app.quit()

app.on 'ready', () ->
  mainWindow = new BrowserWindow({width: 1171, height: 817, resizable: false, center: true, frame: false})

  mainWindow.loadUrl 'file://' + __dirname + '/main.html'

  appMetadata = require './package.json'
  if appMetadata.debug
    mainWindow.openDevTools()

  mainWindow.on 'closed', () ->
    mainWindow = null
