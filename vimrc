"---------------------------------------------------------------------
"
"   Vaughan's
"   vimrc - VIM configuration file
"
"
" Portions liberated from various other vimrc's out in the
" wild, but special credit to:
"
" - Amir Salihefendic @ http://amix.dx
" - Nick Santana
" - Andrew Matteson
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"    -> Plug-in settings
"---------------------------------------------------------------------


"---------------------------------------------------------------------
" => General
"---------------------------------------------------------------------

" Set shell if on windows box
if has("win32")
    set shell=cmd.exe
endif

" Enable Pathogen plugin
" have pathogen start up first to load plugins
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()
Helptags

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on

" set line wrap
set wrap

" set spell checker
set spell

" maximize in GUI on launch
if has("gui_running")
  " GUI is running or is about to start.
  " Maximize gvim window (for an alternative on Windows, see simalt below).
  set lines=999 columns=999
else
  " This is console Vim.
  if exists("+lines")
    set lines=50
  endif
  if exists("+columns")
    set columns=100
  endif
endif

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let g:mapleader = "\<Space>"
let mapleader = "\<Space>"
let maplocalleader = "\<cr>"

" Fast saving
nmap <leader>w :w!<cr>

"---------------------------------------------------------------------
" => VIM user interface
"---------------------------------------------------------------------

" Displays line numbers
set relativenumber
set number

"Always show current position
set ruler

" Set scroll offset - keeps cursor from going all the way to top or
" bottom when moving vertically using j/k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/menu.vim

" Turn on the WiLd menu - for bash-like file name completion
set wildmode=longest,list
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" un-Highlight with double escape
nnoremap <esc> :nohlsearch<cr>:<esc>

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Add a bit extra margin to the left
set foldcolumn=1

" Set split to open on the right
set splitright

" Easier split navigation
nnoremap <leader>j <C-W><C-j>
nnoremap <leader>k <C-W><C-k>
nnoremap <leader>l <C-W><C-l>
nnoremap <leader>h <C-W><C-h>

" Swap windows around using a similar motion as navigating, just hold shift
" during key command
nnoremap <leader>J <C-W><S-j>
nnoremap <leader>K <C-W><S-k>
nnoremap <leader>L <C-W><S-l>
nnoremap <leader>H <C-W><S-h>

"---------------------------------------------------------------------
" => Colors and Fonts
"---------------------------------------------------------------------

" Enable syntax highlighting
syntax enable

try
    colorscheme lucius
    LuciusDark
catch
endtry

" Change highlighting colors (I use column highlighting and default fg color in searches
" can be lost, so make it white-er)
highlight search guifg=#F7F7F7
highlight IncSearch guibg=#006bd6
highlight IncSearch guifg=#F7F7F7

" Break up strings from other constants
highlight constant guifg=#8787af
highlight string guifg=#AFAF87
highlight character guifg=#AFAF87

" Set extra options when running in GUI mode
" Note: this unix stuff was when I was shooting for one vimrc file to rule them all.
"       I've abandoned that approach, but leaving here in case I give it another shot
"       someday.
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
    if has("win32")
        set guifont=Ubuntu_Mono_derivative_Powerlin:h11:cANSI
    else
        if has("unix")
            set guifont=Ubuntu\ Mono\ 11
        endif
    endif
endif

" Set utf8 as standard encoding
set encoding=utf8

"Highlight trailing whitespace
"let g:c_space_errors=1

"Vertical lines - set up for Garmin code conventions & spacings
set colorcolumn=25,37,61,71,81,93
highlight ColorColumn guibg=grey22


"---------------------------------------------------------------------
" => Files, backups and undo
"---------------------------------------------------------------------

" Turn backup off, since most stuff is in git or SVN anyway...
set nobackup
set nowb
set noswapfile

" Set to auto read when a file is changed from the outside
set autoread

" Set autowrite for automatically saving the file when
" transitioning
set autowrite


"---------------------------------------------------------------------
" => Text, tab and indent related
"---------------------------------------------------------------------

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" set text width to 120
set tw=120
" except for git commit files
au FileType gitcommit set tw=72

" set linebreak to break after word, not mid-word
set linebreak

" Auto indent
set ai
" Smart indent
set si
" Wrap lines
set wrap


"---------------------------------------------------------------------
" => Visual mode related
"---------------------------------------------------------------------

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('b', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>


"---------------------------------------------------------------------
" => Moving around, tabs, windows and buffers
"---------------------------------------------------------------------
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

"use jk as an escape combination in insert mode
inoremap jk <esc>

" disable arrow keys because they are a crutch
nnoremap <Left> <nop>
nnoremap <Up> <nop>
nnoremap <Right> <nop>
nnoremap <Down> <nop>

" prevent the arrow keys in insert mode as well
inoremap <Left> <nop>
inoremap <Up> <nop>
inoremap <Right> <nop>
inoremap <Down> <nop>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
" DISABLED because I don't use and many conflicts with using space as leader,
" but leaving here in case I want to use something similar later.
" map <space> /
" map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Maps leader-bb to show list of buffers and waits on number
" to switch to.
map <leader>bb :ls<CR>:b<Space>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Use virtual edit to allow walking around anywhere
set virtualedit=all


"---------------------------------------------------------------------
" => Status line
"---------------------------------------------------------------------

" Always show the status line
set laststatus=2

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l


"---------------------------------------------------------------------
" => Editing mappings
"---------------------------------------------------------------------

" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()


"---------------------------------------------------------------------
" => Ack searching and cope displaying
"    requires ack.vim - it's much better than vimgrep/grep
"---------------------------------------------------------------------

" When you press gv you Ack after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open Ack and put the cursor in the right position
map <leader>g :Ack

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with Ack, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>

"---------------------------------------------------------------------
" => Spell checking
"---------------------------------------------------------------------

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"---------------------------------------------------------------------
" => Misc
"---------------------------------------------------------------------

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

"---------------------------------------------------------------------
" => Helper functions
"---------------------------------------------------------------------
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction



"---------------------------------------------------------------------
" => Plug-ins
"---------------------------------------------------------------------

"-----------------------------------
" -> Plug-in: Airline
"-----------------------------------
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 's'


"-----------------------------------
" -> Plug-in: Auto-Save
"-----------------------------------
let g:auto_save_in_insert_mode=0
let g:auto_save=1


"-----------------------------------
" -> Plug-in: Cscope
"-----------------------------------
" Found a trick for asynchronous running and updating, so what we do is call
" cscope to update the file databases, then once it's done it calls back into
" Vim to reset or add the cscope database.
"nnoremap <f12> :!start /min ctags -R --fields=+liaS --c-kinds=+px --c++-kinds=+p --extra=+q --languages=c,c++ --excmd=n . <cr>
nnoremap <f12> :exec 'silent !start /b cmd /c "
\                 cscope.exe -R -b -q
\                 & vim --servername '.v:servername.' --remote-expr UpdateCscope()
\                 "'<cr>
\                 \|:silent !start /b ctags -R --fields=+liaS --c-kinds=+px --c++-kinds=+p
\                          --extra=+q --languages=c,c++ --excmd=n . <cr>

function! UpdateCscope()
cscope kill -1
cscope add cscope.out
endfunction

if filereadable("cscope.out")
cscope add cscope.out
endif
nnoremap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ce :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>cf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <leader>ci :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <leader>cd :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>vs :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>vg :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>vc :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>vt :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ve :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>vf :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <leader>vi :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <leader>vd :vert scs find d <C-R>=expand("<cword>")<CR><CR>


"-----------------------------------
" -> Plug-in: Ctags
"-----------------------------------
" map ctags to open in vertical split or tab
:set tags=./tags,tags;$HOME
map <C-\> :tag <CR>:exec("tag ".expand("<cword>"))<CR>
map <leader><C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>


"-----------------------------------
" -> Plug-in: CTRL-P
"-----------------------------------
" For G2xxx with all the submodules the 'r' option
" locks your searches down in your local submodule
" so just use 'a' so we can see all files from where
" vim was started.
let g:ctrlp_working_path_mode = 'a'

" I just want to open by file name so ignore
" path matching
"let g:ctrlp_by_filename = 1

" I don't like ctrl, if i don't need it
" so remap CTRL-P to be easier to open with leader-f
let g:ctrlp_map = '<leader>f'

"ignore binaries
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn|sbas)$',
    \ 'file': '\v\.(lnk|ucfg|sln|o32|o|via|exe|so|dll|bmp|obj|rsp|oxml|sbmp|lib|pyc)$',
    \ }

"-----------------------------------
" -> Plug-in: Easytags
"  Note to myself: random slow-downs trace back to easytags - not sure I
"  want to keep using.
"-----------------------------------
:set tags=./tags,tags;
" disable the easytags report to keep real messages on command line
let g:easytags_suppress_report=1


"-----------------------------------
" -> Plug-in: Fugitive
"-----------------------------------
" Going to use the 'g' prefix to signify git commands
" So basically everything will be <leader>g<something>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gl :Glog<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gm :Gvdiff master<CR>

" To prevent me accidentally making changes on the master branch I only
" blindly push branches if they aren't master.
" May need to update this to ignore 'development/**' and 'production/**'
nnoremap <leader>gp :call Safepush()<CR>
function! Safepush()
let l:branchname = fugitive#head()
if l:branchname ==? 'master'
    echo 'Not pushing, this is a mainline branch: "' . l:branchname . '"'
else
    execute ":Git push"
endif
endfunction

" Add the branch to the status line
set laststatus=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P


"-----------------------------------
" -> Plug-in: Garmin-Vim
"-----------------------------------

let g:garmin_requiem_exe = 'd:/gtn/requiem/requiem.exe'

" Pylint falls on its face for relative imports so disable that check for now
let $PYTHONPATH .= ';' . resolve(expand('~')) . '/vimfiles/bundle/vim-garmin/pychecks'
let g:syntastic_python_pylint_args  = '--rcfile='
let g:syntastic_python_pylint_args .= resolve(expand('~')) . '/vimfiles/bundle/vim-garmin/pychecks/aviation_pylint.cfg -f parseable -r n -i y'
let g:syntastic_python_pylint_args .= ' --disable=F0401'


"-----------------------------------
" -> Plug-in: linediff
"-----------------------------------

let g:linediff_buffer_type = 'scratch'


"-----------------------------------
" -> Plug-in: Tagbar
"-----------------------------------

"This allows exploring file by function variable declarations
"Use leader t to show the tagbar
nmap <F8> :TagbarToggle<CR>
nnoremap <leader>t :TagbarOpenAutoClose<CR>

"override the order of displayed info for my
"preferences
let g:tagbar_type_c = {
    \ 'kinds' : [
        \ 'f:functions:0:1',
        \ 'd:macros:0:0',
        \ 'g:enums',
        \ 'e:enumerators:0:0',
        \ 't:typedefs:0:0',
        \ 's:structs',
        \ 'u:unions',
        \ 'm:members:0:0',
        \ 'v:variables:0:0',
    \ ],
\ }

let g:tagbar_type_cpp = {
    \ 'kinds' : [
        \ 'f:functions:0:1',
        \ 'd:macros:0:0',
        \ 'g:enums',
        \ 'e:enumerators:0:0',
        \ 't:typedefs:0:0',
        \ 'n:namespaces',
        \ 'c:classes',
        \ 's:structs',
        \ 'u:unions',
        \ 'm:members:0:0',
        \ 'v:variables:0:0',
    \ ],
\ }

let g:tagbar_type_jam = {
    \ 'ctagstype' : 'jam',
    \ 'kinds'     : [
        \ 'r:rules',
        \ 'v:variables'
    \ ],
\ }


"-----------------------------------
" -> Plug-in: Ultisnips
"-----------------------------------

" set up UltiSnips to work nicely with you complete me
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"

let g:UltiSnipsEditSplit='vertical'
nnoremap <leader>eu :UltiSnipsEdit<cr>

"-----------------------------------
" -> Plug-in: YouCompleteMe
"-----------------------------------
" (as with a lot of this, from Nick Santana's vimrc)
" I was having problems with it erroring out on
" vim scripts when editing so this just tells it
" to work on c files
let g:ycm_filetype_whitelist= {'c': 1, 'python': 1, 'cpp': 1}
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/vimfiles/clangflags.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_always_populate_location_list = 1

nnoremap <localleader>] :YcmCompleter GoTo<CR>
nnoremap <localleader>t :YcmCompleter GetType<CR>

" YCM holds onto file longer than it should and sometimes prevents saves
" This is a hack to force a save.
function! SaveWithYCM()
YcmRestartServer
w!
endfunction

command! W call SaveWithYCM()

"let g:ycm_collect_identifiers_from_tags_files = 1


"-----------------------------------
" -> Plug-in: YUNOcommit
"-----------------------------------
" 250 writes before yelling at me - a lot because I am autosaving
let g:YUNOcommit_after=20


