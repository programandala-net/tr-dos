#! /usr/bin/env gforth

\ rst20.fs

\ This file is part of TR-DOS disassembled
\ By Marcos Cruz (programandala.net), 2016

\ Description:
\
\ This program creates disassembly blocks of TR-DOS' `rst 20`, for the
\ z80dasm disassembler.

\ 2016-08-15: Written to complete the `rst 20` blocks.

: h.  ( n -- )  s>d hex <# # # # # #> decimal type  ;

: rst20  ( n -- )
  ." rst20_" dup h. ':' emit space
  ." unlabeled start 0x" 1+ dup h. space
  ." unlabeled last 0x" 1+ h. space
  ." type worddata" cr  ;

$1e1f rst20
$1e26 rst20
$1e2a rst20
$1e2e rst20
$1e32 rst20
$2212 rst20
$249a rst20
$2621 rst20
$2665 rst20
$306b rst20
$306f rst20
$30f0 rst20
$3d94 rst20
$3d9d rst20
$3da2 rst20

bye
