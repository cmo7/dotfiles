" ==============================================================================
" Configuración moderna de Vim - Dotfiles
" ==============================================================================

" Configuración básica
set nocompatible              " Desactivar compatibilidad con vi
set encoding=utf-8            " Codificación UTF-8
set fileencoding=utf-8        " Codificación de archivos UTF-8
set backspace=indent,eol,start " Backspace más intuitivo

" Interfaz y apariencia
set number                    " Números de línea
set relativenumber           " Números de línea relativos
set cursorline              " Resaltar línea actual
set showmatch               " Resaltar paréntesis coincidentes
set laststatus=2            " Siempre mostrar barra de estado
set showcmd                 " Mostrar comando en progreso
set ruler                   " Mostrar posición del cursor
set wildmenu                " Menú de autocompletado mejorado
set wildmode=list:longest,full
set background=dark         " Fondo oscuro

" Búsqueda
set hlsearch               " Resaltar resultados de búsqueda
set incsearch              " Búsqueda incremental
set ignorecase             " Ignorar mayúsculas en búsqueda
set smartcase              " Caso inteligente en búsqueda

" Indentación
set autoindent             " Auto-indentación
set smartindent            " Indentación inteligente
set expandtab              " Usar espacios en lugar de tabs
set tabstop=4              " Ancho de tab visual
set shiftwidth=4           " Ancho de indentación
set softtabstop=4          " Ancho de tab al editar
set shiftround             " Redondear indentación a múltiplos de shiftwidth

" Archivos y respaldos
set nobackup               " No crear archivos de backup
set nowritebackup          " No crear backup antes de escribir
set noswapfile             " No usar archivos swap
set autoread               " Leer automáticamente archivos modificados externamente
set hidden                 " Permitir buffers ocultos sin guardar

" Rendimiento
set lazyredraw             " No redibujar durante macros
set ttyfast                " Terminal rápida
set updatetime=300         " Tiempo de actualización más rápido

" Folding
set foldmethod=indent      " Plegado basado en indentación
set foldlevelstart=99      " Comenzar con todo desplegado
set foldnestmax=10         " Máximo 10 niveles de plegado

" Navegación y splits
set splitbelow             " Nuevos splits horizontales abajo
set splitright             " Nuevos splits verticales a la derecha
set scrolloff=8            " Mantener 8 líneas visibles arriba/abajo del cursor
set sidescrolloff=8        " Mantener 8 columnas visibles a los lados

" Completado
set completeopt=menuone,noinsert,noselect
set pumheight=10           " Altura máxima del menú de completado

" ==============================================================================
" MAPEOS DE TECLAS
" ==============================================================================

" Leader key
let mapleader = " "
let maplocalleader = ","

" Guardar y salir más rápido
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Limpiar resaltado de búsqueda
nnoremap <leader>h :nohlsearch<CR>

" Navegación entre ventanas
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Redimensionar ventanas
nnoremap <leader>= <C-w>=
nnoremap <leader>- <C-w>-
nnoremap <leader>+ <C-w>+
nnoremap <leader>< <C-w><
nnoremap <leader>> <C-w>>

" Navegación entre buffers
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>d :bdelete<CR>

" Mover líneas arriba y abajo
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Indentación en modo visual
vnoremap < <gv
vnoremap > >gv

" Navegación en modo inserción
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Copiar al portapapeles del sistema
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y

" Pegar del portapapeles del sistema
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" ==============================================================================
" COMANDOS Y FUNCIONES
" ==============================================================================

" Comando para limpiar espacios en blanco al final de líneas
command! TrimWhitespace %s/\s\+$//e

" Función para alternar números relativos
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc
nnoremap <leader>r :call NumberToggle()<CR>

" Función para centrar texto
command! -range=% Center <line1>,<line2>s/^/\=repeat(' ', (&tw-len(getline('.'))+1)/2)/

" ==============================================================================
" AUTO COMANDOS
" ==============================================================================

if has("autocmd")
    " Restaurar posición del cursor al abrir archivo
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif

    " Resaltar texto yankeado
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}

    " Configuraciones específicas por tipo de archivo
    autocmd FileType javascript,typescript,json setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType html,css,scss,yaml,yml setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
    autocmd FileType markdown setlocal wrap linebreak nolist textwidth=80

    " Limpiar espacios en blanco automáticamente
    autocmd BufWritePre * %s/\s\+$//e

    " Crear directorios automáticamente al guardar
    autocmd BufWritePre * if !isdirectory(expand('<afile>:p:h')) | call mkdir(expand('<afile>:p:h'), 'p') | endif
endif

" ==============================================================================
" CONFIGURACIÓN DE COLORES Y TEMA
" ==============================================================================

" Habilitar colores verdaderos si está disponible
if has('termguicolors')
    set termguicolors
endif

" Esquema de colores básico mejorado
syntax enable
colorscheme default

" Personalización de colores
highlight LineNr ctermfg=244 guifg=#808080
highlight CursorLineNr ctermfg=220 guifg=#ffdd00 cterm=bold gui=bold
highlight CursorLine cterm=NONE ctermbg=238 guibg=#444444
highlight Visual ctermbg=239 guibg=#4e4e4e
highlight Search ctermbg=58 guibg=#5f5f00 ctermfg=15 guifg=#ffffff
highlight MatchParen ctermbg=53 guibg=#5f005f ctermfg=15 guifg=#ffffff

" ==============================================================================
" CONFIGURACIÓN DEL STATUSLINE
" ==============================================================================

" Función para mostrar el modo actual
function! Mode()
    let l:mode = mode()
    if l:mode ==# 'n'
        return 'NORMAL'
    elseif l:mode ==# 'i'
        return 'INSERT'
    elseif l:mode ==# 'v'
        return 'VISUAL'
    elseif l:mode ==# 'V'
        return 'V-LINE'
    elseif l:mode ==# "\<C-v>"
        return 'V-BLOCK'
    elseif l:mode ==# 'R'
        return 'REPLACE'
    else
        return l:mode
    endif
endfunction

" Función para mostrar información de Git (si está disponible)
function! GitBranch()
    if exists('*fugitive#head')
        let l:branch = fugitive#head()
        return l:branch !=# '' ? ' ' . l:branch : ''
    endif
    return ''
endfunction

" Statusline personalizada
set statusline=
set statusline+=%#PmenuSel#                    " Color de fondo
set statusline+=\ %{Mode()}                    " Modo actual
set statusline+=\ %#LineNr#                    " Cambiar color
set statusline+=\ %f                           " Ruta del archivo
set statusline+=%m                             " Modificado
set statusline+=%r                             " Solo lectura
set statusline+=%h                             " Ayuda
set statusline+=%w                             " Vista previa
set statusline+=%=                             " Alineación derecha
set statusline+=%#CursorColumn#                " Color
set statusline+=\ %y                           " Tipo de archivo
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} " Codificación
set statusline+=\ [%{&fileformat}]             " Formato
set statusline+=\ %p%%                         " Porcentaje
set statusline+=\ %l:%c                        " Línea:Columna
set statusline+=\ 

" ==============================================================================
" CONFIGURACIONES ADICIONALES
" ==============================================================================

" Mejorar la experiencia de comando
set history=1000               " Más historia de comandos
set undolevels=1000           " Más niveles de deshacer

" Configuración de archivos temporales
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

" Directorio para archivos temporales
if !isdirectory('~/.vim/tmp')
    call mkdir($HOME . '/.vim/tmp', 'p')
endif
set directory=~/.vim/tmp

" Configuración para diferentes sistemas
if has('unix')
    set shell=/bin/bash
endif

" Mejorar rendimiento en archivos grandes
set synmaxcol=200             " Sintaxis solo hasta columna 200
set regexpengine=1            " Motor de regex más rápido

" ==============================================================================
" CONFIGURACIÓN FINAL
" ==============================================================================

" Mensaje de bienvenida
if has('autocmd')
    autocmd VimEnter * if argc() == 0 | echo "🚀 Vim configurado y listo para usar!" | endif
endif

" Fuente predeterminada para GUI
if has('gui_running')
    set guifont=Consolas:h11
    set guioptions-=T " Ocultar toolbar
    set guioptions-=m " Ocultar menubar
endif

" Configuración específica para diferentes tipos de terminal
if &term =~ '256color'
    set t_Co=256
endif
