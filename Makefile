# TR-DOS disassembled Makefile

# Author: Marcos Cruz (programandala.net), 2016

# This file is part of
# TR-DOS disassembled
# http://programandala.net/

# Copying and distribution of this file, with or without modification, are
# permitted in any medium without royalty provided the copyright notice and
# this notice are preserved.  This file is offered as-is, without any warranty.

################################################################
# Requirements

# z80dasm by Tomaž Šolc. It's included in Debian and other Linux
# distros, and can be obtained from its author's website:
# https://www.tablix.org/~avian/z80dasm/
# http://www.tablix.org/~avian/git/#z80dasm

################################################################
# Change history

# See at the end of the file.

################################################################
# Config

MAKEFLAGS = --no-print-directory

# .ONESHELL:

################################################################

.PHONY: all
all: trdos.z80s

.PHONY : clean
clean:
	rm -f trdos.z80s

trdos.z80s: trdos.symbols.input.z80s trdos.blocks.txt
	z80dasm \
	  --origin=0x0000 \
	  --address \
	  --labels \
	  --source \
	  --block-def=trdos.blocks.txt \
	  --sym-input=trdos.symbols.input.z80s \
	  --sym-output=trdos.symbols.output.z80s \
	  --output=trdos.z80s \
	  trdos.rom

################################################################
# Change history

# 2016-08-14 Start.
