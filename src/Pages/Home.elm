module Pages.Home exposing (..)
import Browser
import Effect
import Html
import Html.Attributes as Attrs
import Components
import Context exposing (Context)

type alias Model =
    { username : String
    }

type Msg =
    NoOp

init : (Model , Effect.Effect Msg)
init = 
    (initModel, Effect.none )

initModel : Model
initModel = {username = ""}

update : Context -> Msg -> Model ->  ( Model, Effect.Effect Msg )
update ctx msg model =
    case msg of
        NoOp ->
            (model , Effect.none)


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
    