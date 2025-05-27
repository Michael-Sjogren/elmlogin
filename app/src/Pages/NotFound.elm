module Pages.NotFound exposing (init,initModel,update,view, Model, Msg)

import Components as Comps
import Html
import Browser
import Context as Ctx
import Signal exposing(Signal)
type Msg = 
    DoNothing

type alias Model = ()
initModel : ()
initModel = ()
init : Ctx.Context -> (Model , Signal Msg)
init _ =
    (initModel , Signal.none)

update : Ctx.Context -> Msg -> Model ->  ( Model, Signal Msg )
update _ msg model =
    case msg of
        DoNothing ->
             ( model, Signal.none )

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