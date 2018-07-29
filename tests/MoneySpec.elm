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
            , describe "specific values" <|
                List.map
                    (\( unit, value ) ->
                        test ("a " ++ toString unit ++ " is worth " ++ toString value) <|
                            \_ ->
                                Expect.equal (Money.toFloat unit) value
                    )
                    [ ( Dollar, 1 )
                    , ( Quarter, 0.25 )
                    , ( Dime, 0.1 )
                    , ( Nickel, 0.05 )
                    , ( Penny, 0.01 )
                    ]
            ]
        , describe "toMoney"
            [ fuzz (Fuzz.floatRange 0 1000) "has at least one money in it" <|
                \amount ->
                    Money.toMoney amount
                        |> Expect.notEqual []
            ]
        ]
