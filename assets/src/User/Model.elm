module User.Model exposing (..)

-- MODEL


type alias Model =
    { uid : String
    , name : String
    , url : String
    , loginStatus : LoginStatus
    , userType : UserType
    }


type UserType
    = Unknown
    | Client
    | Vendor
    | Runner


type LoginStatus
    = Connected
    | UnAuthorised
    | Disconnected



-- INIT


init : Model
init =
    { uid = ""
    , name = ""
    , url = ""
    , loginStatus = UnAuthorised
    , userType = Unknown
    }


newUser : String -> String -> String -> Model
newUser uid name picture =
    { uid = uid
    , name = name
    , url = picture
    , loginStatus = Connected
    , userType = Client
    }
