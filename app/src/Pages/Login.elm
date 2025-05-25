module Pages.Login exposing (..)
import Html
import Browser
import Context as Ctx
import Components as Comp
type Msg =
    Login
    | LoginResponse

type alias Model =
    { username : String
    , password : String
    }

initModel : Model
initModel = Model "" ""

init : Ctx.Context -> (Model , Cmd Msg)
init ctx =
    (initModel , Cmd.none)

update : Ctx.Context -> Msg -> Model ->  ( Model, Cmd Msg )
update ctx msg model =
    case msg of
        Login ->
             ( model, Cmd.none )

        LoginResponse ->
             ( model, Cmd.none )

view : Ctx.Context -> Model -> Browser.Document Msg
view ctx model =
    {
        body = [
            Comp.viewHeader
            ,Html.div [] [ Html.text "Login page" ]
        ]
        ,title = "Login page"
    }
