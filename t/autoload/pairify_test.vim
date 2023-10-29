function! s:TestFindPair() abort
  let tests = [{
        \ 'text': '(',
        \ 'pair': ')',
        \ }, {
        \ 'text': '[',
        \ 'pair': ']',
        \ }, {
        \ 'text': '{',
        \ 'pair': '}',
        \ }, {
        \ 'text': "<",
        \ 'pair': '>',
        \ }, {
        \ 'text': '"',
        \ 'pair': '"',
        \ }, {
        \ 'text': "'",
        \ 'pair': "'",
        \ }, {
        \ 'text': '`',
        \ 'pair': '`',
        \ }]

  for test in tests
    call testify#assert#equals(pairify#find_pair(test.text), test.pair)
  endfor
endfunction
call testify#it('pairify#find_pair should find the pair', function('s:TestFindPair'))

function! s:TestFindNestedPairs() abort
  let text = '([{<'
  let pairs = '>}])'
  for pair in split(pairs, '\zs')
    let fpair = pairify#find_pair(text)
    call testify#assert#equals(pair, fpair)
    let text = text .. pair
  endfor
endfunction
call testify#it('pairify#find_pair should find nested pairs', function('s:TestFindNestedPairs'))

function! s:TestFindNestedQuotes() abort
  let text = '`"'''
  let pairs = '''"`'
  for pair in split(pairs, '\zs')
    let fpair = pairify#find_pair(text)
    call testify#assert#equals(pair, fpair)
    let text = text .. pair
  endfor
endfunction
call testify#it('pairify#find_pair should find nested quotes', function('s:TestFindNestedQuotes'))

function! s:TestFindMultilinePairs() abort
  let text = '(
        \ [
        \ {
        \ <'
  let pairs = '>}])'
  for pair in split(pairs, '\zs')
    let fpair = pairify#find_pair(text)
    call testify#assert#equals(pair, fpair)
    let text = text .. pair
  endfor
endfunction
call testify#it('pairify#find_pair should find the pair in multiline string', function('s:TestFindMultilinePairs'))
