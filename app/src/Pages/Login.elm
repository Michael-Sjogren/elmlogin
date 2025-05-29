module Pages.Login exposing (Model, Msg, init, initModel, update, view)

import Browser
import Components as Comp
import Context as Ctx
import Effect exposing (Effect)
import Html
import Html.Attributes as Attrs
import Html.Events as Events


type Msg
    = Login
    | PasswordChanged String
    | UsernameChanged String


type alias Model =
    { username : String
    , password : String
    }


initModel : Model
initModel =
    Model "" ""  


init : Ctx.Context -> ( Model, Effect Msg )
init ctx =
    ( initModel, Effect.none )


postLogin : { username : String, password : String } -> Effect Msg
postLogin data =
    Effect.Login data


update : Ctx.Context -> Msg -> Model -> ( Model, Effect Msg )
update ctx msg model =
    case msg of
        Login ->
            ( model, postLogin { password = model.password, username = model.username } )

        PasswordChanged password ->
            ( { model | password = password }, Effect.none )

        UsernameChanged username ->
            ( { model | username = username }, Effect.none )


view : Ctx.Context -> Model -> Browser.Document Msg
view ctx model =
    { body =
        [ Html.div [ Attrs.class "grid gap-4 px-4 py-4" ]
            [ Comp.viewHeader
            , Html.div [ Attrs.class "grid gap-4 items-center justify-center" ]
                [ Html.div [ Attrs.class "grid gap-4" ]
                    [ Html.div
                        [ Attrs.class "grid gap-2"
                        ]
                        [ Html.label [ Attrs.for "username" ] [ Html.text "Username" ]
                        , Html.div []
                            [ Comp.viewTextInput { inputType = "text", name = "username", id = "username", inputEvent = Events.onInput UsernameChanged, value = model.username }
                            ]
                        ]

                    --
                    , Html.div
                        [ Attrs.class "grid gap-2"
                        ]
                        [ Html.label [ Attrs.for "password" ] [ Html.text "Password" ]
                        , Html.div []
                            [ Comp.viewTextInput { inputType = "password", name = "password", id = "password", inputEvent = Events.onInput PasswordChanged, value = model.password }
                            ]
                        ]
                    , Html.div []
                        [ Comp.viewButtonPrimary { text = "Login", name = "loginbutton", event = Events.onClick Login, id = "loginBtn" }
                        ]
                    ]
                ]
            ]
        ]
    , title = "Login page"
    }
