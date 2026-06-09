if exists('g:loaded_pairify')
  finish
endif
let g:loaded_pairify = 1

if !exists('g:pairifiers')
  let g:pairifiers = {
        \ "left": {
        \   "[": "]",
        \   "(": ")",
        \   "{": "}",
        \   "<": ">",
        \   "'": "'",
        \   '"': '"',
        \   '`': '`',
        \ },
        \ "right": {
        \   "]": "[",
        \   ")": "(",
        \   "}": "{",
        \   ">": "<",
        \   "'": "'",
        \   '"': '"',
        \   '`': '`',
        \ }
        \}
endif

if !exists('g:pairify_map')
  let g:pairify_map = "<C-J>"
endif

" Maximum number of lines to scan backwards when searching for an open pair.
" Capped to avoid blocking on very large files. Increase if you work with
" deeply nested structures that span more than this many lines.
if !exists('g:pairify_max_lines')
  let g:pairify_max_lines = 200
endif

function! s:is_already_matched(char)
  return index(keys(g:pairifiers.right), a:char) >= 0
endfunction

function! s:pairify()
  let line = getline('.')
  let cchar = line[col('.')-1]
  if s:is_already_matched(cchar) | return "\<C-O>a" | endif

  let start_line = max([0, line('.') - g:pairify_max_lines])
  let prev_lines_string = join(add(getline(start_line, line('.')-1), line[0:col('.')-1]), "\n")
  let pair_match = pairify#find_pair(prev_lines_string)
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
