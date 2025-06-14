module Pages.Login exposing (..)
import Browser
import Effect
import Html
import Components
import Html.Attributes as Attrs
import Components exposing (viewTextInput)
import Html.Events as Events
import Http
import Route
import Context exposing (Context)
import Effect exposing (ServerError(..))
import DTO
import Maybe exposing (withDefault)
type alias Model =
    { username : String
    , password : String
    , error : Maybe String
    }

type Msg =
    OnPasswordChanged String
    | OnUsernameChanged String
    | OnLoginSubmit
    | LoginResponseRecevied (Result Http.Error DTO.LoginResponse)

init : Context -> (Model , Effect.Effect Msg)
init ctx = 
    (initModel, Effect.none )

initModel : Model
initModel = { username = "", password = "", error = Nothing} 

update : Context -> Msg -> Model ->  ( Model, Effect.Effect Msg )
update ctx msg model =
    case msg of
        OnPasswordChanged pw ->
             ( {model | password = pw } , Effect.none )

        OnUsernameChanged usr ->
            ( {model | username = usr } , Effect.none )
        OnLoginSubmit ->
            ( {model | error = Nothing}  , Effect.Login { username = model.username, password = model.password } LoginResponseRecevied )
        LoginResponseRecevied result ->
            case result of
                Ok val ->
                    ({model | error = Nothing}, Effect.pushRoute ctx.key Route.HomeRoute )
                Err err ->
                    case handleHttpError err of
                        UnAuthorized ->
                            ({model | error = Just "Invalid username or password."}, Effect.none )
                        _ ->
                            (model, Effect.none )


handleHttpError : Http.Error -> Effect.ServerError
handleHttpError err =
    case err of
        Http.BadStatus code ->
            case code of
                401 -> UnAuthorized 
                _ -> InternalServerError
        Http.BadBody a ->
            InternalServerError
        _ -> InternalServerError 

view : Model -> Browser.Document Msg
view model =
    {
       title  = "Login",
       body  = [ Html.div[] [
            Html.header[] [
                Components.viewPrimaryNav
            ]
            ,Html.div [ Attrs.class "grid justify-center gap-4 py-4" ] [
                Html.h1 [ Attrs.class "text-2xl"] [
                    Html.text "Login"
                ],
                Html.div [ Attrs.class "grid gap-4"] [
                    Html.label [ Attrs.for "username" ] [ Html.text "Username"]
                    ,Html.div [] [
                        viewTextInput {  
                            type_ = "text" ,
                            id = "username",
                            event = Events.onInput OnUsernameChanged , 
                            value = model.username, 
                            class = "py-2 rounded-lg border-1 border border-neutral-500 text-neutral-800 px-4"
                        }
                    ]
                ],
                Html.div [ Attrs.class "grid gap-4"] [
                    Html.label [ Attrs.for "password" ] [ Html.text "Password"]
                    ,Html.div [] [
                        viewTextInput {  
                            type_ = "password" ,
                            id = "password",
                            event = Events.onInput OnPasswordChanged , 
                            value = model.password, 
                            class = "py-2 rounded-lg border-1 border border-neutral-500 text-neutral-800 px-4"
                        }
                    ]
                ]
                ,Components.viewBtn { 
                    text = "Login", 
                    event = Events.onClick OnLoginSubmit, 
                    class = "cursor-pointer py-2 px-4 bg-green-400 text-black rounded-sm hover:bg-green-500" 
                }
                ,Html.div [ Attrs.class "text-red-400"] [
                    Html.text <| withDefault "" model.error
                ]
            ]
        ]
       ]
    }
    