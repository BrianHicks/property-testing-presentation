module VendingMachine
    exposing
        ( Item
        , Stock
        , VendingMachine
        , get
        , init
        , pay
        , refund
        )

import Dict exposing (Dict)
import Money exposing (Money)


type alias Item =
    { inventory : Int
    , price : Float
    }


type alias Stock =
    Dict String Item


type alias VendingMachine =
    { change : List Money
    , currentlyPaid : List Money
    , stock : Dict String Item
    }


init : List Money -> Stock -> VendingMachine
init change stock =
    { change = change
    , currentlyPaid = []
    , stock = stock
    }


pay : Money -> VendingMachine -> VendingMachine
pay money machine =
    machine


refund : VendingMachine -> ( List Money, VendingMachine )
refund machine =
    ( [], machine )


get : String -> VendingMachine -> ( String, VendingMachine )
get name machine =
    ( name, machine )
