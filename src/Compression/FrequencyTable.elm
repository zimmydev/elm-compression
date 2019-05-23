module Compression.FrequencyTable exposing (FrequencyTable, frequencyOf, generate, generateFromString, numberOfSymbolsIn, toList)

import Array exposing (Array)
import Bytes exposing (Bytes)
import Bytes.Encode as BEncode
import Compression exposing (Symbol, Weight, decodeBytesAsArray)
import Dict exposing (Dict)



--- TYPES ---


type FrequencyTable
    = FrequencyTable (Dict Symbol Weight)



--- OBTAINING A FREQUENCY-TABLE ---


generate : Bytes -> Maybe FrequencyTable
generate bytes =
    bytes
        |> decodeBytesAsArray
        |> buildFrequencyTable


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


buildFrequencyTable : Array Symbol -> Maybe FrequencyTable
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
                |> Array.foldl
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
