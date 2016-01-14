# vim-pairify v0.3.2

A simple plugin for pair completion such as () and [].

* However, this is a different take on pair completion instead of auto
  completing pairs, this plugin simply puts the cursor between the pair if you
  happen to type just the pair, i.e. if you type (), it will put the cursor
  between the braces and you can type whatever you want. If however you were
  completing a pair with already something within them, the plugin stays out
  of your way and does nothing.
* This will also reposition the cursor on the pair ending when you leave
  insert mode and happen to be at the end but just before the ending pair.

## Installation

You can either do a standard installation or using a plugin manager such as
Pathogen, Vundle, NeoBundle, VimPlug

## Contributing

* Fork It
* Commit your changes and give your commit message some love
* Push to your fork on github
* Open a Pull Request
