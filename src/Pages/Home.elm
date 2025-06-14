module Pages.Home exposing (..)
import Browser
import Effect
import Html
import Html.Attributes as Attrs
import Components
import Context exposing (Context)
import Url exposing (Protocol(..))
import Http
import Route

type alias Model =
    { username : String
    }

type Msg =
    NoOp
    | CheckLogin (Result Http.Error ())

init : (Model , Effect.Effect Msg)
init = 
    (initModel, Effect.CheckLoginStatus CheckLogin )

initModel : Model
initModel = {username = ""}

update : Context -> Msg -> Model ->  ( Model, Effect.Effect Msg )
update ctx msg model =
    case msg of
        NoOp ->
            (model , Effect.none)
        CheckLogin res ->
            case res of
                Ok _ ->
                    (model, Effect.none)
                Err err ->
                    (model, Effect.pushRoute ctx.key Route.LoginRoute)


view : Model -> Browser.Document Msg
view model =
    {
       title  = "Home",
       body  = [ Html.div[] [
            Html.header[] [
                Components.viewPrimaryNav
            ]
            ,Html.div [ Attrs.class "grid justify-center gap-4 py-4" ] [
                Html.h1 [ Attrs.class "text-2xl"] [
                    Html.text "Home page"
                ]
            ]
       ]]
    }
    