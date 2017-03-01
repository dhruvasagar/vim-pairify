function! s:is_compliment(char1, char2)
  if has_key(g:pairifiers.left, a:char1)
    return a:char2 == g:pairifiers.left[a:char1]
  elseif has_key(g:pairifiers.right, a:char1)
    return a:char2 == g:pairifiers.right[a:char1]
  endif
endfunction

function! s:is_quote(char)
  return a:char ==# "'" || a:char ==# '"'
endfunction

function! pairify#find_pair(string)
  let stack = []
  let characters = split(a:string, '\zs')

  for char in reverse(characters)
    if has_key(g:pairifiers.right, char)
      if !empty(stack) && s:is_quote(char) && stack[-1] ==# char
        call remove(stack, -1)
        continue
      endif
      call add(stack, char)
    elseif has_key(g:pairifiers.left, char)
      if !empty(stack) && s:is_compliment(char, stack[-1])
        call remove(stack, -1)
      elseif empty(stack)
        return g:pairifiers.left[char]
      endif
    endif
  endfor

  if empty(stack)
    return ''
  else
    return remove(stack, 0)
  endif
endfunction
