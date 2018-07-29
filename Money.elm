module Money exposing (Money(..), toFloat)


type Money
    = Dollar
    | Quarter
    | Dime
    | Nickel
    | Penny


toFloat : Money -> Float
toFloat money =
    if money == Dollar then
        1
    else if money == Quarter then
        0.25
    else if money == Dime then
        0.1
    else if money == Nickel then
        0.05
    else if money == Penny then
        0.01
    else
        0
