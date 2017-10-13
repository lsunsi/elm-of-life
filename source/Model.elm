module Model exposing (Dot(Alive, Dead), Model, SpawnMode(Swipe, Touch), init, neighbors)

import Matrix
import Maybe


type Dot
    = Alive
    | Dead


type SpawnMode
    = Touch
    | Swipe


type alias Model =
    { active : Bool
    , spawn : SpawnMode
    , edge : Int
    , dots : Matrix.Matrix Dot
    }


init : Int -> Int -> Int -> Model
init edge width height =
    Model
        True
        Swipe
        edge
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
