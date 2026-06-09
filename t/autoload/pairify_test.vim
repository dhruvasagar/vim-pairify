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

function! s:TestFindPairsWithNonPairChars() abort
  " Original multiline test — uses continuation syntax so text has spaces
  " and backslashes between pairs (not real newlines), verifying non-pair
  " chars between brackets are correctly ignored.
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
call testify#it('pairify#find_pair should find pairs with non-pair chars between them', function('s:TestFindPairsWithNonPairChars'))

function! s:TestFindPairAcrossRealNewlines() abort
  " Double-quoted strings give actual \n characters, testing true multiline behaviour.
  call testify#assert#equals(pairify#find_pair("(\n["), ']')
  call testify#assert#equals(pairify#find_pair("(\n[\n{"), '}')
  call testify#assert#equals(pairify#find_pair("(\n[\n{\n<"), '>')
  " Fully balanced across lines returns empty
  call testify#assert#equals(pairify#find_pair("(\n)"), '')
  call testify#assert#equals(pairify#find_pair("(\n[\n]\n)"), '')
  " Nested pairs partly on different lines
  call testify#assert#equals(pairify#find_pair("(\nfoo\n[bar"), ']')
endfunction
call testify#it('pairify#find_pair should find pairs across real newline boundaries', function('s:TestFindPairAcrossRealNewlines'))

function! s:TestFindPairEmpty() abort
  call testify#assert#equals(pairify#find_pair(''), '')
endfunction
call testify#it('pairify#find_pair should return empty string for empty input', function('s:TestFindPairEmpty'))

function! s:TestFindPairBalanced() abort
  for text in ['()', '[]', '{}', '<>', '""', "''", '``']
    call testify#assert#equals(pairify#find_pair(text), '')
  endfor
endfunction
call testify#it('pairify#find_pair should return empty string for balanced pairs', function('s:TestFindPairBalanced'))

function! s:TestFindPairIgnoresComparisonOperators() abort
  " < followed by space = comparison operator, not an angle bracket
  call testify#assert#equals(pairify#find_pair('a < b'), '')
  " > preceded by space = comparison operator
  call testify#assert#equals(pairify#find_pair('a > b'), '')
  " outer pair is still found when < is a comparison inside
  call testify#assert#equals(pairify#find_pair('if (a < b'), ')')
  " chained comparisons
  call testify#assert#equals(pairify#find_pair('a < b && c > d'), '')
endfunction
call testify#it('pairify#find_pair should not treat spaced < and > as angle brackets', function('s:TestFindPairIgnoresComparisonOperators'))

function! s:TestFindPairAngleBrackets() abort
  " < immediately followed by non-space = angle bracket opener
  call testify#assert#equals(pairify#find_pair('vector<int'), '>')
  call testify#assert#equals(pairify#find_pair('<div'), '>')
  " balanced angle brackets
  call testify#assert#equals(pairify#find_pair('vector<int>'), '')
  call testify#assert#equals(pairify#find_pair('<div>'), '')
  " nested generics
  call testify#assert#equals(pairify#find_pair('Map<string,int'), '>')
  call testify#assert#equals(pairify#find_pair('Map<string,vector<int>'), '>')
endfunction
call testify#it('pairify#find_pair should treat < without trailing space as angle bracket', function('s:TestFindPairAngleBrackets'))

function! s:TestFindPairIgnoresNonPairChars() abort
  call testify#assert#equals(pairify#find_pair('(foo'), ')')
  call testify#assert#equals(pairify#find_pair('[foo bar'), ']')
  call testify#assert#equals(pairify#find_pair('{foo bar ['), ']')
endfunction
call testify#it('pairify#find_pair should find pair ignoring non-pair characters', function('s:TestFindPairIgnoresNonPairChars'))
