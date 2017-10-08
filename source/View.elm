module View exposing (view)

import Html
import Html.Attributes
import Matrix
import Model
import Svg
import Svg.Attributes
import Svg.Events
import Update


view : Model.Model -> Html.Html Update.Msg
view board =
    Html.div
        [ Html.Attributes.style
            [ ( "height", "100%" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            ]
        ]
        [ Svg.svg
            [ Svg.Attributes.width (toString (board.edge * Matrix.colCount board.dots))
            , Svg.Attributes.height (toString (board.edge * Matrix.rowCount board.dots))
            ]
            (Matrix.mapWithLocation
                (\( row, col ) dot ->
                    Svg.rect
                        [ Svg.Events.onMouseOver (Update.Spawn row col)
                        , Svg.Attributes.x (toString (board.edge * col))
                        , Svg.Attributes.y (toString (board.edge * row))
                        , Svg.Attributes.width (toString board.edge)
                        , Svg.Attributes.height (toString board.edge)
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
                board.dots
                |> Matrix.flatten
            )
        ]
