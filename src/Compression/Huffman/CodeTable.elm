module Compression.Huffman.CodeTable exposing (CodeTable, codeOf, generate)

import Compression exposing (Symbol)
import Compression.Bits as Bits exposing (Bits)
import Compression.Huffman.Tree exposing (Tree(..))
import Dict exposing (Dict)



--- TYPES ---


type CodeTable
    = CodeTable (Dict Symbol Bits)



--- OBTAINING A CODE-TABLE ---


generate : Tree -> CodeTable
generate tree =
    tree
        |> buildCodes Bits.empty []
        |> Dict.fromList
        |> CodeTable



--- ACCESSING PROPERTIES OF A CODE-TABLE ---


codeOf : Symbol -> CodeTable -> Maybe Bits
codeOf symbol (CodeTable dict) =
    Dict.get symbol dict



--- HELPER FUNCTIONS ---


buildCodes : Bits -> List ( Symbol, Bits ) -> Tree -> List ( Symbol, Bits )
buildCodes lastCode acc tree =
    case tree of
        Leaf _ symbol ->
            ( symbol, lastCode ) :: acc

        Branch _ tree1 tree2 ->
            let
                codes1 =
                    tree1
                        |> buildCodes (lastCode |> Bits.append False) acc

                codes2 =
                    tree2
                        |> buildCodes (lastCode |> Bits.append True) acc
            in
            codes1 ++ codes2
