let mapleader = " "
set nocompatible

" -----------------------------------------------------
call plug#begin('~/.config/nvim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
map <C-b> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
" -----------------------------------------------------

" -----------------------------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
map <C-p> :GFiles<cr>
map <C-G> :Files<cr>
map <C-m> :Buffers<cr>
map <C-n> :Commands<cr>
map <C-s> :Ag<cr>
map <C-'> :Marks<cr>
let g:fzf_action = {
      \ 'return': 'tab split',
      \ 'ctrl-j': 'split',
      \ 'ctrl-l': 'vsplit' }
"let g:fzf_preview_window = []
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'relative': v:false, 'yoffset': 1.0 } }
" -----------------------------------------------------

" -----------------------------------------------------
"Plug 'sbdchd/neoformat'
" -----------------------------------------------------

" Themes 
" -----------------------------------------------------

"  Gruvbox
Plug 'gruvbox-community/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_transparent_bg = '1'

" Papercolor
Plug 'NLKNguyen/papercolor-theme'

" -----------------------------------------------------

" -----------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-css', 'coc-prettier']
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
nmap <silent> gn <Plug>(coc-diagnostic-prev)
nmap <silent> gN <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
map <leader>f :Prettier<cr>

" trigger completion with enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" -----------------------------------------------------

" -----------------------------------------------------
Plug 'preservim/nerdcommenter'
let g:NERDCustomDelimiters={
	\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
\}
" -----------------------------------------------------

" -----------------------------------------------------
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
" -----------------------------------------------------

Plug 'sheerun/vim-polyglot'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'pantharshit00/vim-prisma'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'

call plug#end()

" Lua 
lua << EOF
EOF

" Settings
set encoding=utf-8
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c

set mouse=a
set number relativenumber
set termguicolors
set background=dark
set signcolumn=number
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
colorscheme gruvbox
filetype plugin on
filetype indent on

" mappings
imap jj <Esc>

nmap <Leader>s :w<CR>
nmap <Leader>e :bd<CR>
nmap <Leader>fe :q!<CR>

" use Cntl + j,k,l,h to move between split
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" use arrow keys to resize split
map <Up> <C-W>-
map <Down> <C-W>+
map <Left> <c-w><
map <Right> <c-w>>

" paste g
map <Leader>y "+y
map <Leader>p "+p
