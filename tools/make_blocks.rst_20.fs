#! /usr/bin/env gforth

\ make_blocks.rst_20.fs

\ This file is part of TR-DOS disassembled
\ By Marcos Cruz (programandala.net), 2016

\ Description:
\
\ This program creates disassembly blocks of TR-DOS' `rst 20`, for the
\ z80dasm disassembler.

\ 2016-08-15: Written to complete the `rst 20` blocks.
\ 2016-08-20: Rename the file. Complete with all blocks.

: h.  ( n -- )  s>d hex <# # # # # #> decimal type  ;

: rst20  ( n -- )
  ." rst20_" dup h. ':' emit space
  ." unlabeled start 0x" 1+ dup h. space
  ." unlabeled last 0x" 1+ h. space
  ." type worddata" cr  ;

$0102 rst20
$014C rst20
$0163 rst20
$1056 rst20
$105D rst20
$1064 rst20
$1080 rst20
$1680 rst20
$19CE rst20
$19D1 rst20
$19EC rst20
$19FD rst20
$1A38 rst20
$1D6C rst20
$1D84 rst20
$1D8C rst20
$1D93 rst20
$1D97 rst20
$1D9B rst20
$1D9F rst20
$1DAE rst20
$1DB5 rst20
$1DB9 rst20
$1DBD rst20
$1DC1 rst20
$1E1F rst20
$1E26 rst20
$1E2A rst20
$1E2E rst20
$1E32 rst20
$2212 rst20
$249A rst20
$2621 rst20
$2665 rst20
$306B rst20
$306F rst20
$30F0 rst20
$3D94 rst20
$3D9D rst20
$3DA2 rst20

bye
