module MoneySpec exposing (..)

import Dict
import Expect
import Fuzz exposing (Fuzzer)
import Money exposing (Money)
import Test exposing (..)


money : Fuzzer Money
money =
    Fuzz.oneOf
        [ Fuzz.constant Money.Nickel
        , Fuzz.constant Money.Dime
        , Fuzz.constant Money.Quarter
        , Fuzz.constant Money.Dollar
        ]


aReasonableAmountOfMoney : Fuzzer Int
aReasonableAmountOfMoney =
    Fuzz.intRange 0 500


moneyTest : Test
moneyTest =
    describe "Money"
        [ fuzz money "toCents and changeFor are symmetric for single items" <|
            \money ->
                money
                    |> Money.toCents
                    |> Money.changeFor
                    |> Expect.equal [ money ]
        , fuzz aReasonableAmountOfMoney "changeFor then toCents results in the same amount" <|
            \amount ->
                amount
                    |> Money.changeFor
                    |> List.map Money.toCents
                    |> List.sum
                    |> Expect.equal amount
        ]
