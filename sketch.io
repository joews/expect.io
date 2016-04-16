#
# expect.io API sketches
# A small unit testing library for Io
#

# TODO
# > More assertions
# > Report test- and assertion-level stats
# > Don't allow assertions outside tests? then we could expose a single `test` global
# > Smaller Lobby footprint
# > Tape output
# > Auto wire up report to print header and footer without explicit
#   method calls
# > Parallel tests
# > Skip feature
# > Only feature
# > Decide how to impl matcher messages - see comments on `equal`

# Assertions
Matchers := Object clone

# TODO choose an API for exposing a message
# > return list(result, message) [current choice]
# > magic last argument contains message - I think this has problems for interpolate.
# > set last matcher message on Matchers (self lastMessage := ...)
# > throw with message on fail (no message on pass)
# > ?
Matchers equal := method(a, b, 
  list(a == b, "#{a} should equal #{b}" interpolate)
)

#
# Reporter
#
DevReporter := Object clone do(
  passCount := 0
  failCount := 0

  reportStart := method(
    "# Starting expect.io tests\n" println
  )

  reportTestStart := method(desc,
    "## Test: #{desc}" interpolate println
  )

  reportFail := method(msg,
    failCount = failCount + 1
    " - failed: #{msg}" interpolate println
  )

  reportPass := method(msg,
    passCount = passCount + 1
    " - passed: #{msg}" interpolate println
  )

  reportEnd := method(
    "\n# Test report" println
    testCount := passCount + failCount
    tests := if(testCount == 1, "test", "tests")

    "Ran #{passCount + failCount} #{tests}" interpolate println
    " - #{passCount} passed" interpolate println
    " - #{failCount} failed" interpolate println
  )
)

# Test runner
reporter := DevReporter clone

getDefaultMessage := method(name, actual, expected,
  "#{name}: expected #{expected} but got #{actual}" interpolate
)

runMatcher := method(name, target, other,
  # "runMatcher #{name} #{target} #{other}" interpolate println
  testResult := Matchers perform(name, target, other)
  # " -> #{testResult}" interpolate println

  # Matchers can return result or (result, message)
  if (testResult isKindOf(list)) then(
    isPass := testResult first
    msg := testResult second
  ) else (
    isPass := testResult
    msg := getDefaultMessage(name, target, other)
  )

  if (isPass) then (
    reporter reportPass(msg)
  ) else (
    reporter reportFail(msg)
  ) 

)

test := method(desc, /* testCase, */
  reporter reportTestStart(desc)
  call evalArgAt(1)
)


#
# assert api
#
assert := Object clone
assert forward := method(a, b,
  methodName := call message name
  runMatcher(methodName, a, b)
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
    # "proxy #{target} #{other}" interpolate println

    runMatcher(methodName, target, other)
  )

  proxy
)

Object should := method(
  proxyFor(call target)
)

Object expect := method(target,
  wrapper := Object clone
  wrapper to := proxyFor(target)
  wrapper
)

