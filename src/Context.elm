module Context exposing (..)
import Browser.Navigation as Nav
import Url

type alias Context =
    { key : Nav.Key
    , url : Url.Url
    }