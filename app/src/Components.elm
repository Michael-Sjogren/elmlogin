module Components exposing (..)
import Html
import Html.Attributes as Attrs

import Route
viewHeader : Html.Html msg
viewHeader = 
    Html.header [] [
        Html.nav [ Attrs.class "py-2" ] [
            Html.ul [ Attrs.class "flex gap-4 items-center justify-center"] [
                Html.li [ ] [ Html.a [Attrs.href <| Route.toString Route.LoginRoute] 
                    [ Html.text "login" ] ]
                ,Html.li [ ] [ Html.a [Attrs.href <| Route.toString Route.DashboardRoute] 
                    [ Html.text "Dashboard" ] ]
            ]
        ]
    ]

primaryBtnClass : String
primaryBtnClass = "bg-green-500 rounded-md py-3 px-5 text-white cursor-pointer hover:bg-green-600"
inputTextClass : String
inputTextClass = "bg-white rounded-md py-3 px-3 text-black border-black border-1"
viewButtonPrimary : { text : String ,  name: String , event : Html.Attribute msg, id:String } -> Html.Html msg
viewButtonPrimary data =
    Html.button [ Attrs.class primaryBtnClass, Attrs.id data.id , Attrs.name data.name,  data.event ] [
        Html.text data.text
    ]



viewTextInput : {  inputType: String,  name: String , inputEvent : Html.Attribute msg, id:String, value : String } -> Html.Html msg
viewTextInput data =
    Html.input [ Attrs.type_  data.inputType,  Attrs.class inputTextClass, Attrs.id data.id , Attrs.name data.name,  data.inputEvent, Attrs.value data.value  ] []