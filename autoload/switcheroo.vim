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

function! s:GetVisualSelection() abort
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ""
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == "inclusive" ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! s:GetMatchingCharacter(char) abort
    " If the user has defined a character pair in g:switcheroo, return the
    " match.
    for l:pair in g:switcheroo
        if a:char == pair[0]
            return l:pair[1]
        elseif a:char == pair[1]
            return l:pair[0]
        endif
    endfor

    " If we get here, the user hasn't defined a character pair, so just switch
    " the case.
    if a:char ==# toupper(a:char)
        return tolower(a:char)
    elseif a:char ==# tolower(a:char)
        return toupper(a:char)
    endif
endfunction

function! switcheroo#SwitcherooOp(type = "") abort
    if a:type ==# ""
        set opfunc=switcheroo#SwitcherooOp
        return "g@"
    endif

    let visual_marks_save = [getpos("'<"), getpos("'>")]

    if a:type ==# "char"
        exe "norm! v`]o`["
    elseif a:type ==# "line"
        exe "norm! V']o'["
    endif

    call switcheroo#SwitcherooVisual()
    call setpos("'<", visual_marks_save[0])
    call setpos("'>", visual_marks_save[1])
endfunction

function! switcheroo#Switcheroo() abort
    let l:line = getline(".")
    let l:char = l:line[col(".") - 1]

    let l:matching_char = s:GetMatchingCharacter(l:char)
    exe "norm! r" . l:matching_char . "l"
endfunction

function! switcheroo#SwitcherooVisual() abort
    norm! ~
    for l:pair in g:switcheroo
        exe "silent! '<,'>s/\\%V\\V" . l:pair[0] . "/flub/ge |"
            \ . "silent! '<,'>s/\\%V\\V" . l:pair[1] . "/" . l:pair[0] . "/ge |"
            \ . "silent! '<,'>s/\\%V\\Vflub/" . l:pair[1] . "/ge"
    endfor
endfunction

