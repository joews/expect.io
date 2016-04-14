#
# expect.io API sketches
# A small unit testing library for Io
#

# TODO
# > More assertions
# > Assertion-level try/catch so each test can
#   report on several assertions
# > Smaller Lobby footprint
# > Tape output
# > Auto wire up report to print header and footer without explicit
#   method calls
# > Parallel tests
# > Skip feature
# > Only feature

# Assertions
assert := Object clone

AssertError := Exception clone

assert _assert := method(okIfTrue, msg,
  okIfTrue ifFalse(
    AssertError raise(msg)
  )

  msg
)

assert equal := method(a, b, 
  _assert(a == b, "#{a} should be equal to #{b}" interpolate)
)

# Test runner
passCount := 0
failCount := 0

# First cut test method, with testcase-level error granularity
test := method(description, /* testCase, */
  ("Test: " .. description) println
  e := try (call evalArgAt(1)) 

  if (e isNil) then (
    passCount = passCount + 1
    " - passed" println
  ) else (
    failCount = failCount + 1
    " - failed: #{e error}" interpolate println
  ) 
)

#
# Reporter
#
reportStart := method(
  "# Starting expect.io tests\n" println
)

reportEnd := method(
  "\n# Test report" println
  testCount := passCount + failCount
  tests := if(testCount == 1, "test", "tests")

  "Ran #{passCount + failCount} #{tests}" interpolate println
  " - #{passCount} passed" interpolate println
  " - #{failCount} failed" interpolate println
)

#
# expect/should api
#
Object proxyFor := method(target,
  proxy := Object clone
  proxy target := target

  # Forward missing method calls to assert
  # Assumes tests have arity 2. I think we can work around
  #  that using performWithArgList if necessary.
  proxy forward := method(other,
    methodName := call message name
    assert perform(methodName, target, other)
  )

  proxy
)

# TODO opt-in to `should` monkeypatch
Object should := method(
  proxyFor(call target)
)

Object expect := method(target,
  wrapper := Object clone
  wrapper to := proxyFor(target)
  wrapper
)


#
# Testing 
#
reportStart()

test("This test will pass",
  1 should equal(1)
  1 should equal(1)
)

test("This test will fail",
  1 should equal(22)
)

reportEnd()
