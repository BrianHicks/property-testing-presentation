module Money exposing (Money(..), toCents, toMoney)


type Money
    = Dollar
    | Quarter
    | Dime
    | Nickel
    | Penny


toCents : Money -> Int
toCents money =
    case money of
        Dollar ->
            100

        Quarter ->
            25

        Dime ->
            10

        Nickel ->
            5

        Penny ->
            1


toMoney : Int -> List Money
toMoney amount =
    toMoneyHelp amount []


toMoneyHelp : Int -> List Money -> List Money
toMoneyHelp amount soFar =
    if amount >= toCents Dollar then
        toMoneyHelp (amount - toCents Dollar) (Dollar :: soFar)
    else if amount >= toCents Quarter then
        toMoneyHelp (amount - toCents Quarter) (Quarter :: soFar)
    else if amount >= toCents Dime then
        toMoneyHelp (amount - toCents Dime) (Dime :: soFar)
    else if amount >= toCents Nickel then
        toMoneyHelp (amount - toCents Nickel) (Nickel :: soFar)
    else if amount >= toCents Penny then
        toMoneyHelp (amount - toCents Penny) (Penny :: soFar)
    else
        soFar
