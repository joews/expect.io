A := Object clone do(
  preA := method("preA" println)
  a := method(wait(1); "a1" println; yield; "a2" println)
  b := method(wait(0) "b" println; yield; "b2" println)
)

o := A clone
p := A clone

o @preA
o @b
o @a
o @b
p @preA
p @b
p @a
p @b

Scheduler waitForCorosToComplete
"all the coros are done" println
