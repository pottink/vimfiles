set nocompatible

let mapleader = ","

call plug#begin()
Plug 'airblade/vim-gitgutter'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'elzr/vim-json'
Plug 'ervandew/supertab'
Plug 'iyuuya/denite-ale'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'joonty/vim-sauce'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kburdett/vim-nuuid'
Plug 'kristijanhusak/deoplete-phpactor'
Plug 'lumiliet/vim-twig'
Plug 'Matt-Deacalion/vim-systemd-syntax', { 'for': 'service' }
Plug 'matze/vim-move'
Plug 'morhetz/gruvbox'
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
Plug 'qpkorr/vim-bufkill'
Plug 'rhysd/conflict-marker.vim'
Plug 'romainl/vim-cool'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/neomru.vim'
Plug 'StanAngeloff/php.vim'
Plug 'tobyS/pdv'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'yggdroot/indentline'
call plug#end()

" vim settings
set autoindent
set autowrite
set clipboard+=unnamedplus
set colorcolumn=120       " show column 120 in different color
set conceallevel=0        " disable json concealing
set encoding=utf-8        " encoding
set expandtab
set fileencodings=utf-8,ucs-bom,cp1250,iso-8859-1
set fileformats=unix,dos
set foldlevelstart=0
set foldtext=general#FoldText()
set hidden                " hide buffer even when changed
set hlsearch              " highlight search
set history=1000          " remember 1000 history entries
set incsearch
set mouse=a               " add mouse support
set nowrap                " no wrapping lines
set noswapfile            " remove swap files
set number                " set line numbers
set nrformats=
set secure
set scrolloff=4           " keep at least 4 lines above or below the cursor
set shiftwidth=4
set showcmd
set showmode
set softtabstop=4
set tabstop=4
set ttyfast               " send more data for redrawing
set wildmenu              " enable the command completion menu
set wildmode=longest,full " command completion longest common part, then all

if (!has("nvim"))
    set pyxversion=3      " use python3 first
endif

" Autostart stuff
if has("autocmd")
	autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
	autocmd FileType json setlocal equalprg=python\ -m\ json.tool\ -\ 2>/dev/null
    autocmd FileType php setlocal omnifunc=phpactor#Complete

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

    au FileType denite call s:denite_my_settings()

    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

" Save read-only files
cmap w!! w !sudo tee % >/dev/null

" syntax
syntax on
syntax sync minlines=300
set synmaxcol=300

" filetype
filetype on
filetype plugin on
filetype indent on

" Quick jumping between splits
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Open new splits easily
map vv <C-W>v
map ss <C-W>s
map Q  <C-W>q

" Open splits on the right and below
set splitbelow
set splitright

" colorscheme
set background=dark
colorscheme gruvbox
let g:solarized_termcolors=256

" Insert UUID
nmap <Leader><Leader>U :r !uuidgen<CR>

" vim-airline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_detect_modified = 1
let g:airline_powerline_fonts = 1
let g:airline_statusline_onbottom = 1
let g:airline_theme='jellybeans'

" fzf
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)

" Override Colors command. You can safely do this in your .vimrc as fzf.vim
" will not override existing commands.
command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --line-number --no-heading --color=always --ignore-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:70%:hidden', '?'),
  \   <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})"
nmap <silent> <leader>f :FZF<cr>
nnoremap <silent> <C-f> :FZF<cr>

" nerdtree
map <C-P> :NERDTreeFocus<CR>:wincmd w<CR>:CtrlP<CR>
nnoremap <silent> <leader>nt :NERDTree<Enter>
nnoremap <silent> <leader>ntf :NERDTreeFind<Enter>
nnoremap <silent> <leader>ntt :NERDTreeToggle<Enter>

let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
let NERDTreeCascadeSingleChildDir = 0

" easy align
xmap ga <Plug>(EasyAlign)
nmap :ga <Plug>(EasyAlign)

" phpactor
let g:phpactorPhpBin = '/usr/bin/php'
let g:phpactorOmniAutoClassImport = v:true
let g:deoplete#enable_at_startup = 1

nmap <Leader>u :call phpactor#UseAdd()<CR>
nmap <Leader>mm :call phpactor#ContextMenu()<CR>
nmap <Leader>nn :call phpactor#Navigate()<CR>
nmap <Leader>o :call phpactor#GotoDefinition()<CR>
nmap <Leader>K :call phpactor#Hover()<CR>
nmap <Leader>tt :call phpactor#Transform()<CR>
nmap <Leader>cc :call phpactor#ClassNew()<CR>
nmap <Leader>fr :call phpactor#FindReferences()<CR>
nmap <silent><Leader>ee :call phpactor#ExtractExpression(v:false)<CR>
vmap <silent><Leader>ee :<C-U>call phpactor#ExtractExpression(v:true)<CR>
vmap <silent><Leader>em :<C-U>call phpactor#ExtractMethod()<CR>"

" Remove whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Open terminal below
nmap <silent> <leader>bt :below term<cr>

" bufkill
nmap <silent> <leader>bb :BB<cr>
nmap <silent> <leader>bd :BD<cr>
nmap <silent> <leader>bn :BF<cr>
nmap <silent> <leader>bun :BUN<cr>

" phpdoc
let g:pdv_template_dir = $HOME ."/.vim/bundle/pdv/templates_snip"
" nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>

" ale php
let g:ale_php_php_executable = '/usr/bin/php'
let g:ale_php_phpcs_executable = '/home/jelle/.config/composer/vendor/bin/phpcs'
let g:ale_php_phpmd_executable = '/home/jelle/.config/composer/vendor/bin/phpmd'
let g:ale_php_langserver_executable = 'php-language-server.php'
let g:ale_php_phan_executable = '/home/jelle/.config/composer/vendor/bin/phan'
let g:ale_php_phpstan_executable = '/home/jelle/.config/composer/vendor/bin/phpstan --level=4'
let g:ale_php_psalm_executable = '/home/jelle/.config/composer/vendor/bin/psalm'
let g:ale_linters= {'php': ['php', 'psalm', 'phpstan', 'phpcs', 'phpmd']}

" Just filename in the tabline
let g:airline#extensions#tabline#fnamemod = ':t'

" Easier tab/buffer switching
nmap <leader>& <Plug>AirlineSelectTab1
nmap <leader>é <Plug>AirlineSelectTab2
nmap <leader>" <Plug>AirlineSelectTab3
nmap <leader>' <Plug>AirlineSelectTab4
nmap <leader>( <Plug>AirlineSelectTab5
nmap <leader>' <Plug>AirlineSelectTab6
nmap <leader>è <Plug>AirlineSelectTab7
nmap <leader>! <Plug>AirlineSelectTab8
nmap <leader>ç <Plug>AirlineSelectTab9

" Move key
let g:move_key_modifier = 'C'

" ultisnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vimfiles/UltiSnips']

" sort use block
nmap <leader>su mugg/use<CR>vip:sort u<CR>:nohlsearch<CR>'u'

" vim-cool
let g:CoolTotalMatches = 1

" vim-uuid
let g:nuuid_no_mappings = 1
nnoremap <Leader><Leader>u <Plug>Nuuid

" Denite
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
                \ denite#do_map('do_action')
"    nnoremap <silent><buffer><expr> d
"                \ denite#do_map('do_action', 'delete')
"    nnoremap <silent><buffer><expr> p
"                \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
                \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
                \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
                \ denite#do_map('toggle_select').'j'
    nnoremap <silent><buffer><expr> <C-v>
                \ denite#do_map('do_action', 'vsplit')
endfunction

call denite#custom#option('default', {
            \ 'prompt': '❯'
            \ })
call denite#custom#var('file/rec', 'command',
            \ ['rg', '--files', '--glob', '!.git', ''])
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
            \ ['-i', '--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',
            \'noremap')
call denite#custom#map('normal', '<Esc>', '<NOP>',
            \'noremap')
"  call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>',
"        \'noremap')
"  call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>',
"        \'noremap')
call denite#custom#map('normal', 'dw', '<denite:delete_word_after_caret>',
            \'noremap')
call denite#custom#map('normal', '<Down>', '<denite:move_to_next_line>',
            \'noremap')
call denite#custom#map('normal', '<Up>', '<denite:move_to_previous_line>',
            \'noremap')
nnoremap <C-p> :Denite file/rec<cr>
nnoremap <C-m> :Denite file_mru<cr>
nnoremap <C-b> :Denite buffer<cr>
nnoremap <C-g> :Denite grep<cr>
nnoremap <C-s> :DeniteCursorWord grep<cr>

" auto format xml
au FileType xml exe ":silent %!xmllint --format --recover - 2>/dev/null"

" remap terminal normal key
tnoremap <Leader><Leader>tn <C-W>N
