autoscale: true
theme: Fira, 6
header-strong: #7ED321
quote: #7ED321

<!--
SWBAT:

- apply property tests to their own code
  - formulate properties
    - know what a property is
      - example: commutativity
        assumed knowledge: most people know that `n*m == m*n`
      - example: encoding/decoding
        assumed knowledge: what serialization and deserialization are "supposed" to do
    - answer what properties their code has
      - example: sorting algorithm
        assumed knoweldge: what "sorting" means
        - rephrase the intent of the code
      - example: modeling change
        - introduce the money example
          - what properties does this spec have?
  - write custom generators

Money spec:

We want to program the money handling for a vending machine. That means, we need
to be able to keep track of units of monetary value and make change for them. We
also need to be able to perform basic mathematical operations on them.

-->

# Property Testing
## :beetle: **Find More Bugs!** :beetle:

---

# 'sup?

---

## This is the part of the talk where I say my company is hiring.

---

## We're gonna cover…

---

[.background-color: #7ED321]
[.header: #FFF]

## 1. What's a property test?

---

[.background-color: #7ED321]
[.header: #FFF]

## 2. When are they useful?

---

[.background-color: #7ED321]
[.header: #FFF]

## 3. How can I write good properties?

---

[.background-color: #7ED321]
[.header: #FFF]

## 4. :skull: Demo :skull:

---

[.background-color: #7ED321]
[.header: #FFF]

## 5. Takeaways & Recommendations

---

# Do Questions As We Go!

---

[.background-color: #7ED321]
[.header: #FFF]

## 1. What's a property test?

---

[.background-color: #7ED321]
[.header: #FFF]

## 1. What's a property ~~test~~?

---

## A property is a rule that describes a program's behavior.

---

# `5*3 = 3*5`

---

# Unit Testing

```elm
multiplication : Test
multiplication =
    describe "multiplication"
        [ test "is commutative" <|
            \_ ->
                Expect.equal (3 * 5) (5 * 3)
        ]
```

---

# `5*3 = 3*5`

---

# `x*y = y*x`

---

# Unit Testing

```elm
multiplication : Test
multiplication =
    describe "multiplication"
        [ test "is commutative" <|
            \_ ->
                Expect.equal (3 * 5) (5 * 3)
        ]
```

---

# Property Testing

```elm
multiplication : Test
multiplication =
    describe "multiplication"
        [ fuzz2 Fuzz.int Fuzz.int "is commutative" <|
            \x y ->
                Expect.equal (x * y) (y * x)
        ]
```

---

# What's going on here?

---

1. Generate a random integer `x`
2. Generate a random integer `y`
3. Feed those to the assertion
4. Repeat 100ish times

---

# Property Testing

```elm
multiplication : Test
multiplication =
    describe "multiplication"
        [ fuzz2 Fuzz.int Fuzz.int "is commutative" <|
            \x y ->
                Expect.equal (x * y) (y * x)
        ]
```

---

# Won't I get garbage input on failure?

---

1. Generate a random integer `x`
2. Generate a random integer `y`
3. Feed those to the assertion, **which fails! :cry:**
4. **Shrink the input to the simplest failing case**

---

```elm
fuzz (Fuzz.list Fuzz.int) "no five items" <|
    \xs ->
        Expect.notEqual 5 (List.length xs)

````

:x: `[26495, 20, -8, -47, 7]`

:x: `[0, 0, 0, -47, 7]`

:x: `[0, 0, 0, 0, 0]` :point_left:

:white_check_mark: `[0, 0, 0, 0]`

---

[.background-color: #7ED321]
[.header: #FFF]

## 2. When are they useful?

---

## When a property (invariant) is known.

---

## When two functions do symmetric things.

---

## When the system under test does a complex thing, but the user sees a simple thing.

---

## When you can use an "oracle" to verify behavior.

---

[.background-color: #7ED321]
[.header: #FFF]

## [fit] 2b. When are they *not* useful?

---

## When the code under test is super simple.

---

## When the code under test is extremely expensive.

---

[.background-color: #7ED321]
[.header: #FFF]

## 3. How can I write good properties?

---

## It's really hard to write properties. Sorry.

---

## Write down, in natural language, what your code should do.

---

> The numbers in this list are ordered from least to greatest.

---

> Each number in this list is less than or equal to the one after.

---

[.background-color: #7ED321]
[.header: #FFF]

## 4. :skull: Demo :skull:

---

[.background-color: #7ED321]
[.header: #FFF]

## 5. Takeaways & Recommendations

---

## Don't try to force property testing everywhere

---

## Built-in generators are often insufficient.
## Write your own!

---

## Language Support

| Language | Library |
|---|---|
| Elixir | stream_data
| Elm | elm-test
| Erlang | Quviq QuickCheck, PropEr
| Haskell | ~~QuickCheck~~ Hedgehog
| Python | Hypothesis
| Scala | ScalaCheck, Hedgehog
| *your favorite language here* | probably. Google it.

---

## Further Reading

- **Proper Testing:** propertesting.com
- **Hypothesis blog:** hypothesis.works

---

[.background-color: #7ED321]
[.header: #FFF]

# Thank You!

## brian@brianthicks.com

### github.com/BrianHicks/property-testing-presentation
