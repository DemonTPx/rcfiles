sy on
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
filetype plugin indent on
set showcmd
set showmatch
set ignorecase
set smartcase
set incsearch
set autowrite
set hidden
set mouse=a
set softtabstop=4
set shiftwidth=4
set expandtab
set hlsearch
set ruler
set smartindent
set autoindent
set bg=dark
set number
set wildmenu
set cursorline
hi CursorLine term=none cterm=none ctermbg=236
hi LineNr term=none cterm=none ctermfg=3 ctermbg=236
set scrolloff=5
set history=1000
set undolevels=1000
set backspace=indent,eol,start
set list
set listchars=tab:>·,trail:·
set shortmess=atI
set title
set t_Co=256
