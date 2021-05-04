
" autocmd VimEnter,BufReadPre,BufNewFile * startinsert
autocmd BufReadPost * silent! exe "normal! '."

autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
autocmd InsertEnter * silent exec "! echo -ne '\e[5 q'"
autocmd InsertLeave * silent exec "! echo -ne '\e[1 q'"

set timeoutlen=550 ttimeoutlen=-1

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
set nostartofline

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

inoremap <silent> <Esc>o <C-O>

inoremap <silent> <Esc>[1;2R <S-F3>
nnoremap <silent> <Esc>[1;2R <S-F3>

inoremap <silent> <Esc>[1;2C <S-Right>
snoremap <silent> <Esc>[1;2C <S-Right>
inoremap <silent> <Esc>[1;2D <S-Left>
snoremap <silent> <Esc>[1;2D <S-Left>

nnoremap <silent> <Esc>[1;5D <C-Left>
inoremap <silent> <Esc>[1;5D <C-Left>
snoremap <silent> <Esc>[1;5D <C-Left>

nnoremap <silent> <Esc>[1;5C <C-Right>
inoremap <silent> <Esc>[1;5C <C-Right>
snoremap <silent> <Esc>[1;5C <C-Right>

inoremap <silent> <Esc>[1;6D <C-S-Left>
snoremap <silent> <Esc>[1;6D <C-S-Left>
inoremap <silent> <Esc>[1;6C <C-S-Right>
snoremap <silent> <Esc>[1;6C <C-S-Right>

inoremap <silent> <Esc>[1;2H <S-Home>
snoremap <silent> <Esc>[1;2H <S-Home>
inoremap <silent> <Esc>[1;2F <S-End>
snoremap <silent> <Esc>[1;2F <S-End>

inoremap <silent> <Esc>[1;5EK <C-S-Home>
snoremap <silent> <Esc>[1;5EK <C-S-Home>
inoremap <silent> <Esc>[1;5FK <C-S-End>
snoremap <silent> <Esc>[1;5FK <C-S-End>

nnoremap <silent> <Esc>[1;5E <C-Home>
inoremap <silent> <Esc>[1;5E <C-Home>
snoremap <silent> <Esc>[1;5E <C-Home>

nnoremap <silent> <Esc>[1;5F <C-End>
inoremap <silent> <Esc>[1;5F <C-End>
snoremap <silent> <Esc>[1;5F <C-End>

inoremap <silent> <Esc>[1;2A <S-Up>
snoremap <silent> <Esc>[1;2A <S-Up>
inoremap <silent> <Esc>[1;2B <S-Down>
snoremap <silent> <Esc>[1;2B <S-Down>

inoremap <silent> <Esc>[5;2~ <S-PageUp>
snoremap <silent> <Esc>[5;2~ <S-PageUp>
inoremap <silent> <Esc>[6;2~ <S-PageDown>
snoremap <silent> <Esc>[6;2~ <S-PageDown>

snoremap <silent> <Esc>[3~ <Del>

" inoremap <buffer> <silent> <C-S-Left> <C-O>db
" inoremap <buffer> <silent> <C-S-Right> <C-O>de

nnoremap <silent> <Esc>[5;5~ :bnext<CR>
inoremap <silent> <Esc>[5;5~ <C-O>:bnext<CR>

nnoremap <silent> <Esc>[6;5~ :bprevious<CR>
inoremap <silent> <Esc>[6;5~ <C-O>:bprevious<CR>

" F5 for qsh
snoremap <silent> <Esc>[15~ <C-O>:call QshExecuteSelection()<CR>
vnoremap <silent> <Esc>[15~ :call QshExecuteSelection()<CR>

" Ctrl+Enter for qsh
inoremap <silent> <Esc>[XB <C-O>:call QshExecute()<CR>
nnoremap <silent> <Esc>[XB :call QshExecute()<CR>

" Ctrl+Shift+Enter for qsh
inoremap <silent> <Esc>[XD <C-O>:call QshExecute("---", 0)<CR>
nnoremap <silent> <Esc>[XD :call QshExecute("---", 0)<CR>

" Scripts
snoremap <silent> <Esc>[1;3P <C-O>:call QshExecuteNamedScript("describe")<CR>
vnoremap <silent> <Esc>[1;3P :call QshExecuteNamedScript("describe")<CR>

snoremap <silent> <Esc>[1;3Q <C-O>:call QshExecuteNamedScript("select-some")<CR>
vnoremap <silent> <Esc>[1;3Q :call QshExecuteNamedScript("select-some")<CR>

snoremap <silent> <Esc>[1;3R <C-O>:call QshExecuteScript()<CR>
vnoremap <silent> <Esc>[1;3R :call QshExecuteScript()<CR>

snoremap <silent> <Esc><Space> <C-O>:call QshExecuteSnippet()<CR>
vnoremap <silent> <Esc><Space> :call QshExecuteSnippet()<CR>
nnoremap <silent> <Esc><Space> :call QshExecuteSnippet()<CR>
inoremap <silent> <Esc><Space> <C-O>:call QshExecuteSnippet()<CR>

" F7 for qsh
inoremap <silent> <Esc>[18~ <C-O>:call QshExecuteAll()<CR>
nnoremap <silent> <Esc>[18~ :call QshExecuteAll()<CR>

nnoremap , @@

nnoremap <SPACE> <Nop>
let mapleader=" "

nmap <Leader>gd <Plug>(coc-definition)
nmap <Leader>gr <Plug>(coc-references)

nmap <Leader>fh :call fzf#run({'options': '--reverse', 'down': 20, 'dir': '~', 'sink': 'e' })<CR>
nmap <Leader>ff :call fzf#run({'options': '--reverse', 'down': 20, 'sink': 'e' })<CR>
nmap <Leader>fg :GitFiles<CR>
nmap <Leader>bb :Buffers<CR>

"nnoremap x "_x
"nnoremap X "_X
"nnoremap d "_d
"nnoremap D "_D
"vnoremap d "_d

"nnoremap <Leader>dd ""dd
"nnoremap <Leader>d ""d
"nnoremap <Leader>D ""D
"vnoremap <Leader>d ""d

":set clipboard=unnamedplus
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

call plug#begin('~/.vim/plugged')

"Plug 'muhmud/novim-mode'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'pgavlin/pulumi.vim'
Plug 'https://github.com/hardcoreplayers/sql.vim'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'

Plug 'muhmud/qsh', { 'dir': '~/.qsh', 'branch': 'main', 'rtp': 'editors/vim' }

call plug#end()

set rtp+=/usr/lib/python3.9/site-packages/powerline/bindings/vim

" Always show statusline
set laststatus=2

