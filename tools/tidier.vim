" tidier.vim

" This file is part of TR-DOS disassembled
" By Marcos Cruz (programandala.net), 2016

" Last modified 201609012212

" ==============================================================
" History

" 2016-08-19: Start.
"
" 2016-08-20: Remove unused ROM routines. Add `include` for ROM routines.
" Clear the messages.
"
" 2016-09-01: Label the token commands. Clear the key
" comparisons. Update the requirements.

" ==============================================================
" To-do

" Restore literals. Examples:
"	 ld de,rst_10
"  ld hl,l3c00h
"  ld de,l15afh
"  ld bc,l0015h
"
" Convert this literal to character:
"  sbc a,041h
"  sbc a,"A"

" ==============================================================

function! ChangeHeader()
  :1,2delete
  call append(0,['; trdos.z80s','','; This file is part of TR-DOS disassembled','; By Marcos Cruz (programandala.net), 2016'])
endfunction

function! AddInclude()
  call cursor(1,1)
  call search('^  org ')
  call append('.',['','  include inc/zx_spectrum_rom_routines.z80s','  include inc/zx_spectrum_char_codes.z80s',''])
endfunction

function! RemoveComments()
  silent! %substitute@\s\+;[0-9a-f]\{4} .\+$@@
endfunction

function! ClearControlChar(char)
  let l:hexByte=printf('%02x',a:char)
  execute 'silent! %substitute@\(\s\+defb 0'.l:hexByte.'h\)\s\+;[0-9a-f]\{4}\s[0-9a-f]\{2}\s\+\.\s$@\1@e'
endfunction

function! ClearControlChars()
  let l:char = 0
  while l:char<32
    call ClearControlChar(l:char)
    let l:char += 1
  endwhile
endfunction

function! ClearPrintableChar(char)
  let l:hexByte=printf('%02x',a:char)
  execute 'silent! %substitute@\(\s\+defb \)0'.l:hexByte.'h\s\+;[0-9a-f]\{4}\s[0-9a-f]\{2}\s\+\(.\)\s$@\1"\2"@e'
endfunction

function! ClearPrintableChars()
  let l:char = 32
  while l:char<127
    call ClearPrintableChar(l:char)
    let l:char += 1
  endwhile
endfunction

function! ClearMessages()
  call ClearControlChars()
  call ClearPrintableChars()
endfunction

function! AddRst20Label(label,address)
  execute 'silent! %substitute@rst 20h.\+\n  defw 0'.tolower(a:address).'h.\+$@rst 20h\r  defw '.a:label.'@e'
endfunction

function! AddRst20Labels()
  call AddRst20Label('rom_0058','0058')
  call AddRst20Label('rom_add_char_0F85','0F85')
  call AddRst20Label('rom_bc_spaces','0030')
  call AddRst20Label('rom_break_key','1F54')
  call AddRst20Label('rom_chan_open','1601')
  call AddRst20Label('rom_clear_prb','0EDF')
  call AddRst20Label('rom_cls','0D6B')
  call AddRst20Label('rom_cls_lower','0D6E')
  call AddRst20Label('rom_differ','19DD')
  call AddRst20Label('rom_editor','0F2C')
  call AddRst20Label('rom_expt_1num','1C82')
  call AddRst20Label('rom_expt_exp','1C8C')
  call AddRst20Label('rom_find_int2','1E99')
  call AddRst20Label('rom_free_mem','1F1A')
  call AddRst20Label('rom_get_char','0018')
  call AddRst20Label('rom_k_decode','0333')
  call AddRst20Label('rom_k_test','031E')
  call AddRst20Label('rom_key_scan','028E')
  call AddRst20Label('rom_line_addr','196E')
  call AddRst20Label('rom_look_vars','28B2')
  call AddRst20Label('rom_make_room','1655')
  call AddRst20Label('rom_me_new_lp','08D2')
  call AddRst20Label('rom_next_char','0020')
  call AddRst20Label('rom_out_num_1','1A1B')
  call AddRst20Label('rom_print_a','0010')
  call AddRst20Label('rom_reclaim_1','19E5')
  call AddRst20Label('rom_reclaim_2','19E8')
  call AddRst20Label('rom_remove_fp','11A7')
  call AddRst20Label('rom_report_0','1BB0')
  call AddRst20Label('rom_report_1','1DD8')
  call AddRst20Label('rom_report_l','1B7B')
  call AddRst20Label('rom_set_min','16B0')
  call AddRst20Label('rom_set_work','16BF')
  call AddRst20Label('rom_stk_fetch','2BF1')
  call AddRst20Label('rom_str_data1','1727')
  call AddRst20Label('rom_test_room','1F05')
endfunction

function! LabelTokenCommands()
  call search('defb\s0cfh\s\+;2ff3\s\+cf\s\+.\s$')
  silent! substitute@defb\s0cfh\s\+;2ff3\s\+cf\s\+.\s$@defb token.cat@e
  normal j
  silent! substitute@defb\s02ah\s\+;2ff4\s\+2a\s\+\*\s$@defb "*" ; set current drive@e
  normal j
  silent! substitute@defb\s0d0h\s\+;2ff5\s\+d0\s\+.\s$@defb token.format@e
  normal j
  silent! substitute@defb\s0d1h\s\+;2ff6\s\+d1\s\+.\s$@defb token.move@e
  normal j
  silent! substitute@defb\s0e6h\s\+;2ff7\s\+e6\s\+.\s$@defb token.new@e
  normal j
  silent! substitute@defb\s0d2h\s\+;2ff8\s\+d2\s\+.\s$@defb token.erase@e
  normal j
  silent! substitute@defb\s0efh\s\+;2ff9\s\+ef\s\+.\s$@defb token.load@e
  normal j
  silent! substitute@defb\s0f8h\s\+;2ffa\s\+f8\s\+.\s$@defb token.save@e
  normal j
  silent! substitute@defb\s0feh\s\+;2ffb\s\+fe\s\+.\s$@defb token.return@e
  normal j
  silent! substitute@defb\s0beh\s\+;2ffc\s\+be\s\+.\s$@defb token.peek@e
  normal j
  silent! substitute@defb\s0f4h\s\+;2ffd\s\+f4\s\+.\s$@defb token.poke@e
  normal j
  silent! substitute@defb\s0d5h\s\+;2ffe\s\+d5\s\+.\s$@defb token.merge@e
  normal j
  silent! substitute@defb\s0f7h\s\+;2fff\s\+f7\s\+.\s$@defb token.run@e
  normal j
  silent! substitute@defb\s0d3h\s\+;3000\s\+d3\s\+.\s$@defb token.open_channel@e
  normal j
  silent! substitute@defb\s0d4h\s\+;3001\s\+d4\s\+.\s$@defb token.close_channel@e
  normal j
  silent! substitute@defb\s0ffh\s\+;3002\s\+ff\s\+.\s$@defb token.copy@e
  normal j
  silent! substitute@defb\s034h\s\+;3003\s\+34\s\+4\s$@defb "4" ; set 40 tracks@e
  normal j
  silent! substitute@defb\s0ech\s\+;3004\s\+ec\s\+.\s$@defb token.go_to@e
  normal j
  silent! substitute@defb\s038h\s\+;3005\s\+38\s\+8\s$@defb "8" ; set 80 tracks@e
  normal j
  silent! substitute@defb\s0f0h\s\+;3006\s\+f0\s\+.\s$@defb token.list@e
  normal j
  silent! substitute@defb\s0d6h\s\+;3007\s\+d6\s\+.\s$@defb token.verify@e
endfunction

function! ClearFileTypes()
  call cursor(1,1)
  call search(';05b7')
  silent! substitute@cp\s023h.\+$@cp "#" ; data file type?@
  call search(';06fc')
  silent! substitute@cp\s023h.\+$@cp "#" ; data file type?@
  call search(';102e')
  silent! substitute@ld\sb,043h.\+$@ld b,"C" ; file type: code@
  call search(';103b')
  silent! substitute@ld\sb,043h.\+$@ld b,"C" ; file type: code@
  call search(';1041')
  silent! substitute@ld\sb,044h.\+$@ld b,"D" ; file type: array@
  call search(';1045')
  silent! substitute@cp\s023h.\+$@cp "#" ; data file type?@
  call search(';1047')
  silent! substitute@ld\sb,023h.\+$@ld b,"#" ; file type: data@
  call search(';104b')
  silent! substitute@ld\sb,042h.\+$@ld b,"B" ; file type: BASIC@
  call search(';138e')
  silent! substitute@cp\s023h.\+$@cp "#" ; data file type?@
  call search(';182e')
  silent! substitute@cp\s042h.\+$@cp "B" ; BASIC file type?@
  call search(';18d3')
  silent! substitute@cp\s043h.\+$@cp "C" ; code file type?@
  call search(';1901')
  silent! substitute@cp\s043h.\+$@cp "C" ; code file type?@
  call search(';1906')
  silent! substitute@cp\s042h.\+$@cp "B" ; BASIC file type?@
  call search(';190d')
  silent! substitute@cp\s044h.\+$@cp "D" ; array file type?@
  call search(';19bf')
  silent! substitute@cp\s042h.\+$@cp "B" ; BASIC file type?@
  call search(';1b4b')
  silent! substitute@ld\sa,043h.\+$@ld a,"C" ; file type: code@
  call search(';1bc2')
  silent! substitute@cp\s042h.\+$@cp "B" ; BASIC file type?@
  call search(';1d5c')
  silent! substitute@cp\s042h.\+$@cp "B" ; BASIC file type?@
endfunction

function! ClearKeyComparisons()
  call cursor(1,1)
  call search(';05a1')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';1378')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';13a8')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';1468')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';14a8')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';1541')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';15d4')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';1620')
  silent! substitute@cp\s059h.\+$@cp "Y"@
  call search(';3f7e')
  silent! substitute@cp\s049h.\+$@cp "I"@
  call search(';3f81')
  silent! substitute@cp\s052h.\+$@cp "R"@
  call search(';3f85')
  silent! substitute@cp\s041h.\+$@cp "A"@
endfunction

function! Tidier()
  call AddRst20Labels()
  call LabelTokenCommands()
  call ClearFileTypes()
  call ClearMessages()
  call ClearKeyComparisons()
  call RemoveComments()
  call ChangeHeader()
  call AddInclude()
endfunction

call Tidier()
silent! write! trdos.z80s
quit!
