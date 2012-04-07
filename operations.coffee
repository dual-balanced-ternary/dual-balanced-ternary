
echo = console.log
error = (msg) -> throw new Error msg

# need a function to copy arraies
copy_arr = (arr) -> arr.concat()

# then length of number array*2+1
unit_pos = 3

# template of all number arraies
zero_arr = []
zero_arr.push '5' for i in [1..unit_pos*2+1]
zero_str = zero_arr.join ''

# use these initial strings to test this programe
str_A = '433446&344'
str_B = '45345&'

# a varable to declare operation
operation = '+'

# define the procedures needed to calculate
run_in_arr =
  '+': (arr_A, arr_B) -> []
  '-': (arr_A, arr_B) -> []
  '*': (arr_A, arr_B) -> []
  '/': (arr_A, arr_B) -> []
  '%': (arr_A, arr_B) -> []
  '@': (arr_A, arr_B) -> []

# use array to calculate, translate back and forth
read_arr_from_str = (str) ->
  str = str[1..] while str[0] is '5'
  str = str[...-1] while str[-1..-1][0] is '5'

  find_number = str.match /^([1-9]+)&([1-9]+)$/
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
      if arr_1.pop() isnt '5' then error 'out range right'
      arr_1.unshift '5'
      devation += 1
    while devation > 0
      if arr_1.shift() isnt '5' then error 'out range left'
      arr_1.push '5'
      devation -= 1
    arr_2 = ternary_plus arr_2, arr_1
    arr_1 = copy_arr zero_arr
  return arr_2

ternary_divide = (arr_A, arr_B) ->
  arr_1 = copy_arr zero_arr
  space_A = arr_A.join('').match(/^\s*/).length
  space_B = arr_B.join('').match(/^\s*/).length
  distance = space_B - space_A
  jump = unit_pos - distance - 1
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
          continue
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
  arr_1

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
  test = copy_arr arr_A
  while test[0]?
    head = test.shift()
    if head is '5' then continue
    if head is '9'
      arr_A = negative_arr arr_A
      break
    if head is '1' then break
  test = copy_arr arr_B
  while test[0]?
    head = test.shift()
    if head is '5' then continue
    if head is '9'
      arr_B = negative_arr arr_B
      break
    if head is '1' then break
  for digit, index in arr_A
    if digit is arr_B[index] then continue
    if digit < arr_B[index] then return false
  return true

# the way to connect the whole programe
proceed = (operation, str_A, str_B) ->
  arr_A = read_arr_from_str str_A
  arr_B = read_arr_from_str str_B
  result = run_in_arr[operation] arr_A, arr_B
  read_str_from_arr result

# run test
# echo read_str_from_arr (read_arr_from_str str_A)
echo ternary_divide ['5','5','1','1','1','5','5'], ['5','1','9','5','5','5','5']