-- ==============================================================================
-- Configuración moderna de Neovim - Dotfiles
-- ==============================================================================

-- Configuración básica
-- vim.opt.compatible = false  -- No necesario en Neovim (siempre false)
vim.opt.encoding = 'utf-8'           -- Codificación UTF-8
vim.opt.fileencoding = 'utf-8'       -- Codificación de archivos UTF-8
vim.opt.backspace = {'indent', 'eol', 'start'} -- Backspace más intuitivo

-- Interfaz y apariencia
vim.opt.number = true                -- Números de línea
vim.opt.relativenumber = true        -- Números de línea relativos
vim.opt.cursorline = true           -- Resaltar línea actual
vim.opt.showmatch = true            -- Resaltar paréntesis coincidentes
vim.opt.laststatus = 2              -- Siempre mostrar barra de estado
vim.opt.showcmd = true              -- Mostrar comando en progreso
vim.opt.ruler = true                -- Mostrar posición del cursor
vim.opt.wildmenu = true             -- Menú de autocompletado mejorado
vim.opt.wildmode = {'list:longest', 'full'}
vim.opt.background = 'dark'         -- Fondo oscuro
vim.opt.signcolumn = 'yes'          -- Siempre mostrar columna de signos
vim.opt.colorcolumn = '80'          -- Línea guía a los 80 caracteres

-- Búsqueda
vim.opt.hlsearch = true             -- Resaltar resultados de búsqueda
vim.opt.incsearch = true            -- Búsqueda incremental
vim.opt.ignorecase = true           -- Ignorar mayúsculas en búsqueda
vim.opt.smartcase = true            -- Caso inteligente en búsqueda

-- Indentación
vim.opt.autoindent = true           -- Auto-indentación
vim.opt.smartindent = true          -- Indentación inteligente
vim.opt.expandtab = true            -- Usar espacios en lugar de tabs
vim.opt.tabstop = 4                 -- Ancho de tab visual
vim.opt.shiftwidth = 4              -- Ancho de indentación
vim.opt.softtabstop = 4             -- Ancho de tab al editar
vim.opt.shiftround = true           -- Redondear indentación a múltiplos de shiftwidth

-- Archivos y respaldos
vim.opt.backup = false              -- No crear archivos de backup
vim.opt.writebackup = false         -- No crear backup antes de escribir
vim.opt.swapfile = false            -- No usar archivos swap
vim.opt.autoread = true             -- Leer automáticamente archivos modificados externamente
vim.opt.hidden = true               -- Permitir buffers ocultos sin guardar

-- Rendimiento
vim.opt.lazyredraw = true           -- No redibujar durante macros
-- vim.opt.ttyfast = true           -- No necesario en Neovim (siempre true)
vim.opt.updatetime = 300            -- Tiempo de actualización más rápido
vim.opt.timeout = true
vim.opt.timeoutlen = 500

-- Folding
vim.opt.foldmethod = 'indent'       -- Plegado basado en indentación
vim.opt.foldlevelstart = 99         -- Comenzar con todo desplegado
vim.opt.foldnestmax = 10            -- Máximo 10 niveles de plegado

-- Navegación y splits
vim.opt.splitbelow = true           -- Nuevos splits horizontales abajo
vim.opt.splitright = true           -- Nuevos splits verticales a la derecha
vim.opt.scrolloff = 8               -- Mantener 8 líneas visibles arriba/abajo del cursor
vim.opt.sidescrolloff = 8           -- Mantener 8 columnas visibles a los lados

-- Completado
vim.opt.completeopt = {'menuone', 'noinsert', 'noselect'}
vim.opt.pumheight = 10              -- Altura máxima del menú de completado

-- Archivos de deshacer persistente
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.local/share/nvim/undo')

-- Crear directorio de undo si no existe
local undo_dir = vim.fn.expand('~/.local/share/nvim/undo')
if vim.fn.isdirectory(undo_dir) == 0 then
    vim.fn.mkdir(undo_dir, 'p')
end

-- ==============================================================================
-- MAPEOS DE TECLAS
-- ==============================================================================

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Función helper para mapeos
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

-- Guardar y salir más rápido
map('n', '<leader>w', ':w<CR>')
map('n', '<leader>q', ':q<CR>')
map('n', '<leader>x', ':x<CR>')

-- Limpiar resaltado de búsqueda
map('n', '<leader>h', ':nohlsearch<CR>')

-- Navegación entre ventanas
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Redimensionar ventanas
map('n', '<leader>=', '<C-w>=')
map('n', '<leader>-', '<C-w>-')
map('n', '<leader>+', '<C-w>+')
map('n', '<leader><', '<C-w><')
map('n', '<leader>>', '<C-w>>')

-- Navegación entre buffers
map('n', '<leader>n', ':bnext<CR>')
map('n', '<leader>p', ':bprevious<CR>')
map('n', '<leader>d', ':bdelete<CR>')

-- Mover líneas arriba y abajo
map('n', '<A-j>', ':m .+1<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')
map('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
map('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
map('v', '<A-j>', ':m \'>+1<CR>gv=gv')
map('v', '<A-k>', ':m \'<-2<CR>gv=gv')

-- Indentación en modo visual
map('v', '<', '<gv')
map('v', '>', '>gv')

-- Navegación en modo inserción
map('i', '<C-h>', '<Left>')
map('i', '<C-j>', '<Down>')
map('i', '<C-k>', '<Up>')
map('i', '<C-l>', '<Right>')

-- Copiar al portapapeles del sistema
map('v', '<leader>y', '"+y')
map('n', '<leader>Y', '"+yg_')
map('n', '<leader>y', '"+y')

-- Pegar del portapapeles del sistema
map('n', '<leader>p', '"+p')
map('n', '<leader>P', '"+P')
map('v', '<leader>p', '"+p')
map('v', '<leader>P', '"+P')

-- Cerrar buffer actual sin cerrar ventana
map('n', '<leader>bd', ':bp<bar>sp<bar>bn<bar>bd<CR>')

-- ==============================================================================
-- COMANDOS Y FUNCIONES
-- ==============================================================================

-- Comando para limpiar espacios en blanco al final de líneas
vim.api.nvim_create_user_command('TrimWhitespace', '%s/\\s\\+$//e', {})

-- Función para alternar números relativos
local function toggle_relative_number()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end
map('n', '<leader>r', toggle_relative_number)

-- ==============================================================================
-- AUTO COMANDOS
-- ==============================================================================

-- Crear grupo de autocomandos
local augroup = vim.api.nvim_create_augroup('ModernVimConfig', { clear = true })

-- Restaurar posición del cursor al abrir archivo
vim.api.nvim_create_autocmd('BufReadPost', {
    group = augroup,
    pattern = '*',
    callback = function()
        local line = vim.fn.line('\'"')
        if line > 1 and line <= vim.fn.line('$') then
            vim.cmd('normal! g`"')
        end
    end,
})

-- Resaltar texto yankeado
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 300 })
    end,
})

-- Configuraciones específicas por tipo de archivo
vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = {'javascript', 'typescript', 'json', 'html', 'css', 'scss', 'yaml', 'yml'},
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'python',
    callback = function()
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'go',
    callback = function()
        vim.opt_local.expandtab = false
        vim.opt_local.shiftwidth = 4
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = augroup,
    pattern = 'markdown',
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.list = false
        vim.opt_local.textwidth = 80
    end,
})

-- Limpiar espacios en blanco automáticamente
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup,
    pattern = '*',
    callback = function()
        local save_cursor = vim.fn.getpos('.')
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos('.', save_cursor)
    end,
})

-- Crear directorios automáticamente al guardar
vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup,
    pattern = '*',
    callback = function()
        local dir = vim.fn.expand('<afile>:p:h')
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})

-- ==============================================================================
-- CONFIGURACIÓN DE COLORES Y TEMA
-- ==============================================================================

-- Habilitar colores verdaderos
vim.opt.termguicolors = true

-- Esquema de colores
vim.cmd.colorscheme('default')

-- Personalización de colores
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#808080' })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffdd00', bold = true })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#444444' })
vim.api.nvim_set_hl(0, 'Visual', { bg = '#4e4e4e' })
vim.api.nvim_set_hl(0, 'Search', { bg = '#5f5f00', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = '#5f005f', fg = '#ffffff' })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = '#2d2d2d' })

-- ==============================================================================
-- CONFIGURACIÓN DEL STATUSLINE
-- ==============================================================================

-- Función para obtener el modo actual
local function get_mode()
    local modes = {
        n = 'NORMAL',
        i = 'INSERT',
        v = 'VISUAL',
        V = 'V-LINE',
        ['\22'] = 'V-BLOCK',
        c = 'COMMAND',
        s = 'SELECT',
        S = 'S-LINE',
        ['\19'] = 'S-BLOCK',
        R = 'REPLACE',
        r = 'REPLACE',
        ['!'] = 'SHELL',
        t = 'TERMINAL'
    }
    return modes[vim.fn.mode()] or 'UNKNOWN'
end

-- Función para obtener información de Git (segura, sin errores)
local function get_git_branch()
    local handle = io.popen('git rev-parse --abbrev-ref HEAD 2>/dev/null')
    if handle then
        local branch = handle:read('*a'):gsub('\n', '')
        handle:close()
        return branch ~= '' and ' ' .. branch or ''
    end
    return ''
end

-- Statusline personalizada (simplificada y segura)
vim.opt.statusline = table.concat({
    '%#PmenuSel#',          -- Color de fondo
    ' %{v:lua.get_mode()} ', -- Modo actual
    '%#LineNr#',            -- Cambiar color
    ' %f',                  -- Ruta del archivo
    '%m',                   -- Modificado
    '%r',                   -- Solo lectura
    '%h',                   -- Ayuda
    '%w',                   -- Vista previa
    '%=',                   -- Alineación derecha
    '%#CursorColumn#',      -- Color
    ' %y',                  -- Tipo de archivo
    ' %{&fileencoding?&fileencoding:&encoding}', -- Codificación
    ' [%{&fileformat}]',    -- Formato
    ' %p%%',                -- Porcentaje
    ' %l:%c ',              -- Línea:Columna
}, '')

-- Hacer la función de modo disponible globalmente para statusline
_G.get_mode = get_mode

-- ==============================================================================
-- CONFIGURACIONES ADICIONALES
-- ==============================================================================

-- Configuración para diferentes sistemas
if vim.fn.has('unix') == 1 then
    vim.opt.shell = '/bin/bash'
end

-- Mejorar rendimiento en archivos grandes
vim.opt.synmaxcol = 200     -- Sintaxis solo hasta columna 200
vim.opt.regexpengine = 1    -- Motor de regex más rápido

-- Configuración de clipboard
if vim.fn.has('unnamedplus') == 1 then
    vim.opt.clipboard = 'unnamedplus'
elseif vim.fn.has('unnamed') == 1 then
    vim.opt.clipboard = 'unnamed'
end

-- ==============================================================================
-- CONFIGURACIÓN FINAL
-- ==============================================================================

-- Mensaje de bienvenida
vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
        if vim.fn.argc() == 0 then
            print('🚀 Neovim configurado y listo para usar!')
        end
    end,
})

-- Configuración específica para diferentes tipos de terminal
-- En Neovim, t_Co no es necesario ya que maneja automáticamente los colores
if vim.env.TERM and vim.env.TERM:match('256color') then
    -- Neovim maneja automáticamente los colores de terminal
    -- No necesitamos configurar t_Co como en Vim tradicional
end
