" Auto load / install plugin manager
" Necessite curl et git d'installes

if !1 | finish | endif

" ~~~ Detection des prerequiss ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Verifie curl, git et la connexion a github.com
let s:has_curl = executable('curl')
let s:has_git  = executable('git')
let s:github_ok = 0

if s:has_curl && s:has_git
    " Test de connexion GitHub (timeout 3s, silencieux)
    let s:github_check = system('curl -s --max-time 3 -o /dev/null -w "%{http_code}" https://github.com')
    if s:github_check =~# '^[23]'
        let s:github_ok = 1
    endif
endif

" Verifie si vim-plug et les plugins sont deja installes localement
let s:plug_installed  = !empty(glob('~/.vim/autoload/plug.vim'))
let s:plugged_exists  = !empty(glob('~/.vim/plugged'))

" Conditions composites
let s:can_install     = s:has_curl && s:has_git && s:github_ok
let s:plugins_usable  = s:can_install || (s:plug_installed && s:plugged_exists)

if !s:has_curl
    echom "[vimrc] curl introuvable : installation des plugins ignoree."
endif
if !s:has_git
    echom "[vimrc] git introuvable : installation des plugins ignoree."
endif
if s:has_curl && s:has_git && !s:github_ok
    if s:plug_installed && s:plugged_exists
        echom "[vimrc] GitHub inaccessible mais plugins deja installes : parametrage applique."
    else
        echom "[vimrc] GitHub inaccessible et plugins absents : parametrage ignore."
    endif
endif

" ~~~ Plugins ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Installation uniquement si curl + git + github accessibles
if s:can_install

    if empty(glob('~/.vim/autoload/plug.vim'))
        echo "Installing VimPlug..."
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

endif

" Chargement des plugins si vim-plug est disponible (installation ou deja present)
if s:plugins_usable

    call plug#begin('~/.vim/plugged')

    " Plug 'Shougo/vimproc', { 'do': 'make' }
    Plug 'scrooloose/nerdtree'
    Plug 'vim-airline/vim-airline'
    Plug 'preservim/vim-indent-guides'
    Plug 'joshdick/onedark.vim'
    " Plugin pour LSP
    Plug 'prabirshrestha/vim-lsp'               " client LSP
    Plug 'mattn/vim-lsp-settings'               " auto-install des serveurs LSP
    Plug 'prabirshrestha/asyncomplete.vim'       " moteur d'autocompletion async
    Plug 'prabirshrestha/asyncomplete-lsp.vim'   " bridge LSP -> asyncomplete

    call plug#end()
    " Required:
    filetype plugin indent on

endif

" ~~~ Param Visuel ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Coloration syntaxique
syntax on

" Colorscheme : onedark si plugin charge, sinon fallback natif
if s:plugins_usable
    " colorscheme industry
    colorscheme onedark
else
    " Fallback sans plugin : colorscheme natif disponible dans vim de base
    silent! colorscheme industry
endif

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

" Parametrage de l'indentation
set tabstop=4       " Affiche les caractères tab comme 4 espaces
set shiftwidth=4    " Indentation avec > utilise 4 espaces
set expandtab
set smartindent
set autoindent
filetype indent on
filetype plugin indent on

" indent-guides : uniquement si les plugins sont utilisables
if s:plugins_usable
    let g:indent_guides_start_level=1
    let g:indent_guides_guide_size=1
    let g:indent_guides_enable_on_vim_startup = 1
endif

" Definition de ctrl+e pour afficher NERDtree (uniquement si plugin utilisable)
if s:plugins_usable
    nnoremap <C-e> :NERDTreeToggle<CR>
endif

" ~~~ Airline (uniquement si plugins utilisables) ~~~~~~~~~~~~~~~~~~~~~~
if s:plugins_usable
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
endif

" Activer la detection de filetype (obligatoire, independant des plugins)
filetype plugin on

" ~~~ LSP (uniquement si plugins utilisables) ~~~~~~~~~~~~~~~~~~~~~~~~~~
if s:plugins_usable

    " Activer asyncomplete
    let g:asyncomplete_auto_popup = 1

    " Options vim-lsp
    let g:lsp_diagnostics_echo_cursor = 1   " affiche les erreurs en bas
    let g:lsp_inlay_hints_enabled = 1       " inlay hints si supporte
    let g:lsp_format_sync_timeout = 1000    " timeout format on save

    " Keymaps actives quand un serveur LSP est attache au buffer
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

endif

" ~~~ Info ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Plugins utiles
"vim-plug /facultatif avec arch

"vim-indent-guides
"vim-airline
"nerdtree

"vim-devicons / pb d'affichage
"vim-code-minimap / obsolete

" Police pour airline, arch : powerline-fonts, debian : fonts-powerline
