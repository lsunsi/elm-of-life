module Update exposing (Msg(DotClick, DotHover, Reset, Resize, Tick, ToggleActive, ToggleSpawn), update)

import Matrix
import Model


type Msg
    = Resize Int Int
    | DotClick Int Int
    | DotHover Int Int
    | ToggleActive
    | ToggleSpawn
    | Reset
    | Tick
    | NoOp


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        Tick ->
            ( tick model, Cmd.none )

        Resize width height ->
            ( Model.init 50 width height, Cmd.none )

        DotClick row col ->
            ( if model.spawn == Model.Touch then
                spawn row col model
              else
                model
            , Cmd.none
            )

        DotHover row col ->
            ( if model.spawn == Model.Swipe then
                spawn row col model
              else
                model
            , Cmd.none
            )

        ToggleSpawn ->
            ( toggleSpawn model, Cmd.none )

        ToggleActive ->
            ( toggleActive model, Cmd.none )

        Reset ->
            ( reset model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


reset : Model.Model -> Model.Model
reset model =
    { model | dots = Matrix.map (always Model.Dead) model.dots }


toggleSpawn : Model.Model -> Model.Model
toggleSpawn model =
    { model
        | spawn =
            case model.spawn of
                Model.Swipe ->
                    Model.Touch

                Model.Touch ->
                    Model.Swipe
    }


toggleActive : Model.Model -> Model.Model
toggleActive model =
    { model | active = not model.active }


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
