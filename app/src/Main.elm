module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Context as Ctx
import Html
import Pages.Dashboard
import Pages.Login
import Pages.NotFound
import Route
import Url
import Signal exposing (Signal(..))
import Task
import Http
import Json.Encode as JEncode
import Json.Decode as JDecode
import Route exposing (Route)


type alias LoginResponseData = 
    {
        success : Bool,
        response : String
    }

encodeLoginRequest : {username: String , password: String} -> JEncode.Value
encodeLoginRequest data =
    JEncode.object
        [
            ("username", JEncode.string data.username )
            ,("password", JEncode.string data.password )
        ]

loginResponseDecoder : JDecode.Decoder LoginResponseData
loginResponseDecoder =
    JDecode.map2 LoginResponseData
        ( JDecode.field "success" JDecode.bool)
        ( JDecode.field "response" JDecode.string)



type alias Model =
    { ctx : Ctx.Context
    , pageModel : PageModel
    }


type PageModel
    = Login Pages.Login.Model
    | Dashboard Pages.Dashboard.Model
    | NotFound Pages.NotFound.Model


type Msg
    = OnUrlChanged Url.Url
    | OnUrlRequested Browser.UrlRequest
    | NotFoundMsg Pages.NotFound.Msg
    | DashboardMsg Pages.Dashboard.Msg
    | LoginMsg Pages.Login.Msg
    | LoginResponse (Result Http.Error LoginResponseData)
 


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ctx =
            Ctx.Context key url flags Nothing
    in
    ( Model ctx (NotFound Pages.NotFound.initModel), Cmd.none )


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , onUrlChange = OnUrlChanged
        , onUrlRequest = OnUrlRequested
        , subscriptions = \_ -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (msg, model.pageModel) of
        (OnUrlChanged url, _ ) ->
            case Route.fromString url.path of
                Route.NotFoundRoute ->
                    let
                        ( pModel, cmd ) =
                            Pages.NotFound.init model.ctx
                    in
                    ( { model | pageModel = NotFound pModel },  Signal.map NotFoundMsg cmd |> (signalToCmd model)  )

                Route.DashboardRoute ->
                    let
                        ( pModel, cmd ) =
                            Pages.Dashboard.init model.ctx
                    in
                    ( { model | pageModel = Dashboard pModel }, Signal.map DashboardMsg cmd |> (signalToCmd model) )

                Route.LoginRoute ->
                    let
                        ( pModel, cmd ) =
                            Pages.Login.init model.ctx
                    in
                    ( { model | pageModel = Login pModel }, Signal.map LoginMsg cmd |> (signalToCmd model) )

        (OnUrlRequested req, _ ) ->
            case req of
                Browser.Internal url ->
                    let
                        ctx =
                            Ctx.Context model.ctx.key url model.ctx.flags model.ctx.user
                    in
                    ( { model | ctx = ctx }, Nav.pushUrl ctx.key url.path )

                Browser.External url ->
                    ( model, Nav.replaceUrl model.ctx.key url )
        ( LoginMsg m, Login pageModel ) ->
            let
                (lmodel, signal ) = Pages.Login.update model.ctx m pageModel
            in
            ({model | pageModel = Login lmodel}  , Signal.map LoginMsg signal |> signalToCmd model)
        (LoginMsg _ , _) ->
            (model, Cmd.none)
        (NotFoundMsg m, NotFound pageModel ) ->
            let
                ( lmodel, signal ) = Pages.NotFound.update model.ctx m pageModel
            in
            ({model | pageModel = (NotFound lmodel)}  , Signal.map NotFoundMsg signal |> signalToCmd model)
        (NotFoundMsg _ , _) ->
            (model, Cmd.none)
        (DashboardMsg m , Dashboard pageModel ) ->
            let
                (lmodel, signal ) = Pages.Dashboard.update model.ctx m  pageModel
            in
            ({model | pageModel = (Dashboard lmodel)}, Signal.map DashboardMsg signal |> signalToCmd model)
        (DashboardMsg m , _) ->
            (model, Cmd.none)
        (LoginResponse result, _) ->
            case result of
                Result.Ok response ->
                    if response.success then
                        (model, Nav.pushUrl model.ctx.key (Route.toString Route.DashboardRoute))
                    else
                        (model, Cmd.none)
                Result.Err err ->
                    (model, Cmd.none)


view : Model -> Browser.Document Msg
view model =
    case model.pageModel of
        NotFound m ->
            let
                pview =
                    Pages.NotFound.view model.ctx m
            in
            { title = pview.title
            , body = List.map (\a -> Html.map NotFoundMsg a) <| pview.body
            }

        Dashboard m ->
            let
                pview =
                    Pages.Dashboard.view model.ctx m
            in
            { title = pview.title
            , body = List.map (\a -> Html.map DashboardMsg a) <| pview.body
            }

        Login m ->
            let
                pview =
                    Pages.Login.view model.ctx m
            in
            { title = pview.title
            , body = List.map (\a -> Html.map LoginMsg a) <| pview.body
            }


-- Global Signals , e.g. global events that can be sent from other pages

signalToCmd : Model -> Signal.Signal Msg  -> Cmd Msg
signalToCmd model signal =
    case signal of
        Signal.None -> Cmd.none
        Signal.Batch signals -> Cmd.batch (List.map (signalToCmd model) signals)
        Signal.PushRoute route -> Nav.pushUrl model.ctx.key (Route.toString route)
        Signal.Login data -> Http.post {
            url = "/auth/login",
            body = Http.jsonBody (encodeLoginRequest data),
            expect = Http.expectJson LoginResponse loginResponseDecoder
            }


sendMsg : Msg -> Cmd Msg
sendMsg msg = 
    Task.succeed msg
    |> Task.perform identity