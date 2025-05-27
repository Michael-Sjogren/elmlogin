module Pages.Dashboard exposing (Model,initModel,init,update, view, Msg)
import Components as Comps
import Html
import Browser
import Context as Ctx
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
            Comps.viewHeader
            ,Html.div []
            [Html.text "Dashboard page"]
            , Html.div [] [

            ]    
        ],
        title = "Dashboard page"
    }