
parse = (arr) ->
  do recurse = ->
    head = do arr.shift
    if head is '['
      in_brackets = []
      in_brackets.push do recurse until arr[0] is ']'
      do arr.shift
      return in_brackets
    else
      return head

run = (arr) ->
  head = arr[0]
  body = arr[1..]
  if ternary[head]?
    console.log body
    body = body.map (x) ->
      if typeof x is 'object' then x = run x
      return x
    console.log ''
    if head is '@'
      return ternary[head] body[0]
    body.reduce (x, y) ->
      ternary[head] x, y
  else throw new Error 'cannot find method:', head

fold_str = (arr) ->
  console.log 'while:', arr
  arr = arr.map (x) ->
    if typeof x is 'object'
      return fold_str x
    else return x
  "[#{arr.join ' '}]"

render = (str) ->
  try
    type = 'result'
    arr = str
      .replace(/\[/g, ' [ ')
      .replace(/\]/g, ' ] ')
      .split(' ')
      .filter((x) ->
        if x isnt '' then true else false)
    console.log 'arr:', arr
    fold = parse arr
    console.log 'fold:', fold
    array_str = fold_str fold
    console.log 'array_str:', array_str
    write.innerHTML += "<span class='array'>got array:#{array_str}</span><br>"
    msg = run fold
  catch error
    type = 'error'
    msg = error.message
  html = ">>> &nbsp; &nbsp; <span class='#{type}'>#{msg}</span><br>"
  write.innerHTML += html

write = document.getElementById 'write'
input = document.getElementById 'input'

input.focus()

history = [
  'hello world',
  '[+ 1& 4& [* 4& 567& [/ 45& 34&]]]',
  '[@ 564564&]',
  '[\\ 345& 68&]',
  '[% 345& 68&]'
]

current = 5

previous = ->
  if current > 0
    current -= 1
    input.value = history[current]

next = ->
  if current < history.length - 1
    current += 1
    input.value = history[current]
  if current is (history.length - 1)
    current += 1
    input.value = '[]'
    input.selectionStart = 1
    input.selectionEnd = 1

input.onkeydown = (event) ->
  code = event.keyCode
  console.log code
  pos = input.selectionStart
  str = input.value
  if event.keyCode is 13
    str = input.value
    history.push str
    current += 1
    input.value = '[]'
    input.selectionStart = 1
    input.selectionEnd = 1
    render str
    return false
  if event.keyCode is 229
    write.innerHTML += '<span class="error">please turn off Chinese input mode<span>'
  if code is 219
    str = str[...pos] + '[]' + str[pos..]
    input.value = str
    input.selectionStart = pos + 1
    input.selectionEnd = pos + 1
    return false
  if code is 221
    if str[pos] is ']'
      pos += 1
      input.selectionStart = pos
      input.selectionEnd = pos
      return false
  if code is 8
    if str[pos-1..pos] is '[]'
      str = str[...pos-1] + str[pos+1..]
      input.value = str
      pos -= 1
      input.selectionStart = pos
      input.selectionEnd = pos
      return false
  if code is 56 and event.shiftKey
    str = str[...pos] + '* ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 187 and event.shiftKey
    str = str[...pos] + '+ ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 189
    str = str[...pos] + '- ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 191
    str = str[...pos] + '/ ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 53 and event.shiftKey
    str = str[...pos] + '% ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 50 and event.shiftKey
    str = str[...pos] + '@ ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 220
    str = str[...pos] + '\\ ' + str[pos..]
    input.value = str
    pos += 2
    input.selectionStart = pos
    input.selectionEnd = pos
    return false
  if code is 32
    front = str[...pos]
    find_number = front.match /\s([1-9]+)$/
    console.log front, find_number
    if find_number?
      str = front + '& ' + str[pos..]
      input.value = str
      pos += 2
      input.selectionStart = pos
      input.selectionEnd = pos
      return false
  if code is 38 then do previous
  if code is 40 then do next