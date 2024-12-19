# Vim Cheat Sheet

## Screen Positioning

* Scroll the screen by half increments `ctrl u` and `ctrl d`.
* Scroll the screen by full increments `ctrl f` and `ctrl b`.

* `z` and `return` will move the current line to the top of the screen.
* `50z` and `return` will make the top of the screen start at line 50.
* `z.` will move the current line to the centre of the screen.
* `z-` will move to the bottom.

* Home of page H
* Middle of page M
* Last of page L

## Text Block Movement

Move to the beginning or previous sentence, ( and )
Paragraphs can be navigated using { and }. a paragraph is based on nroff macros (read man nroff if you want to figure out what that means).
moves to the next (brackets, opening and closing c-style comments, and C preprocessor conditionals %,

## Line Movement

Typing 44G would move to the 44th line in the file.
G goes to the last line, and
gg goes to the first line.

The useful thing about this command is typing `` moves back to the last position. This also moves back to the last edit if an edit was made, or the position before a search was started.

## Character Movement

The f and F commands are extremely useful for navigating within a line. Pressing f{char} will move the next occurrence of {char} within the current line. Meanwhile, F will move backwards. A numerical count argument can also be supplied, so 2f: will go to the second occurrence of : after the current cursor position.
To move before the matching character, t and T can be used. The last ftFT can be repeated by pressing ;.

## My workflow

* `j`/`k` move cursor **down/up**
* `w`/`e`jump forwards to the **start/end** of a word
* `W`/`E`jump forwards to the **start/end** of a word (Symbols included)
* `b`/`B` jump backwards to the start of a **word / (Symbols included)**
* `gg`/`G` go to the **first/last** line of the document
* `<linenum> G` go to line
* `i`/`a`/`A`/`o`/`O` insert  - **at cursor/after/end of line/next line/line before**
* `%` go to matching brackets*
* `p`/`P` paste **after/before** cursor
* `Yp`/`yyp` duplicate line
* `rR` replace **current/multiple** letter with the what specified after
* `ciw` change inner word
* `x` deletes a character
* `d$`/`d0` delete from current position to **end/beginning** of line
* `dd` cut a line
* `dw` delete current word
* `wdw` delete next word
* `bdw` delete current/previous word

* `:s/thee/the`
* `:s/thee/the/g`
* `:s/thee/the/gc`
* `v(j*n)d`    #cut a number of lines
* `v(j*n)y`    #copy a number of lines

### Global Commands

* :help keyword # open help for keyword
* :o file       # open file
* :saveas file  # save file as
* :close        # close current pane

### Cursor movement

* h/j/k/l  # move cursor left/down/up/right
* H/M/L        # move to top/middle/bottom of screen
* w/W        # jump forwards to the start of a word/with puncuations
* e/E        # jump forwards to the end of a word/with puncuations
* b/B        # jump backwards to the start of a word/with punctuations
* 0        # jump to the start of the line
* ^        # jump to the first non-blank character of the line
* $        # jump to the end of the line
* g_       # jump to the last non-blank character of the line
* gg       # go to the first line of the document
* G        # go to the last line of the document
* 5G       # go to line 5
* fx/tx       # jump to **next/before next** occurrence of character x
* `{`/`}` jump to **previous/next** paragraph (or function/block, when editing code)
* zz       # center cursor on screen
* Ctrl + b # move back one full screen
* Ctrl + f # move forward one full screen
* Ctrl + d # move forward 1/2 a screen
* Ctrl + u # move back 1/2 a screen

### Insert mode - inserting/appending text:

* i/a        # insert before/after the cursor
* I/A        # insert at the beginning/end of the line
* o/O        # append (open) a new line below/above the current line
* ea       # insert (append) at the end of the word
* Esc      # exit insert mode

### Editing:

* r        # replace a single character
* J        # join line below to the current one
* cc       # change (replace) entire line
* cw       # change (replace) to the start of the next word
* ce       # change (replace) to the end of the next word
* cb       # change (replace) to the start of the previous word
* c$       # change (replace) to the end of the line
* s        # delete character and substitute text
* S        # delete line and substitute text (same as cc)
* xp       # transpose two letters (delete and paste)
* .        # repeat last command
* `u`/ `Ctrl+r` undo/redo

### Marking text (visual mode)

* v        # start visual mode, mark lines, then do a command (like y-yank)
* V        # start linewise visual mode
* o        # move to other end of marked area
* O        # move to other corner of block
* aw       # mark a word
* `ab`/`aB` a block with ()/{}
* `ib`/`iB` inner block with ()/{}
* Esc      # exit visual mode
* Ctrl + v # start visual block mode

### Visual commands:

* `>`/`<` shift text right/left
* `y`/`d` **yank (copy)/delete** marked text
* ~       # switch case

### Cut and paste

* yy       # yank (copy) a line
* 2yy      # yank (copy) 2 lines
* yw       # yank (copy) the characters of the word from the cursor position to the start of the next word
* y$       # yank (copy) to end of line
* p/P        # put (paste) the clipboard after/before cursor
* dd       # delete (cut) a line
* 2dd      # delete (cut) 2 lines
* dw       # delete (cut) the characters of the word from the cursor position to the start of the next word
* D        # delete (cut) to the end of the line
* d$       # delete (cut) to the end of the line
* d^       # delete (cut) to the first non-blank character of the line
* d0       # delete (cut) to the begining of the line
* x        # delete (cut) character

### Search and replace

* /pattern       # search for pattern
* ?pattern       # search backward for pattern
* \vpattern      # 'very magic' pattern: non-alphanumeric characters are interpreted as special regex symbols (no escaping needed)
* n              # repeat search in same direction
* N              # repeat search in opposite direction
* :%s/old/new/g  # replace all old with new throughout file
* :%s/old/new/gc # replace all old with new throughout file with confirmations
* :noh           # remove highlighting of search matches
* Search in multiple files
* :vimgrep /pattern/ {file} # search for pattern in multiple files
*  :cn                       # jump to the next match
* :cp                       # jump to the previous match
* :copen                    # open a window containing the list of matches

### Exiting

* :w              # write (save) the file, but don't exit
* :w !sudo tee %  # write out the current file using sudo
* :wq or :x or ZZ # write (save) and quit
* :q              # quit (fails if there are unsaved changes)
* :q! or ZQ       # quit and throw away unsaved changes

### Working with multiple files

* :e file       # edit a file in a new buffer
* :bnext or :bn # go to the next buffer
* :bprev or :bp # go to the previous buffer
* :bd           # delete a buffer (close a file)
* :ls           # list all open buffers
* :sp file      # open a file in a new buffer and split window
* :vsp file     # open a file in a new buffer and vertically split window
* Ctrl + ws     # split window
* Ctrl + ww     # switch windows
* Ctrl + wq     # quit a window
* Ctrl + wv     # split window vertically
* Ctrl + wh     # move cursor to the left window (vertical split)
* Ctrl + wl     # move cursor to the right window (vertical split)
* Ctrl + wj     # move cursor to the window below (horizontal split)
* Ctrl + wk     # move cursor to the window above (horizontal split)

### Tabs

* :tabnew or :tabnew file # open a file in a new tab
* Ctrl + wT               # move the current split window into its own tab
* gt or :tabnext or :tabn # move to the next tab
* gT or :tabprev or :tabp # move to the previous tab
* <number>gt              # move to tab <number>
* :tabmove <number>       # move current tab to the <number>th position (indexed from 0)
* :tabclose or :tabc      # close the current tab and all its windows
* :tabonly or :tabo       # close all tabs except for the current one
* :tabdo command          # run the command on all tabs (e.g. :tabdo q - closes all opened tabs)