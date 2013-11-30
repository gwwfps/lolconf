angular.module \lolconf .factory \LCCharCodeTranslator, -> 
  table =
    113: 'q'
    119: 'w'
    101: 'e'
    114: 'r'
  {
    translate: (code) ->
      if 48 <= code <= 57 or 97 <= code <= 122
        return String.from-char-code code
      if code of table then table[code] else ''
  }