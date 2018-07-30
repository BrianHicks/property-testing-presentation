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

> Historically, the definition of property based testing has been "The thing that QuickCheck does".
>
> -- David R. MacIver, [What is Property Based Testing?](https://hypothesis.works/articles/what-is-property-based-testing/)

---

![150%](https://media.giphy.com/media/y65VoOlimZaus/giphy.gif)

---

[.background-color: #7ED321]
[.header: #FFF]

## 1. What's a property ~~test~~?

---

## A property is a thing that's always true about some code.

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

# `int`

# [fit] `-27 794774205 -3 -8 1 7`

---

# `list int`

# [fit] `[-42, 29, -16, -3533777802, 0]`

---

# `string`

# [fit] `"\t\t \t\n " "ws0\\M$6E&" "in" ""`

---

# `string`

#### `QTp%gZY+O1~ZvPb7.2L%;@_m1g~P}\"EA2pI!donAF$2nbQ6n#1x?Co4]v/h)_m;x2xsu(\"BM4)4a,fX+L5*e->{QV:#a6|~DWpA'Qt)|+[&%p3N^[cpbK*jK=\\G1lbRNl+]}!@s3\"@MA-JcaHq>w0J)/|YF2|fb&sJCS|rOL2PZ}J$+Q\\B~H#b>*lK-\"So@KxHBD4]>N05wV:[m|>%<,rkUa-nQ\"D,uocep2GNiVtt6K+aXY=r!/S&eo'r5_7N=<bZ%tk)l_slFk~eJBe@MmM$&|ylu:3EGLobZ^\"7/;aVQ|n*o _,l4[_yjqa>vq)mb}Dhq(f_g#0aV&H8/=[B-7W))Ef~pSw~'Ja5o0:J{F8[E,iCU0}-j}'&(CCh~Z<OYkz}Ck8U$hl{nf+tqTH5:rawCP10:K*D)q79CG/e0APSPaXgH:MVAzmT)Z[Ru+7C4*jdJSihQx[RougtGn39TPzcnol|ES 4Cyex$E ={gE}w)$9;>@x@26WD9ok8SGS3P\\Jn)UG#}t^c!LvRdygD;:R$xLhbQ[xRJF^ya+eFVLxi95N:|@vZ_1R=`

---

# Won't I get garbage test cases?

---

# Nope!
# Shrinking!

---

```elm
fuzz (Fuzz.list Fuzz.int) "no five items" <|
    \xs ->
        Expect.notEqual 5 (List.length xs)

````

:x: `[26495, 20, -8, -47, 7]`

:x: `[0, 0, 0, -47, 7]`

:x: `[0, 0, 0, 0, 0]`

:white_check_mark: `[0, 0, 0, 0]`

---

```elm
snack : Fuzzer String
snack =
    Fuzz.oneOf
        [ Fuzz.constant "Dr. Pepper"
        , Fuzz.constant "All Dressed Chips"
        , Fuzz.constant "Baklava"
        ]
```

---

```elm
snack : Fuzzer String
snack =
    Fuzz.frequency
        [ ( 2, Fuzz.constant "Dr. Pepper" )
        , ( 5, Fuzz.constant "All Dressed Chips" )
        , ( 3, Fuzz.constant "Baklava" )
        ]
```

---

[.background-color: #7ED321]
[.header: #FFF]

## 2. When are they useful?

---

## When a property (invariant) is known.

---

## When two functions do symmetric things.

---

## When you can use a model to verify behavior.

---

## When the system under test does a complex thing, but the user sees a simple thing.

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

> The numbers in this list are be ordered from least to greatest.

---

## Rephrase if it's the same as what the implementation does

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
