module Signal exposing (..)
import Route exposing (Route)

type Signal msg 
    = None
    | Batch (List (Signal msg))
    | PushRoute Route


none : Signal msg
none = None

batch : List (Signal msg) -> Signal msg
batch list = Batch list


pushRoute : Route -> Signal msg
pushRoute route =
    PushRoute route


map : ( msg1 -> msg2 ) -> Signal msg1 -> Signal msg2
map toMsg effect =
    case effect of
        None -> None
        Batch signals -> Batch <| List.map (map toMsg) signals
        PushRoute route -> PushRoute route