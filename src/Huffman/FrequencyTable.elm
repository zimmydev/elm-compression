module Huffman.FrequencyTable exposing (FrequencyTable)

import Bytes exposing (Bytes, Endianness(..))
import Bytes.Decode as BDecode exposing (Decoder, Step(..))
import Bytes.Encode as BEncode exposing (Encoder)
import Dict exposing (Dict)



--- TYPES ---


type FrequencyTable
    = FrequencyTable (Dict Int Float)



--- TYPES FOR INTERNAL USE ---


type alias CountTable =
    Dict Int Int



--- OBTAINING A FREQUENCY-TABLE ---


load : Bytes -> FrequencyTable
load bytes =
    Debug.todo "load bytes"


loadString : String -> FrequencyTable
loadString string =
    Debug.todo "load a string"



--- HELPER FUNCTIONS ---


count : Bytes -> CountTable
count bytes =
    let
        maybeInts =
            BDecode.decode (unsignedInt8List (Bytes.width bytes)) bytes
    in
    case maybeInts of
        Nothing ->
            Dict.empty

        Just ints ->
            countHelper Dict.empty ints


countHelper : Dict Int Int -> List Int -> CountTable
countHelper acc ints =
    case ints of
        [] ->
            acc

        x :: xs ->
            let
                updateTable maybeV =
                    case maybeV of
                        Nothing ->
                            Just 1

                        Just v ->
                            Just (v + 1)

                newTable =
                    acc
                        |> Dict.update x updateTable
            in
            countHelper newTable xs


unsignedInt8List : Int -> Decoder (List Int)
unsignedInt8List size =
    BDecode.loop ( size, [] )
        (\( n, acc ) ->
            if n <= 0 then
                BDecode.succeed (Done (List.reverse acc))

            else
                BDecode.map (\x -> Loop ( n - 1, x :: acc )) BDecode.unsignedInt8
        )


bytesFromString : String -> Bytes
bytesFromString string =
    BEncode.encode (BEncode.string string)
