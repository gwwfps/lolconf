angular.module \lolconf .factory \LCLogger, ->   
  {Logger, transports: {File, Console}} = require 'winston'
  
  new Logger {
    transports: [
      new File filename: 'lolconf.log'
      new Console
    ]
    exception-handlers: [
      new File {
        filename: 'exceptions.log'
        exit-on-error: false
      }
    ]      
  }
