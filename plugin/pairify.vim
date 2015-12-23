if exists('g:loaded_pairify')
  finish
endif
let g:loaded_pairify = 1

let g:pairs = {
      \ "[": "]",
      \ "(": ")",
      \ "{": "}",
      \ "<": ">",
      \ "'": "'",
      \ '"': '"'
      \ }

function! s:Pairify(key)
  let pair = getline('.')[col('.')-2]
  return has_key(g:pairs, pair) ? g:pairs[pair]."\<Esc>i" : a:key
endfunction

for pair in values(g:pairs)
  exec "inoremap <silent> <expr> <script>" pair "<SID>Pairify(\"".escape(pair, "'\"")."\")"
endfor
