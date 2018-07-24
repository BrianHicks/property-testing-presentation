module Money exposing (Money(..), toFloat)


type Money
    = Nickel
    | Dime
    | Quarter
    | Dollar


toFloat : Money -> Float
toFloat item =
    case item of
        Nickel ->
            0.5

        Dime ->
            0.1

        Quarter ->
            0.25

        Dollar ->
            1
