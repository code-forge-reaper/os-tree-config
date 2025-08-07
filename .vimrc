" Basic Settings
set nocompatible          " Use Vim defaults (better than Vi)
filetype plugin indent on " Enable filetype detection, plugins, and indentation
syntax on                 " Enable syntax highlighting
set encoding=utf-8        " Set default encoding to UTF-8

" Interface Enhancements
set number                " Show line numbers
set relativenumber        " Relative line numbers
set cursorline            " Highlight the current line
set wrap                  " Enable line wrapping
set linebreak             " Avoid breaking words on wrap
set showcmd               " Show incomplete commands
set wildmenu              " Enhanced command line completion
set lazyredraw            " Improve performance for macros and other commands

" Better Splits
set splitright            " Vertical splits open to the right
set splitbelow            " Horizontal splits open below

" Enable Mouse
set mouse=a               " Enable mouse support

" Initialize Vim-Plug
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'vimwiki/vimwiki'                  " Personal Wiki for Vim
Plug 'junegunn/goyo.vim'                " Distraction-free writing
Plug 'preservim/nerdtree'               " File Explorer
Plug 'preservim/tagbar'                 " Source code tag system
Plug 'preservim/nerdcommenter'          " Commenting plugin
Plug 'tpope/vim-markdown'               " Markdown support
Plug 'godlygeek/tabular'                " Text alignment
Plug 'lervag/vimtex'                    " LaTeX support

call plug#end()

" Plugin Configurations

" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
nnoremap <Leader>ww :VimwikiIndex<CR>
nnoremap <Leader>wt :VimwikiTabIndex<CR>
nnoremap <Leader>ws :VimwikiUISelect<CR>

" Goyo
augroup goyo
  autocmd!
  autocmd User GoyoEnter Limelight
  autocmd User GoyoLeave Limelight!
augroup END
function! ToggleGoyo()
  if exists('g:goyo_width')
    Goyo!
  else
    Goyo 80%
  endif
endfunction
nnoremap <Leader>g :call ToggleGoyo()<CR>

" NERDTree
map <C-n> :NERDTreeToggle<CR>

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp', 'c']
let g:markdown_folding = 1
let g:markdown_syntax_conceal = 0

" NERD Commenter
let g:NERDSpaceDelims = 1

" Tabular
" (No additional configuration needed for basic use)

" VimTeX
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

" Custom Keybindings for Convenience
" (Add any additional keybindings here)

" Install Plugins
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
