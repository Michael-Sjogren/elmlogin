module DTO exposing (..)

-- import Json.Decode as JD
import Json.Encode as JE


type alias LoginCredentials =
    { password : String
    , username : String
    }



-- decoders
-- encoders


loginCredentialsEncoder : LoginCredentials -> JE.Value
loginCredentialsEncoder creds =
    JE.object
        [ ( "username", JE.string creds.username )
        , ( "password", JE.string creds.password )
        ]
