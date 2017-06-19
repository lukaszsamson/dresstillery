module Product exposing (..)

import BasketItem exposing (BasketItem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import Models exposing (..)
import ProductModels exposing (..)
import ProductsApi
import RemoteData exposing (WebData)
import Utils exposing (productText)


type Msg
    = ToBasket BasketItem
    | Load
    | Loaded (WebData BuyNowItem)
    | LenghtChanged Lenght


type alias Model =
    { product : WebData BuyNowItem
    , id : Int
    , flags : Flags
    , selectedLenght : Maybe Lenght
    }


init : Flags -> Int -> Model
init flags i =
    { id = i
    , product = RemoteData.NotAsked
    , flags = flags
    , selectedLenght = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LenghtChanged l ->
            { model | selectedLenght = Just l } ! []

        ToBasket i ->
            model ! []

        Load ->
            ( { model | product = RemoteData.Loading }, ProductsApi.fetchProduct model.flags model.id Loaded )

        Loaded response ->
            let
                selectedLenght =
                    case response of
                        RemoteData.Success product ->
                            List.head product.lenghts

                        _ ->
                            Nothing
            in
            ( { model | product = response, selectedLenght = selectedLenght }, Cmd.none )


lenghtPicker : List Lenght -> Maybe Lenght -> Html Msg
lenghtPicker lenghts selectedLenght =
    div [ class "lenghtPicker" ]
        (lenghts
            |> List.map
                (\a ->
                    Html.label
                        [ class
                            (if selectedLenght == Just a then
                                "radioChecked"
                             else
                                ""
                            )
                        ]
                        [ input [ type_ "radio", name "lenghtPicker", onClick (LenghtChanged a) ] []
                        , text (toString a)
                        ]
                )
        )


maybeProduct : Model -> Html Msg
maybeProduct model =
    case model.product of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success product ->
            div [ class "grid5" ]
                [ div [ class "wideColumn" ] [ img [ src product.src, class "productMainImage" ] [] ]
                , div [ class "productDetails", class "thinColumn" ]
                    [ h2 [] [ text product.label ]
                    , div [ class "productPrice" ] [ text (toString product.price ++ " zł") ]
                    , h3 [] [ text "Opis" ]
                    , div [] [ Markdown.toHtml [] productText ]
                    , h3 [] [ text "Skład" ]
                    , dl []
                        (product.ingridients
                            |> List.concatMap
                                (\a ->
                                    [ dt [] [ text a.name ]
                                    , dd [] [ text (toString a.percentage ++ "%") ]
                                    ]
                                )
                        )
                    , h3 [] [ text "Dostępne warianty" ]
                    , lenghtPicker product.lenghts model.selectedLenght
                    , div [ class "productBasket" ]
                        [ button [ onClick (ToBasket (BasketItem.CatalogItem { item = product, lenght = Maybe.withDefault Mini model.selectedLenght })) ] [ text "Do koszyka" ]
                        ]
                    ]
                ]

        RemoteData.Failure error ->
            text (toString error)


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ maybeProduct model
        ]
