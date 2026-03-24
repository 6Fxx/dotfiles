" Auto load / install plugin manager
" Necessite curl et git d'installe

if !1 | finish | endif

" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    echo "Installing VimPlug..."
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" VimPlug
call plug#begin('~/.vim/plugged')


" VIMPROC
Plug 'Shougo/vimproc', { 'do': 'make' }
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'preservim/vim-indent-guides'
Plug 'joshdick/onedark.vim'

call plug#end()
" Required:
filetype plugin indent on

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Coloration syntaxique
syntax on
" colorscheme industry
colorscheme onedark

" Numero de ligne
set number
" Pour desactiver temporairement dans vim :set number ! ou :set nonumber

" Affichage des caracteres masques
"highlight SpecialKey ctermfg=8 guifg=#555555
"set listchars=eol:⸣
"set listchars=eol:¬
set listchars=tab:▸\ ,trail:·,eol:¬
set list
" Pour desactiver temporairement dans vim :set list ! ou :set nolist

" Gestion de l'encodage
set encoding=utf-8
set ffs=unix,dos

" parametrage de indentation
set ts=4 sw=4
set smartindent
set autoindent
filetype indent on
filetype plugin indent on
let g:indent_guides_start_level=1
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup = 1

" Definition de ctrl+e pour afficher NERDtree
nnoremap <C-e> :NERDTreeToggle<CR>

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty = '⚡'

"~~~~~~~~~~~~~~~~~~~~~~"
" Plugins utiles
"vim-plug /facultatif avec arch

"vim-indent-guides
"vim-airline
"nerdtree

"vim-devicons / pb d'affichage
"vim-code-minimap / obsolete

" Police pour airline, arch : powerline-fonts, debian : fonts-powerline
