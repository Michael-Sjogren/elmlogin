module Pages.Dashboard exposing (..)
import Components as Comps
import Html
import Browser
import Context as Ctx
type Msg = 
    Login
    | LoginResponse

type alias Model =
    { username : String
    , password : String
    }
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
            Comps.viewHeader
            ,Html.div []
            [Html.text "Dashboard page"]
            , Html.div [] [

            ]    
        ],
        title = "Dashboard page"
    }