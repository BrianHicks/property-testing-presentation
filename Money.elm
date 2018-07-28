module Money exposing (Money(..), changeFor, toCents, total)


type Money
    = Dollar
    | Quarter
    | Dime
    | Nickel
    | Penny


toCents : Money -> Int
toCents item =
    case item of
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


total : List Money -> Int
total =
    List.map toCents >> List.sum


changeFor : Int -> List Money
changeFor amount =
    changeForHelper [] amount


changeForHelper : List Money -> Int -> List Money
changeForHelper soFar amount =
    if amount >= 100 then
        changeForHelper (Dollar :: soFar) (amount - 100)
    else if amount >= 25 then
        changeForHelper (Quarter :: soFar) (amount - 25)
    else if amount >= 10 then
        changeForHelper (Dime :: soFar) (amount - 10)
    else if amount >= 5 then
        changeForHelper (Nickel :: soFar) (amount - 5)
    else if amount >= 1 then
        changeForHelper (Penny :: soFar) (amount - 1)
    else
        soFar
