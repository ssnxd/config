let mapleader = " "
set nocompatible

call plug#begin('~/.config/nvim/plugged')

" -----------------------------------------------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
map <C-g> :FzfLua files<cr>
map <C-p> :FzfLua git_files<cr>
map <leader>b :FzfLua buffers<cr>
map <C-s> :FzfLua grep_project<cr>
" -----------------------------------------------------

" -----------------------------------------------------
Plug 'preservim/nerdtree'
map <C-b> :NERDTreeToggle<CR>
" -----------------------------------------------------

"  Gruvbox
Plug 'gruvbox-community/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
" -----------------------------------------------------

" -----------------------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'honza/vim-snippets'

let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-css', 'coc-go', 'coc-snippets']

nmap <silent> gn <Plug>(coc-diagnostic-prev)
nmap <silent> gN <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

nmap <leader>ac  <Plug>(coc-codeaction)

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> to accept selected completion item or notify coc.nvim to format
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction



" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')
map <Leader>f :Format<CR>

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')


" -----------------------------------------------------

" -----------------------------------------------------
Plug 'preservim/nerdcommenter'
" -----------------------------------------------------

" -----------------------------------------------------
Plug 'vim-airline/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
" -----------------------------------------------------

" -----------------------------------------------------
Plug 'sheerun/vim-polyglot'
" -----------------------------------------------------

Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'pantharshit00/vim-prisma'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'

call plug#end()

lua << EOF
require('indent_blankline').setup({
    show_first_indent_level = false,
    filetype_exclude = { 'help', 'packer', 'FTerm' },
    buftype_exclude = { 'terminal', 'nofile' },
})
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
set cursorline
set termguicolors
set background=dark
set signcolumn=yes
set splitbelow
set splitright
autocmd vimenter * ++nested colorscheme gruvbox
filetype plugin on
filetype indent on
" autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE

" mappings
imap jj <Esc>
map tn :bn<cr>
map tp :bp<cr>

nmap <Leader>s :w<CR>
nmap <Leader>e :bd<CR>
nmap <Leader>fe :q!<CR>

" use Cntl + j,k,l,h to move between split
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" use arrow keys to resize split
map <Up> <C-W>+
map <Down> <C-W>-
map <Left> <c-w><
map <Right> <c-w>>

" paste g
map <Leader>y "+y
map <Leader>p "+p
