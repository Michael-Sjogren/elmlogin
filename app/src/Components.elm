module Components exposing (..)
import Html
import Html.Attributes as Attrs
import Route
viewHeader : Html.Html msg
viewHeader = 
    Html.header [] [
        Html.nav [] [
            Html.ul [] [
                Html.li [ ] [ Html.a [Attrs.href <| Route.toString Route.LoginRoute] 
                    [ Html.text "login" ] ]
                ,Html.li [ ] [ Html.a [Attrs.href <| Route.toString Route.DashboardRoute] 
                    [ Html.text "Dashboard" ] ]
            ]
        ]
    ]
