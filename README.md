
Dual Balanced Ternary Calculator
------

### explanation

"Dual Balanced Ternary" is an extend version of "Balanced Ternary" for 2d plane.
It uses digits from `1` to `9` to represent each number, and `&` for `.`.

Instead of `1 0 -1` in Balanced Ternary, Dual Balanced Ternary uses digits like this:

```
  6  1  8
  7  5  3
  2  9  4
```

### Usage

```
npm install --save dual-balanced-ternary
```

`+` represents plus, so do `-`, `\*`, `/`, `\\`, `%`.  
`@` will return the integral part of a given number.  

```coffee
ops = require 'dual-balanced-ternary'
ops.add '1&', '1&'
# => '19&'
ops.add '1&', '1&'
# => '19&'
ops.subtract '345&', '353&'
# => '47&'
ops..multiply '4&4', '3&47'
# => '74&968'
ops.divide '74&968', '4&4'
# => '3&47'
ops.aliquot '74&968', '4&4'
# => '3&'
ops.modular '74&968', '4&4'
# => '7&368'
ops.integer '74&968'
# => '74&'

ternary.decimal_to_ternary -9.296296296296298, 37.2962962962963
# returns '3453&456544656564654...'
ternary.ternary_to_decimal '3453&456'
# returns [ -9.296296296296298, 37.2962962962963 ]
```

### License

MIT