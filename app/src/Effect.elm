module Effect exposing (..)
import Route exposing (Route)

type Effect msg 
    = None
    | Batch (List (Effect msg))
    | PushRoute Route
    | Login { username : String , password : String}

none : Effect msg
none = None

batch : List (Effect msg) -> Effect msg
batch list = Batch list


pushRoute : Route -> Effect msg
pushRoute route =
    PushRoute route


map : ( msg1 -> msg2 ) -> Effect msg1 -> Effect msg2
map toMsg effect =
    case effect of
        None -> None
        Batch signals -> Batch <| List.map (map toMsg) signals
        PushRoute route -> PushRoute route
        Login data -> Login data