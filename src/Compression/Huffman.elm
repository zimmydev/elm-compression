module Compression.Huffman exposing (encode)

import Bytes exposing (Bytes)
import Compression.Huffman.Tree exposing (CodeTable)


encode : Bytes -> CodeTable -> Bytes
encode bytes codeTable =
    Debug.todo "Huffman encoding"
