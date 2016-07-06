"==================== SegonMergeTag ============================

set nu			" Show line number
set showcmd		" Show (partial) command in status line.
set hlsearch		" Highlight search result
set incsearch		" Incremental search
set confirm		" Pop confirm when you process unsaved file or readonly file
set nobackup		" Do not backup file
set showmatch		" Show matching brackets.
set ignorecase smartcase
set laststatus=2	" Show statusbar
set autoindent
set nowrapscan
set shiftwidth=4
set softtabstop=4
set expandtab
set wildmode=longest,list
set history=200

" 用%% 展开当前路径
cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'

" 用Ctrl+F12 开关TagList
nnoremap <silent> <C-F12> :TlistToggle<CR>
let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim

colorscheme evening	" Set default scheme is evening

" vimdiff
set diffopt=filler,vertical
