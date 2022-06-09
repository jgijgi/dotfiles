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
"""""" shift-insert
Plug 'ConradIrwin/vim-bracketed-paste'
"""""" Fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
let g:fzf_history_dir = '~/.local/share/fzf-history'
"""""" bufExplorer
Plug 'https://github.com/jlanzarotta/bufexplorer.git'
"""""" svn/git commands
Plug 'git://repo.or.cz/vcscommand'
"""""" p4 commands
Plug 'ngemily/vim-vp4'
if v:version > 800
"""""" vim-zoom
Plug 'dhruvasagar/vim-zoom'
set statusline+=%{zoom#statusline()}
endif
"""""" vim airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='gruvbox'
"""""" gruvbox colorscheme
Plug 'morhetz/gruvbox'
""""""
"Plug 'neoclide/coc.nvim'
"""""" easy align
"Plug 'junegunn/vim-easy-align'
"" Start interactive EasyAlign in visual mode (e.g. vipga)
"xmap ga <Plug>(EasyAlign)
"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"nmap ga <Plug>(EasyAlign)
"""""" nerdtree
"Plug 'preservim/nerdtree'
"""""" molokai colorscheme
"Plug 'tomasr/molokai'
"""""" cscope
"Plug 'gnattishness/cscope_maps'
""cscope avoid warning
"set nocscopeverbose
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ex mode is useless
nnoremap Q <nop>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=~/tmp,/var/tmp,/tmp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"line numbering
set number
"life is case insensitive
set ignorecase
"we want to search fast
"allow backspacing over everything in insert mode
set bs=indent,eol,start
set incsearch
set hlsearch
"nowrap
set nowrap
"completion and history
set history=10000
set wildmode=longest,list
"To avoid equalized windows when sp ou vs
set noequalalways
"tabulation stuff
set softtabstop=2
set shiftwidth=2
set expandtab
"split windows
set splitright
set splitbelow
"indentation
set autoindent
"tags
set tags=tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
"env variables can be part of file 
set isfname+={,}


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"needed for rxvt
nmap    <ESC>[5^    <C-PageUp>
nmap    <ESC>[6^    <C-PageDown>
nnoremap <C-PageDown> :bn!<CR>
nnoremap <C-PageUp> :bp!<CR>

map <ESC>[1;5D <C-Left>
map <ESC>[1;5C <C-Right>

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

" avoid gray/black different colors
set term=screen-256color

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" grep split result
function! s:GrepSplitResult(line)
  let parts = split(a:line, ':')
  " is there a line number?
  let lnum = 0
  if len(parts) >= 2
    " check if argument is a number
    "let isNumber = parts[1] =~ '[^0-9]'
    "if isNumber
      let lnum = parts[1]
    "endif
  endif
  " is there some text?
  let text = ""
  if len(parts) >= 3
    let text = join(parts[2:], ':')
  endif
  return { 'filename': parts[0]
         \,'lnum': lnum
         \,'text': text
         \ }
endfunction

function! s:grep_handler(lines)
  if len(a:lines) < 2 | return | endif
  let cmd = get({ 'ctrl-x': 'split'
                \,'ctrl-v': 'vertical split'
                \,'ctrl-t': 'tabe'
                \ } , a:lines[0], 'e' )
  let list = map(a:lines[1:], 's:GrepSplitResult(v:val)')
  for item in list
    execute cmd . ' +' . item.lnum . ' ' . item.filename
  endfor
endfunction

" Egrep
function! Egrep(query)
  " hack as bash aliases are not available here
  if a:query =~ "^ *greps"
    let tmp = substitute(a:query, "^ *greps", "grep -nr --color=always --incl=*.{hpp,hxx,h,cpp}", "g")
  elseif a:query =~ "^ *rgs"
    let tmp = substitute(a:query, "^ *rgs", "rg -n --color=always -g '*.{hpp,hxx,h,cpp}'", "g")
  elseif a:query =~ "^ *grep "
    let tmp = substitute(a:query, "^ *grep", "grep -nr --color=always ", "g")
  elseif a:query =~ "^ *rg "
    let tmp = substitute(a:query, "^ *rg", "rg -n --color=always ", "g")
  else
    let tmp = a:query
  end
  " https://misc.flogisoft.com/bash/tip_colors_and_formatting
  " color could be found at .vim/plugged/gruvbox/colors/gruvbox.vim (palette section)
  let cmd_to_run = "GREP_COLORS='ms=38;5;24:mc=01;31:sl=:cx=:fn=38;5;100:ln=38;5;88:bn=32:se=38;5;37' " . tmp
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
    call Egrep(query)
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab sw=4 sts=4
autocmd Filetype cpp set colorcolumn=132
autocmd Filetype cpp setlocal expandtab sw=4 sts=4
autocmd Filetype vhdl setlocal expandtab sw=4 sts=4

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Fn shortcuts
nnoremap <silent> <F1> :Vp4Diff <CR>
nnoremap <silent> <F2> :call Egrep('rg -w ' . expand('<cword>'))<CR>
nnoremap <silent> <F3> :call EgrepCustom()<CR>
map <F4> :Vp4Edit <CR>
map <F5> :DiffSaved <CR>
map <F11>  :w <CR>
map <F12>  :x <CR>

