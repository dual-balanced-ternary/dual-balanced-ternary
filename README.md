
Dual balanced ternary calculator
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

```coffee
ops = require 'dual-balanced-ternary'
ops.add '1&', '1&' # => '19&'
```

`+` represents plus, so do `-`, `\*`, `/`, `\\`, `%`.  
`@` will return the integral part of a given number.  

```coffee
ternary['+']  1&, 1&        # returns '19&'
ternary['-']  345&, 353&    # returns '47&'
ternary['*']  4&4, 3&47     # returns '74&968'
ternary['/']  74&968, 4&4   # returns '3&47'
ternary['\\'] 74&968, 4&4   # returns '3&'
ternary['%']  74&968, 4&4   # returns '7&368'
ternary['@']  74&968        # returns '74&'

ternary.decimal_to_ternary -9.296296296296298, 37.2962962962963
# returns '3453&456544656564654...'
ternary.ternary_to_decimal 3453&456
# returns [ -9.296296296296298, 37.2962962962963 ]
```

### License

MIT