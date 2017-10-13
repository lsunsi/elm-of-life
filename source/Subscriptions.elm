module Subscriptions exposing (subscriptions)

import Model
import Time
import Update


subscriptions : Model.Model -> Sub Update.Msg
subscriptions state =
    if state.active then
        Time.every Time.second (\_ -> Update.Tick)
    else
        Sub.none
