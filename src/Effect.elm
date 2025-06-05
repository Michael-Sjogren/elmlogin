module Effect exposing (..)

import DTO
import Http
import Route
import Browser.Navigation as Nav
import Route exposing (Route)

type Effect msg
    = None
    | Batch (List (Effect msg))
    | Login DTO.LoginCredentials (Result Http.Error () -> msg)
    | PushRoute Nav.Key Route

none : Effect msg
none =
    None


map : (a -> msg) -> Effect a -> Effect msg
map inMsg effect =
    case effect of
        Batch effects ->
            Batch (List.map (map inMsg) effects)

        None ->
            None

        Login creds msg ->
            Login creds (msg >> inMsg)
        
        PushRoute key route ->
            PushRoute key route



pushRoute : Nav.Key -> Route.Route -> Effect msg
pushRoute key route =
    PushRoute key route

effectToCmd : Effect msg -> Cmd msg
effectToCmd effect =
    case effect of
        Batch effects ->
            Cmd.batch <| List.map effectToCmd effects

        None ->
            Cmd.none
        PushRoute key route ->
            Nav.pushUrl key (Route.toUrl route)
    
        Login creds expectMsg ->
            Http.post
                { url = "/login"
                , body = Http.jsonBody <| DTO.loginCredentialsEncoder creds
                , expect = Http.expectWhatever expectMsg
                }
