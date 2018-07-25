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


amountInStock : String -> VendingMachine -> Int
amountInStock name machine =
    VendingMachine.maintenanceCheckStock machine
        |> Dict.get name
        |> Maybe.map .inventory
        |> Maybe.withDefault 0


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
                    -- an empty machine shouldn't give any items
                    Nothing ->
                        machine
                            |> VendingMachine.get "shouldn't matter"
                            |> Tuple.first
                            |> Expect.equal Nothing

                    -- an out-of-stock item shouldn't be vended
                    Just ( name, _, False ) ->
                        machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal Nothing

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
                    -- an empty machine shouldn't give any items
                    Nothing ->
                        machine
                            |> VendingMachine.get "shouldn't matter"
                            |> Tuple.first
                            |> Expect.equal Nothing

                    Just ( name, price, inStock ) ->
                        Money.changeFor price
                            |> List.foldl VendingMachine.pay machine
                            |> VendingMachine.get name
                            |> Tuple.first
                            |> Expect.equal
                                (if inStock then
                                    Just name
                                 else
                                    Nothing
                                )
        , fuzz machine "the vending machine is not infinite" <|
            \machine ->
                case arbitrarySelection machine of
                    Nothing ->
                        machine
                            |> VendingMachine.get "shouldn't matter"
                            |> Tuple.second
                            |> Expect.equal machine

                    -- the stock shouldn't change if it was out
                    Just ( name, price, False ) ->
                        Money.changeFor price
                            |> List.foldl VendingMachine.pay machine
                            |> VendingMachine.get name
                            |> Tuple.second
                            |> amountInStock name
                            |> Expect.equal (amountInStock name machine)

                    -- the stock should change if it wasn't out
                    Just ( name, price, True ) ->
                        Money.changeFor price
                            |> List.foldl VendingMachine.pay machine
                            |> VendingMachine.get name
                            |> Tuple.second
                            |> amountInStock name
                            |> Expect.equal (amountInStock name machine - 1)
        ]
