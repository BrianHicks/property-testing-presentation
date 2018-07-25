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
    Fuzz.map2 Dict.singleton Fuzz.string item


machine : Fuzzer VendingMachine
machine =
    Fuzz.map2 VendingMachine.init
        (Fuzz.list money)
        stock


arbitrarySelection : VendingMachine -> Maybe ( String, Int, Bool )
arbitrarySelection machine =
    machine
        |> VendingMachine.prices
        |> Dict.toList
        |> List.head
        |> Maybe.map
            (\( name, price ) ->
                ( name
                , price
                , VendingMachine.hasItem name machine
                )
            )


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
                case arbitrarySelection machine of
                    -- don't bother trying, the machine is empty
                    Nothing ->
                        Expect.pass

                    -- don't bother trying, this item is out
                    Just ( _, _, False ) ->
                        Expect.pass

                    -- if the item was free, we can get it
                    Just ( name, 0, _ ) ->
                        machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal (Just name)

                    -- and we shouldn't be able to get it if it isn't free
                    Just ( name, _, _ ) ->
                        machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal Nothing
        , fuzz machine "paying the exact amount lets you get something" <|
            \machine ->
                case arbitrarySelection machine of
                    -- don't bother trying, the machine is empty
                    Nothing ->
                        Expect.pass

                    -- don't bother trying, this item is out
                    Just ( _, _, False ) ->
                        Expect.pass

                    Just ( name, price, _ ) ->
                        Money.changeFor price
                            |> List.foldl VendingMachine.pay machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal (Just name)
        ]
