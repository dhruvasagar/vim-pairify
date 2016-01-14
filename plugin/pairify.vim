if exists('g:loaded_pairify')
  finish
endif
let g:loaded_pairify = 1

let g:pairs = {
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

function! s:Pairify(key)
  let leftOfCursor = getline('.')[col('.')-2]
  let pairMatch = get(g:pairs.left, a:key, get(g:pairs.right, a:key, ""))

  if empty(pairMatch)
    return a:key
  else
    return leftOfCursor ==# pairMatch ? a:key . "\<Esc>i" : a:key
  endif
endfunction

function! s:isEndOfPair()
  let rightOfCursor = getline('.')[col('.')]
  return index(keys(g:pairs.right), rightOfCursor) >= 0
endfunction

function! s:Pairified()
  let rightOfCursor = getline('.')[col('.')]
  if s:isEndOfPair()
    exe 'normal! f' . rightOfCursor
  endif
endfunction

for pair in values(g:pairs.left)
  exec "inoremap <silent> <expr> <script>" pair "<SID>Pairify(\"".escape(pair, "'\"")."\")"
endfor

augroup Pairify
  au!

  autocmd InsertLeave * call s:Pairified()
augroup END
