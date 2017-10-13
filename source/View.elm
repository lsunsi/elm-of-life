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


view : Model.Model -> Html.Html Update.Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "height", "100%" )
            , ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            ]
        ]
        [ Html.div []
            [ Html.button
                [ Html.Events.onClick Update.ToggleActive ]
                [ Html.text
                    (case model.active of
                        False ->
                            "Paused"

                        True ->
                            "Playing"
                    )
                ]
            , Html.button
                [ Html.Events.onClick Update.Reset ]
                [ Html.text "Reset" ]
            , Html.button
                [ Html.Events.onClick Update.ToggleSpawn ]
                [ Html.text
                    (case model.spawn of
                        Model.Swipe ->
                            "Swipe"

                        Model.Touch ->
                            "Touch"
                    )
                ]
            , Html.a [ Html.Attributes.href "https://github.com/lsunsi/elm-of-life" ] [ Html.text "Star" ]
            ]
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
                                "white"
                            )
                        , Svg.Attributes.fill
                            (case dot of
                                Model.Alive ->
                                    "black"

                                Model.Dead ->
                                    "white"
                            )
                        ]
                        [ Svg.text (toString dot) ]
                )
                model.dots
                |> Matrix.flatten
            )
        ]
