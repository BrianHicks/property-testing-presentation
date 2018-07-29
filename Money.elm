module Money exposing (Money(..), toFloat)


type Money
    = Dollar
    | Quarter
    | Dime
    | Nickel
    | Penny


toFloat : Money -> Float
toFloat money =
    0
