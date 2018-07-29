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


monies : Fuzzer (List Money)
monies =
    Fuzz.list money
        |> Fuzz.map (List.sortBy Money.toCents)


moneySpec : Test
moneySpec =
    describe "Money"
        [ describe "toCents"
            [ fuzz money "is never zero" <|
                \money ->
                    money
                        |> Money.toCents
                        |> Expect.notEqual 0
            , describe "specific values" <|
                List.map
                    (\( unit, value ) ->
                        test ("a " ++ toString unit ++ " is worth " ++ toString value) <|
                            \_ ->
                                Expect.equal (Money.toCents unit) value
                    )
                    [ ( Dollar, 100 )
                    , ( Quarter, 25 )
                    , ( Dime, 10 )
                    , ( Nickel, 5 )
                    , ( Penny, 1 )
                    ]
            ]
        , describe "toMoney"
            [ fuzz (Fuzz.intRange 1 1000) "has the right amount of money in it" <|
                \amount ->
                    Money.toMoney amount
                        |> List.map Money.toCents
                        |> List.sum
                        |> Expect.equal amount
            , fuzz monies "does not lose money" <|
                \howMuch ->
                    howMuch
                        |> List.map Money.toCents
                        |> List.sum
                        |> Money.toMoney
                        |> List.sortBy Money.toCents
                        |> Expect.equal howMuch
            ]
        ]
