module Update exposing (..)

import Model


type Msg
    = Resize Int Int
    | Spawn Int Int
    | Tick
    | NoOp


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            ( tick model, Cmd.none )

        Resize width height ->
            ( Model.init 50 width height, Cmd.none )

        Spawn row col ->
            ( Model.spawn row col model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


tick : Model.Model -> Model.Model
tick board =
    Model.map
        (\dot row col ->
            let
                neighbors =
                    Model.neighbors row col board

                alives =
                    List.filter (\d -> d == Model.Alive) neighbors
                        |> List.length
            in
            case ( dot, alives ) of
                ( Model.Alive, 2 ) ->
                    Model.Alive

                ( _, 3 ) ->
                    Model.Alive

                _ ->
                    Model.Dead
        )
        board
