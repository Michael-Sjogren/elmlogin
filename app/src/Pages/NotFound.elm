module Pages.NotFound exposing (init,initModel,update,view, Model, Msg)

import Components as Comps
import Html
import Browser
import Context as Ctx
import Effect exposing(Effect)
type Msg = 
    DoNothing

type alias Model = ()
initModel : ()
initModel = ()
init : Ctx.Context -> (Model , Effect Msg)
init _ =
    (initModel , Effect.none)

update : Ctx.Context -> Msg -> Model ->  ( Model, Effect Msg )
update _ msg model =
    case msg of
        DoNothing ->
             ( model, Effect.none )

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