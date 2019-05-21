module Compression.Huffman exposing (codeTable, encode)

import Bytes exposing (Bytes)
import Compression.FrequencyTable as FrequencyTable
import Compression.Huffman.CodeTable as CodeTable exposing (CodeTable)
import Compression.Huffman.Tree as Tree


encode : Bytes -> CodeTable -> Bytes
encode bytes codes =
    Debug.todo "Huffman encoding"



--- HELPER FUNCTIONS ---


codeTable : Bytes -> Maybe CodeTable
codeTable bytes =
    bytes
        |> FrequencyTable.generate
        |> Maybe.map Tree.generate
        |> Maybe.map CodeTable.generate
