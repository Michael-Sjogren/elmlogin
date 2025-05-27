module Pages.Login exposing (Model,Msg,init,initModel,update,view)
import Html
import Html.Attributes as Attrs
import Browser
import Context as Ctx
import Components as Comp
import Signal exposing(Signal)
import Html.Events as Events
import Http
import Json.Encode as JEncode
import Json.Decode as JDecode
import Route
type Msg =
    Login
    | PasswordChanged String
    | UsernameChanged String





type alias Model =
    { username : String
    , password : String
    }

initModel : Model
initModel = Model "" ""

init : Ctx.Context -> (Model , Signal Msg)
init ctx =
    (initModel , Signal.none)




postLogin : {username : String, password : String } -> Signal.Signal Msg
postLogin data =
    Signal.Login data

update : Ctx.Context -> Msg -> Model ->  ( Model, Signal Msg )
update ctx msg model =
    case msg of
        Login ->
             ( model,postLogin {password = model.password,  username = model.username })
        PasswordChanged password ->
            ( {model | password = password} , Signal.none)
        UsernameChanged username ->
            ( {model | username = username }, Signal.none )
view : Ctx.Context -> Model -> Browser.Document Msg
view ctx model =
    {
        body = [
            Html.div [ Attrs.class "grid gap-4 px-4"] [

            Comp.viewHeader
            ,Html.div [ Attrs.class "grid gap-4 items-center"] [
                Html.div [ Attrs.class "grid gap-4"] [
                    Html.div [
                        Attrs.class "grid gap-2"
                    ] [
                        Html.label [Attrs.for "username"] [ Html.text "Username"]
                        ,Html.div [] [
                            Comp.viewTextInput {inputType = "text", name = "username", id="username", inputEvent = Events.onInput UsernameChanged, value = model.username } 
                        ]
                    ]
                    -- 
                    ,Html.div [
                        Attrs.class "grid gap-2"
                    ] [
                        Html.label [Attrs.for "password"] [ Html.text "Password"]
                        ,Html.div [] [
                            Comp.viewTextInput {inputType = "password", name = "password", id="password", inputEvent = Events.onInput PasswordChanged, value = model.password } 
                        ]
                    ]
                    ,(Comp.viewButtonPrimary { text = "Login", name = "loginbutton", event = Events.onClick Login , id = "loginBtn" })
                ]
             ]
            ]
        ]
        ,title = "Login page"
    }
