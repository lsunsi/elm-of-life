module Model exposing (..)

import Matrix
import Maybe


type Dot
    = Alive
    | Dead


type alias Model =
    { edge : Int
    , dots : Matrix.Matrix Dot
    }


init : Int -> Int -> Int -> Model
init edge width height =
    Model edge
        (Matrix.matrix
            (height // edge)
            (width // edge)
            (always Dead)
        )


neighbors : Int -> Int -> Matrix.Matrix Dot -> Int
neighbors row col dots =
    [ Matrix.get ( row - 1, col - 1 ) dots
    , Matrix.get ( row - 1, col + 0 ) dots
    , Matrix.get ( row - 1, col + 1 ) dots
    , Matrix.get ( row + 0, col - 1 ) dots
    , Matrix.get ( row + 0, col + 1 ) dots
    , Matrix.get ( row + 1, col - 1 ) dots
    , Matrix.get ( row + 1, col + 0 ) dots
    , Matrix.get ( row + 1, col + 1 ) dots
    ]
        |> List.map (Maybe.withDefault Dead)
        |> List.filter ((==) Alive)
        |> List.length
