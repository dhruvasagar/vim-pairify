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

function! s:is_already_matched(char)
  return index(keys(g:pairifiers.right), a:char) >= 0
endfunction

function! s:pairify()
  let line = getline('.')
  let cchar = line[col('.')-1]
  let pair_match = pairify#find_pair(line[0:col('.')-1])
  if empty(pair_match) && s:is_already_matched(cchar)
    return "\<C-O>a"
  else
    return pair_match
  endif
endfunction

inoremap <expr> <silent> <Plug>(pairify-complete) <SID>pairify()
imap <C-J> <Plug>(pairify-complete)
