
Double balanced ternary calculator  
--

**explanation**  

jump my shoddy English docs if reads Chinese...  
it's more or less a wrapper of complex numbers, that's all about it  
visiting the live version is a good idea, hope it won't crash:  
<http://docview.cnodejs.net/projects/ternary/ternary-calculator/index.html?html>  

the `&` mark in a number is nessesary, `&` also represents '5&5'.  
the calculator takes in string in a string in S-exression but wrapped with '[]'.  
or you may import the methods in a script and then run it.  
I didn't test the methods throughly, but seems fine by now.  

usage  
--

it's CoffeeScript. you mao kown what to do if you know coffee..  
`ternary = require './operations'` while in the same directory.  
or put it in `<script src='operations.coffee' type='text/coffeescript'>`,  
then use a 'coffee-script.js' script to invoke, just like what I did,  
you can read the source of `index.html` for more detail.  

or, use coffee to compile it, for example, on Ubuntu(not sure for details):  

    $ sudo aptitude install nodejs npm -y
    $ sudo npm install coffee-script -g
    $ git clone git@github.com:jiyinyiyong/ternary-calculator.git
    $ cd ternary-calculator/
    $ coffee -bc operations.coffee # will get a js file

**in Node**  

using `var ternary = requrie('./operations');` to load it,  

**in browser**

just put in `<script>` tag, you will get a `ternary` object.  

**methods**  

`+` represents plus, so do `-`, `\*`, `/`, `\\`, `%`.  
`@` will return the integral part of a given number.  

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

中文部分  
--

实在不知道怎么写才好.. 双平衡三进制, 牵强附会比较多  
哪天能派上用场再说吧, 我期待是平面图形上能用, 再说
