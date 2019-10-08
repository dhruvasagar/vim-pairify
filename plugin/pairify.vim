if exists('g:loaded_pairify')
  finish
endif
let g:loaded_pairify = 1

let g:pairifiers = {
      \ "left": {
      \   "[": "]",
      \   "(": ")",
      \   "{": "}",
      \   "<": ">",
      \   "'": "'",
      \   '"': '"'
      \ },
      \ "right": {
      \   "]": "[",
      \   ")": "(",
      \   "}": "{",
      \   ">": "<",
      \   "'": "'",
      \   '"': '"'
      \ }
      \}

if !exists('g:pairify_map')
  let g:pairify_map = "<C-J>"
endif

function! s:is_already_matched(char)
  return index(keys(g:pairifiers.right), a:char) >= 0
endfunction

function! s:pairify()
  let line = getline('.')
  let cchar = line[col('.')-1]
  if s:is_already_matched(cchar) | return "\<C-O>a" | endif

  let pair_match = pairify#find_pair(line[0:col('.')-1])
  if empty(pair_match)
    return len(g:pairify_map) == 1 ? g:pairify_map : ''
  else
    return pair_match
  endif
endfunction

inoremap <expr> <silent> <Plug>(pairify-complete) <SID>pairify()

if !hasmapto('<Plug>(pairify-complete)')
  exec 'imap' g:pairify_map '<Plug>(pairify-complete)'
endif
