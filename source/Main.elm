module App exposing (..)

import Html exposing (Html, div, program, text)
import Model
import Subscriptions
import Task
import Update
import View
import Window


init : ( Model.Model, Cmd Update.Msg )
init =
    ( Model.init 0 0 0
    , Task.perform
        (\size -> Update.Resize size.width size.height)
        Window.size
    )



-- MAIN


main : Program Never Model.Model Update.Msg
main =
    program
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = Subscriptions.subscriptions
        }
