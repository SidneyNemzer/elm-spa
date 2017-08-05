module Page.NotFound exposing (..)

import Html
import Route


main_ : Route.SimplePage
main_ =
    { title = "Not Found"
    , view = Html.text "Not Found"
    }
