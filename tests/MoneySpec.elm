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


someMoney : Fuzzer (List Money)
someMoney =
    Fuzz.map2 (::) money (Fuzz.list money)
        |> Fuzz.map (List.sortBy Money.toCents)


moneySpec : Test
moneySpec =
    describe "Money"
        [ describe "toCents"
            [ fuzz money "is never zero" <|
                \amount ->
                    amount
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
            [ fuzz (Fuzz.intRange 0 1000) "gives the right amount of money" <|
                \amount ->
                    amount
                        |> Money.toMoney
                        |> List.map Money.toCents
                        |> List.sum
                        |> Expect.equal amount
            , fuzz someMoney "does not lose value" <|
                \currency ->
                    currency
                        |> List.map Money.toCents
                        |> List.sum
                        |> Money.toMoney
                        |> List.length
                        |> Expect.all
                            [ Expect.greaterThan 0
                            , Expect.atMost (List.length currency)
                            ]
            ]
        ]
