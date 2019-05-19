module Huffman.FrequencyTable exposing (FrequencyTable, generate, generateFromString, sampleSize, toCharList, toList)

import Bytes exposing (Bytes, Endianness(..))
import Bytes.Decode as BDecode exposing (Decoder, Step(..))
import Bytes.Encode as BEncode
import Dict exposing (Dict)
import Huffman.Types exposing (..)



--- TYPES ---


type FrequencyTable
    = FrequencyTable Int (Dict Symbol Count)



--- OBTAINING A FREQUENCY-TABLE ---


generate : Bytes -> FrequencyTable
generate bytes =
    let
        size =
            Bytes.width bytes

        startOrIncrement maybeCount =
            case maybeCount of
                Nothing ->
                    Just 1

                Just count ->
                    Just (count + 1)
    in
    case BDecode.decode (unsignedInt8List size) bytes of
        Nothing ->
            FrequencyTable 0 Dict.empty

        Just symbols ->
            symbols
                |> List.foldl
                    (\sym acc -> acc |> Dict.update sym startOrIncrement)
                    Dict.empty
                |> FrequencyTable size


generateFromString : String -> FrequencyTable
generateFromString string =
    generate (bytesFromString string)



--- TRANSFORMING A FREQUENCY-TABLE ---


toList : FrequencyTable -> List ( Symbol, Count )
toList (FrequencyTable _ dict) =
    dict
        |> Dict.toList
        |> List.sortBy Tuple.second
        |> List.reverse


toCharList : FrequencyTable -> List ( Char, Count )
toCharList frequencyTable =
    frequencyTable
        |> toList
        |> List.map (Tuple.mapFirst Char.fromCode)


sampleSize : FrequencyTable -> Count
sampleSize (FrequencyTable size _) =
    size



--- HELPER FUNCTIONS ---


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
