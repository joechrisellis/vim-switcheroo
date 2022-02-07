" vim-switcheroo - customize the behaviour of ~.
"
" Maintainer:   Joe Ellis <joechrisellis@gmail.com>
" Version:      0.1.0
" License:      Same terms as Vim itself (see |license|)
" Location:     plugin/switcheroo.vim
" Website:      https://github.com/joechrisellis/vim-switcheroo
"
" Use this command to get help on vim-switcheroo:
"
"     :help switcheroo

if exists("g:loaded_switcheroo")
    finish
endif
let g:loaded_switcheroo = 1

let g:switcheroo = []

nnoremap <silent> ~ <cmd>call switcheroo#Switcheroo()<cr>
xnoremap <silent> ~ <cmd>call switcheroo#SwitcherooVisual()<cr>

nnoremap <expr> <Plug>(switcheroo) switcheroo#SwitcherooOp()
nmap g~ <Plug>(switcheroo)
