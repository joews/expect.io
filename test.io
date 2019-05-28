# TODO test with namespaced import
doFile("sketch.io")

reporter reportStart()

# reporter @@reportEnd()


test("This test will pass",
  1 should equal(1)
)

test("This test will fail",
  1 should equal(22)
)

test("This test will partly fail",
  1 should equal(1)
  1 should equal(10)
)

# Scheduler waitForCorosToComplete
