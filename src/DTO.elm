module DTO exposing (..)
import Json.Decode as JD
import Json.Encode as JE

-- Request objects
type alias LoginCredentials =
    { password : String
    , username : String
    }
-- Response objects
type alias LoginResponse =
    { username : String
    , access : Int
    }

type alias ErrorResponse =
    { 
        errors : List String
    }

-- Decoders

errorResponseDecoder : JD.Decoder ErrorResponse
errorResponseDecoder =
    JD.map ErrorResponse
        (JD.field "errors" (JD.list JD.string) )

loginResponseDecoder : JD.Decoder LoginResponse
loginResponseDecoder =
    JD.map2 LoginResponse
        (JD.field "username" JD.string )
        (JD.field "access" JD.int )


-- Encoders

loginCredentialsEncoder : LoginCredentials -> JE.Value
loginCredentialsEncoder creds =
    JE.object
        [ ( "username", JE.string creds.username )
        , ( "password", JE.string creds.password )
        ]
