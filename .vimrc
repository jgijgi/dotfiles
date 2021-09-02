""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" retreive automatically plug.vim
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" statusline
set statusline=\ %f%m%r%h%w\ %=%({%{&ff}\|%{(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\")}%k\|%Y}%)\ %([%l,%v][%p%%]\ %)
set laststatus=2

call plug#begin('~/.vim/plugged')
" bufExplorer
Plug 'https://github.com/jlanzarotta/bufexplorer.git'
" svn commands
Plug 'git://repo.or.cz/vcscommand'
" cscope
Plug 'gnattishness/cscope_maps'
" vim-zoom
Plug 'dhruvasagar/vim-zoom'
" molokai colorscheme
"Plug 'tomasr/molokai'
" gruvbox colorscheme
Plug 'morhetz/gruvbox'
set statusline+=%{zoom#statusline()}
call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ex mode is useless
nnoremap Q <nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/tmp,/var/tmp,/tmp

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"shortcuts
map <F12>  :x <CR>
map <F11>  :w <CR>
map <F2>   :s:^:--: <CR> :noh <CR>
map <S-F2> :s:^--:: <CR> :noh <CR>
map <F3>   :s:^: : <CR>  :noh <CR>
map <S-F3> :s:^ :: <CR>  :noh <CR>
map <F4>   :s/\([ ]\+\)\([A-Za-z_0-9]\+\)\([^:]\+\):.*$/\1\2\3=> \2,<CR>  :noh <CR>
"map <F4>   :s/\([ ]\+\)\([A-Za-z_0-9]\+\)\([^:]\+\):.*$/\1\2\3=> \2,:g | s:port:port map:g | s:entity:component:g | noh
"map <F4> :s/[   ]*\([a-z][a-z]*.*\)[    ][      ]*:.*/                 \1 => \1,/^M:s/  *,/,/^M^M
map <F5> i  CLOCK_PROC : process (clk, rst_n) <CR>  begin<CR>   if rst_n = '0' then <CR>   elsif rising_edge(clk) then <C


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"line numbering
set number
"life is case insensitive
set ignorecase
"we want to search fast
set incsearch
"nowrap
set nowrap
"completion and history
set history=10000
set wildmode=longest,list
"To avoid equalized windows when sp ou vs
set noequalalways
"tabualtion stuff
set softtabstop=4
set shiftwidth=4
set expandtab
"split windows
set splitright
set splitbelow
"indentation
set autoindent
"tags
set tags=tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"needed for rxvt
nmap    <ESC>[5^    <C-PageUp>
nmap    <ESC>[6^    <C-PageDown>
nnoremap <C-PageDown> :bn!<CR>
nnoremap <C-PageUp> :bp!<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"autocmd Filetype cpp set colorcolumn=80
"autocmd Filetype cpp setlocal expandtab sw=2 sts=2
"highlight ExtraWhitespace ctermbg=red guibg=red
"match ExtraWhitespace /\s\+$/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  "for the blinds, increase font size
  set guifont=DejaVu\ Sans\ Mono\ 12  
  "disabling bell, we are not deaf
  set noeb vb t_vb=
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"word completion
"work with ctrl-p and ctrl-n
"but map it on tabulation
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

"inoremap <tab> <c-r>=InsertTabWrapper("forward")<cr>
"the next line is commented in order to write a tabulation at any time with shift tab.
"inoremap <s-tab> <c-r>=InsertTabWrapper("backward")<cr>
"the TabWordCompletion search backward (latest written words)
inoremap <tab> <c-r>=InsertTabWrapper("backward")<cr>
"end completion
"
syntax enable

"command-line control-w as in bash
imap  <C-BS> <C-W>

"cscope avoid warning
set nocscopeverbose

"colorscheme koehler
"colorscheme desert
"colorscheme molokai
colorscheme gruvbox
set background=dark
"let g:colors_name="molokai"
"
"if exists("g:molokai_original")
"    let s:molokai_original = g:molokai_original
"else
"    let s:molokai_original = 0
"endif
