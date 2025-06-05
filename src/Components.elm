module Components exposing (..)

import Html
import Html.Attributes as Attrs
import Route


viewBtn : { text : String, event : Html.Attribute msg, class : String } -> Html.Html msg
viewBtn d =
    Html.button [ d.event, Attrs.class d.class ] [ Html.text d.text ]


viewNavLinkItem : { href : String, linkText : String } -> Html.Html msg
viewNavLinkItem r =
    Html.li [ Attrs.class "text-green-400 rounded-sm px-4 py-2 bg-white hover:bg-neutral-100" ]
        [ Html.a [ Attrs.href r.href ] [ Html.text r.linkText ]
        ]


viewPrimaryNav : Html.Html msg
viewPrimaryNav =
    Html.nav []
        [ Html.ul [ Attrs.class "flex gap-1 items-center justify-center py-2 px-2" ]
            [ viewNavLinkItem { href = Route.toUrl Route.HomeRoute, linkText = "Home" }
            , viewNavLinkItem { href = Route.toUrl Route.LoginRoute, linkText = "Login" }
            ]
        ]


viewTextInput : { type_ : String, id : String, event : Html.Attribute msg, value : String, class : String } -> Html.Html msg
viewTextInput d =
    Html.input [ Attrs.type_ d.type_, Attrs.value d.value, d.event, Attrs.class d.class, Attrs.id d.id ] []
