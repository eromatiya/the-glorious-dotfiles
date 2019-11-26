mapclear
let &t_ZM = "\e[3m"

" vim-plugs
call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim', { 'for': ['*html', '*css', 'vue'] }
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular'
Plug 'lambdalisue/vim-manpager'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'rust-lang/rust.vim'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'
Plug 'andymass/vim-matchup'
Plug 'jiangmiao/auto-pairs'
Plug 'posva/vim-vue'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'sebastianmarkow/deoplete-rust'
Plug 'Yggdroot/indentLine'
Plug 'nerdypepper/agila.vim'
Plug 'nerdypepper/vim-colors-plain'
Plug 'skywind3000/vim-keysound'
Plug 'vim-airline/vim-airline'

call plug#end()


" augroups
augroup indents
	autocmd!
	autocmd FileType less,css,html setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType text,markdown setlocal expandtab
	autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
augroup END


augroup highlight_follows_vim
	autocmd!
	autocmd FocusGained * set cursorline
	autocmd FocusLost * set nocursorline
augroup END

augroup mapppings
	autocmd!
	autocmd FileType less,css,html nnoremap <Leader>s viB:sort<cr>
augroup END

augroup restorecursor
	autocmd BufReadPost *
				\ if line("'\"") > 1 && line("'\"") <= line("$") |
				\   execute "normal! g`\"" |
				\ endif
augroup END

augroup nerdtree
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END


" general settings
set nobackup
set nowritebackup
set noswapfile " get rid of swapfiles everywhere
set dir=/tmp

syntax on

set omnifunc=syntaxcomplete#Complete
set completefunc=LanguageClient#complete
set list
filetype indent on
set laststatus=2
set nowrap
set noshowmode
set listchars=tab:│\ ,nbsp:␣,trail:∙,extends:>,precedes:<
set fillchars=vert:\│
set ignorecase
set smartcase
set sidescroll=40
set incsearch
set hlsearch
set undofile
set undodir=~/Documents/Neovim
set path+=**
set inccommand=split
set backspace=indent,eol,start
set hidden
set wildmenu
set foldmethod=manual
set complete=.,w,b,i,u,t,
set background=dark
set mouse=a

set wildignore+=.git,.hg,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
set wildignore+=*.mp3,*.oga,*.ogg,*.wav,*.flac
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf,*.cbr,*.cbz
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
set wildignore+=*.swp,.lock,.DS_Store,._*


"colorscheme agila

set shiftwidth=4     " indent = 4 spaces
set expandtab
set tabstop=4        " tab = 4 spaces
set softtabstop=4    " backspace through spaces


" statusline
let g:currentmode={
			\ 'n'  : 'NORMAL ',
			\ 'no' : 'N·OPERATOR PENDING ',
			\ 'v'  : 'VISUAL ',
			\ 'V'  : 'V·LINE ',
			\ '' : 'V·BLOCK ',
			\ 's'  : 'SELECT ',
			\ 'S'  : 'S·LINE ',
			\ '' : 'S·BLOCK ',
			\ 'i'  : 'INSERT ',
			\ 'R'  : 'REPLACE ',
			\ 'Rv' : 'V·REPLACE ',
			\ 'c'  : 'COMMAND ',
			\ 'cv' : 'VIM EX ',
			\ 'ce' : 'EX ',
			\ 'r'  : 'PROMPT ',
			\ 'rm' : 'MORE ',
			\ 'r?' : 'CONFIRM ',
			\ '!'  : 'SHELL ',
			\ 't'  : 'TERMINAL '}
hi PrimaryBlock ctermfg=03 ctermbg=00
hi SecondaryBlock ctermfg=03 ctermbg=00
hi Blanks ctermfg=03 ctermbg=00

highlight EndOfBuffer ctermfg=black ctermbg=black

set statusline=
set statusline+=%#PrimaryBlock#
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%#SecondaryBlock#
set statusline+=%{StatuslineGit()}
set statusline+=%#Blanks#
set statusline+=\ %t\
set statusline+=%(%m%)
set statusline+=%=
set statusline+=%#SecondaryBlock#
set statusline+=\ Ln
set statusline+=\ %l
set statusline+=,Col
set statusline+=\ %c\
set statusline+=%#PrimaryBlock#
set statusline+=\ %Y\

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction


" Functions
function! GetTabber()  " a lil function that integrates well with Tabular.vim
	let c = nr2char(getchar())
	:execute 'Tabularize /' . c
endfunction

let g:help_in_tabs = 1

nmap <silent> H  :let g:help_in_tabs = !g:help_in_tabs<CR>

" Only apply to .txt files...
augroup HelpInTabs
	autocmd!
	autocmd BufEnter  *.txt   call HelpInNewTab()
augroup END

" Only apply to help files...
function! HelpInNewTab ()
	if &buftype == 'help' && g:help_in_tabs
		"Convert the help window to a tab...
		execute "normal \<C-W>T"
	endif
endfunction


" mappings
let mapleader=' '


" nnoremap
nnoremap <Leader>o : only<cr>
nnoremap <Leader>l : Lines<cr>
nnoremap <Leader>b : Buffers<cr>
nnoremap <Leader>z : FZF<cr>
nnoremap <Leader>w : MtaJumpToOtherTag<cr>
nnoremap <Leader>t : call GetTabber()<cr>
nnoremap <Leader>r : RustRun<cr>
nnoremap <Leader><ESC> : nohlsearch<cr>
nnoremap <F2>      : NERDTreeToggle<cr>
nnoremap <C-l> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>
nnoremap H H:exec 'norm! '. &scrolloff . 'k'<cr>
nnoremap L L:exec 'norm! '. &scrolloff . 'j'<cr>
nnoremap  <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

cmap w!! %!sudo tee > /dev/null %

" vnoremap
vnoremap > >gv
vnoremap < <gv

" onoremap
onoremap ax a`
onoremap ix i`

" xnoremap
xnoremap + g<C-a>
xnoremap - g<C-x>

:command! WQ wq
:command! Wq wq
:command! Wqa wqa
:command! W w
:command! Q q

" abbreviations
abclear
iab #i #include
iab #d #define
cab dst put =strftime('%d %a, %b %Y')<cr>
cab vg vimgrep


" plugin settings

" emmet
let g:user_emmet_mode='a'
let g:user_emmet_leader_key='<C-X>'

" nerdtree
let g:NERDTreeMinimalUI           = 1
let g:NERDTreeWinPos              = 'left'
let g:NERDTreeWinSize             = 20
let g:NERDTreeStatusline          = "  "
let g:NERDTreeDirArrowExpandable  = '+'
let g:NERDTreeDirArrowCollapsible = '-'

" gitgutter
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added                     = '+'
let g:gitgutter_sign_modified                  = '±'
let g:gitgutter_sign_removed                   = '-'
let g:gitgutter_sign_removed_first_line        = '×'
let g:gitgutter_sign_modified_removed          = '×'

" ale
let g:ale_set_signs             = 1
let g:ale_use_deprecated_neovim = 1
let g:ale_sign_error            = '> '
let g:ale_sign_warning          = '! '

hi ALEErrorSign ctermfg=01 ctermbg=00
hi ALEWarningSign ctermfg=06 ctermbg=00

" rust.vim
let g:rustfmt_autosave = 0

" deoplete
let g:deoplete#enable_at_startup = 1

" deoplete rust
let g:deoplete#sources#rust#racer_binary='/home/gerome/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/gerome/leet/rust-lang/src'
nmap <buffer> gd <plug>DeopleteRustGoToDefinitionTab

" airline
let g:airline_powerline_fonts = 1

" fzf colors
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" indentLine
let g:indentLine_setColors = 0
let g:indentLine_char      = '┊'

" keysound
let g:keysound_enable = 1
let g:keysound_volume = 1000
let g:keysound_py_version = 3
let g:keysound_theme = 'typewriter'


" emmet
let g:user_emmet_mode='a'    "enable all function in all mode.