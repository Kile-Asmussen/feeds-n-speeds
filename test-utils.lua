require('utils')

mytable = table.new()

mytable:insert(22)

mytable.a = "hello"

assert(mytable.a == "hello")
assert(mytable[1] == 22)
assert(mytable:rawget('a') == "hello")