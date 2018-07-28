module VendingMachineSpec exposing (..)

import ArchitectureTest
import ArchitectureTest.Types exposing (TestedApp, TestedModel(..), TestedUpdate(..))
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


itemName : Fuzzer String
itemName =
    Fuzz.oneOf
        [ Fuzz.constant "Dr. Pepper"
        , Fuzz.constant "Stroopwafel"
        , Fuzz.constant "Potato Chips"
        ]


stock : Fuzzer VendingMachine.Stock
stock =
    Fuzz.tuple ( itemName, item )
        |> Fuzz.list
        |> Fuzz.map Dict.fromList


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



-- MODEL TESTING!


type alias Model =
    { machine : VendingMachine
    , ourMoney : Int
    , totalMoney : Int
    }


type
    Action
    -- consumer
    = Pay Money
    | Refund
    | Get String
      -- maintenance
    | SetStock VendingMachine.Stock
    | EmptyCoins


action : Fuzzer Action
action =
    Fuzz.oneOf
        [ Fuzz.map Pay money
        , Fuzz.constant Refund
        , Fuzz.map Get Fuzz.string
        , Fuzz.map SetStock stock
        , Fuzz.constant EmptyCoins
        ]


updater : Action -> Model -> Model
updater action ({ machine } as model) =
    case action of
        Pay howMuch ->
            { model
                | machine = VendingMachine.pay howMuch machine
                , totalMoney = Money.toCents howMuch + model.totalMoney
            }

        Refund ->
            let
                ( refunded, newMachine ) =
                    VendingMachine.refund machine
            in
            { model
                | machine = newMachine
                , ourMoney = Money.total refunded + model.ourMoney
            }

        Get item ->
            case VendingMachine.get item machine of
                ( Just item, newMachine ) ->
                    { model | machine = newMachine }

                ( Nothing, newMachine ) ->
                    { model | machine = newMachine }

        SetStock stock ->
            { model | machine = { machine | stock = stock } }

        EmptyCoins ->
            { model
                | machine = { machine | money = [] }
                , totalMoney = model.totalMoney
            }


modelForTesting : TestedApp Model Action
modelForTesting =
    { model =
        stock
            |> Fuzz.map (VendingMachine.init [])
            |> Fuzz.map (\machine -> Model machine 0 0)
            |> FuzzedModel
    , update = BeginnerUpdate updater
    , msgFuzzer = action
    }


modelTest : Test
modelTest =
    describe "model testing for vending machines"
        [ ArchitectureTest.invariantTest "money is never destroyed" modelForTesting <|
            \_ _ { machine, ourMoney, totalMoney } ->
                Expect.equal
                    (Money.total machine.money
                        + Money.total machine.pending
                        + ourMoney
                    )
                    totalMoney
        ]
