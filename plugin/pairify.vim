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


function! s:pairify()
  return pairify#find_pair(getline('.')[0:col('.')-1])
endfunction

inoremap <expr> <silent> <Plug>(pairify-complete) <SID>pairify()
imap <C-J> <Plug>(pairify-complete)
