module Subscriptions exposing (..)

import Model
import Time
import Update


subscriptions : Model.Model -> Sub Update.Msg
subscriptions model =
    Time.every Time.second (\_ -> Update.Tick)
