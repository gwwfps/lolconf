angular.module \lolconf .factory \LCCharCodeTranslator, -> 
  table =
    113: 'q'
    119: 'w'
    101: 'e'
    114: 'r'
  {
    translate: (code) ->
      if code of table then table[code] else ''
  }