module BasketItem exposing (..)


type BasketItem
    = CatalogItem { id : Int }
    | CustomItem { color : String, lenght : Int }
