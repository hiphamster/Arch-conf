set nocompatible               " be iMproved

" vundle conf {{{

filetype off                   " required by vundle!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" }}}

" bundles {{{

" required it's vundle! 
Bundle 'gmarik/vundle'

" My Bundles here:
Bundle 'klen/python-mode'
Bundle 'scrooloose/nerdtree'
Bundle 'mbbill/undotree'
Bundle 'tpope/vim-fugitive'
Bundle 'airblade/vim-gitgutter'
Bundle 'groenewege/vim-less'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-markdown'
Bundle 'sophacles/vim-bundle-mako'
Bundle 'vim-scripts/django.vim'

filetype plugin indent on     " required by vundle!

" }}}

" color and syntax {{{ 

" color syntax
syntax on
set t_Co=256

" fold text
if has("folding")
  set foldtext=MyFoldText()
  function! MyFoldText()
    " for now, just don't try if version isn't 7 or higher
    if v:version < 701
      return foldtext()
    endif
    " clear fold from fillchars to set it up the way we want later
    let &l:fillchars = substitute(&l:fillchars,',\?fold:.','','gi')
    let l:numwidth = (v:version < 701 ? 8 : &numberwidth)
    if &fdm=='diff'
      let l:linetext=''
      let l:foldtext='---------- '.(v:foldend-v:foldstart+1).' lines the same ----------'
      let l:align = winwidth(0)-&foldcolumn-(&nu ? Max(strlen(line('$'))+1, l:numwidth) : 0)
      let l:align = (l:align / 2) + (strlen(l:foldtext)/2)
      " note trailing space on next line
      setlocal fillchars+=fold:\ 
    elseif !exists('b:foldpat') || b:foldpat==0
      let l:foldtext = ' '.(v:foldend-v:foldstart).' lines folded'.v:folddashes.'|'
      let l:endofline = (&textwidth>0 ? &textwidth : 80)
      let l:linetext = strpart(getline(v:foldstart),0,l:endofline-strlen(l:foldtext))
      let l:align = l:endofline-strlen(l:linetext)
      setlocal fillchars+=fold:-
    elseif b:foldpat==1
      let l:align = winwidth(0)-&foldcolumn-(&nu ? Max(strlen(line('$'))+1, l:numwidth) : 0)
      let l:foldtext = ' '.v:folddashes
      let l:linetext = substitute(getline(v:foldstart),'\s\+$','','')
      let l:linetext .= ' ---'.(v:foldend-v:foldstart-1).' lines--- '
      let l:linetext .= substitute(getline(v:foldend),'^\s\+','','')
      let l:linetext = strpart(l:linetext,0,l:align-strlen(l:foldtext))
      let l:align -= strlen(l:linetext)
      setlocal fillchars+=fold:-
    endif
    return printf('%s%*s', l:linetext, l:align, l:foldtext)
  endfunction
endif

" set fold color
highlight Folded ctermfg=DarkBlue ctermbg=232

" Gutter color
highlight SignColumn ctermbg=232

" vsplit color
highlight VertSplit ctermbg=0 ctermfg=0

" statusline color
highlight statusline ctermbg=0 ctermfg=0
highlight StatusLineNC ctermbg=0 ctermfg=0

" visual color
hi Visual  ctermbg=0 ctermfg=Grey

" tab color
hi TabLineFill ctermfg=Black ctermbg=Black
hi TabLine ctermfg=DarkBlue ctermbg=Black
hi TabLineSel ctermfg=Red ctermbg=Black
hi Title ctermfg=LightBlue ctermbg=Black

" remove statusline
set laststatus=0
set statusline=\

" ruler setting
set ruler
set rulerformat=%-50(%=%M%H%R\ %f%<\ (%n)%4(%)%Y:%{&tw}%9(%l,%c%V%)%4(%)%P%)

" put ⋅ for space at the end of line
" | for tabs
" ˽ for non breakable space
set list
set listchars=tab:\|\ ,trail:⋅,nbsp:˽

" remove useless line number set by python-mode
au BufRead,BufNewFile *.py set nonumber

" Language syntax indent
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4
autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 expandtab

" Language folding
au Filetype javascript set omnifunc=javascriptcomplete#CompleteJS foldmethod=indent fdl=1
au Filetype vim set foldmethod=marker
au Filetype python set foldtext=MyFoldText()

" minimum number of line under and above the cursor
set scrolloff=5

" }}}

" Key map and Plugin conf {{{

" remap the leader default: '\'
let mapleader='!'

" map jk for exit insert mode
imap jk <ESC>

" GitGutter - navig through git diff
nmap <leader>h <Plug>GitGutterNextHunk
nmap <leader>H <Plug>GitGutterPrevHunk

" UndoTree
nnoremap <leader>u :UndotreeToggle<cr>

" NeerdTree
nnoremap <leader>e :NERDTreeToggle<cr>
let NERDTreeQuitOnOpen=1

" usefull for search, centering the result
nnoremap n nzz
nnoremap N Nzz

" tab keys
map <leader>tn :tabnew<cr>
map <leader>tc :tabclose<CR>

" paste
set pastetoggle=<leader>p

" don't use arrow keys
map <right> <esc>
map <left> <esc>
map <up> <esc>
map <down> <esc>
imap <right> <esc>
imap <left> <esc>
imap <up> <esc>
imap <down> <esc>

" upload to sprunge.us
command! Sprunge w !curl -F 'sprunge=<-' http://sprunge.us

" }}}

" persistence {{{
" thanks to TWal https://github.com/TWal

if isdirectory($HOME . '/.vim/backup') == 0
	:silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backup

" Save swp files to a less annoying place than the current directory.
if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=~/.vim/swap//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
	" undofile - This allows you to use undos after exiting and restarting
	if isdirectory($HOME . '/.vim/undo') == 0
		:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
	endif
	set undodir=~/.vim/undo//
	set undodir=~/.vim/undo//
	set undofile
endif

" }}}

" search {{{

set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching, search case sensitive if at least one upercase in the patern
set incsearch " Incremental search, start searching will typing patern

" }}}

" vim: fdm=marker
