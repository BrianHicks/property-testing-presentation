module VendingMachine exposing (..)

import Currency exposing (Currency)
import Dict exposing (Dict)


type alias Inventory =
    Dict String Float


type VendingMachine
    = VendingMachine (List Currency) Inventory


init : VendingMachine
init =
    VendingMachine [] Dict.empty
