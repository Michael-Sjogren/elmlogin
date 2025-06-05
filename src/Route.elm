module Route exposing (..)


type Route
    = NotFoundRoute
    | LoginRoute
    | HomeRoute


toUrl : Route -> String
toUrl route =
    case route of
        NotFoundRoute ->
            "/404"

        LoginRoute ->
            "/login"

        HomeRoute ->
            "/home"


fromUrl : String -> Route
fromUrl url =
    case url of
        "/login" ->
            LoginRoute

        "/home" ->
            HomeRoute

        _ ->
            NotFoundRoute
