module Route exposing (..)


type Route =
    LoginRoute
    | DashboardRoute
    | NotFoundRoute


fromString : String -> Route
fromString url =
    case url of
        "/login" -> LoginRoute
        "/home" -> DashboardRoute
        _ -> NotFoundRoute

toString : Route -> String
toString r =
    case r of
        LoginRoute -> "/login"
        DashboardRoute -> "/home"
        NotFoundRoute -> "/"