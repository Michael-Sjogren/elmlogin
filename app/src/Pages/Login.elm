module Pages.Login exposing (Model,Msg,init,initModel,update,view)
import Html
import Browser
import Context as Ctx
import Components as Comp
import Signal exposing(Signal)
type Msg =
    Login
    | LoginResponse

type alias Model =
    { username : String
    , password : String
    }

initModel : Model
initModel = Model "" ""

init : Ctx.Context -> (Model , Signal Msg)
init ctx =
    (initModel , Signal.none)

update : Ctx.Context -> Msg -> Model ->  ( Model, Signal Msg )
update ctx msg model =
    case msg of
        Login ->
             ( model, Signal.none )

        LoginResponse ->
             ( model, Signal.none )

view : Ctx.Context -> Model -> Browser.Document Msg
view ctx model =
    {
        body = [
            Comp.viewHeader
            ,Html.div [] [ Html.text "Login page" ]
        ]
        ,title = "Login page"
    }
