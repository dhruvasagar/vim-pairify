function! s:is_complement(char1, char2)
  if has_key(g:pairifiers.left, a:char1)
    return a:char2 == g:pairifiers.left[a:char1]
  elseif has_key(g:pairifiers.right, a:char1)
    return a:char2 == g:pairifiers.right[a:char1]
  endif
  return 0
endfunction

function! s:is_symmetric(char)
  return g:pairifiers.right[a:char] ==# a:char
endfunction

function! pairify#find_pair(string)
  let stack = []
  let chars = split(a:string, '\zs')
  let n = len(chars)

  for i in range(n - 1, 0, -1)
    let char = chars[i]

    if has_key(g:pairifiers.right, char)
      if char ==# '>' && i > 0 && chars[i-1] ==# ' '
        continue
      endif
      if !empty(stack) && s:is_symmetric(char) && stack[-1] ==# char
        call remove(stack, -1)
        continue
      endif
      call add(stack, char)
    elseif has_key(g:pairifiers.left, char)
      if char ==# '<' && i < n-1 && chars[i+1] ==# ' '
        continue
      endif
      if !empty(stack) && s:is_complement(char, stack[-1])
        call remove(stack, -1)
      elseif empty(stack)
        return g:pairifiers.left[char]
      endif
    endif
  endfor

  return get(stack, 0, '')
endfunction
