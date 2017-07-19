module BasketItem exposing (..)

import ProductModels exposing (..)


type BasketItem
    = CatalogItem { item : BuyNowItem, lenght : Lenght }
    | CustomItem { color : String, lenght : Lenght }
