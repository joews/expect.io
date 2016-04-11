#
# expect.io API sketches
# A small unit testing library for Io
#

# Matchers
# TODO more of these
assert := Object clone
assert equal := method(a, b, a == b)


# TODO opt-in to `should` monkeypatch
# TODO explore even more linear syntax:
# x should equal y
Object should := method(
  proxy := Object clone
  proxy target := call target

  # Forward missing method calls to assert
  # Assumes tests have arity 2. I think we can work around
  #  that using performWithArgList if necessary.
  proxy forward := method(other,
    methodName := call message name
    assert perform(methodName, target, other)
  )

  proxy
)

# TODO DRY up proxy with should
Object expect := method(target,
  proxy := Object clone
  proxy target := target

  # Forward missing method calls to assert
  # Assumes tests have arity 2. I think we can work around
  #  that using performWithArgList if necessary.
  proxy forward := method(other,
    methodName := call message name

    # TODO can target be lexically bound?
    # ATM this only works with proxy target := target
    assert perform(methodName, target, other)
  )

  # TODO can I do this with do?
  # I want to replace these 3 lines with Object clone do (to := proxy),
  # but "Object does not respond to 'proxy'". Another issue with my understanding
  #  of lexical scope in Io
  wrapper := Object clone
  wrapper to := proxy
  wrapper
)

# TODO test with expect.io!
assert equal(1, 1) println
assert equal(1, 2) println

1 should equal(1) println
1 should equal(2) println

expect(1) to equal(1) println 
expect(1) to equal(2) println
