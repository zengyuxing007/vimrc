"!how to  write vim-script!
"https://www.ibm.com/developerworks/cn/linux/l-vim-script-1/index.html
let g:fencview_autodetect=1

set term=dtterm
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <S-n> :tabnext<cr>
map <S-m> :tabprev<cr>

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/



""""""""""""""""""""""""""""""""""""
" find module in perl INC and edit "
""""""""""""""""""""""""""""""""""""
function! GetCursorModuleName()
    let cw = substitute( expand("<cWORD>"), '.\{-}\(\(\w\+\)\(::\w\+\)*\).*$', '\1', '' )
    return cw
endfunction

function! TranslateModuleName(n)
    return substitute( a:n, '::', '/', 'g' ) . '.pm'
endfunction

function! GetPerlLibPaths()
    let out = system('perl -e ''print join "\n", @INC''')
    let paths = split( out, "\n" )
    return paths
endfunction

function! FindModuleFileInPaths()
    let paths = [ 'lib' ] + ['t/lib'] + ['lib/Chariot/WebApp/Controller'] + GetPerlLibPaths()
    let fname = TranslateModuleName( GetCursorModuleName() )

    for p in paths
        let f = p . '/' . fname
        if filereadable(f)
            exec "tabnew " . f
            return 1
        endif
    endfor

    echo "File not found: " . fname
endfunction

function! FindModuleFileInPathsVsplit()
    let paths = [ 'lib' ] + ['t/lib'] + ['lib/Chariot/WebApp/Controller'] + GetPerlLibPaths()
    let fname = TranslateModuleName( GetCursorModuleName() )

    for p in paths
        let f = p . '/' . fname
        if filereadable(f)
            exec "vs " . f
            return 1
        endif
    endfor

    echo "File not found: " . fname
endfunction

function! FormatJsonString()
:%!python -mjson.tool
endfunction


"nmap fm :call FindModuleFileInPaths() <cr>
nmap fv :call FindModuleFileInPathsVsplit() <cr>

"format json string using python module json.tool
"nmap jm :call FormatJsonString() <cr>


" make tags
fun! MAKETAGS()
:!find . -path ./.bak -path ./bazel-genfiles -prune -o -name "*.h" -o -name "*.cpp" -o -name "*.c" -o -name "*.cc" -o -name "*.cs" -o -name "*.lua" -o -name "*.xml" -o -name "*.php" -o -name "*.go" -o -name "*.proto" > cscope.files
:!cscope -bkq -i cscope.files
:!/usr/local/bin/ctags -L cscope.files
:!rm -f cscope.files
:cs reset
endfun


" key map
map  <leader>cc :up<CR>:call MAKETAGS()<CR>
colorscheme darkblue
"colorscheme desert
set path+=./vendor


" a.vim
map ,a :A<Enter>
" set paste
map ,p :set paste<Enter> i

let NERDTreeIgnore=['\.vim$', '\~$','\.out' , '\.o']
let NERDTreeWinSize=45

function! JesseNERDWinSizePlusPlus()
    let g:NERDTreeWinSize+=2
    execute "NERDTree"
endfunction

function! JesseNERDWinSizeSubSub()
    let g:NERDTreeWinSize-=2
    execute "NERDTree"
endfunction

nmap fa :call JesseNERDWinSizePlusPlus() <cr>
nmap fz :call JesseNERDWinSizeSubSub() <cr>


" for php
map <C-P> :!/usr/bin/php5 -f %<CR>
autocmd BufNewFile,Bufread *.ros,*.inc,*.php set keywordprg=pman


function! JesseDebugRun(cmd)
    :w
    execute '!' . a:cmd . ' %'
endfunction

au FileType php map <F5> :call JesseDebugRun('php')<cr>
au FileType php imap <F5> <Esc>:call JesseDebugRun('php')<cr>
au FileType python map <F5> :call JesseDebugRun('python')<cr>
au FileType python imap <F5> <Esc>:call JesseDebugRun('python')<cr>
au FileType perl map <F5> :call JesseDebugRun('perl')<cr>
au FileType perl imap <F5> <Esc>:call JesseDebugRun('perl')<cr>


au BufRead,BufNewFile *.thrift set filetype=thrift
au! Syntax thrift source ~/.vim/plugin/thrift.vim

function! OpenPerlModule(module)
  let module_path = system("perldoc -l " . a:module)
  if v:shell_error == 1
    echo module_path
    return
  endif
  execute "e " . module_path
endfunction
command! -nargs=1 Pme call OpenPerlModule(<f-args>)


function! CsFindMe(cmd)
   " let word = expand<"cWORD">
    let cw=  expand("<cword>")
    "let cw = substitute( expand("<cWORD>"), '\(\w\+::\).*$', '\1', '' )
    execute "cs find " a:cmd cw 
endfunction


nmap fm :call CsFindMe('s') <cr>
nmap fc :call CsFindMe('c') <cr>
nmap fg :call CsFindMe('g') <cr>

let g:ycm_global_ycm_extra_conf= '~/.vim_runtime/bundle/YouCompleteMe/third_party/ycmd/cpp/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  endif
  set csverb
endif


" autoloading cscope db
function! LoadCscope()
   let db = findfile("cscope.out",".;")
   if(!empty(db))
	let path = strpart(db,0,match(db,"/cscope.out$"))
	set nocsverb
	exe "cs add " . db . " " . path
	set csverb
    endif
endfunction
au BufEnter /* call LoadCscope()

"""""""""""""""""""""""""""""""
" Vim section
"""""""""""""""""""""""""""""""
autocmd FileType vim set nofen
autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>

""""""""""""""""""""""""""""""
" HTML
"""""""""""""""""""""""""""""""
au FileType html set ft=xml
au FileType html set syntax=html

au FileType perl set ft=perl

""""""""""""""""""""""""""""""
" C/C++
"""""""""""""""""""""""""""""""
autocmd FileType c,cpp  map <buffer> <leader><space> :make<cr>

"file encoding auto detect
map <leader>t :FencAutoDetect<cr>
nmap <leader>t :FencAutoDetect<cr>
"
set fileencoding=utf8
set fileencodings=utf-8,gb2312

" git blame 
vmap b :!git blame =expand("%:p")  \| sed -n =line("',=line("'>") p 


call plug#begin('~/.vim_runtime/plugged') 
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'skywind3000/asyncrun.vim'
call plug#end()


" set the runtime path to include Vundle and initialize
set rtp+=~/.vim_runtime/bundle/Vundle.vim
call vundle#begin('~/.vim_runtime/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'

Plugin 'tarekbecker/vim-yaml-formatter'

Plugin 'fatih/vim-go'

Plugin 'tpope/vim-fugitive'

Plugin 'git://git.wincent.com/command-t.git'

Plugin 'Yggdroot/LeaderF'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let g:ycm_server_python_interpreter = '/usr/bin/python3'

"set path+=/home/jesse/serviceMesh/envoy-gf/*/**
"set path+=/home/jesse/serviceMesh/envoy-develop/*/**
set path+=./*/**

" some for git mergr using vimdiff
set laststatus=2 "show the status line
set statusline=%-10.3n  "buffer number

map <silent> <leader>2 :diffget 2<CR> :diffupdate<CR>
map <silent> <leader>3 :diffget 3<CR> :diffupdate<CR>
map <silent> <leader>4 :diffget 4<CR> :diffupdate<CR>


" search word under cursor, the pattern is treated as regex, and enter normal mode directly
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
" search word under cursor, the pattern is treated as regex,
" append the result to previous search results.
noremap <C-G> :<C-U><C-R>=printf("Leaderf! rg --append -e %s ", expand("<cword>"))<CR>
" search word under cursor literally only in current buffer
noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer -e %s ", expand("<cword>"))<CR>
" search visually selected text literally, don't quit LeaderF after accepting an entry
xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen -e %s ", leaderf#Rg#visual())<CR>
" recall last search. If the result window is closed, reopen it.
noremap go :<C-U>Leaderf! rg --stayOpen --recall<CR>

" search word under cursor in *.h and *.cpp files.
noremap <Leader>c :<C-U><C-R>=printf("Leaderf! rg -e %s -g *.h -g *.cc -g *.cpp -g !bazel-genfiles/*", expand("<cword>"))<CR>


" FZF vim plugin settings

map ,q :FZF<Enter>

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" [Buffers] 如果可能跳到已存在窗口
let g:fzf_buffers_jump = 1



" automatically open quickfix window when AsyncRun command is executed
" set the quickfix window 6 lines height.
let g:asyncrun_open = 6

" ring the bell to notify you job finished
let g:asyncrun_bell = 1

" F10 to toggle quickfix window
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
