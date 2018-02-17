module App exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Json.Encode


type alias Model =
    { newMessage : Message
    }


emptyModel : Model
emptyModel =
    { newMessage = emptyNewMessage
    }


emptyNewMessage =
    Message "" ""


type alias Message =
    { email : String
    , message : String
    }


type Msg
    = SendMessage
    | UpdateMessage Message
    | SendMessageHttp (Result Http.Error Message)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateMessage newMessage ->
            ( { model | newMessage = newMessage }, Cmd.none )

        SendMessage ->
            let
                newMessage =
                    Debug.log "model.newMessage" model.newMessage
            in
            ( { model | newMessage = emptyNewMessage }, postMessage newMessage )

        SendMessageHttp (Ok response) ->
            let
                _ =
                    Debug.log "response" response
            in
            ( model, Cmd.none )

        SendMessageHttp (Err err) ->
            let
                _ =
                    Debug.log "err" err
            in
            ( model, Cmd.none )


decodeMessage : Json.Decoder Message
decodeMessage =
    Json.map2 Message
        (Json.field "id" Json.string)
        (Json.field "message" Json.string)


postMessage newMessage =
    Http.send SendMessageHttp
        (Http.post "https://csunn71hu7.execute-api.us-east-1.amazonaws.com/dev/sendMail"
            (encodeNewMessage newMessage)
            decodeMessage
        )


encodeNewMessage : Message -> Http.Body
encodeNewMessage newMessage =
    Http.jsonBody <|
        Json.Encode.object
            [ ( "email", Json.Encode.string newMessage.email )
            , ( "message", Json.Encode.string newMessage.message )
            ]


isEmpty : String -> Bool
isEmpty =
    String.isEmpty << String.trim


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , init = ( emptyModel, Cmd.none )
        }


viewForm newMessage toUpdateMessage sendMessage =
    Html.form [ class "form", onSubmit SendMessage, action "javascript:void(0);" ]
        [ h2 [ id "contact", class "title" ] [ text "Contact us" ]
        , label [ class "label" ] [ text "Your email" ]
        , input
            [ class "input"
            , placeholder "Your email"
            , value newMessage.email
            , onInput (\v -> toUpdateMessage { newMessage | email = v })
            ]
            []
        , label [ class "label" ] [ text "Message" ]
        , textarea
            [ class "textarea"
            , placeholder "Let us know how we can help you..."
            , value newMessage.message
            , onInput (\v -> toUpdateMessage { newMessage | message = v })
            ]
            []
        , button
            [ class "button is-primary has-text-centered"
            , type_ "submit"
            , disabled <| isEmpty newMessage.email || isEmpty newMessage.message
            ]
            [ text "Send" ]
        ]


view model =
    div []
        [ section [ class "hero is-info is-medium is-bold" ]
            [ div [ class "hero-head" ]
                [ nav [ class "navbar" ]
                    [ div [ class "container " ]
                        [ div [ class "navbar-brand" ]
                            [ a [ class "navbar-item", href "http://skynetng.pw" ] [ span [] [ text "CloudX" ] ]
                            , span [ class "navbar-burger burger", attribute "data-target" "navbarMenu" ]
                                [ span [] []
                                , span [] []
                                , span [] []
                                ]
                            ]
                        , div [ id "navbarMenu", class "navbar-menu" ]
                            [ div [ class "navbar-end" ]
                                [ a [ class "navbar-item", href "#serverless" ] [ text "Serverless" ]
                                , a [ class "navbar-item", href "#cloud" ] [ text "Cloud" ]
                                , a [ class "navbar-item", href "#onpremises" ] [ text "On premises" ]
                                , a [ class "navbar-item", href "#contact" ] [ text "Contact" ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , section [ class "hero is-info is-medium is-bold" ]
            [ div [ class "hero-body" ]
                [ div [ class "container has-text-centered" ]
                    [ h1 [ class "title" ]
                        [ text "Cloud and serverless it's the future, let us show you how..." ]
                    , h2
                        [ class "subtitle" ]
                        [ text "As you should be aware by now, having your own hardware and keeping everything in your offices can bring a lot of pain and increased costs against all the options that the cloud can offer." ]
                    ]
                ]
            ]
        , div [ class "box cta" ]
            [ p [ class "has-text-centered" ]
                [ span [ class "tag is-primary" ] [ text "New" ]
                , text "Serverless framework can help you reduce hosting costs and scalability issues."
                ]
            ]
        , section
            [ class "container" ]
            [ div [ class "columns features" ]
                [ div [ class "column is-4" ]
                    [ div [ class "card" ]
                        [ div [ class "card-image has-text-centered" ]
                            [ i [ class "fa fab fa-cloudscale" ] []
                            ]
                        , div [ class "card-content" ]
                            [ div [ class "content" ]
                                [ h4 [] [ text "Scalability" ]
                                , p []
                                    [ text "Serverless backends expand and contract with demand. Go get on the front page of HackerNews, we dare you." ]
                                , p
                                    []
                                    [ a [ href "/contact" ] [ text "Be serverless" ] ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "column is-4" ]
                    [ div [ class "card" ]
                        [ div [ class "card-image has-text-centered" ]
                            [ i [ class "fas fa-fighter-jet" ] []
                            ]
                        , div [ class "card-content" ]
                            [ div [ class "content" ]
                                [ h4 [] [ text "Lifecycle" ]
                                , p []
                                    [ text "Serverless cuts weeks off development cycles. Don’t spend time provisioning unused infrastructure." ]
                                , p
                                    []
                                    [ a [ href "/contact" ] [ text "Be serverless" ] ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "column is-4" ]
                    [ div [ class "card" ]
                        [ div [ class "card-image has-text-centered" ]
                            [ i [ class "fas fa-fighter-jet" ] []
                            ]
                        , div [ class "card-content" ]
                            [ div [ class "content" ]
                                [ h4 [] [ text "Save money" ]
                                , p []
                                    [ text "Build, test and deploy cloud functions to any provider. Skip the setup; deploy your function right now and only pay for what you really use." ]
                                , p
                                    []
                                    [ a [ href "/contact" ] [ text "Be serverless" ] ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div
            [ class "container" ]
            [ h2 [ class "title" ] [ text "Perfect for developers" ]
            , p [ class "subtitle" ] [ text "Serverless Framework is your single toolkit for deploying serverless architectures to any provider. You build the features, we configure the infrastructure. Done." ]
            , br [] []
            , h2 [ id "serverless", class "title" ] [ text "Serverless" ]
            , p [ class "subtitle" ] [ text "You can pick your preferred cloud provider: Amazon AWS, Google Cloud, Microsoft Azure, IBM OpenWhisk." ]
            , br [] []
            , h2 [ id "cloud", class "title" ] [ text "Cloud" ]
            , p [ class "subtitle" ] [ text "You can get vps/vpc/etc and let us do the administration: Amazon AWS, Google Cloud, Microsoft Azure, IBM OpenWhisk." ]
            , br [] []
            , h2 [ id "onpremises", class "title" ] [ text "On premises" ]
            , p [ class "subtitle" ] [ text "You can still use your hardware and let us do the administration" ]
            ]
        , div
            [ class "container" ]
            [ br [] []
            , div [ class "columns" ]
                [ div [ class "column auto" ] <| [ viewForm model.newMessage UpdateMessage SendMessage ]
                ]
            ]
        , br [] []
        , div
            [ class "container" ]
            [ footer [ class "footer" ]
                [ div [ class "container" ]
                    [ div [ class "content has-text-centered" ]
                        [ p []
                            [ a [ href "http://skynetng.pw/" ]
                                [ img [ src "https://bulma.io/images/made-with-bulma--dark.png", alt "Made with Bulma", width 128, height 24 ] []
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
