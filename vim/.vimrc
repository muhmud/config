
autocmd BufRead,BufNewFile * start 
autocmd BufReadPost * silent! exe "normal! '."
set timeoutlen=10 ttimeoutlen=0

set nocompatible  " be iMproved, required
filetype off  " required
set exrc

set encoding=UTF-8

set guifont=Victor\ Mono\ 23
set fillchars+=vert:\|
syntax enable
set background=dark
set ruler
set hidden
set number
set laststatus=2
set smartindent
set st=4 sw=4 et
set shiftwidth=2
set tabstop=2
set colorcolumn=100
set noinsertmode
set noshowmode
set cursorline

colorscheme atom-dark-256

:hi CursorLine cterm=NONE ctermbg=Black ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=Black ctermfg=white guibg=darkred guifg=white

" ==== moving around
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" ==== disable mouse
set mouse=c

let g:pymode_indent = 0
" ==== custom commands
command JsonPretty execute ":%!python -m json.tool"
set secure

inoremap <buffer> <silent> <Esc>o <C-O>

inoremap <buffer> <silent> <Esc>[1;2C <S-Right>
snoremap <buffer> <silent> <Esc>[1;2C <S-Right>
inoremap <buffer> <silent> <Esc>[1;2D <S-Left>
snoremap <buffer> <silent> <Esc>[1;2D <S-Left>

nnoremap <buffer> <silent> <Esc>[1;5D <C-Left>
inoremap <buffer> <silent> <Esc>[1;5D <C-Left>
snoremap <buffer> <silent> <Esc>[1;5D <C-Left>

nnoremap <buffer> <silent> <Esc>[1;5C <C-Right>
inoremap <buffer> <silent> <Esc>[1;5C <C-Right>
snoremap <buffer> <silent> <Esc>[1;5C <C-Right>

inoremap <buffer> <silent> <Esc>[6D6~ <C-S-Left>
snoremap <buffer> <silent> <Esc>[6D6~ <C-S-Left>
inoremap <buffer> <silent> <Esc>[6C6~ <C-S-Right>
snoremap <buffer> <silent> <Esc>[6C6~ <C-S-Right>

inoremap <buffer> <silent> <Esc>[1;2H <S-Home>
snoremap <buffer> <silent> <Esc>[1;2H <S-Home>
inoremap <buffer> <silent> <Esc>[1;2F <S-End>
snoremap <buffer> <silent> <Esc>[1;2F <S-End>

inoremap <buffer> <silent> <Esc>[1;6H <C-S-Home>
snoremap <buffer> <silent> <Esc>[1;6H <C-S-Home>
inoremap <buffer> <silent> <Esc>[1;6F <C-S-End>
snoremap <buffer> <silent> <Esc>[1;6F <C-S-End>

nnoremap <buffer> <silent> <Esc>[1;5H <C-Home>
inoremap <buffer> <silent> <Esc>[1;5H <C-Home>
snoremap <buffer> <silent> <Esc>[1;5H <C-Home>

nnoremap <buffer> <silent> <Esc>[1;5F <C-End>
inoremap <buffer> <silent> <Esc>[1;5F <C-End>
snoremap <buffer> <silent> <Esc>[1;5F <C-End>

inoremap <buffer> <silent> <Esc>[1;2A <S-Up>
snoremap <buffer> <silent> <Esc>[1;2A <S-Up>
inoremap <buffer> <silent> <Esc>[1;2B <S-Down>
snoremap <buffer> <silent> <Esc>[1;2B <S-Down>

inoremap <buffer> <silent> <Esc>[5;2~ <S-PageUp>
snoremap <buffer> <silent> <Esc>[5;2~ <S-PageUp>
inoremap <buffer> <silent> <Esc>[6;2~ <S-PageDown>
snoremap <buffer> <silent> <Esc>[6;2~ <S-PageDown>

snoremap <buffer> <silent> <Esc>[3;2~ <Del>

inoremap <buffer> <silent> <Esc>[6;5! <C-O>db

nnoremap <silent> <Esc>[5;5~ :bnext<CR>
inoremap <silent> <Esc>[5;5~ <C-O>:bnext<CR>

nnoremap <silent> <Esc>[6;5~ :bprevious<CR>
inoremap <silent> <Esc>[6;5~ <C-O>:bprevious<CR>

inoremap <silent> <Esc>[1;5H <C-O>gg
inoremap <silent> <Esc>[1;5F <C-O>G<End>

" F5 for qsh
snoremap <silent> <Esc>[95~ <C-O>:call QshExecuteSelection()<CR>

" Ctrl+Enter for qsh
inoremap <silent> <Esc>[24;3~ <C-O>:call QshExecute()<CR>
nnoremap <silent> <Esc>[24;3~ <C-O>:call QshExecute()<CR>

" F7 for qsh
inoremap <silent> <Esc>[98~ <C-O>:call QshExecuteAll()<CR>
nnoremap <silent> <Esc>[98~ <C-O>:call QshExecuteAll()<CR>

call plug#begin('~/.vim/plugged')

Plug 'tombh/novim-mode'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'pgavlin/pulumi.vim'
Plug 'https://github.com/hardcoreplayers/sql.vim'

Plug 'muhmud/qsh', { 'dir': '~/.qsh/editors/vim' }

call plug#end()

set rtp+=/usr/lib/python3.8/site-packages/powerline/bindings/vim

" Always show statusline
set laststatus=2

