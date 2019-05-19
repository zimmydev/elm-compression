module Huffman.CodeTable exposing (CodeTable, Tree, codeTable, generate, huffmanTree)

import Dict exposing (Dict)
import Huffman.Code as Code exposing (Bit(..), Code)
import Huffman.FrequencyTable as Freq exposing (FrequencyTable)
import Huffman.Types exposing (..)
import Set exposing (Set)



--- TYPES ---


type CodeTable
    = CodeTable (Dict Symbol Code)



--- INTERMEDIATE REPRESENTATION TYPES ---


type Tree
    = Cons Weight SymbolSet Tree Tree
    | Leaf Weight Symbol


type alias SymbolSet =
    Set Symbol



--- OBTAINING A CODE-TABLE ---


generate : FrequencyTable -> Maybe CodeTable
generate freqTable =
    freqTable
        |> huffmanTree
        |> Maybe.map codeTable



--- HELPER FUNCTIONS ---


codeTable : Tree -> CodeTable
codeTable tree =
    Dict.empty
        |> constructCodes tree Code.empty
        |> CodeTable


constructCodes : Tree -> Code -> Dict Symbol Code -> Dict Symbol Code
constructCodes tree lastCode dict =
    case tree of
        Leaf _ symbol ->
            dict
                |> Dict.insert symbol lastCode

        Cons _ _ tree1 tree2 ->
            let
                codeTable1 =
                    dict
                        |> constructCodes tree1 (lastCode |> Code.append Zero)

                codeTable2 =
                    dict
                        |> constructCodes tree2 (lastCode |> Code.append One)
            in
            Dict.merge
                Dict.insert
                (\k a _ -> Dict.insert k a)
                Dict.insert
                codeTable1
                codeTable2
                Dict.empty


huffmanTree : FrequencyTable -> Maybe Tree
huffmanTree freqTable =
    if Freq.sizeOf freqTable < 2 then
        -- Can't Huffman-encode a stream with less than 2 symbols
        Nothing

    else
        freqTable
            -- Convert the frequency-table to a sorted list
            |> Freq.toList
            -- Convert all the symbols and weights into leaves
            |> List.map (\( sym, weight ) -> Leaf weight sym)
            -- Then construct a tree using the list of leaves
            |> constructTree
            |> Just


constructTree : List Tree -> Tree
constructTree queue =
    case queue of
        node1 :: node2 :: rest ->
            let
                newTree =
                    join node1 node2
            in
            constructTree (enqueue newTree rest)

        node :: [] ->
            node

        [] ->
            -- This case branch will never execute, per the nature of the queue
            Leaf 0 0


weightOf : Tree -> Weight
weightOf tree =
    case tree of
        Cons weight _ _ _ ->
            weight

        Leaf weight _ ->
            weight


join : Tree -> Tree -> Tree
join tree1 tree2 =
    case ( tree1, tree2 ) of
        ( Leaf weight1 symbol1, Leaf weight2 symbol2 ) ->
            Cons (weight1 + weight2) (Set.fromList [ symbol1, symbol2 ]) tree1 tree2

        ( Leaf weight1 symbol, Cons weight2 symbolSet _ _ ) ->
            Cons (weight1 + weight2) (Set.insert symbol symbolSet) tree1 tree2

        ( Cons weight1 symbolSet _ _, Leaf weight2 symbol ) ->
            -- When joining a cons-node and leaf-node, the leaf-node will always
            -- occupy the left branch (for simplicity's sake)
            Cons (weight1 + weight2) (Set.insert symbol symbolSet) tree2 tree1

        ( Cons weight1 symbolSet1 _ _, Cons weight2 symbolSet2 _ _ ) ->
            Cons (weight1 + weight2) (Set.union symbolSet1 symbolSet2) tree1 tree2


enqueue : Tree -> List Tree -> List Tree
enqueue tree trees =
    -- Using this queuing function, we can avoid having to do an entire sort
    case trees of
        [] ->
            [ tree ]

        nextTree :: rest ->
            if weightOf tree <= weightOf nextTree then
                tree :: nextTree :: rest

            else
                nextTree :: enqueue tree rest
