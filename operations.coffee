
echo = console.log
error = (msg) -> throw new Error msg

# need a function to copy arraies
copy_arr = (arr) -> arr.concat()

# then length of number array*2+1
unit_pos = 7

# template of all number arraies
zero_arr = []
zero_arr.push '5' for i in [1..unit_pos*2+1]

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

# the way to connect the whole programe
proceed = (operation, str_A, str_B) ->
  arr_A = read_arr_from_str str_A
  arr_B = read_arr_from_str str_B
  result = run_in_arr[operation] arr_A, arr_B
  read_str_from_arr result

# run test
echo read_str_from_arr (read_arr_from_str str_A)