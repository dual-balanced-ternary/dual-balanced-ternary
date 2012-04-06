
echo = console.log
error = (msg) -> throw new Error msg

# need a function to copy arraies
copy_arr = (arr) -> arr.concat()

# then length of number array
accuracy = 81

# template of all number arraies
zero_arr = []
zero_arr.push '5' for i in [1..80]

# use these initial strings to test this programe
str_A = '3456&344'
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
  str = str[1..] while str[1] is '5'
  str = str[...-1] while str[-1..-1][0] is '5'
  find_number = str.match /^([1-9]+)&([1-9]+)$/
  if find_number?
    echo find_number
  else error 'not right string'

read_str_from_arr = (arr) ->
  ''

# the way to connect the whole programe
proceed = (operation, str_A, str_B) ->
  arr_A = read_arr_from_str str_A
  arr_B = read_arr_from_str str_B
  result = run_in_arr[operation] arr_A, arr_B
  read_str_from_arr result