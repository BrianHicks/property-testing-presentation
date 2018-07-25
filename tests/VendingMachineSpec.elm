module VendingMachineSpec exposing (..)

import Dict
import Expect
import Fuzz exposing (Fuzzer)
import Money exposing (Money)
import MoneySpec exposing (aReasonableAmountOfMoney, money)
import Test exposing (..)
import VendingMachine exposing (VendingMachine)


item : Fuzzer VendingMachine.Item
item =
    Fuzz.map2 VendingMachine.Item
        (Fuzz.intRange 0 10)
        aReasonableAmountOfMoney


stock : Fuzzer VendingMachine.Stock
stock =
    Fuzz.tuple ( Fuzz.string, item )
        |> nonEmptyList
        |> Fuzz.map Dict.fromList


nonEmptyList : Fuzzer a -> Fuzzer (List a)
nonEmptyList item =
    Fuzz.map2 (::)
        item
        (Fuzz.list item)


machine : Fuzzer VendingMachine
machine =
    Fuzz.map2 VendingMachine.init
        (Fuzz.list money)
        stock


vendingMachineTest : Test
vendingMachineTest =
    describe "VendingMachine"
        [ fuzz2 machine (Fuzz.list money) "paying and refunding should give you the same money" <|
            \machine money ->
                money
                    |> List.foldr VendingMachine.pay machine
                    |> VendingMachine.refund
                    |> Tuple.first
                    |> Expect.equal money
        , fuzz machine "you can't usually get stuff without paying" <|
            \machine ->
                let
                    selection =
                        machine
                            |> VendingMachine.prices
                            |> Dict.toList
                            |> List.head
                in
                case selection of
                    -- don't bother trying, the machine is empty
                    Nothing ->
                        Expect.pass

                    -- if the item was free, we can get it
                    Just ( name, 0 ) ->
                        machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal (Just name)

                    -- and we shouldn't be able to get it if it isn't free
                    Just ( name, _ ) ->
                        machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal Nothing
        ]
