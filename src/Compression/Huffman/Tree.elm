module Compression.Huffman.Tree exposing (Tree(..), generate, weightOf)

import Compression exposing (Symbol, Weight)
import Compression.FrequencyTable as FrequencyTable exposing (FrequencyTable)



--- TYPES ---


type Tree
    = Branch Weight Tree Tree
    | Leaf Weight Symbol



--- OBTAINING A TREE ---


generate : FrequencyTable -> Tree
generate freqs =
    freqs
        |> FrequencyTable.toList
        -- Convert all the symbols and weights into leaves
        |> List.map (\( sym, weight ) -> Leaf weight sym)
        |> buildTree



--- ACCESSING PROPERTIES OF A TREE ---


weightOf : Tree -> Weight
weightOf tree =
    case tree of
        Branch weight _ _ ->
            weight

        Leaf weight _ ->
            weight



--- HELPER FUNCTIONS ---


buildTree : List Tree -> Tree
buildTree queue =
    case queue of
        node1 :: node2 :: rest ->
            let
                newTree =
                    join node1 node2
            in
            buildTree (enqueue newTree rest)

        node :: [] ->
            node

        [] ->
            -- This case branch will never execute, per the nature of the queue
            Leaf 0 0


join : Tree -> Tree -> Tree
join tree1 tree2 =
    Branch (weightOf tree1 + weightOf tree2) tree1 tree2


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
