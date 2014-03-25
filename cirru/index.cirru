
doctype
html
  head
    title $ = Calculator
    meta (:charset utf-8)
    link (:rel stylesheet) (:href css/style.css)
    script (:defer) (:src build/build.js)
  body
    #write
    textarea#input