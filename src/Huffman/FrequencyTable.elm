module Huffman.FrequencyTable exposing (FrequencyTable, generate, generateFromString, sizeOf, toList)

import Bytes exposing (Bytes)
import Bytes.Decode as BDecode exposing (Decoder, Step(..))
import Bytes.Encode as BEncode
import Dict exposing (Dict)
import Huffman.Types exposing (..)



--- TYPES ---


type FrequencyTable
    = FrequencyTable (Dict Symbol Weight)



--- OBTAINING A FREQUENCY-TABLE ---


generate : Bytes -> FrequencyTable
generate bytes =
    let
        size =
            Bytes.width bytes
    in
    BDecode.decode (unsignedInt8List size) bytes
        |> Maybe.withDefault []
        |> frequencyTable


generateFromString : String -> FrequencyTable
generateFromString string =
    let
        bytes =
            BEncode.encode (BEncode.string string)
    in
    generate bytes



--- TRANSFORMING A FREQUENCY-TABLE ---


toList : FrequencyTable -> List ( Symbol, Weight )
toList (FrequencyTable dict) =
    dict
        |> Dict.toList
        |> List.sortBy Tuple.second


sizeOf : FrequencyTable -> Int
sizeOf (FrequencyTable dict) =
    Dict.size dict



--- HELPER FUNCTIONS ---


frequencyTable : List Symbol -> FrequencyTable
frequencyTable symbols =
    let
        createOrIncrement maybeWeight =
            case maybeWeight of
                Nothing ->
                    Just 1

                Just weight ->
                    Just (weight + 1)
    in
    symbols
        |> List.foldl
            (\sym acc -> acc |> Dict.update sym createOrIncrement)
            Dict.empty
        |> FrequencyTable


unsignedInt8List : Int -> Decoder (List Int)
unsignedInt8List size =
    BDecode.loop ( size, [] )
        (\( n, acc ) ->
            if n <= 0 then
                BDecode.succeed (Done (List.reverse acc))

            else
                BDecode.map (\x -> Loop ( n - 1, x :: acc )) BDecode.unsignedInt8
        )
