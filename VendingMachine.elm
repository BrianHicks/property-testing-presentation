module VendingMachine
    exposing
        ( Item
        , Stock
        , VendingMachine
        , get
        , hasItem
        , init
        , maintenanceCheckStock
        , pay
        , prices
        , refund
        )

import Dict exposing (Dict)
import Money exposing (Money)


type alias Item =
    { inventory : Int
    , price : Int
    }


type alias Stock =
    Dict String Item


type alias VendingMachine =
    { change : List Money
    , paid : List Money
    , stock : Dict String Item
    }



-- information about the machine


prices : VendingMachine -> Dict String Int
prices machine =
    Dict.map (\_ item -> item.price) machine.stock


hasItem : String -> VendingMachine -> Bool
hasItem name { stock } =
    stock
        |> Dict.get name
        |> Maybe.map .inventory
        |> Maybe.map ((<) 0)
        |> Maybe.withDefault False



-- using the machine


init : List Money -> Stock -> VendingMachine
init change stock =
    { change = change
    , paid = []
    , stock = stock
    }


pay : Money -> VendingMachine -> VendingMachine
pay money machine =
    { machine | paid = money :: machine.paid }


refund : VendingMachine -> ( List Money, VendingMachine )
refund machine =
    ( machine.paid
    , { machine | paid = [] }
    )


get : String -> VendingMachine -> ( Maybe String, VendingMachine )
get selection machine =
    let
        paid =
            machine.paid
                |> List.map Money.toCents
                |> List.sum
    in
    case Dict.get selection machine.stock of
        Just item ->
            if paid == item.price && item.inventory > 0 then
                ( Just selection
                , { machine
                    | stock =
                        Dict.insert
                            selection
                            { item | inventory = item.inventory - 1 }
                            machine.stock
                  }
                )
            else
                ( Nothing, machine )

        Nothing ->
            ( Nothing, machine )



-- maintaining the machine


maintenanceCheckStock : VendingMachine -> Stock
maintenanceCheckStock { stock } =
    stock
