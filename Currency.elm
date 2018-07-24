module Currency exposing (Currency(..), toFloat)


type Currency
    = Nickel
    | Dime
    | Quarter
    | Dollar


toFloat : Currency -> Float
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
