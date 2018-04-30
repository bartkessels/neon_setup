set exrc
set secure

colorscheme wwdc17
syntax on

set tabstop=4
set softtabstop=4
set shiftwidth=4

set autoindent
set smartindent
set cindent

set number!
set numberwidth=5

set scrolloff=15
set cursorline

augroup project
    autocmd!
    autocmd! BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END

" Set path where to check for header files
let &path.="src,src/include,/usr/include/AL,"
