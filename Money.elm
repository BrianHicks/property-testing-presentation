module Money exposing (Money(..), toFloat, toMoney)


type Money
    = Dollar
    | Quarter
    | Dime
    | Nickel
    | Penny


toFloat : Money -> Float
toFloat money =
    case money of
        Dollar ->
            1

        Quarter ->
            0.25

        Dime ->
            0.1

        Nickel ->
            0.05

        Penny ->
            0.01


toMoney : Float -> List Money
toMoney amount =
    if amount >= toFloat Dollar then
        Dollar :: toMoney (amount - toFloat Dollar)
    else if amount >= toFloat Quarter then
        Quarter :: toMoney (amount - toFloat Quarter)
    else if amount >= toFloat Dime then
        Dime :: toMoney (amount - toFloat Dime)
    else if amount >= toFloat Nickel then
        Nickel :: toMoney (amount - toFloat Nickel)
    else if amount >= toFloat Penny then
        Penny :: toMoney (amount - toFloat Penny)
    else
        []
