module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Context as Ctx
import Effect exposing (Effect(..))
import Html
import Http
import Json.Decode as JDecode
import Json.Encode as JEncode
import Pages.Dashboard
import Pages.Login
import Pages.NotFound
import Route
import Task
import Url
import Platform.Cmd as Cmd
import Platform.Cmd as Cmd
import Html.Attributes exposing (class)


type alias LoginResponseData =
    { success : Bool
    , response : String
    }


encodeLoginRequest : { username : String, password : String } -> JEncode.Value
encodeLoginRequest data =
    JEncode.object
        [ ( "username", JEncode.string data.username )
        , ( "password", JEncode.string data.password )
        ]


loginResponseDecoder : JDecode.Decoder LoginResponseData
loginResponseDecoder =
    JDecode.map2 LoginResponseData
        (JDecode.field "success" JDecode.bool)
        (JDecode.field "response" JDecode.string)


type alias Model =
    { ctx : Ctx.Context
    , pageModel : PageModel
    , errorMsg : Maybe String
    }

type alias ErrorResponse = 
    {
        statusCode : Int
        ,errorMessage : String
    }

type ServerStatusError =
    BadStatus (Maybe ErrorResponse)
    | UnAuthorized (Maybe ErrorResponse)

decodeErrorResponse : JDecode.Decoder ErrorResponse
decodeErrorResponse =
    JDecode.map2 ErrorResponse
        (JDecode.field "statusCode" JDecode.int )
        (JDecode.field "errorMessage" JDecode.string)



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
    | LoginResponse (Result ServerStatusError LoginResponseData)


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ctx =
            Ctx.Context key url flags Nothing
    in
    ( Model ctx (Login Pages.Login.initModel) Nothing, Cmd.none )


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
    case ( msg, model.pageModel ) of
        ( OnUrlChanged url, _ ) ->
            case Route.fromString url.path of
                Route.NotFoundRoute ->
                    let
                        ( pModel, cmd ) =
                            Pages.NotFound.init model.ctx
                    in
                    ( { model | pageModel = NotFound pModel }, Effect.map NotFoundMsg cmd |> signalToCmd model )

                Route.DashboardRoute ->
                    let
                        ( pModel, cmd ) =
                            Pages.Dashboard.init model.ctx
                    in
                    ( { model | pageModel = Dashboard pModel }, Effect.map DashboardMsg cmd |> signalToCmd model )

                Route.LoginRoute ->
                    let
                        ( pModel, cmd ) =
                            Pages.Login.init model.ctx
                    in
                    ( { model | pageModel = Login pModel }, Effect.map LoginMsg cmd |> signalToCmd model )

        ( OnUrlRequested req, _ ) ->
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
                ( lmodel, signal ) =
                    Pages.Login.update model.ctx m pageModel
            in
            ( { model | pageModel = Login lmodel }, Effect.map LoginMsg signal |> signalToCmd model )

        ( LoginMsg _, _ ) ->
            ( model, Cmd.none )

        ( NotFoundMsg m, NotFound pageModel ) ->
            let
                ( lmodel, signal ) =
                    Pages.NotFound.update model.ctx m pageModel
            in
            ( { model | pageModel = NotFound lmodel }, Effect.map NotFoundMsg signal |> signalToCmd model )

        ( NotFoundMsg _, _ ) ->
            ( model, Cmd.none )

        ( DashboardMsg m, Dashboard pageModel ) ->
            let
                ( lmodel, signal ) =
                    Pages.Dashboard.update model.ctx m pageModel
            in
            ( { model | pageModel = Dashboard lmodel }, Effect.map DashboardMsg signal |> signalToCmd model )

        ( DashboardMsg m, _ ) ->
            ( model, Cmd.none )

        ( LoginResponse result, _ ) ->
            case result of
                Result.Ok _ ->
                    ( {model | errorMsg = Nothing }, Nav.pushUrl model.ctx.key (Route.toString Route.DashboardRoute) )


                Result.Err err ->
                    case err of
                        UnAuthorized res ->
                            case res of
                                Just errorMsg ->
                                    ({model | errorMsg = Just errorMsg.errorMessage } , Cmd.none)
                                Nothing ->
                                    (model , Cmd.none)
                        BadStatus res ->
                            case res of
                                Just errorMsg ->
                                    ({model | errorMsg = Just errorMsg.errorMessage } , Cmd.none)
                                Nothing ->
                                    (model , Cmd.none)


view : Model -> Browser.Document Msg
view model =
    case model.pageModel of
        NotFound m ->
            let
                pview =
                    Pages.NotFound.view model.ctx m
                
                body = List.map (\a -> Html.map NotFoundMsg a) <| pview.body

                bodt = List.append [ Html.div [ class "grid gap-4"] [
                    case model.errorMsg of
                        Just val -> Html.text val
                        Nothing -> Html.text "" ]] body
            in
            { title = pview.title
            , body = bodt
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

                body = List.map (\a -> Html.map LoginMsg a) <| pview.body

                bodt = List.append [ Html.div [ class "grid gap-4"] [
                    case model.errorMsg of
                        Just val -> Html.text val
                        Nothing -> Html.text "" ]] body
            in
            { title = pview.title
            , body = bodt
            }



-- Global Signals , e.g. global events that can be sent from other pages


signalToCmd : Model -> Effect Msg -> Cmd Msg
signalToCmd model signal =
    case signal of
        Effect.None ->
            Cmd.none

        Effect.Batch signals ->
            Cmd.batch (List.map (signalToCmd model) signals)

        Effect.PushRoute route ->
            Nav.pushUrl model.ctx.key (Route.toString route)

        Effect.Login data ->
            Http.post
                { url = "/auth/login"
                , body = Http.jsonBody (encodeLoginRequest data)
                , expect = expectJson LoginResponse loginResponseDecoder
                }

expectJson : (Result ServerStatusError a -> msg) -> JDecode.Decoder a -> Http.Expect msg
expectJson toMsg decoder =
    Http.expectStringResponse toMsg<|
    \response -> case response of
        Http.BadUrl_ url ->
          Err (BadStatus Nothing)

        Http.Timeout_ ->
          Err (BadStatus Nothing)

        Http.NetworkError_ ->
          Err (BadStatus Nothing)

        Http.BadStatus_ metadata body ->
            case metadata.statusCode of
                401 -> 
                    case (JDecode.decodeString decodeErrorResponse body) of 
                        Ok res ->
                            Result.Err (UnAuthorized <| Just res)
                        Err _ ->
                            Result.Err (UnAuthorized Nothing )
                _ ->
                    Result.Err (BadStatus Nothing )

        Http.GoodStatus_ metadata body ->
          case (JDecode.decodeString decoder body) of
            Ok value ->
              Ok value

            Err err ->
              Err (BadStatus Nothing)

sendMsg : Msg -> Cmd Msg
sendMsg msg =
    Task.succeed msg
        |> Task.perform identity
