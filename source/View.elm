module View exposing (view)

import Html
import Html.Attributes
import Html.Events
import Matrix
import Model
import Svg
import Svg.Attributes
import Svg.Events
import Update


pixels : Int -> String
pixels px =
    toString px ++ "px"


color : Int -> String
color x =
    let
        a =
            toString (9 - x)
    in
    "#" ++ a ++ a ++ a


view : Model.Model -> Html.Html Update.Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "height", "100%" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            ]
        ]
        [ Html.div
            [ Html.Attributes.style
                [ ( "width", pixels (model.edge * Matrix.colCount model.dots) )
                , ( "height", pixels (model.edge * Matrix.rowCount model.dots) )
                , ( "position", "relative" )
                ]
            ]
            [ Html.div [] (controls model)
            , Svg.svg
                [ Svg.Attributes.width (toString (model.edge * Matrix.colCount model.dots))
                , Svg.Attributes.height (toString (model.edge * Matrix.rowCount model.dots))
                ]
                (Matrix.mapWithLocation
                    (\( row, col ) dot ->
                        Svg.rect
                            [ Svg.Events.onMouseOver (Update.DotHover row col)
                            , Svg.Events.onClick (Update.DotClick row col)
                            , Svg.Events.onMouseOut Update.Unhighlight
                            , Svg.Attributes.x (toString (model.edge * col))
                            , Svg.Attributes.y (toString (model.edge * row))
                            , Svg.Attributes.width (toString model.edge)
                            , Svg.Attributes.height (toString model.edge)
                            , Svg.Attributes.stroke
                                (if model.highlight == Just ( row, col ) then
                                    "black"
                                 else
                                    "none"
                                )
                            , Svg.Attributes.fill (color (Model.neighbors row col model.dots))
                            ]
                            [ Svg.text (toString dot) ]
                    )
                    model.dots
                    |> Matrix.flatten
                )
            ]
        ]


controls : Model.Model -> List (Html.Html Update.Msg)
controls model =
    let
        edge =
            pixels (2 * model.edge)

        sharedStyle =
            [ ( "width", edge )
            , ( "height", edge )
            , ( "position", "absolute" )
            , ( "background-color", "red" )
            ]
    in
    [ Html.div
        [ Html.Events.onClick Update.ToggleActive
        , Html.Attributes.style
            ([ ( "top", "0" ), ( "left", "0" ) ] ++ sharedStyle)
        ]
        [ Html.text
            (case model.active of
                False ->
                    "Paused"

                True ->
                    "Playing"
            )
        ]
    , Html.div
        [ Html.Events.onClick Update.Reset
        , Html.Attributes.style
            ([ ( "bottom", "0" ), ( "left", "0" ) ] ++ sharedStyle)
        ]
        [ Html.text "Reset" ]
    , Html.div
        [ Html.Events.onClick Update.ToggleSpawn
        , Html.Attributes.style
            ([ ( "top", "0" ), ( "right", "0" ) ] ++ sharedStyle)
        ]
        [ Html.text
            (case model.spawn of
                Model.Swipe ->
                    "Swipe"

                Model.Touch ->
                    "Touch"
            )
        ]
    , Html.div
        [ Html.Attributes.href "https://github.com/lsunsi/elm-of-life"
        , Html.Attributes.style
            ([ ( "bottom", "0" ), ( "right", "0" ) ] ++ sharedStyle)
        ]
        [ Html.text "Star" ]
    ]
