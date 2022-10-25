set nocompatible

let mapleader=","

" Plugins
call plug#begin()
    Plug 'airblade/vim-gitgutter'
    Plug 'morhetz/gruvbox'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
    Plug 'preservim/nerdtree'
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Config
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax enable
colorscheme gruvbox

" Settings
set autoindent
set autowrite
set clipboard+=unnamedplus
set colorcolumn=120
set conceallevel=0
set encoding=utf-8
set expandtab
set fileencodings=utf-8,ucs-bom,cp1250,iso-8859-1
set fileformats=unix,dos
set hidden
set hlsearch
set history=1000
set incsearch
set mouse=a
set noswapfile
set noshowmode
set nowrap
set number
set nrformats=
set secure
set scrolloff=4
set shiftwidth=4
set showcmd
set softtabstop=4
set tabstop=4
set ttyfast
set wildmenu
set wildmode=longest:full,full

" Plugin config
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline_detect_modified=1
let g:airline_powerline_fonts=1
let g:airline_statusline_onbottom=1
let g:airline_theme='tomorrow'

" Automatic stuff
if has("autocmd")
    " XML formatting
    autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

    " JSON formatting
	autocmd FileType json setlocal equalprg=python\ -m\ json.tool\ -\ 2>/dev/null
    
    " Enable text wrapping in the format options
    au FileType gitcommit set fo+=t
    
    " Force new line after 72 chars
    au FileType gitcommit set tw=72
    
    " Show vertical line at 72+1 columns
    au FileType gitcommit set colorcolumn=+1
    
    " Add extra colored vertical line at 51 columns (for title)
    au FileType gitcommit set colorcolumn+=51
    
    " Specify some indenting options
    au FileType gitcommit set nosmartindent
endif

" Key mappings
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#confirm() : "<TAB>"
