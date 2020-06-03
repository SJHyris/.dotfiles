"
" BASIC COMPATIBILITY OPTIONS
"

" Allow to select with mouse
if has('mouse')	
  set mouse=a
endif



"
"SYNTAX AND VISUALS
"

syntax enable           " enable syntax processing
set number              " show line numbers
set numberwidth=4	" numerations indent, same as default
set wrap 		" makes text go on new line if too long
set breakindent		" Indents wrapped lines as much as the 'parent' 
set formatoptions+=r	" auto format for comments.

set foldmethod=indent	" enable folding at indents.
set foldlevelstart=99	" All folds open when file is opened.	

"
" TABBING SETTINGS
"

set tabstop=4       	" number of visual spaces per TAB
set softtabstop=4   	" number of spaces in tab when editing
set shiftwidth=4	" number of spaces of << or >> commands
set shiftround		" << and >>  align w/ multiples of shiftwidth
set autoindent		" lines inherit tabbing from line before


"
" Search, highlight and movement settings
"

" Find a way to highlight as it is typed?
set hlsearch		" Highlight search terms.
set incsearch		" Highlight as you type

"Do completion and omnicompletion
"CursorMoved event to toggle off? or InsertEnter

"
" ABBREVIATIONS
"
"" C ABBREVIATIONS
""
:iabbrev stdio #include <stdio.h> 
:iabbrev stdlib #include <stdlib.h> 
:iabbrev intmain int main(void){}<LEFT><CR><CR><CR><CR><UP><TAB>return 0;<UP><UP><TAB>
:iabbrev DBG printf("[DEBUG]: ");<LEFT><LEFT><LEFT><LEFT>
:iabbrev tstruct struct NAME {<CR><CR>} TAG; <UP><TAB>

