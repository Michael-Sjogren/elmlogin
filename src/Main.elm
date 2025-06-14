module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Context exposing (Context)
import Dict exposing (update)
import Effect exposing (Effect(..))
import Html
import Http
import Pages.Home
import Pages.Login
import Platform.Cmd as Cmd
import Route
import Url exposing (Protocol(..), Url)


type PageModel
    = LoginPageModel Pages.Login.Model
    | HomePageModel Pages.Home.Model


type Msg
    = OnUrlRequest Browser.UrlRequest
    | OnUrlChanged Url.Url
    | LoginPageMsg Pages.Login.Msg
    | HomePageMsg Pages.Home.Msg
    | HandleLoginStatus (Result Http.Error ())


type alias Model =
    { key : Nav.Key
    , url : Url
    , page : PageModel
    , ctx : Context
    }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    -- TODO: CHANGE VIEW TO PAGE
    let
        ctx : Context
        ctx =
            { url = url, key = key, user = Nothing }
    in
    ( { key = key, url = url, page = LoginPageModel Pages.Login.initModel, ctx = ctx }, Effect.checkLoginStatus HandleLoginStatus )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


getPage : Route.Route -> Model -> ( Model, Cmd Msg )
getPage route model =
    case route of
        Route.HomeRoute ->
            ( { model | page = HomePageModel Pages.Home.initModel }, Effect.checkLoginStatus HandleLoginStatus )

        Route.NotFoundRoute ->
            ( model, Cmd.none )

        Route.LoginRoute ->
            ( { model | page = LoginPageModel Pages.Login.initModel }, Cmd.none )


handlePageUpdate : Msg -> Model -> ( Model, Cmd Msg )
handlePageUpdate pmsg model =
    case ( pmsg, model.page ) of
        ( LoginPageMsg lmsg, LoginPageModel lmodel ) ->
            let
                ( newModel, newCMd ) =
                    Pages.Login.update model.ctx lmsg lmodel

                cmd =
                    Effect.map LoginPageMsg newCMd
            in
            ( { model | page = LoginPageModel newModel }, Effect.effectToCmd cmd )

        ( HomePageMsg lmsg, HomePageModel lmodel ) ->
            let
                ( newModel, newCMd ) =
                    Pages.Home.update model.ctx lmsg lmodel

                cmd =
                    Effect.map HomePageMsg newCMd
            in
            ( { model | page = HomePageModel newModel }, Effect.effectToCmd cmd )

        ( _, _ ) ->
            ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoginPageMsg _ ->
            handlePageUpdate msg model

        HomePageMsg _ ->
            handlePageUpdate msg model

        OnUrlChanged url ->
            getPage (Route.fromUrl url.path) model

        OnUrlRequest request ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key url.path )

                Browser.External url ->
                    ( model, Nav.load url )

        HandleLoginStatus res ->
            if Effect.handleCheckLoginStatus res then
                ( model, Nav.pushUrl model.key <| Route.toUrl Route.HomeRoute )

            else
                ( model, Nav.pushUrl model.key <| Route.toUrl Route.LoginRoute )


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = OnUrlRequest
        , onUrlChange = OnUrlChanged
        }


mapDocument : Browser.Document msg -> (msg -> Msg) -> Browser.Document Msg
mapDocument doc toMsg =
    { body = List.map (Html.map toMsg) doc.body
    , title = doc.title
    }


mapView : PageModel -> Browser.Document Msg
mapView pagemodel =
    case pagemodel of
        LoginPageModel m ->
            mapDocument (Pages.Login.view m) <| LoginPageMsg

        HomePageModel m ->
            mapDocument (Pages.Home.view m) <| HomePageMsg


view : Model -> Browser.Document Msg
view model =
    mapView model.page
