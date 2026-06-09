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
  let n = len(a:string)
  let i = n - 1

  while i >= 0
    let char = a:string[i]

    if has_key(g:pairifiers.right, char)
      if char ==# '>' && i > 0 && a:string[i-1] ==# ' '
        " comparison operator, skip
      elseif !empty(stack) && s:is_symmetric(char) && stack[-1] ==# char
        call remove(stack, -1)
      else
        call add(stack, char)
      endif
    elseif has_key(g:pairifiers.left, char)
      if char ==# '<' && i < n - 1 && a:string[i+1] ==# ' '
        " comparison operator, skip
      elseif !empty(stack) && s:is_complement(char, stack[-1])
        call remove(stack, -1)
      elseif empty(stack)
        return g:pairifiers.left[char]
      endif
    endif
    let i -= 1
  endwhile

  return get(stack, 0, '')
endfunction
