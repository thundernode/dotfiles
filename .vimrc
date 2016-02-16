set nocompatible
" Pathogen
source ~/.vimmodules/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect('~/.vimmodules/{}')
" Aesthetic and comfort
syntax on
filetype plugin indent on
set number                        " show line numbers
set listchars=tab:>·,trail:·      " but only show tabs and trailing whitespace
set list                          " show invisible characters
color vividchalk
set encoding=utf-8                " Set default encoding to UTF-8
scriptencoding utf-8
set fileencoding=utf-8
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an auto indent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
set undofile                      " use persistant undo history
set undodir=~/.vimundo/           " Directory to store the undo history
if exists('+colorcolumn')
  nnoremap <leader>c :set colorcolumn=80<CR> "sets a column to show width of 80
endif

" Auto indent
nnoremap <leader>fef :normal! gg=G``<CR>
nnoremap <leader>fwf :%s/\s\+$<CR>
" fix git-gutter column
highlight SignColumn ctermbg=black
" Spelling
nnoremap <Leader>s :setlocal spell! spelllang=en_ca<CR>
""
"" Searching
""

set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... Unless they contain at least one capital letter

"Vim Airline
set noshowmode					" don't show mode (insert, normal)
set lazyredraw
set timeout timeoutlen=3000 ttimeoutlen=50	" eliminates lag when switching from insert to normal
set laststatus=2				" airline will not appear without this
let g:airline#extensions#tabline#enabled = 1	" Enables Tab Bar at the top of the file
let g:airline_theme='dark'			" Enables dark theme
let g:airline#extensions#whitespace#enabled = 0 " Speed up loading large files
let g:airline#extensions#tagbar#enabled = 0     " Speed up loading large files
let g:airline#extensions#disable_rtp_load = 1   " Speed up loading large files

if has("autocmd")
  " Drupal *.module and *.install files.
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
    autocmd BufRead,BufNewFile *.view set filetype=php
  augroup END
endif

"Automatically set paste mode for pasting
"taken from https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
