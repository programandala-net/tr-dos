" tidier.vim

" This file is part of TR-DOS disassembled
" By Marcos Cruz (programandala.net), 2016, 2017

" Last modified 201703102215

" ==============================================================
" History

" 2016-08-19: Start.
"
" 2016-08-20: Remove unused ROM routines. Add `include` for ROM
" routines.  Clear the messages.
"
" 2016-09-01: Label the token commands. Clear the key
" comparisons. Update the requirements.
"
" 2016-09-02: Remove wrong labels. Restore literals. Clear drive
" letters. Generalize the clearing of key comparisons to
" characters and complete it.
"
" 2016-09-15: Add `CompactUnusedZones()`.
"
" 2016-10-01: Clear comparisons of data file modes.
"
" 2017-02-03: Add new char to `ClearCharacters()` at $043F.
"
" 2017-02-04: Add `AddComments()`.
"
" 2017-02-05: Make `AddRst20Label()` keep the original comment
" of the line. This way the line can be found later to add a
" specific comment. Original comments are removed at the end
" anyway. Convert the hexadecimal notation of `rst`
" instructions.
"
" 2017-02-10: Remove the new label `zx_spectrum_font_char_0`
" from the result.  It must be referenced in code, but it
" belongs to the main ROM.
"
" 2017-02-12: Add more character substitutions.
"
" 2017-03-08: Add more character substitutions.
"
" 2017-03-09: Add more character substitutions.

" ==============================================================

function! Report(message)

  echomsg a:message

endfunction

function! ChangeHeader()
  call Report('Changing the header...')
  silent :1,2delete
  call append(0,['; trdos.z80s','','; This file is part of TR-DOS Disassembled','; By Marcos Cruz (programandala.net), 2016, 2017'])
endfunction

function! AddInclude()
  call Report('Adding include directives...')
  call cursor(1,1)
  call search('^  org ')
  call append('.',['','  include inc/zx_spectrum_rom_routines.z80s','  include inc/zx_spectrum_char_codes.z80s',''])
endfunction

function! RemoveComments()
  call Report('Removing default comments...')
  silent %substitute@\s\+;[0-9a-f]\{4} .\+$@@
endfunction

function! ClearControlChar(char)
  let l:hexByte=printf('%02x',a:char)
  execute 'silent %substitute@\(\s\+defb 0'.l:hexByte.'h\)\s\+;[0-9a-f]\{4}\s[0-9a-f]\{2}\s\+\.\s$@\1@e'
endfunction

function! ClearControlChars()
  call Report('  Clearing control chars...')
  let l:char = 0
  while l:char<32
    call ClearControlChar(l:char)
    let l:char += 1
  endwhile
endfunction

function! ClearPrintableChar(char)
  let l:hexByte=printf('%02x',a:char)
  execute 'silent %substitute@\(\s\+defb \)0'.l:hexByte.'h\s\+;[0-9a-f]\{4}\s[0-9a-f]\{2}\s\+\(.\)\s$@\1"\2"@e'
endfunction

function! ClearPrintableChars()
  call Report('  Clearing printable chars...')
  let l:char = 32
  while l:char<127
    call ClearPrintableChar(l:char)
    let l:char += 1
  endwhile
endfunction

function! ClearMessages()
  call Report('Clearing messages...')
  call ClearControlChars()
  call ClearPrintableChars()
endfunction

function! AddRst20Label(label,address)
  execute 'silent %substitute@rst 20h.\+\n  defw 0'.tolower(a:address).'h@rst 20h\r  defw '.a:label.'@e'
endfunction

function! AddRst20Labels()
  call Report('Adding labels to `rst 20h` calls...')
  call AddRst20Label('rom_0058','0058')
  call AddRst20Label('rom_add_char_keeping_current_mode','0F85')
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
  call AddRst20Label('rom_report_l','1B7B')
  call AddRst20Label('rom_set_min','16B0')
  call AddRst20Label('rom_set_work','16BF')
  call AddRst20Label('rom_stk_fetch','2BF1')
  call AddRst20Label('rom_str_data1','1727')
  call AddRst20Label('rom_test_room','1F05')
endfunction

function! LabelTokenCommands()
  call Report('Labelling token commands...')
  call search('defb\s0cfh\s\+;2ff3\s\+cf\s\+.\s$')
  silent substitute@defb\s0cfh\s\+;2ff3\s\+cf\s\+.\s$@defb token.cat@e
  normal j
  silent substitute@defb\s02ah\s\+;2ff4\s\+2a\s\+\*\s$@defb "*" ; set current drive@e
  normal j
  silent substitute@defb\s0d0h\s\+;2ff5\s\+d0\s\+.\s$@defb token.format@e
  normal j
  silent substitute@defb\s0d1h\s\+;2ff6\s\+d1\s\+.\s$@defb token.move@e
  normal j
  silent substitute@defb\s0e6h\s\+;2ff7\s\+e6\s\+.\s$@defb token.new@e
  normal j
  silent substitute@defb\s0d2h\s\+;2ff8\s\+d2\s\+.\s$@defb token.erase@e
  normal j
  silent substitute@defb\s0efh\s\+;2ff9\s\+ef\s\+.\s$@defb token.load@e
  normal j
  silent substitute@defb\s0f8h\s\+;2ffa\s\+f8\s\+.\s$@defb token.save@e
  normal j
  silent substitute@defb\s0feh\s\+;2ffb\s\+fe\s\+.\s$@defb token.return@e
  normal j
  silent substitute@defb\s0beh\s\+;2ffc\s\+be\s\+.\s$@defb token.peek@e
  normal j
  silent substitute@defb\s0f4h\s\+;2ffd\s\+f4\s\+.\s$@defb token.poke@e
  normal j
  silent substitute@defb\s0d5h\s\+;2ffe\s\+d5\s\+.\s$@defb token.merge@e
  normal j
  silent substitute@defb\s0f7h\s\+;2fff\s\+f7\s\+.\s$@defb token.run@e
  normal j
  silent substitute@defb\s0d3h\s\+;3000\s\+d3\s\+.\s$@defb token.open_channel@e
  normal j
  silent substitute@defb\s0d4h\s\+;3001\s\+d4\s\+.\s$@defb token.close_channel@e
  normal j
  silent substitute@defb\s0ffh\s\+;3002\s\+ff\s\+.\s$@defb token.copy@e
  normal j
  silent substitute@defb\s034h\s\+;3003\s\+34\s\+4\s$@defb "4" ; set 40 tracks@e
  normal j
  silent substitute@defb\s0ech\s\+;3004\s\+ec\s\+.\s$@defb token.go_to@e
  normal j
  silent substitute@defb\s038h\s\+;3005\s\+38\s\+8\s$@defb "8" ; set 80 tracks@e
  normal j
  silent substitute@defb\s0f0h\s\+;3006\s\+f0\s\+.\s$@defb token.list@e
  normal j
  silent substitute@defb\s0d6h\s\+;3007\s\+d6\s\+.\s$@defb token.verify@e
endfunction

function! ClearFileTypes()
  call Report('Clearing file types...')
  call cursor(1,1)
  call search(';05b7')
  silent substitute@023h.\+$@"#" ; data file type?@
  call search(';06fc')
  silent substitute@023h.\+$@"#" ; data file type?@
  call search(';102e')
  silent substitute@043h.\+$@"C" ; file type: code@
  call search(';103b')
  silent substitute@043h.\+$@"C" ; file type: code@
  call search(';1041')
  silent substitute@044h.\+$@"D" ; file type: array@
  call search(';1045')
  silent substitute@023h.\+$@"#" ; data file type?@
  call search(';1047')
  silent substitute@023h.\+$@"#" ; file type: data@
  call search(';104b')
  silent substitute@042h.\+$@"B" ; file type: BASIC@
  call search(';11da')
  silent substitute@023h.\+$@"#" ; stream speficied?@
  call search(';138e')
  silent substitute@023h.\+$@"#" ; data file type?@
  call search(';182e')
  silent substitute@042h.\+$@"B" ; BASIC file type?@
  call search(';18d3')
  silent substitute@043h.\+$@"C" ; code file type?@
  call search(';1901')
  silent substitute@043h.\+$@"C" ; code file type?@
  call search(';1906')
  silent substitute@042h.\+$@"B" ; BASIC file type?@
  call search(';190d')
  silent substitute@044h.\+$@"D" ; array file type?@
  call search(';19bf')
  silent substitute@042h.\+$@"B" ; BASIC file type?@
  call search(';1b1f')
  silent substitute@042h.\+$@"B" ; file type: BASIC@
  call search(';1b2c')
  silent substitute@044h.\+$@"D" ; file type: array@
  call search(';1b4b')
  silent substitute@043h.\+$@"C" ; file type: code@
  call search(';1bc2')
  silent substitute@042h.\+$@"B" ; BASIC file type?@
  call search(';1d5c')
  silent substitute@042h.\+$@"B" ; BASIC file type?@
  call search(';219a')
  silent substitute@0a5h.\+$@token.rnd ; random access data file type?@
  call search(';21a5')
  silent substitute@052h.\+$@"R" ; sequential access data file type read mode?@
  call search(';21a9')
  silent substitute@057h.\+$@"W" ; sequential access data file type write mode?@
  call search(';21b4')
  silent substitute@023h.\+$@"#" ; data file type?@
  call search(';21ed')
  silent substitute@052h.\+$@"R" ; sequential access data file type read mode?@
  call search(';2209')
  silent substitute@052h.\+$@"R" ; sequential access data file type read mode?@
  call search(';225a')
  silent substitute@0a5h.\+$@token.rnd ; random access data file type?@
  call search(';2264')
  silent substitute@052h.\+$@"R" ; sequential access data file type read mode?@
  call search(';22d8')
  silent substitute@044h.\+$@"D" ; file type: array -- XXX TODO -- confirm@
  call search(';22f2')
  silent substitute@052h.\+$@"R" ; sequential access data file type read mode?@
endfunction

function! AddComments()
  call Report('Adding comments...')
  call cursor(1,1)
  call search(';0164')
  silent substitute@\s\+;0164.\+$@ ; Error report: "OK"@
  call search(';130b')
  silent substitute@\s\+;130b.\+$@ ; Length of a file descriptor@
  call search(';130e')
  silent substitute@\s\+;130e.\+$@ ; Point to the next entry@
  call search(';1d20')
  silent substitute@\s\+;1d20.\+$@ ; Error report code: "Nonsense in BASIC"@
  call search(';221b')
  silent substitute@\s\+;221b.\+$@ ; Error report code: "Parameter error" (should be 0x17, invalid stream)@
  call search(';2492')
  silent substitute@\s\+;2492.\+$@ ; Error report code: "End of file"@
  call search(';272b')
  silent substitute@\s\+;272b.\+$@ ; Error report code: "Tape loading error"@
  call search(';272f')
  silent substitute@\s\+;272f.\+$@ ; Error report code: "Invalid I/O device"@
  call search(';2735')
  silent substitute@\s\+;2735.\+$@ ; Error report code: "Out of memory"@
  call search(';2760')
  silent substitute@\s\+;2760.\+$@ ; Error code: "Disk errors"@
  call search(';3da3')
  silent substitute@\s\+;3da3.\+$@ ; Error report: "BREAK into program"@
  call search(';3e19')
  silent substitute@\s\+;3e19.\+$@ ; initial step rate@
  call search(';3e1b')
  silent substitute@\s\+;3e1b.\+$@ ; number of tries@
  call search(';3e3f')
  silent substitute@\s\+;3e3f.\+$@ ; try the next step rate@
  call search(';3e40')
  silent substitute@\s\+;3e40.\+$@ ; more tries?@
  call search(';3fac')
  silent substitute@\s\+;3fac.\+$@ ; increase the step rate@
endfunction

function! ClearCharacters()
  call Report('Clearing characters...')
  call cursor(1,1)
  call search(';01c8')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';0215')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';0430')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';043f')
  silent substitute@023h.\+$@'#' ; channel?@
  call search(';044c')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';04c8')
  silent substitute@03ah.\+$@":"@
  call search(';058d')
  silent substitute@03ah.\+$@":"@
  call search(';05a1')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';0697')
  silent substitute@053h.\+@"S" ; `COPY s`?@
  call search(';069c')
  silent substitute@042h.\+@"B" ; `COPY b`?@
  call search(';1039')
  silent substitute@0afh.\+$@token.code ; `CODE`?@
  call search(';103f')
  silent substitute@0e4h.\+$@token.data ; `DATA`?@
  call search(';1168')
  silent substitute@030h.\+$@"0"@
  call search(';1179')
  silent substitute@030h.\+$@"0"@
  call search(';118a')
  silent substitute@030h.\+$@"0"@
  call search(';119b')
  silent substitute@030h.\+$@"0"@
  call search(';11a2')
  silent substitute@030h.\+$@"0"@
  call search(';11e7')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';12d4')
  silent substitute@020h.\+$@" "@
  call search(';12ef')
  silent substitute@020h.\+$@" "@
  call search(';1304')
  silent substitute@042h.\+$@"B" ; BASIC program?@
  call search(';1356')
  silent substitute@020h.\+$@" "@
  call search(';1378')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';13a8')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';1468')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';14a8')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';1541')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';15d4')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';1620')
  silent substitute@059h.\+$@"Y" ; Yes?@
  call search(';1847')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';188c')
  silent substitute@0afh.\+$@token.code ; `CODE`?@
  call search(';1891')
  silent substitute@0e4h.\+$@token.data ; `DATA`?@
  call search(';1adf')
  silent substitute@0afh.\+$@token.code ; `CODE`?@
  call search(';1ae3')
  silent substitute@0cah.\+$@token.line ; `LINE`?@
  call search(';1af8')
  silent substitute@0aah.\+$@token.screen_dollar ; `SCREEN$`?@
  call search(';1b16')
  silent substitute@0e4h.\+$@token.data ; `DATA`?@
  call search(';1b1a')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';1c83')
  silent substitute@03ah.\+$@":"@
  call search(';1de8')
  silent substitute@0afh.\+$@token.code ; `CODE`?@
  call search(';1dfe')
  silent substitute@02ch.\+$@","@
  call search(';1e02')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';215e')
  silent substitute@02ch.\+$@","@
  call search(';2191')
  silent substitute@041h.\+@"A"@
  call search(';261d')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';2940')
  silent substitute@03ch.\+$@"<"@
  call search(';2945')
  silent substitute@03eh.\+$@">"@
  call search(';308b')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';3093')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';3096')
  silent substitute@022h.\+$@'"'@
  call search(';309c')
  silent substitute@00dh.\+$@char.carriage_return@
  call search(';309f')
  silent substitute@022h.\+$@'"'@
  call search(';3f7e')
  silent substitute@049h.\+$@"I" ; Ignore?@
  call search(';3f81')
  silent substitute@052h.\+$@"R" ; Retry?@
  call search(';3f85')
  silent substitute@041h.\+$@"A" ; Abort?@

endfunction

function! ConvertHexNumbersNotation()

  " Convert hex numbers from notation '0d..dh' to '0xD..D'.
  " This change must be done at the end, when all other
  " substitutions have been done.

  call Report('Converting notation of hex numbers...')
  silent %substitute@\<0\([0-9a-f]\{2}\)h\>@0x\U\1@g
  silent %substitute@\<0\([0-9a-f]\{4}\)h\>@0x\U\1@g
  silent %substitute@^  rst \([0-9a-f]\{2}\)h\>@  rst 0x\U\1@

endfunction

function! RestoreLiteral(label,literal)

  " Restore a literal the disassembler interpreted as an address
  " loaded into a register, and converted to a label.

  execute 'silent %substitute@ld \(\a\a\),'.a:label.'@ld \1,'.a:literal.'@'

endfunction

function! RestoreLiterals()

  " Restore the literals the disassembler interpreted as
  " addresses loaded into a register, and converted to labels.

  call Report('Restoring literals...')
  call RestoreLiteral('l0009h','0x0009')
  call RestoreLiteral('rst_10','0x10')
  call RestoreLiteral('rst_20','0x20')
  call RestoreLiteral('l0013h','0x0013')
  call RestoreLiteral('l0024h','0x0024')
"  call RestoreLiteral('sub_03e8h','1000') " XXX OLD?
  call RestoreLiteral('l1e40h','0x1E40')

endfunction

function! RemoveWrongLabel(address)

  " Remove a wrong label, which has been created by the
  " disassembler, but actually is a literal.

  execute 'silent %substitute@^l'.a:address.'h:\n@@e'
  execute 'silent %substitute@,l'.a:address.'h@'.',0x\U'.a:address.'@e'

endfunction

function! RemoveWrongLabels()

  " Remove wrong labels, which have been created by the
  " disassembler, but actually are literals.

  call Report('Removing wrong labels...')
  call RemoveWrongLabel('0000')
  call RemoveWrongLabel('0001')
  call RemoveWrongLabel('0004')
  call RemoveWrongLabel('0008')
  call RemoveWrongLabel('000b')
  call RemoveWrongLabel('000d')
  call RemoveWrongLabel('000f')
  call RemoveWrongLabel('0015')
  call RemoveWrongLabel('001e')
  call RemoveWrongLabel('0064')
  call RemoveWrongLabel('00a8')
  call RemoveWrongLabel('0100')
  call RemoveWrongLabel('0124')
  call RemoveWrongLabel('0200')
  call RemoveWrongLabel('0270')
  call RemoveWrongLabel('0280')
  call RemoveWrongLabel('0523')
  call RemoveWrongLabel('09f0')
  call RemoveWrongLabel('0a00')
  call RemoveWrongLabel('2000')
  call RemoveWrongLabel('2710')
  call RemoveWrongLabel('3c00')

endfunction

function! FixMiscThings()

  " Remove a label that belongs to the main ROM:
  :%s@^zx_spectrum_font_char_0:\n@@e

  " Convert back to code three bytes that the disassembler
  " interprets as data (it seems a bug related to the
  " calculation of block zones):

  :%s@^; BLOCK 'code_31FA_XXX_FIXME' (start 0x31fa end 0x31fd)\n@@e
  :%s@^code_31FA_XXX_FIXME_start:\n@@e
"  :%s@^\s\+defb 0xed,0x42,0xc9.\+;31fa.\+\n@  sbc hl,bc\r  ret\r@e
"  :%s@^\s\+defb 0xED,0x42,0xC9\n@  sbc hl,bc\r  ret\r@e
	:%s@^\s\+defb\s\+0edh,042h,0c9h.\+;31fa.\+\n@  sbc hl,bc\r  ret\r@e

  " XXX TMP -- The three lines above are searched apart, just in
  " case the block definition that tries to fix the problem is
  " removed. Also, the data is searched for in two formats, to
  " make it possible to change the position of this function in
  " the flow of the program.

endfunction


function! ClearDriveLetter(address)

  " Clear a reference to drive 'A' at the given address.

  call search(';'.a:address)
  execute 'silent substitute@041h@"A" ; first drive letter@'

endfunction

function! ClearDriveLetters()

  " Clear all references to drive 'A'.
  "
  " Note: calls to `ClearDriveLetter()` must be in address
  " order.

  call Report('Clearing drive letters...')
  call cursor(1,1)
  call ClearDriveLetter('04bf')
  call ClearDriveLetter('0526')
  call ClearDriveLetter('0588')
  call ClearDriveLetter('1252')
  call ClearDriveLetter('214a')
  
endfunction

function! CompactUnusedZones()

  " Compact the unused zones.
  " XXX TODO -- finish

  call cursor(1,1)
  call search('^not_used_31FD_start:$')
  normal j
  silent substitute@\_.\+\(^l[0-9a-f]\{4}h:$\)@  defs 2813,$0xFF\r\r@

endfunction

function! Tidier()

  call AddRst20Labels()
  call LabelTokenCommands()
  call ClearFileTypes()
  call ClearMessages()
  call ClearCharacters()
  call ClearDriveLetters()
  call RemoveWrongLabels()
  call RestoreLiterals()
  " call CompactUnusedZones()
  call FixMiscThings()
  call AddComments()
  call ConvertHexNumbersNotation()
  call RemoveComments()
  call ChangeHeader()
  call AddInclude()

endfunction

call Tidier()
silent! write! trdos.z80s
quit!
