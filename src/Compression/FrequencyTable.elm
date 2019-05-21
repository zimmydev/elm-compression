module Compression.FrequencyTable exposing (FrequencyTable, Symbol, Weight, frequencyOf, generate, generateFromString, numberOfSymbolsIn, toList)

import Bytes exposing (Bytes)
import Bytes.Decode as BDecode exposing (Decoder, Step(..))
import Bytes.Encode as BEncode
import Dict exposing (Dict)



--- TYPES ---


type alias Symbol =
    Int


type alias Weight =
    Int


type FrequencyTable
    = FrequencyTable (Dict Symbol Weight)



--- OBTAINING A FREQUENCY-TABLE ---


generate : Bytes -> Maybe FrequencyTable
generate bytes =
    let
        size =
            Bytes.width bytes
    in
    BDecode.decode (unsignedInt8List size) bytes
        |> Maybe.andThen buildFrequencyTable


generateFromString : String -> Maybe FrequencyTable
generateFromString string =
    let
        bytes =
            BEncode.encode (BEncode.string string)
    in
    generate bytes



--- CONVERTING A FREQUENCY-TABLE ---


toList : FrequencyTable -> List ( Symbol, Weight )
toList (FrequencyTable dict) =
    -- Converts the buildFrequencyTable to a list sorted-ascending by weight
    dict
        |> Dict.toList
        |> List.sortBy Tuple.second



--- ACCESSING PROPERTIES OF A FREQUENCY-TABLE ---


frequencyOf : Symbol -> FrequencyTable -> Maybe Weight
frequencyOf symbol (FrequencyTable dict) =
    Dict.get symbol dict


numberOfSymbolsIn : FrequencyTable -> Int
numberOfSymbolsIn (FrequencyTable dict) =
    Dict.size dict



--- HELPER FUNCTIONS ---


buildFrequencyTable : List Symbol -> Maybe FrequencyTable
buildFrequencyTable symbols =
    let
        createOrIncrement maybeWeight =
            case maybeWeight of
                Nothing ->
                    Just 1

                Just weight ->
                    Just (weight + 1)

        frequencies =
            symbols
                |> List.foldl
                    (\sym acc -> acc |> Dict.update sym createOrIncrement)
                    Dict.empty
                |> FrequencyTable
    in
    if numberOfSymbolsIn frequencies < 2 then
        -- A frequency-table with less than 2 symbols is useless for any coding
        -- algorithms; there is no entropy to encode!
        Nothing

    else
        Just frequencies


unsignedInt8List : Int -> Decoder (List Int)
unsignedInt8List size =
    BDecode.loop ( size, [] )
        (\( n, acc ) ->
            if n <= 0 then
                BDecode.succeed (Done (List.reverse acc))

            else
                BDecode.map (\x -> Loop ( n - 1, x :: acc )) BDecode.unsignedInt8
        )
