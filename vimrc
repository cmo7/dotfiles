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

" Función para cambiar tema rápidamente
function! ChangeTheme(theme)
    if a:theme ==# 'dark'
        " Tema oscuro por defecto (One Dark)
        colorscheme default
        highlight Normal ctermfg=255 ctermbg=235 guifg=#abb2bf guibg=#282c34
        highlight LineNr ctermfg=59 guifg=#5c6370
        highlight CursorLineNr ctermfg=180 guifg=#e5c07b cterm=bold gui=bold
        highlight CursorLine cterm=NONE ctermbg=236 guibg=#2c323c
        highlight Visual ctermbg=61 guibg=#3e4451
        highlight Search ctermbg=172 ctermfg=235 guifg=#282c34 guibg=#e06c75
        echo "Tema oscuro activado"
    elseif a:theme ==# 'light'
        " Tema claro
        colorscheme default
        highlight Normal ctermfg=235 ctermbg=255 guifg=#2d3748 guibg=#ffffff
        highlight LineNr ctermfg=244 guifg=#a0aec0
        highlight CursorLineNr ctermfg=166 guifg=#ed8936 cterm=bold gui=bold
        highlight CursorLine cterm=NONE ctermbg=254 guibg=#f7fafc
        highlight Visual ctermbg=117 guibg=#bee3f8
        highlight Search ctermbg=220 ctermfg=235 guifg=#2d3748 guibg=#fbd38d
        echo "Tema claro activado"
    elseif a:theme ==# 'gruvbox'
        " Tema Gruvbox
        colorscheme default
        highlight Normal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828
        highlight LineNr ctermfg=243 guifg=#7c6f64
        highlight CursorLineNr ctermfg=214 guifg=#fabd2f cterm=bold gui=bold
        highlight CursorLine cterm=NONE ctermbg=237 guibg=#3c3836
        highlight Visual ctermbg=237 guibg=#665c54
        highlight Search ctermbg=214 ctermfg=235 guifg=#282828 guibg=#fabd2f
        echo "Tema Gruvbox activado"
    elseif a:theme ==# 'dracula'
        " Tema Dracula
        colorscheme default
        highlight Normal ctermfg=255 ctermbg=236 guifg=#f8f8f2 guibg=#282a36
        highlight LineNr ctermfg=61 guifg=#6272a4
        highlight CursorLineNr ctermfg=228 guifg=#f1fa8c cterm=bold gui=bold
        highlight CursorLine cterm=NONE ctermbg=237 guibg=#44475a
        highlight Visual ctermbg=61 guibg=#6272a4
        highlight Search ctermbg=212 ctermfg=236 guifg=#282a36 guibg=#ff79c6
        echo "Tema Dracula activado"
    else
        echo "Temas disponibles: dark, light, gruvbox, dracula"
    endif
endfunction

" Comandos para cambiar tema fácilmente
command! -nargs=1 Theme call ChangeTheme(<q-args>)
nnoremap <leader>td :call ChangeTheme('dark')<CR>
nnoremap <leader>tl :call ChangeTheme('light')<CR>
nnoremap <leader>tg :call ChangeTheme('gruvbox')<CR>
nnoremap <leader>tr :call ChangeTheme('dracula')<CR>

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

" Esquema de colores mejorado
syntax enable
colorscheme default

" Tema moderno inspirado en VS Code Dark y One Dark
" Colores base
highlight Normal ctermfg=255 ctermbg=235 guifg=#abb2bf guibg=#282c34
highlight NonText ctermfg=59 guifg=#5c6370

" Números de línea con colores suaves
highlight LineNr ctermfg=59 guifg=#5c6370
highlight CursorLineNr ctermfg=180 guifg=#e5c07b cterm=bold gui=bold
highlight CursorLine cterm=NONE ctermbg=236 guibg=#2c323c

" Selección y búsqueda con colores modernos
highlight Visual ctermbg=61 guibg=#3e4451
highlight Search ctermbg=172 ctermfg=235 guifg=#282c34 guibg=#e06c75
highlight IncSearch ctermbg=180 ctermfg=235 guifg=#282c34 guibg=#e5c07b

" Paréntesis coincidentes
highlight MatchParen ctermbg=61 ctermfg=255 guifg=#ffffff guibg=#528bff cterm=bold gui=bold

" Comentarios más suaves
highlight Comment ctermfg=59 guifg=#5c6370 cterm=italic gui=italic

" Strings y constantes
highlight String ctermfg=114 guifg=#98c379
highlight Constant ctermfg=180 guifg=#e5c07b
highlight Number ctermfg=204 guifg=#d19a66

" Palabras clave y tipos
highlight Keyword ctermfg=170 guifg=#c678dd
highlight Type ctermfg=180 guifg=#e5c07b
highlight Function ctermfg=75 guifg=#61afef

" Operadores y delimitadores
highlight Operator ctermfg=204 guifg=#56b6c2
highlight Delimiter ctermfg=255 guifg=#abb2bf

" Statusline moderna
highlight StatusLine ctermbg=61 ctermfg=255 guibg=#3e4451 guifg=#abb2bf cterm=bold gui=bold
highlight StatusLineNC ctermbg=59 ctermfg=244 guibg=#5c6370 guifg=#828997

" Menús de completado
highlight Pmenu ctermbg=237 ctermfg=255 guibg=#353b45 guifg=#abb2bf
highlight PmenuSel ctermbg=61 ctermfg=255 guibg=#3e4451 guifg=#ffffff cterm=bold gui=bold
highlight PmenuSbar ctermbg=59 guibg=#5c6370
highlight PmenuThumb ctermbg=244 guibg=#828997

" Fold (plegado) moderno
highlight Folded ctermbg=237 ctermfg=109 guibg=#353b45 guifg=#848b98
highlight FoldColumn ctermbg=235 ctermfg=59 guibg=#282c34 guifg=#5c6370

" Errores y warnings
highlight Error ctermbg=204 ctermfg=255 guibg=#e06c75 guifg=#ffffff cterm=bold gui=bold
highlight Warning ctermbg=180 ctermfg=235 guibg=#e5c07b guifg=#282c34 cterm=bold gui=bold

" Diferencias (para Git)
highlight DiffAdd ctermbg=22 ctermfg=114 guibg=#1e3d18 guifg=#98c379
highlight DiffChange ctermbg=58 ctermfg=180 guibg=#2c2418 guifg=#e5c07b
highlight DiffDelete ctermbg=52 ctermfg=204 guibg=#3d1e18 guifg=#e06c75
highlight DiffText ctermbg=94 ctermfg=255 guibg=#4a3518 guifg=#ffffff cterm=bold gui=bold

" Signos en la columna lateral
highlight SignColumn ctermbg=235 guibg=#282c34
highlight ColorColumn ctermbg=236 guibg=#2c323c

" Tabs y espacios
highlight TabLine ctermbg=237 ctermfg=244 guibg=#353b45 guifg=#828997
highlight TabLineSel ctermbg=61 ctermfg=255 guibg=#3e4451 guifg=#ffffff cterm=bold gui=bold
highlight TabLineFill ctermbg=235 guibg=#282c34

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
" TEMAS ALTERNATIVOS - Descomenta el que prefieras
" ==============================================================================

" OPCIÓN 1: Tema claro minimalista (descomenta para usar)
" highlight Normal ctermfg=235 ctermbg=255 guifg=#2d3748 guibg=#ffffff
" highlight LineNr ctermfg=244 guifg=#a0aec0
" highlight CursorLineNr ctermfg=166 guifg=#ed8936 cterm=bold gui=bold
" highlight CursorLine cterm=NONE ctermbg=254 guibg=#f7fafc
" highlight Visual ctermbg=117 guibg=#bee3f8
" highlight Search ctermbg=220 ctermfg=235 guifg=#2d3748 guibg=#fbd38d
" highlight Comment ctermfg=244 guifg=#a0aec0 cterm=italic gui=italic

" OPCIÓN 2: Tema Gruvbox oscuro (descomenta para usar)
" highlight Normal ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828
" highlight LineNr ctermfg=243 guifg=#7c6f64
" highlight CursorLineNr ctermfg=214 guifg=#fabd2f cterm=bold gui=bold
" highlight CursorLine cterm=NONE ctermbg=237 guibg=#3c3836
" highlight Visual ctermbg=237 guibg=#665c54
" highlight Search ctermbg=214 ctermfg=235 guifg=#282828 guibg=#fabd2f
" highlight Comment ctermfg=243 guifg=#7c6f64 cterm=italic gui=italic

" OPCIÓN 3: Tema Dracula (descomenta para usar)
" highlight Normal ctermfg=255 ctermbg=236 guifg=#f8f8f2 guibg=#282a36
" highlight LineNr ctermfg=61 guifg=#6272a4
" highlight CursorLineNr ctermfg=228 guifg=#f1fa8c cterm=bold gui=bold
" highlight CursorLine cterm=NONE ctermbg=237 guibg=#44475a
" highlight Visual ctermbg=61 guibg=#6272a4
" highlight Search ctermbg=212 ctermfg=236 guifg=#282a36 guibg=#ff79c6
" highlight Comment ctermfg=61 guifg=#6272a4 cterm=italic gui=italic

" OPCIÓN 4: Tema monokai (descomenta para usar)
" highlight Normal ctermfg=255 ctermbg=234 guifg=#f8f8f2 guibg=#1e1e1e
" highlight LineNr ctermfg=59 guifg=#90908a
" highlight CursorLineNr ctermfg=226 guifg=#e6db74 cterm=bold gui=bold
" highlight CursorLine cterm=NONE ctermbg=235 guibg=#293739
" highlight Visual ctermbg=239 guibg=#49483e
" highlight Search ctermbg=208 ctermfg=234 guifg=#1e1e1e guibg=#fd971f
" highlight Comment ctermfg=102 guifg=#75715e cterm=italic gui=italic

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
