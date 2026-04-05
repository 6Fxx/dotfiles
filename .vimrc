" Auto load / install plugin manager
" Necessite curl et git d'installe

if !1 | finish | endif

" ~ Plugin ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    echo "Installing VimPlug..."
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" VimPlug
call plug#begin('~/.vim/plugged')

" Plug 'Shougo/vimproc', { 'do': 'make' }
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'preservim/vim-indent-guides'
Plug 'joshdick/onedark.vim'
" Plugin pour LSP
Plug 'prabirshrestha/vim-lsp'          " client LSP
Plug 'mattn/vim-lsp-settings'          " auto-install des serveurs LSP
Plug 'prabirshrestha/asyncomplete.vim' " moteur d'autocomplétion async
Plug 'prabirshrestha/asyncomplete-lsp.vim' " bridge LSP → asyncomplete

call plug#end()
" Required:
filetype plugin indent on

" ~ Param Visuel ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

" airline
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

" Activer la détection de filetype (obligatoire)
filetype plugin on

" ~~~ LSP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Activer asyncomplete
let g:asyncomplete_auto_popup = 1

" Options vim-lsp
let g:lsp_diagnostics_echo_cursor = 1   " affiche les erreurs en bas
let g:lsp_inlay_hints_enabled = 1       " inlay hints si supporté
let g:lsp_format_sync_timeout = 1000    " timeout format on save

" Keymaps activés quand un serveur LSP est attaché au buffer
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> K  <plug>(lsp-hover)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>ca <plug>(lsp-code-action)
  " Format on save pour certains types de fichiers
  autocmd! BufWritePre *.py,*.sh call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" ~~~ Info ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Plugins utiles
"vim-plug /facultatif avec arch

"vim-indent-guides
"vim-airline
"nerdtree

"vim-devicons / pb d'affichage
"vim-code-minimap / obsolete

" Police pour airline, arch : powerline-fonts, debian : fonts-powerline
