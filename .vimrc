"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
nnoremap <C-p> :Files<Cr>
" easy align
Plug 'junegunn/vim-easy-align'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" shift-insert
Plug 'ConradIrwin/vim-bracketed-paste'
"Fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" nerdtree
Plug 'preservim/nerdtree'
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ex mode is useless
nnoremap Q <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/tmp,/var/tmp,/tmp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"shortcuts
map <F12>  :x <CR>
map <F11>  :w <CR>
"map <F2>   :s:^:--: <CR> :noh <CR>
map <S-F2> :s:^--:: <CR> :noh <CR>
map <F3>   :s:^: : <CR>  :noh <CR>
map <S-F3> :s:^ :: <CR>  :noh <CR>
map <F4>   :s/\([ ]\+\)\([A-Za-z_0-9]\+\)\([^:]\+\):.*$/\1\2\3=> \2,<CR>  :noh <CR>
"map <F4>   :s/\([ ]\+\)\([A-Za-z_0-9]\+\)\([^:]\+\):.*$/\1\2\3=> \2,:g | s:port:port map:g | s:entity:component:g | noh
"map <F4> :s/[   ]*\([a-z][a-z]*.*\)[    ][      ]*:.*/                 \1 => \1,/^M:s/  *,/,/^M^M
map <F5> i  CLOCK_PROC : process (clk, rst_n) <CR>  begin<CR>   if rst_n = '0' then <CR>   elsif rising_edge(clk) then <C


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"line numbering
set number
"life is case insensitive
set ignorecase
"we want to search fast
set incsearch
set hlsearch
"highlight current line
set cursorline
"nowrap
set nowrap
"completion and history
set history=10000
set wildmode=longest,list
"To avoid equalized windows when sp ou vs
set noequalalways
"tabulation stuff
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"needed for rxvt
nmap    <ESC>[5^    <C-PageUp>
nmap    <ESC>[6^    <C-PageDown>
nnoremap <C-PageDown> :bn!<CR>
nnoremap <C-PageUp> :bp!<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_running")
  "for the blinds, increase font size
  set guifont=DejaVu\ Sans\ Mono\ 12  
  "disabling bell, we are not deaf
  set noeb vb t_vb=
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Specific colorscheme settings (must come before setting your colorscheme).
if !exists('g:gruvbox_contrast_light')
  let g:gruvbox_contrast_light='hard'
endif

" Set the color scheme.
colorscheme gruvbox
set background=dark

" Specific colorscheme settings (must come after setting your colorscheme).
if (g:colors_name == 'gruvbox')
  if (&background == 'dark')
    hi Visual cterm=NONE ctermfg=NONE ctermbg=237 guibg=#3a3a3a
  else
    hi Visual cterm=NONE ctermfg=NONE ctermbg=228 guibg=#f2e5bc
    hi CursorLine cterm=NONE ctermfg=NONE ctermbg=228 guibg=#f2e5bc
    hi ColorColumn cterm=NONE ctermfg=NONE ctermbg=228 guibg=#f2e5bc
  endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" grep split result
function! s:GrepSplitResult(line)
  let parts = split(a:line, ':')
  return { 'filename': parts[0]
         \,'lnum': parts[1]
         \,'text': join(parts[2:], ':')
         \ }
endfunction

function! s:grep_handler(lines)
  if len(a:lines) < 2 | return | endif
  let cmd = get({ 'ctrl-x': 'split'
                \,'ctrl-v': 'vertical split'
                \,'ctrl-t': 'tabe'
                \ } , a:lines[0], 'e' )
  let list = map(a:lines[1:], 's:GrepSplitResult(v:val)')
  let first = list[0]
  execute cmd . ' +' . first.lnum . ' ' . first.filename
endfunction

" Egrep
function! Egrep(option, query)
  " https://misc.flogisoft.com/bash/tip_colors_and_formatting
  " color could be found at .vim/plugged/gruvbox/colors/gruvbox.vim (palette section)
  let cmd_to_run = "GREP_COLORS='ms=38;5;24:mc=01;31:sl=:cx=:fn=38;5;100:ln=38;5;88:bn=32:se=38;5;37' grep -nr --color=always " . a:option . " " . a:query . " ./ "
  call fzf#run({
  \ 'source':  cmd_to_run,
  \ 'sink*':    function('s:grep_handler'),
  \ 'options': ['--ansi', '--prompt', '> ',
  \             '--multi', '--bind', 'alt-a:select-all,alt-d:deselect-all',
  \             '--expect=ctrl-t,ctrl-v,ctrl-x',
  \             '--color', 'fg:188,fg+:222,bg+:#3a3a3a,hl+:104'],
  \ 'down': '40%'
  \ })
endfunction

function! EgrepCustom()
  call inputsave()
  let query = input('Searching for: ')
  call inputrestore()
  if query != ""
    call Egrep('', query)
  else
    call Egrep('', expand('<cword>'))
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F2> :call EgrepCustom()<CR>

autocmd Filetype cpp nnoremap <silent> <F2> :call Egrep('--incl=*.{hpp,hxx,h,cpp}', expand('<cword>'))<CR>
autocmd Filetype cpp set colorcolumn=80
autocmd Filetype cpp setlocal expandtab sw=2 sts=2

autocmd Filetype vhdl nnoremap <silent> <F2> :call Egrep('--incl=*.vhd', expand('<cword>'))<CR>
