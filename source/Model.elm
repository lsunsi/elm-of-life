module Model exposing (..)

import Array
import Maybe
import Window


type Dot
    = Alive
    | Dead


type alias Model =
    { edge : Int
    , rows : Int
    , cols : Int
    , dots : List Dot
    }


init : Int -> Int -> Int -> Model
init edge width height =
    let
        rows =
            height // edge

        cols =
            width // edge
    in
    Model
        edge
        rows
        cols
        (List.repeat
            (rows * cols)
            Dead
        )


map : (Dot -> Int -> Int -> Dot) -> Model -> Model
map fn board =
    { board | dots = mapOut fn board }


mapOut : (Dot -> Int -> Int -> a) -> Model -> List a
mapOut fn board =
    List.indexedMap
        (\index dot ->
            let
                row =
                    index // board.cols

                col =
                    index % board.cols
            in
            fn dot row col
        )
        board.dots


index : Int -> Int -> Int -> Int
index cols row col =
    row * cols + col


spawn : Int -> Int -> Model -> Model
spawn row col board =
    { board
        | dots =
            board.dots
                |> Array.fromList
                |> set board.cols row col Alive
                |> Array.toList
    }


set : Int -> Int -> Int -> Dot -> Array.Array Dot -> Array.Array Dot
set cols row col dot dots =
    Array.set (index cols row col) dot dots


get : Int -> Int -> Int -> Array.Array Dot -> Dot
get cols row col dots =
    Array.get (index cols row col) dots
        |> Maybe.withDefault Dead


neighbors : Int -> Int -> Model -> List Dot
neighbors row col board =
    let
        dots =
            Array.fromList board.dots

        dot =
            get board.cols
    in
    [ dot (row - 1) (col - 1) dots
    , dot (row - 1) (col + 0) dots
    , dot (row - 1) (col + 1) dots
    , dot (row + 0) (col - 1) dots
    , dot (row + 0) (col + 1) dots
    , dot (row + 1) (col - 1) dots
    , dot (row + 1) (col + 0) dots
    , dot (row + 1) (col + 1) dots
    ]
