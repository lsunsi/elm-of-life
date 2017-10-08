module Update exposing (Msg(Resize, Spawn, Tick), update)

import Matrix
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
            ( spawn row col model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


spawn : Int -> Int -> Model.Model -> Model.Model
spawn row col model =
    { model | dots = Matrix.set ( row, col ) Model.Alive model.dots }


tick : Model.Model -> Model.Model
tick model =
    { model
        | dots =
            Matrix.mapWithLocation
                (\( row, col ) dot ->
                    case ( dot, Model.neighbors row col model.dots ) of
                        ( Model.Alive, 2 ) ->
                            Model.Alive

                        ( _, 3 ) ->
                            Model.Alive

                        _ ->
                            Model.Dead
                )
                model.dots
    }
