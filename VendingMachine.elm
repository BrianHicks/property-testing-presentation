module VendingMachine
    exposing
        ( Inventory
        , Prices
        , VendingMachine
        , get
        , init
        , pay
        , refund
        )

import Currency exposing (Currency)
import Dict exposing (Dict)


type alias Prices =
    Dict String Float


type alias Inventory =
    Dict String Int


type alias VendingMachine =
    { change : List Currency
    , currentlyPaid : List Currency
    , prices : Dict String Float
    , inventory : Dict String Int
    }


init : List Currency -> Prices -> Inventory -> VendingMachine
init change prices inventory =
    { change = change
    , currentlyPaid = []
    , prices = prices
    , inventory = inventory
    }


pay : Currency -> VendingMachine -> VendingMachine
pay currency machine =
    machine


refund : VendingMachine -> ( List Currency, VendingMachine )
refund machine =
    ( [], machine )


get : String -> VendingMachine -> ( String, VendingMachine )
get name machine =
    ( name, machine )
