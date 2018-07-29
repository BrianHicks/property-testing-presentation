module MoneySpec exposing (..)

import Expect
import Fuzz exposing (Fuzzer)
import Money exposing (..)
import Test exposing (..)


money : Fuzzer Money
money =
    Fuzz.oneOf
        [ Fuzz.constant Dollar
        , Fuzz.constant Quarter
        , Fuzz.constant Dime
        , Fuzz.constant Nickel
        , Fuzz.constant Penny
        ]


moneySpec : Test
moneySpec =
    describe "Money"
        [ describe "toFloat"
            [ fuzz money "is never zero" <|
                \money ->
                    money
                        |> Money.toFloat
                        |> Expect.notEqual 0
            ]
        ]
