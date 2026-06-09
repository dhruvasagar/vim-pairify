# vim-pairify v0.5.1 [![Build](https://github.com/dhruvasagar/vim-pairify/actions/workflows/ci.yml/badge.svg)](https://github.com/dhruvasagar/vim-pairify/actions/workflows/ci.yml)

A simple plugin for pair completion such as `()` and `[]`. Press
<kbd>Ctrl-J</kbd> in insert mode and the plugin identifies the correct closing
character to insert. It handles nesting and multiline matching.

## How it works

The plugin scans backwards from the cursor through all preceding lines,
tracking open and close pairs on a stack. When it finds an unmatched opening
character it inserts the corresponding closing character. If the cursor is
already sitting before a closing character it moves past it instead.

**Angle brackets** (`<` and `>`) are treated as comparison operators when
surrounded by a space (e.g. `a < b`) and as angle bracket pairs when not
(e.g. `vector<int`, `<div`).

## Default pairs

| Opener | Closer |
|--------|--------|
| `(`    | `)`    |
| `[`    | `]`    |
| `{`    | `}`    |
| `<`    | `>`    |
| `'`    | `'`    |
| `"`    | `"`    |
| `` ` ``| `` ` ``|

## Installation

Using any plugin manager (Pathogen, Vundle, vim-plug, etc.) or Vim 8+'s
built-in package support:

```sh
# vim-plug
Plug 'dhruvasagar/vim-pairify'

# built-in packages
git clone https://github.com/dhruvasagar/vim-pairify \
  ~/.vim/pack/plugins/start/vim-pairify
```

## Configuration

### Change the trigger key

The default mapping is <kbd>Ctrl-J</kbd>. To use a different key, set
`g:pairify_map` in your vimrc **before** the plugin loads:

```vim
let g:pairify_map = '<C-Space>'
```

### Customise pairs

Set `g:pairifiers` in your vimrc **before** the plugin loads to replace the
default pair set entirely. The dict requires a `left` map (opener → closer)
and a `right` map (closer → opener):

```vim
" Example: drop angle brackets and add | for Rust closures
let g:pairifiers = {
      \ 'left':  { '(': ')', '[': ']', '{': '}', "'": "'", '"': '"', '`': '`', '|': '|' },
      \ 'right': { ')': '(', ']': '[', '}': '{', "'": "'", '"': '"', '`': '`', '|': '|' },
      \}
```

Symmetric pairs (where opener equals closer, such as quotes and `|`) follow
the same matching logic as quote characters.

## Contributing

- Fork it
- Commit your changes with a descriptive message
- Push to your fork on GitHub
- Open a Pull Request
