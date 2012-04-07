
parse = (arr) ->
  do recurse = ->
    head = do arr.shift
    if head is '('
      in_brackets = []
      in_brackets.push do recurse until arr[0] is ')'
      do arr.shift
      return in_brackets
    else
      return head

run = (arr) ->
  head = arr[0]
  body = arr[1..]
  if window[head]?
    console.log body
    body = body.map (x) ->
      if typeof x is 'object' then x = run x
      return x
    body.reduce (x, y) ->
      window[head] x, y
  else throw new Error 'cannot find method:', head

render = (str) ->
  try
    type = 'result'
    arr = str
      .replace(/\(/g, ' ( ')
      .replace(/\)/g, ' ) ')
      .split(' ')
      .filter((x) ->
        if x isnt '' then true else false)
    msg = run (parse arr)
  catch error
    type = 'error'
    msg = error.message
  html = ">>> &nbsp; &nbsp; <span class='#{type}'>#{msg}</span><br>"
  write.innerHTML += html

write = document.getElementById 'write'
input = document.getElementById 'input'

input.focus()
document.onkeydown = (event) ->
  input.focus()
  if event.keyCode is 13
    str = input.value
    input.value = ''
    render str
    return false