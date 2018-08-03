module Money exposing (Money(..), toCents, toMoney)


type Money
    = Dollar
    | Quarter
    | Dime
    | Nickel
    | Penny


toCents : Money -> Int
toCents amount =
    case amount of
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
    toMoneyRec amount []


toMoneyRec : Int -> List Money -> List Money
toMoneyRec amount soFar =
    if amount >= toCents Dollar then
        toMoneyRec (amount - toCents Dollar) (Dollar :: soFar)
    else if amount >= toCents Quarter then
        toMoneyRec (amount - toCents Quarter) (Quarter :: soFar)
    else if amount >= toCents Dime then
        toMoneyRec (amount - toCents Dime) (Dime :: soFar)
    else if amount >= toCents Nickel then
        toMoneyRec (amount - toCents Nickel) (Nickel :: soFar)
    else if amount >= toCents Penny then
        toMoneyRec (amount - toCents Penny) (Penny :: soFar)
    else
        soFar
