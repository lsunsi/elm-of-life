module Subscriptions exposing (subscriptions)

import Model
import Time
import Update


subscriptions : Model.Model -> Sub Update.Msg
subscriptions _ =
    Time.every Time.second (\_ -> Update.Tick)
