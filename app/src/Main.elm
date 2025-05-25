module Main exposing (main)
import Html
import Browser
import Browser.Navigation as Nav
import Url
import Context as Ctx
import Pages.Login
import Pages.Dashboard
import Pages.NotFound
import Route

type alias Model =
    {
        ctx : Ctx.Context,
        pageModel : PageModel
    }

type PageModel =
    Login Pages.Login.Model
    | Dashboard Pages.Dashboard.Model
    | NotFound Pages.NotFound.Model

type Msg =
    OnUrlChanged Url.Url
    | OnUrlRequested Browser.UrlRequest
    | NotFoundMsg Pages.NotFound.Msg
    | DashboardMsg Pages.Dashboard.Msg
    | LoginMsg Pages.Login.Msg

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init flags url key =
    let
        ctx = Ctx.Context key url flags Nothing
    in

    ( Model ctx (NotFound Pages.NotFound.initModel)  , Cmd.none)

main : Program () Model Msg
main = Browser.application
    {
    init = init ,
    view = view,
    update = update ,
    onUrlChange = OnUrlChanged ,
    onUrlRequest = OnUrlRequested ,
    subscriptions = \ _ -> Sub.none
    }


update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
    OnUrlChanged url ->
        case Route.fromString url.path of
        Route.NotFoundRoute ->
            let
                (pModel, cmd) = Pages.NotFound.init model.ctx
            in

            ( {model | pageModel = NotFound pModel }, Cmd.map NotFoundMsg cmd  )
        Route.DashboardRoute ->
            let
                (pModel, cmd) = Pages.Dashboard.init model.ctx
            in

            ( {model | pageModel = Dashboard pModel }, Cmd.map DashboardMsg cmd )
        Route.LoginRoute ->
            let
                (pModel, cmd) = Pages.Login.init model.ctx
            in
            ( {model | pageModel = Login pModel }, Cmd.map LoginMsg cmd )
    OnUrlRequested req ->
        case req of
            Browser.Internal url ->
                let
                    ctx = Ctx.Context model.ctx.key url model.ctx.flags model.ctx.user
                in
                ( {model | ctx = ctx }, Nav.pushUrl ctx.key url.path )
            Browser.External url ->
                ( model, Nav.replaceUrl model.ctx.key url )
    _ ->
        ( model, Cmd.none )

view : Model -> Browser.Document Msg
view model =
    case model.pageModel of
        NotFound m ->
            let
                pview = Pages.NotFound.view model.ctx m
            in
            {
                title = pview.title,
                body = List.map ( \a -> Html.map NotFoundMsg a ) <| pview.body
            }

        Dashboard m ->
            let
                pview = Pages.Dashboard.view model.ctx m
            in
            {
                title = pview.title,
                body = List.map ( \a -> Html.map DashboardMsg a ) <| pview.body
            }
        Login m ->
            let
                pview = Pages.Login.view model.ctx m
            in
            {
                title = pview.title,
                body = List.map ( \a -> Html.map LoginMsg a ) <| pview.body
            }
