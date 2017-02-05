# TR-DOS disassembled Makefile

# Author: Marcos Cruz (programandala.net), 2016

# This file is part of
# TR-DOS disassembled
# http://programandala.net/

# Last modified 201610011544

################################################################
# Requirements

# z80dasm by Tomaž Šolc. It's included in Debian and other Linux
# distros, and can be obtained from its author's website:
# https://www.tablix.org/~avian/z80dasm/
# http://www.tablix.org/~avian/git/#z80dasm

# Vim by Bram Moolenaar
# http://vim.org

# Pasmo by Julián Albo
# http://pasmo.speccy.org

# diffutils by Paul Eggert, Mike Haertel, David Hayes, Richard
# Stallman, and Len Tower.
# http://www.gnu.org/software/diffutils/

################################################################
# History

# See at the end of the file.

################################################################
# Config

MAKEFLAGS = --no-print-directory

# .ONESHELL:

################################################################

.PHONY: all
all: trdos.z80s

.PHONY: clean
clean:
	rm -f trdos.raw.z80s trdos.z80s trdos.reassembled.rom

.PHONY: back
back: trdos.reassembled.rom

trdos.raw.z80s: trdos.symbols.input.z80s trdos.blocks.txt
	z80dasm \
	  --origin=0x0000 \
	  --address \
	  --labels \
	  --source \
	  --block-def=trdos.blocks.txt \
	  --sym-input=trdos.symbols.input.z80s \
	  --sym-output=trdos.symbols.output.z80s \
	  --output=$@ \
	  trdos.rom

trdos.z80s: trdos.raw.z80s tools/tidier.vim
	vim -e -R -n -S tools/tidier.vim $<

trdos.reassembled.rom: trdos.z80s
	pasmo $< $@
	diff -s trdos.rom $@

################################################################
# Change history

# 2016-08-14: Start.
#
# 2016-08-19: Add after-processing with Vim.
#
# 2016-08-20: Add assembling of the disassembled source, as a check.
#
# 2016-10-01: Add `diff` check to the reassembled ROM; formerly a manual check
# was done with VBinDiff.
