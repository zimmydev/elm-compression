module Huffman.FrequencyTable exposing (FrequencyTable, generate, generateFromString, sampleSize, toCharList, toList)

import Bytes exposing (Bytes, Endianness(..))
import Bytes.Decode as BDecode exposing (Decoder, Step(..))
import Bytes.Encode as BEncode
import Dict exposing (Dict)



--- TYPES ---


type alias Symbol =
    Int


type FrequencyTable
    = FrequencyTable Int (Dict Symbol Int)



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


toList : FrequencyTable -> List ( Symbol, Int )
toList (FrequencyTable _ dict) =
    dict
        |> Dict.toList
        |> List.sortBy Tuple.second
        |> List.reverse


toCharList : FrequencyTable -> List ( Char, Int )
toCharList frequencyTable =
    frequencyTable
        |> toList
        |> List.map (Tuple.mapFirst Char.fromCode)


sampleSize : FrequencyTable -> Int
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
