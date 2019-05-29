# elm-compression [![Build Status](https://travis-ci.com/zimmydev/elm-compression.svg?branch=master)](https://travis-ci.com/zimmydev/elm-compression)

*NOTE: This library is under development. It is mostly unusable in its current form.*

An aspiring general-purpose compression library written for Elm.

This package will not include every compression method; rather, it will include implementations of common coding and compression schemes. These should be designed like building blocks, so that composing them into more complex schemes should be easy and relatively straight-forward (that's the hope, at least).

Any gaps in the library should be made as easy as possible to fill using the library itself, in most cases. A high-level API (e.g. compressing `Bytes` to a `gzip` file) should be available, but so should a low-level API which allows access to the transform and coding layers. This should allow you to create new or unincluded compression schemes in (usually) just a few lines of code.

## Roadmap for this library

*NOTE: This is more a checklist for myself than anything else.*

### Planned

* Elaborate this README
* Huffman Coding
  * ~~Infrastructure~~
  * Encoding
  * Decoding
* Arithmetic Coding
  * Infrastructure
  * Encoding
  * Decoding
* ANS Coding
  * Infrastructure
  * Compression
  * Decompression
* RLE Compression
  * Infrastructure
  * Compression
  * Decompression
* LZ77 Compression
  * Infrastructure
  * Compression
  * Decompression
* LZ78 Compression
  * Infrastructure
  * Compression
  * Decompression
* DEFLATE
  * Compression
  * Decompression
* gzip
* more…

### Maybe?

* Adaptive versions of some coders
* FSE Coding

## Big ideas & notes

* `Bits` should probably be broken off into its own library.
  * A variable-bit datatype and bitwise parsing can be useful beyond the scope of data compression, such as base64, which is an encoding which does not aim to compress data.
* `Bits.Reader` needs to be sacrificed to `/dev/null` and `Bits.Parser` should replace it. It should behave much like the `elm/parser` library, for each function that makes sense in the context of bitstreams.
* Take advantage of the guaranteed 32-bit `Int` for storing in the array. (implementation detail)
* Prefer naming explicitness with `type Bit = One | Zero` over an alias for `Bool`.
* `Bits.append` should become `Bits.push` and `Bits.append` should become a new function which has the type signature `Bits -> Bits -> Bits`. (also an implementation detail)
  * Use some shifting and masking wizardry to speed up writes to the array.
  * Borrows naming conventions from the `Array` library, for consistence.
* Accessing **n** sequential bits could be faster. Currently it is done one-at-a-time with `Array.get` for each bit. Maybe this is okay. With some tedious math I would be able to calculate a slice of the array (`Array.slice`) and do some masking and shifting on it to get another valid array that I can pass to the `Bits` constructor, which can just be passed back to the user of the library.
  * Make an explicit top-level function that will convert any `Bits` to their `List Bit` for convenience. Otherwise, there should be no need to deal with `List` across the library.