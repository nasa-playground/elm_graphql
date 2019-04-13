module Data.Contriview exposing (Contriview, contriviewDecoder)

import Json.Decode as D exposing (Decoder)


type alias Contriview =
    { sum : Int
    }


contriviewDecoder : Decoder Contriview
contriviewDecoder =
    D.map Contriview (D.at [ "data", "contriview", "sumContributions" ] D.int)
