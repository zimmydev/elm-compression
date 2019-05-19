module Huffman.Tree exposing (Tree)

import Huffman.FrequencyTable as Freq exposing (FrequencyTable)
import Huffman.Types exposing (..)


type Tree
    = Branch Count Tree Tree
    | Leaf Count Symbol
