"
"SYNTAX AND VISUALS
"

syntax enable           " enable syntax processing
set number              " show line numbers
set numberwidth=4	" numerations indent, same as default
set wrap 		" makes text go on new line if too long
set breakindent		" Indents wrapped lines as much as the 'parent' 
set formatoptions+=r	" auto format for comments.

"
" TABBING SETTINGS
"

set tabstop=4       	" number of visual spaces per TAB
set softtabstop=4   	" number of spaces in tab when editing
set shiftwidth=4	" number of spaces of << or >> commands
set shiftround		" << and >>  align w/ multiples of shiftwidth
set autoindent		" lines inherit tabbing from line before
