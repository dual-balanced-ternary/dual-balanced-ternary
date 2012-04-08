
echo = console.log
error = (msg) -> throw new Error msg

# need a function to copy arraies
copy_arr = (arr) -> arr.concat()

# then length of number array*2+1
unit_pos = 100

# template of all number arraies
zero_arr = []
zero_arr.push '5' for i in [1..unit_pos*2+1]
zero_str = zero_arr.join ''

# use these initial strings to test this programe
str_A = '436&'
str_B = '43&'

# a varable to declare operation
operation = '+'

# define the procedures needed to calculate
run_in_arr =
  '+': (arr_Ax, arr_Ay, arr_Bx, arr_By) ->
    arr_x = ternary_plus arr_Ax, arr_Bx
    arr_y = ternary_plus arr_Ay, arr_By
    return [arr_x, arr_y]
  '-': (arr_Ax, arr_Ay, arr_Bx, arr_By) ->
    arr_x = ternary_minus arr_Ax, arr_Bx
    arr_y = ternary_minus arr_Ay, arr_By
    return [arr_x, arr_y]
  '*': (arr_Ax, arr_Ay, arr_Bx, arr_By) ->
    arr_x1 = ternary_multiply arr_Ax, arr_Bx
    arr_x2 = ternary_multiply arr_Ay, arr_By
    arr_x = ternary_minus arr_x1, arr_x2
    arr_y1 = ternary_multiply arr_Ax, arr_By
    arr_y2 = ternary_multiply arr_Ay, arr_Bx
    arr_y = ternary_plus arr_y1, arr_y2
    return [arr_x, arr_y]
  '/': (arr_Ax, arr_Ay, arr_Bx, arr_By) ->
    arr_x1 = ternary_multiply arr_Ax, arr_Bx
    arr_x2 = ternary_multiply arr_Ay, arr_By
    arr_x = ternary_plus arr_x1, arr_x2
    arr_y1 = ternary_multiply arr_Ay, arr_Bx
    arr_y2 = ternary_multiply arr_Ax, arr_By
    arr_y = ternary_minus arr_y1, arr_y2
    divisor_1 = ternary_multiply arr_Bx, arr_Bx
    divisor_2 = ternary_multiply arr_By, arr_By
    divisor = ternary_plus divisor_1, divisor_2
    arr_x = ternary_divide arr_x, divisor
    arr_y = ternary_divide arr_y, divisor
    return [arr_x, arr_y]
  '\\': (arr_Ax, arr_Ay, arr_Bx, arr_By) ->
    (@['/'] arr_Ax, arr_Ay, arr_Bx, arr_By).map @['@']
  '%': (arr_Ax, arr_Ay, arr_Bx, arr_By) ->
    [Ax, Ay] = @['\\'] arr_Ax, arr_Ay, arr_Bx, arr_By
    [Bx, By] = @['*'] Ax, Ay, arr_Bx, arr_By
    @['-'] arr_Ax, arr_Ay, Bx, By
  '@': (arr) ->
    for digit, index in arr
      if index > unit_pos
        arr[index] = '5'
      else arr[index] = digit
    arr

# use array to calculate, translate back and forth
read_arr_from_str = (str) ->
  str = str[1..] while str[0] is '5'
  str = str[...-1] while str[-1..-1][0] is '5'

  find_number = str.match /^([1-9]*)&([1-9]*)$/
  if find_number?
    arr = copy_arr zero_arr
    integral_part = find_number[1].split ''
    fraction_part = find_number[2].split ''

    digit_pos = unit_pos
    while integral_part.length > 0
      error 'integral_part to long' unless arr[digit_pos]?
      arr[digit_pos] = integral_part.pop()
      digit_pos -= 1

    digit_pos = unit_pos + 1
    while fraction_part.length > 0
      error 'fraction_part to long' unless arr[digit_pos]?
      arr[digit_pos] = fraction_part.shift()
      digit_pos += 1

    arr_x = []
    arr_y = []
    arr.forEach (digit) ->
      pair = digit_map[digit]
      arr_x.push pair[0]
      arr_y.push pair[1]

    return [arr_x, arr_y]
  else error 'not right string'

read_str_from_arr = (arrs) ->
  arr_x = arrs[0]
  arr_y = arrs[1]
  arr = []

  for digit, index in arr_x
    arr.push digit_map[digit + '' + arr_y[index]]

  integral_part = arr[..unit_pos].join ''
  fraction_part = arr[unit_pos+1..].join ''
  str = integral_part + '&' + fraction_part

  str = str[1..] while str[0] is '5'
  str = str[...-1] while str[-1..-1][0] is '5'
  str

# map between balanced ternary and double balanced ternary
digit_map =
  '1': '15'
  '15': '1'
  '2': '99'
  '99': '2'
  '3': '51'
  '51': '3'
  '4': '91'
  '91': '4'
  '5': '55'
  '55': '5'
  '6': '19'
  '19': '6'
  '7': '59'
  '59': '7'
  '8': '11'
  '11': '8'
  '9': '95'
  '95': '9'

# map used for plus and multiply in balanced ternary
plus_map =
  '11': '19'
  '15': '51'
  '19': '55'
  '51': '51'
  '55': '55'
  '59': '59'
  '91': '55'
  '95': '59'
  '99': '91'

multiply_map =
  '11': '1'
  '15': '5'
  '19': '9'
  '51': '5'
  '55': '5'
  '59': '5'
  '91': '9'
  '95': '5'
  '99': '1'

# plus of ternary in array
ternary_plus = (arr_A, arr_B) ->
  arr_A = arr_A.concat()
  arr_B = arr_B.concat()
  arr = copy_arr zero_arr
  while (arr_B.join '') isnt zero_str
    for digit, index in arr_A
      pair = digit + '' + arr_B[index]
      [tens, ones] = plus_map[pair]
      arr_A[index] = ones
      if (not arr[index-1]?) and tens isnt '5'
        error 'overflow while plus'
      arr[index-1] = tens
    arr_B = copy_arr arr
    arr = copy_arr zero_arr
  return arr_A

ternary_minus = (arr_A, arr_B) ->
  ternary_plus arr_A, (negative_arr arr_B)

ternary_multiply = (arr_A, arr_B) ->
  arr_1 = copy_arr zero_arr
  arr_2 = copy_arr zero_arr
  for digit, index in arr_A
    if digit is '5' then continue
    else if digit is '1'
      arr_1 = copy_arr arr_B
    else if digit is '9'
      arr_1 = negative_arr arr_B
    else error 'bad arr elem in multiply'
    devation = index - unit_pos
    while devation < 0
      if arr_1.shift() isnt '5' then error 'out range right'
      arr_1.push '5'
      devation += 1
    while devation > 0
      if arr_1.pop() isnt '5' then error 'out range left'
      arr_1.unshift '5'
      devation -= 1
    arr_2 = ternary_plus arr_2, arr_1
    arr_1 = copy_arr zero_arr
  return arr_2

ternary_divide = (arr_A, arr_B) ->
  arr_1 = copy_arr zero_arr
  if (arr_A.join '') is zero_str
    # echo 'zero!'
    return arr_A
  # echo 'A is: ', (arr_A.join '')
  # echo 'B is: ', (arr_B.join '')
  space_A = arr_A.join('').match(/^(5*)/)[1].length
  space_B = arr_B.join('').match(/^(5*)/)[1].length
  distance = space_B - space_A
  jump = unit_pos - distance - 2
  if distance < 0 then distance = -distance
  if unit_pos - distance < 1 then error 'our range dvision'
  for item_1, index_1 in arr_1
    if index_1 < jump then continue
    arr_2 = copy_arr zero_arr
    jump_loop = no
    for item_2, index_2 in arr_B
      point = index_1 + index_2 - unit_pos
      if not arr_2[point]?
        if item_2 isnt '5'
          jump_loop = yes
          break
      if arr_2[point]?
        arr_2[point] = arr_B[index_2]
    if jump_loop then continue
    digit = '5'
    left = copy_arr arr_A
    left_1 = ternary_minus arr_A, arr_2
    left_9 = ternary_plus arr_A, arr_2
    if smaller_arr left_1, left
      digit = '1'
      left = copy_arr left_1
    if smaller_arr left_9, left
      digit = '9'
      left = copy_arr left_9
    arr_A = copy_arr left
    arr_1[index_1] = digit
  
  # echo 'r is: ', arr_1.join ''
  return arr_1

# use negative arr while doing minus
negative_arr = (arr) ->
  arr.map (x) ->
    switch x
      when '1' then return '9'
      when '9' then return '1'
      when '5' then return '5'
      else error 'bad digit'

# will be used to choose the closest quotient
smaller_arr = (arr_A, arr_B) ->
  # echo 'sm: ', arr_A.join ''
  # echo 'sm: ', arr_B.join ''
  head_files_1 = (arr_A.join '').match(/^(5*)/)[1].length
  head_files_2 = (arr_B.join '').match(/^(5*)/)[1].length
  if head_files_2 > head_files_1 then return false
  if head_files_2 < head_files_1 then return true
  test = copy_arr arr_A
  while test[0]?
    head = test.shift()
    if head is '5' then continue
    if head is '9'
      arr_A = negative_arr arr_A
    break
  test = copy_arr arr_B
  while test[0]?
    head = test.shift()
    if head is '5' then continue
    if head is '9'
      arr_B = negative_arr arr_B
    break
  for digit, index in arr_A
    if digit is arr_B[index] then continue
    if digit < arr_B[index] then return false
  return true

# map decimal to ternary
decimal_ternary_map =
  "0": "&"
  "1": "1&"
  "2": "19&"
  "3": "15&"
  "4": "11&"
  "5": "199&"
  "6": "195&"
  "7": "191&"
  "8": "159&"
  "9": "155&"
  "10": "151&"
  '1&': [ 1, 0]
  '2&': [-1, -1]
  '3&': [ 0, 1]
  '4&': [-1, 1]
  '5&': [ 0, 0]
  '6&': [ 1,-1]
  '7&': [ 0,-1]
  '8&': [ 1, 1]
  '9&': [-1, 0]

# the way to connect the whole programe
proceed = (operation, str_A, str_B) ->
  [arr_Ax, arr_Ay] = read_arr_from_str str_A
  [arr_Bx, arr_By] = read_arr_from_str str_B
  result = run_in_arr[operation] arr_Ax, arr_Ay, arr_Bx, arr_By
  # echo result[0].join '_'
  # echo result[1].join '_'
  read_str_from_arr result

# run test
# echo read_str_from_arr (read_arr_from_str str_A)
# echo ternary_divide ['5','5','1','1','1','5','5'], ['5','1','9','5','5','5','5']
# echo proceed '%', str_A, str_B

# translation between decimal and ternary
decimal_to_ternary = (x, y) ->
  x_negative = no
  y_negative = no
  if x < 0
    x_negative = on
    x = -x
  if y < 0
    y_negative = on
    y = -y
  x = String x
  y = String y
  ternary_x = '&'
  ternary_y = '&'
  find_x = x.match /^(\d+)(\.(\d+))?$/
  if find_x?
    if not find_x[3] then find_x[3] = ''
    int_arr = find_x[1].split ''
    fra_arr = find_x[3].split ''
    base = '1&'
    while int_arr.length > 0
      number = decimal_ternary_map[int_arr.pop()]
      number = proceed '*', number, base
      ternary_x = proceed '+', number, ternary_x
      base = proceed '*', base, '151&'
    base = proceed '/', '1&', '151&'
    while fra_arr.length > 0
      number = decimal_ternary_map[fra_arr.shift()]
      number = proceed '+', number, ternary_x
      ternary_x = proceed '+', number, ternary_x
  else error 'bad x number string'
  find_y = y.match /^(\d+)(\.(\d+))?$/
  if find_y?
    if not find_y[3] then find_y[3] = ''
    int_arr = find_y[1].split ''
    fra_arr = find_y[3].split ''
    base = '1&'
    while int_arr.length > 0
      number = decimal_ternary_map[int_arr.pop()]
      number = proceed '*', number, base
      ternary_y = proceed '+', number, ternary_y
      base = proceed '*', base, '151&'
    base = proceed '/', '1&', '151&'
    while fra_arr.length > 0
      number = decimal_ternary_map[fra_arr.shift()]
      number = proceed '+', number, ternary_y
      ternary_y = proceed '+', number, ternary_y
      base = proceed '/', base, '151&'
  else error 'bad y number string'
  if x_negative then ternary_x = proceed '-', '&', ternary_x
  if y_negative then ternary_y = proceed '-', '&', ternary_y
  ternary_y = proceed '*', '3&', ternary_y
  return proceed '+', ternary_x, ternary_y

ternary_to_decimal = (ternary_str) ->
  find_number = ternary_str.match /^([1-9]*)&([1-9]*)$/
  if find_number?
    integral_part = find_number[1]
    fraction_part = find_number[2]
    pos_x = 0
    pos_y = 0
    unit = 1
    int_arr = integral_part.split ''
    fra_arr = fraction_part.split ''
    while int_arr.length > 0
      [x, y] = decimal_ternary_map[int_arr.pop()+'&']
      pos_x += x * unit
      pos_y += y * unit
      unit *= 3
    unit = 1 / 3
    while fra_arr.length > 0
      [x, y] = decimal_ternary_map[fra_arr.shift()+'&']
      pos_x += x * unit
      pos_y += y * unit
      unit /= 3
    return [pos_x, pos_y]
  else error 'bad ternary_str to translate'

# [a, b] = ternary_to_decimal '888&'
# echo decimal_to_ternary a, b

# export ads libs
if exports?
  exports['+'] = (str_A, str_B) ->
    proceed '+', str_A, str_B
  exports['-'] = (str_A, str_B) ->
    proceed '-', str_A, str_B
  exports['*'] = (str_A, str_B) ->
    proceed '*', str_A, str_B
  exports['/'] = (str_A, str_B) ->
    proceed '/', str_A, str_B
  exports['\\'] = (str_A, str_B) ->
    proceed '\\', str_A, str_B
  exports['%'] = (str_A, str_B) ->
    proceed '%', str_A, str_B
  exports['@'] = (str) ->
    arr = read_arr_from_str str
    arr = arr.map run_in_arr['@']
    read_str_from_arr arr
  exports.decimal_to_ternary = decimal_to_ternary
  exports.ternary_to_decimal = ternary_to_decimal

if window?
  window['+'] = (str_A, str_B) ->
    proceed '+', str_A, str_B
  window['-'] = (str_A, str_B) ->
    proceed '-', str_A, str_B
  window['*'] = (str_A, str_B) ->
    proceed '*', str_A, str_B
  window['/'] = (str_A, str_B) ->
    proceed '/', str_A, str_B
  window['\\'] = (str_A, str_B) ->
    proceed '\\', str_A, str_B
  window['%'] = (str_A, str_B) ->
    proceed '%', str_A, str_B
  window['@'] = (str) ->
    arr = read_arr_from_str str
    arr = arr.map run_in_arr['@']
    read_str_from_arr arr
  window.decimal_to_ternary = decimal_to_ternary
  window.ternary_to_decimal = ternary_to_decimal