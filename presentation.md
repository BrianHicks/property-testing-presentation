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
      - example: vending machine spec
        - introduce the vending machine example
          - what properties does this spec have?
  - write well-formed generators/shrinkers
- apply model testing to their own code

Vending machine spec:

It works how you'd expect a vending machine to work. Specifically:

1. Put money into the vending machine
2. Push the button for the drink you want
3. Get the drink

Level 2:

- only accept payment if you can provide the requested drink
- only accept non-exact payments if you can make change
- if there's no money in the machine:
  - pushing a drink button doesn't dispense a drink
  - pushing the refund button doesn't dispense change

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

## 3. How can I use them?

---

[.background-color: #7ED321]
[.header: #FFF]

## 4. :skull: Demo :skull:

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

## 1b. What's a property?

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

# [fit] `1024*512 = 512*1024`

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
            \n m ->
                Expect.equal (n * m) (m * n)
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

# [fit] What property
# testing *isn't*

---

### Property Testing isn't...
## Formal Methods

---

### Property Testing isn't...
## Fuzzing

---

### Property Testing isn't...
## Integration Testing

---

the end no more slides garbage now
