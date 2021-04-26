set nocompatible

"autoinstall vim plug
"check for uninstalled plugins
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"auto install plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

"statusline/bufferline
Plug 'itchyny/lightline.vim'
Plug 'ojroques/vim-scrollstatus'

"icons
Plug 'ryanoasis/vim-devicons'
""Plug 'kyazdani42/nvim-web-devicons'

"fuzzy search + files
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }

"minimap // enable when supported in openGL neovide
""Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

"git
Plug 'tpope/vim-fugitive', { 'on': [] }
Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterToggle' }

"unix commands
""Plug 'tpope/vim-eunuch'

"start dash + give a tip
Plug 'glepnir/dashboard-nvim'

"distraction free/zen mode
Plug 'junegunn/goyo.vim', { 'on': 'Goyo'}
Plug 'junegunn/limelight.vim', { 'on': 'Goyo'}

"syntax/themes (treesitter replacing polygot)
""Plug 'arcticicestudio/nord-vim'
"Plug 'drewtempelmeyer/palenight.vim'
""Plug 'Brettm12345/moonlight.vim'
Plug 'GustavoPrietoP/doom-one.vim'
""Plug 'marko-cerovac/material.nvim'

"markdown writing
Plug 'kana/vim-textobj-user', {'for': ['markdown', 'text']}
Plug 'preservim/vim-textobj-quote', {'for': ['markdown', 'text']}
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

"lines on indents + auto pairs+ multiple cursors
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesToggle' }
"Plug 'jiangmiao/auto-pairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

"linting + lsp
"Plug 'dense-analysis/ale', { 'on':  'ALEToggle' }
"Plug 'maximbaz/lightline-ale', { 'on':  'ALEToggle' }
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'

"rich presence
""Plug 'andweeb/presence.nvim'
call plug#end()

"set true colors for term + vim
if has('termguicolors')
  set termguicolors
endif
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

"theme info
set background=dark
""let g:material_style = 'deep ocean'
""let g:material_terminal_italics = 1
""colorscheme moonlight
""colorscheme nord
colorscheme doom-one

"material theme
"let g:material_italic_comments = v:true
"let g:material_italic_keywords = v:true
"let g:material_italic_functions = v:true
"let g:material_italic_variables = v:true
"let g:material_contrast = v:false
"let g:material_borders = v:false
"colorscheme material

"enable syntax
syntax on

"set 256 colors
set t_Co=256

"Neovide + gui
set guifont=SFMono\ Nerd\ Font:h13
""set guifont=FiraCode\ Nerd\ Font:h13
let g:neovide_cursor_antialiasing=v:false
let g:neovide_fullscreen=v:true
let g:neovide_refresh_rate=60
let g:neovide_keyboard_layout="qwerty"

"numrow transparent, vert split line transparent.
highlight clear SignColumn
hi VertSplit ctermfg=1 ctermbg=NONE cterm=NONE
set fillchars+=vert:┊

"highlight current number
set number relativenumber
""set number
set cursorline
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
hi clear CursorLine
"Reset cursorline everytime colorscheme updates because stupid vim
augroup CLClear
    autocmd! ColorScheme * hi clear CursorLine
augroup END

"auto switch number depending on mode + show numbers in Goyo command mode
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"various settings
set autoindent                 " Minimal automatic indenting for any filetype.
set backspace=indent,eol,start " Proper backspace behavior.
""set hidden                     " Possibility to have more than one unsaved buffers.
set incsearch                  " Incremental search, hit `<CR>` to stop.
set ruler                      " Shows the current line number at the bottom-right
set wildmenu                   " Better autcomplete
set wildmode=longest,list,full

" Indents word-wrapped lines as much as the 'parent' line
set breakindent
" Ensures word-wrap does not split words
set formatoptions=l
set lbr

"macos clipbard
set clipboard=unnamed
"remove insert from bottom left
set noshowmode
"always display taline and bufferlie"
set laststatus=2
set showtabline=2
"no swap files, no backus
set noswapfile
set nobackup

"lightline setup
"colorscheme, active, components, ale, seperators
"Colors, [doom, moonlight = ayu_mirage], [nord = nord], [material ocean =
"material]
"
let g:lightline = {
    \ 'colorscheme': 'ayu_mirage',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             ['gitbranch',  'filetype', 'filename', 'wordcount', 'modified', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ] ],
    \   'right': [ ['fileformat'],
    \              [ 'relativepath', 'readonly', 'percent', 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]]
    \ },
    \ 'component_function': {
    \    'filetype': 'MyFiletype',
    \    'fileformat': 'MyFileformat',
    \    'wordcount': 'WordCount',
    \    'gitbranch': 'FugitiveHead',
    \    'readonly': 'LightlineReadonly',
    \    'percent' : 'ScrollStatus',
    \ },
    \ 'component_expand': {
    \   'linter_checking': 'lightline#ale#checking',
    \   'linter_infos': 'lightline#ale#infos',
    \   'linter_warnings': 'lightline#ale#warnings',
    \   'linter_errors': 'lightline#ale#errors',
    \   'linter_ok': 'lightline#ale#ok',
    \ },
    \ 'component_type': {
    \   'linter_checking': 'right',
    \   'linter_infos': 'right',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error',
    \   'linter_ok': 'right',
    \ },
    \ 'component': {
    \   'lineinfo': '%3l:%-2v%<',
    \ },
    \ 'separator': { 'left': '', 'right': '' },
    \ 'subseparator': { 'left': '', 'right': '' }
    \ }

"add devicon to lightline
function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction
function! MyFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

"create function to get read only
function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

"create function to get workdcount
function! WordCount()
    let currentmode = mode()
    if !exists("g:lastmode_wc")
        let g:lastmode_wc = currentmode
    endif
    " if we modify file, open a new buffer, be in visual ever, or switch modes
    " since last run, we recompute.
    if &modified || !exists("b:wordcount") || currentmode =~? '\c.*v' || currentmode != g:lastmode_wc
        let g:lastmode_wc = currentmode
        let l:old_position = getpos('.')
        let l:old_status = v:statusmsg
        execute "silent normal g\<c-g>"
        if v:statusmsg == "--No lines in buffer--"
            let b:wordcount = 0
        else
            let s:split_wc = split(v:statusmsg)
            if index(s:split_wc, "Selected") < 0
                let b:wordcount = str2nr(s:split_wc[11])
            else
                let b:wordcount = str2nr(s:split_wc[5])
            endif
            let v:statusmsg = l:old_status
        endif
        call setpos('.', l:old_position)
        return b:wordcount
    else
      return b:wordcount
    endif
endfunction

let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

"doom
let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:#bbc2cf,bg:#3c4557,hl:#baacff,fg+:#bbc2cf,bg+:#3c4557,hl+:#5B6268 --color=info:#3c4557,prompt:#3c4557,pointer:#c678dd,marker:#3c4557,spinner:#3c4557,header:-1 --layout=reverse  --margin=1,4'

"nord
""let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:#bbc2cf,bg:#414C60,hl:#baacff,fg+:#bbc2cf,bg+:#414C60,hl+:#5B6268 --color=info:#414C60,prompt:#414C60,pointer:#c678dd,marker:#414C60,spinner:#414C60,header:-1 --layout=reverse  --margin=1,4'

"material ocean
""let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:#bbc2cf,bg:#10141c,hl:#baacff,fg+:#bbc2cf,bg+:#10141c,hl+:#5B6268 --color=info:#10141c,prompt:#10141c,pointer:#c678dd,marker:#10141c,spinner:#10141c,header:-1 --layout=reverse  --margin=1,4'

let g:fzf_layout = { 'window': 'call FloatingFZF()' }

""hardcoded atm sorry
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(30)
  let width = float2nr(135)
  let horizontal = float2nr((&columns - width) / 2)
  ""let vertical = 1
  let vertical = float2nr((&lines - height) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

" Floating Term
let s:float_term_border_win = 0
let s:float_term_win = 0
function! FloatTerm(...)
  " Configuration
  let height = float2nr((&lines - 2) * 0.6)
  let row = float2nr((&lines - height) / 2)
  let width = float2nr(&columns * 0.6)
  let col = float2nr((&columns - width) / 2)
  " Border Window
  let border_opts = {
    \ 'relative': 'editor',
    \ 'row': row - 1,
    \ 'col': col - 2,
    \ 'width': width + 4,
    \ 'height': height + 2,
    \ 'style': 'minimal'
    \ }
  " Terminal Window
  let opts = {
    \ 'relative': 'editor',
    \ 'row': row,
    \ 'col': col,
    \ 'width': width,
    \ 'height': height,
    \ 'style': 'minimal'
    \ }
  let top = "╭" . repeat("─", width + 2) . "╮"
  let mid = "│" . repeat(" ", width + 2) . "│"
  let bot = "╰" . repeat("─", width + 2) . "╯"
  let lines = [top] + repeat([mid], height) + [bot]
  let bbuf = nvim_create_buf(v:false, v:true)

  call nvim_buf_set_lines(bbuf, 0, -1, v:true, lines)
    let s:float_term_border_win = nvim_open_win(bbuf, v:true, border_opts)
    let buf = nvim_create_buf(v:false, v:true)
    let s:float_term_win = nvim_open_win(buf, v:true, opts)

    " Styling
  hi FloatWinBorder guifg=#bbc2cf
  call setwinvar(s:float_term_border_win, '&winhl', 'Normal:FloatWinBorder')
  call setwinvar(s:float_term_win, '&winhl', 'Normal:Normal')

  if a:0 == 0
    terminal
  else
    call termopen(a:1)
  endif

  startinsert
  " Close border window when terminal window close
  autocmd TermClose * ++once :bd! | call nvim_win_close(s:float_term_border_win, v:true)
endfunction

"map FloatermNew to new terminal
command FloatermNew call FloatTerm()

""always mouse available
"if has('mouse')
"  set mouse=a
"endif

"fzf
nnoremap <silent> <C-p> :call fzf#vim#files('.', {'options': '--prompt ""'})<CR>

"basic autopair
inoremap " ""<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

"remove arrow keys from normal mode (forces to use hjkl)
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

"jk to exit instead
inoremap jk <esc>
cnoremap jk <C-C>
" Note: In command mode mappings to esc run the command for some odd
" historical vi compatibility reason. We use the alternate method of
" existing which is Ctrl-C

"basic vim wm (ctrl + hjkl to move/create)
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction
nnoremap <silent> <C-h> :call WinMove('h')<CR>
nnoremap <silent> <C-j> :call WinMove('j')<CR>
nnoremap <silent> <C-k> :call WinMove('k')<CR>
nnoremap <silent> <C-l> :call WinMove('l')<CR>

"f5 to run current filetype
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
exec "w"
if &filetype == 'c'
exec "!gcc % -o %<"
exec "!time ./%<"
elseif &filetype == 'cpp'
exec "!g++ % -o %<"
exec "!time ./%<"
elseif &filetype == 'java'
exec "!javac %"
exec "!time java -cp %:p:h %:t:r"
elseif &filetype == 'sh'
exec "!time bash %"
elseif &filetype == 'python'
exec "!time python3 %"
elseif &filetype == 'html'
exec "!firefox % &"
elseif &filetype == 'go'
exec "!go build %<"
exec "!time go run %"
endif
endfunc

"lightline ale
let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c "

"just ale icons
let g:ale_enabled = 0

"let g:ale_sign_error = '×'
"let g:ale_sign_warning = '»'
let g:ale_sign_warning = "\uf071"
let g:ale_sign_error = "\uf05e"
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow

let g:ale_linters = {
            \   'mail': ['proselint'],
            \   'markdown': ['proselint', 'languagetool'],
            \   'text': ['proselint', 'languagetool'],
	    \   'python': ['pyls', 'autoimport', 'flake8', 'yapf'],
            \   }
let g:ale_fixers = {
\   '*':          ['remove_trailing_lines', 'trim_whitespace'],
\}

let g:ale_lint_on_text_changed = 'never'
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1

"make cursor line -> block
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"anti-delay for above
set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast

"make statusline transparent (kindof working)
autocmd VimEnter * call SetupLightlineColors()
function SetupLightlineColors() abort

" transparent background in statusbar
let l:palette = lightline#palette()
let l:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let l:palette.insert.middle = l:palette.normal.middle
let l:palette.visual.middle = l:palette.normal.middle
let l:palette.inactive.middle = l:palette.normal.middle
let l:palette.inactive.middle = l:palette.normal.middle
let l:palette.tabline.middle = l:palette.normal.middle
call lightline#colorscheme()
endfunction

"indentline
let g:indentLine_enabled = 0
let g:indentLine_char_list = ['┊']

"NERDTree
"enable icons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:NERDTreeHighlightCursorline = 0
"better ui
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let g:NERDTreeDirArrowExpandable = '»'
let g:NERDTreeDirArrowCollapsible = '«'
"let me see dotfiles
let NERDTreeShowHidden=1

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

"dashboard (use fzf + doom logo)
let g:dashboard_default_executive ='fzf'
let g:dashboard_custom_header =<< trim END
=================     ===============     ===============   ========  ========
\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||
||.=='    _-'                                                     `' |  /==.||
=='    _-'                        N E O V I M                         \/   `==
\   _-'                                                                `-_   /
 `''                                                                      ''`
END

"minimap
let g:minimap_width = 10
let g:minimap_auto_start = 1
let g:minimap_auto_start_win_enter = 1

"limelight
let g:limelight_default_coefficient = 0.7
let g:limelight_paragraph_span = 0

"discord presence
"let g:presence_auto_update       = 1
"let g:presence_editing_text      = "Editing %s"
"let g:presence_workspace_text    = "Working on %s"
"let g:presence_neovim_image_text = "The One True Text Editor"
"let g:presence_main_image        = "neovim"
"let g:presence_client_id         = "793271441293967371"
"let g:presence_debounce_timeout  = 15

"Vim multi-cursors
"use alt instead of ctrl
let g:VM_maps = {}
let g:VM_default_mappings = 0
let g:VM_maps["Add Cursor Down"]             = '<A-Down>'
let g:VM_maps["Add Cursor Up"]               = '<A-Up>'

"vim markdown
let g:vim_markdown_folding_disabled = 1
"quote stuff (curly instead of normal "", qc to autocorrect)
filetype plugin on       " may already be in your .vimrc
nnoremap <silent> qr <Plug>ReplaceWithCurly
"spell check for only markdown
autocmd FileType markdown setlocal spell
"set to conceal formatting by default to not clutter
set conceallevel=2

augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType textile call textobj#quote#init()
  autocmd FileType text call textobj#quote#init({'educate': 0})
augroup END

"lazy load vim-fuigitive
command! Gstatus call LazyLoadFugitive('Gstatus')
command! Gdiff call LazyLoadFugitive('Gdiff')
command! Glog call LazyLoadFugitive('Glog')
command! Gblame call LazyLoadFugitive('Gblame')
function! LazyLoadFugitive(cmd)
  call plug#load('vim-fugitive')
  call fugitive#detect(expand('%:p'))
  exe a:cmd
endfunction

"limelight +goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

autocmd! User GoyoLeave Limelight!
