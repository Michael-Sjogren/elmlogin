module Pages.NotFound exposing (..)

import Components as Comps
import Html
import Browser
import Context as Ctx
type Msg = 
    DoNothing

type alias Model = ()
initModel : ()
initModel = ()
init : Ctx.Context -> (Model , Cmd Msg)
init _ =
    (initModel , Cmd.none)

update : Ctx.Context -> Msg -> Model ->  ( Model, Cmd Msg )
update _ msg model =
    case msg of
        DoNothing ->
             ( model, Cmd.none )

view : Ctx.Context -> Model -> Browser.Document Msg
view _ _ =
    {
        body = [ 
            Comps.viewHeader
            ,Html.div [] [
                Html.text "Error 404: Page Not found"
            ]
        ],
        title = "Error: 404 Not Found!"
    }