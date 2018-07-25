module VendingMachine
    exposing
        ( Item
        , Stock
        , VendingMachine
        , get
        , init
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


get : String -> VendingMachine -> Maybe ( String, VendingMachine )
get selection machine =
    case Dict.get selection machine.stock of
        Just _ ->
            Just ( selection, machine )

        Nothing ->
            Nothing
