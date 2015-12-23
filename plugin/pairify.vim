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

for pair in values(g:pairs.left)
  exec "inoremap <silent> <expr> <script>" pair "<SID>Pairify(\"".escape(pair, "'\"")."\")"
endfor
