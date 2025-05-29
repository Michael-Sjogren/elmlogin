module Pages.Dashboard exposing (Model,initModel,init,update, view, Msg)
import Components as Comps
import Html
import Browser
import Context as Ctx
import Effect exposing(Effect)
type Msg = 
    Login
    | LoginResponse

type alias Model =
    { username : String
    , password : String
    }
initModel : Model
initModel = Model "" ""
init : Ctx.Context -> (Model , Effect Msg)
init ctx =
    (initModel , Effect.none)

update : Ctx.Context -> Msg -> Model ->  ( Model, Effect Msg )
update ctx msg model =
    case msg of
        Login ->
             ( model, Effect.none )

        LoginResponse ->
             ( model, Effect.none )

view : Ctx.Context -> Model -> Browser.Document Msg
view ctx model =
    {
        body = [ 
            Comps.viewHeader
            ,Html.div []
            [Html.text "Dashboard page"]
        ],
        title = "Dashboard page"
    }