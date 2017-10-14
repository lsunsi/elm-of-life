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


view : Model.Model -> Html.Html Update.Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "height", "100%" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            , ( "background-color", "#715f95" )
            ]
        ]
        [ Html.node "link"
            [ Html.Attributes.rel "stylesheet", Html.Attributes.href "http://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" ]
            []
        , Html.div
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
                            , Svg.Attributes.fill
                                (case ( dot, model.highlight == Just ( row, col ), Model.neighbors row col model.dots ) of
                                    ( Model.Alive, _, _ ) ->
                                        "#ae91e8"

                                    ( Model.Dead, False, 0 ) ->
                                        "#544d60"

                                    ( Model.Dead, _, _ ) ->
                                        "#715f95"
                                )
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

        iconSizeStyle =
            Html.Attributes.style [ ( "font-size", "50pt" ) ]

        buttonStyle =
            [ ( "width", edge )
            , ( "height", edge )
            , ( "position", "absolute" )
            , ( "background-color", "#fec38f" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            ]
    in
    [ Html.div
        [ Html.Events.onClick Update.ToggleActive
        , Html.Attributes.style
            ([ ( "top", "0" ), ( "left", "0" ) ] ++ buttonStyle)
        ]
        [ Html.i
            [ iconSizeStyle
            , Html.Attributes.class
                (case model.active of
                    False ->
                        "ion-play"

                    True ->
                        "ion-pause"
                )
            ]
            []
        ]
    , Html.div
        [ Html.Events.onClick Update.Reset
        , Html.Attributes.style
            ([ ( "bottom", "0" ), ( "left", "0" ) ] ++ buttonStyle)
        ]
        [ Html.i
            [ iconSizeStyle, Html.Attributes.class "ion-ios-refresh" ]
            []
        ]
    , Html.div
        [ Html.Events.onClick Update.ToggleSpawn
        , Html.Attributes.style
            ([ ( "top", "0" ), ( "right", "0" ) ] ++ buttonStyle)
        ]
        [ Html.i
            [ iconSizeStyle
            , Html.Attributes.class
                (case model.spawn of
                    Model.Swipe ->
                        "ion-paintbrush"

                    Model.Touch ->
                        "ion-edit"
                )
            ]
            []
        ]
    , Html.a
        [ Html.Attributes.href "https://github.com/lsunsi/elm-of-life"
        , Html.Attributes.style
            ([ ( "bottom", "0" ), ( "right", "0" ) ] ++ buttonStyle)
        ]
        [ Html.i
            [ iconSizeStyle, Html.Attributes.class "ion-ios-star" ]
            []
        ]
    ]
