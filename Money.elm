module Money exposing (Money(..), toFloat)


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
