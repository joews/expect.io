# expect.io
A tiny unit test library for Io. Work in progress.

```io
test("testing some tests", 
  assert equal(result, "foo")
  expect(result) to equal("bar")
  result should equal("wat")
)
```

