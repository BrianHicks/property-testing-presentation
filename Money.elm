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
    toMoneyHelp amount []


toMoneyHelp : Float -> List Money -> List Money
toMoneyHelp amount soFar =
    if amount >= toFloat Dollar then
        toMoneyHelp (amount - toFloat Dollar) (Dollar :: soFar)
    else if amount >= toFloat Quarter then
        toMoneyHelp (amount - toFloat Quarter) (Quarter :: soFar)
    else if amount >= toFloat Dime then
        toMoneyHelp (amount - toFloat Dime) (Dime :: soFar)
    else if amount >= toFloat Nickel then
        toMoneyHelp (amount - toFloat Nickel) (Nickel :: soFar)
    else if amount >= toFloat Penny then
        toMoneyHelp (amount - toFloat Penny) (Penny :: soFar)
    else
        []
