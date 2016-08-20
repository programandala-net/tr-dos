" tidier.vim

" This file is part of TR-DOS disassembled
" By Marcos Cruz (programandala.net), 2016

" Last modified 201608201121

" 2016-08-19: Start.
" 2016-08-20: Remove unused ROM routines.

function! ChangeHeader()
  :1,2delete
  call append(0,['; trdos.z80s','','; This file is part of TR-DOS disassembled','; By Marcos Cruz (programandala.net), 2016'])
endfunction

function! RemoveComments()
  silent! %substitute@\s\+;[a-f0-9]\{4} .\+$@@
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

function! Tidier()
  call AddRst20Labels()
  call RemoveComments()
  call ChangeHeader()
endfunction

call Tidier()
silent! write! trdos.z80s
quit!
