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
        |> Fuzz.list
        |> Fuzz.map Dict.fromList


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
        , fuzz machine "you can't get drinks for free" <|
            \machine ->
                let
                    selection =
                        machine
                            |> VendingMachine.prices
                            |> Dict.keys
                            |> List.head
                in
                case selection of
                    -- don't bother trying, the machine is empty
                    Nothing ->
                        Expect.pass

                    Just name ->
                        machine
                            |> VendingMachine.get name
                            |> Expect.equal Nothing
        ]
