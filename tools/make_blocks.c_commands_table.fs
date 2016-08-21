#! /usr/bin/env gforth

\ make_blocks.c_commands_table.fs

\ This file is part of TR-DOS disassembled
\ By Marcos Cruz (programandala.net), 2016

\ Description:
\
\ This program creates disassembly blocks of TR-DOS' `rst 20`, for the
\ z80dasm disassembler.

\ 2016-08-20: Start.

: 2h.  ( n -- )  s>d hex <# # # #> decimal type  ;
: 4h.  ( n -- )  s>d hex <# # # # # #> decimal type  ;

$288C constant commands
   25 constant commands#
    3 constant /command

: >index    ( n -- a )  /command * commands +  ;

: >pointer  ( n -- a )  >index 1+ ;

: make-index-block  ( n -- )
  dup >index
  ." c_commands_table_" swap 2h. ." _index: "
  ." unlabeled start 0x" dup 4h. space
  ." unlabeled last 0x" 4h. space ." type bytedata" cr  ;

: make-pointer-block  ( n -- )
  dup >pointer
  ." c_commands_table_" swap 2h. ." _pointer: "
  ." unlabeled start 0x" dup 4h. space
  ." unlabeled last 0x" 1+ 4h. space ." type pointers" cr  ;

: make-block  ( n -- )
  dup make-index-block make-pointer-block  ;

: make-blocks  ( -- )
  commands# 0 do  i make-block  loop
  commands# make-index-block  ;

make-blocks bye

