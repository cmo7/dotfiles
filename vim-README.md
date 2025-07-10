# Configuración de Vim/Neovim

Este directorio contiene configuraciones modernas para Vim y Neovim.

## Archivos incluidos

### `vimrc`
Configuración completa y moderna para Vim tradicional que incluye:

- **Configuración básica**: Codificación UTF-8, backspace intuitivo
- **Interfaz mejorada**: Números de línea, resaltado de sintaxis, statusline personalizada
- **Búsqueda inteligente**: Búsqueda incremental, ignorar mayúsculas
- **Indentación**: Espacios en lugar de tabs, indentación inteligente
- **Navegación**: Mapeos para ventanas, buffers y movimiento de líneas
- **Productividad**: Autocompletado, folding, comandos personalizados
- **Autocomandos**: Restaurar posición del cursor, configuraciones por tipo de archivo

### `config/nvim/init.lua`
Configuración moderna para Neovim usando Lua que incluye todo lo anterior más:

- **Sintaxis Lua moderna**: Aprovecha las características de Neovim
- **Mejor rendimiento**: Configuración optimizada
- **Funciones mejoradas**: Resaltado de texto yankeado, mejor manejo de autocomandos
- **Statusline avanzada**: Información de modo, Git (si está disponible)

## Características principales

### Mapeos de teclas (Leader: Espacio)

- `<leader>w` - Guardar archivo
- `<leader>q` - Salir
- `<leader>h` - Limpiar resaltado de búsqueda
- `<Ctrl>hjkl` - Navegación entre ventanas
- `<leader>np` - Navegación entre buffers
- `<Alt>jk` - Mover líneas arriba/abajo
- `<leader>y/p` - Copiar/pegar al portapapeles del sistema

### Configuraciones por tipo de archivo

- **JavaScript/TypeScript/JSON/HTML/CSS/YAML**: 2 espacios de indentación
- **Python**: 4 espacios de indentación
- **Go**: Tabs reales, 4 espacios de ancho
- **Markdown**: Wrap de líneas, 80 caracteres

### Funciones útiles

- `:TrimWhitespace` - Eliminar espacios en blanco al final
- `<leader>r` - Alternar números relativos
- Autoguardado con limpieza de espacios en blanco
- Creación automática de directorios al guardar

## Instalación

El script `install.sh` se encarga automáticamente de:

1. Crear enlace simbólico de `vimrc` a `~/.vimrc`
2. Crear enlace simbólico de `config/nvim/init.lua` a `~/.config/nvim/init.lua`

## Personalización

### Para añadir plugins (Vim)

Considera usar un gestor de plugins como:
- [vim-plug](https://github.com/junegunn/vim-plug)
- [Vundle](https://github.com/VundleVim/Vundle.vim)

### Para añadir plugins (Neovim)

Considera usar gestores modernos como:
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [packer.nvim](https://github.com/wbthomason/packer.nvim)

## 🎨 Temas de colores

### Temas disponibles

La configuración incluye varios temas de colores modernos:

1. **One Dark** (por defecto) - Tema oscuro inspirado en VS Code
2. **Light** - Tema claro minimalista
3. **Gruvbox** - Tema cálido y retro
4. **Dracula** - Tema oscuro con colores vibrantes

### Cambiar temas

#### Comandos:
```vim
:Theme dark      " Tema oscuro (One Dark)
:Theme light     " Tema claro
:Theme gruvbox   " Tema Gruvbox
:Theme dracula   " Tema Dracula
```

#### Mapeos de teclas:
- `<space>td` - Tema oscuro
- `<space>tl` - Tema claro  
- `<space>tg` - Tema Gruvbox
- `<space>tr` - Tema Dracula

### Personalización de colores

Los temas están optimizados para:
- ✨ **Sintaxis moderna** con colores diferenciados
- 👁️ **Legibilidad mejorada** con contrastes apropiados
- 🎯 **Statusline atractiva** con información clara
- 📝 **Comentarios suaves** que no distraen
- 🔍 **Búsqueda resaltada** fácil de identificar
- 📋 **Menús de completado** con estilo moderno

### Colores incluidos

**One Dark (por defecto)**:
- Fondo: `#282c34` (gris oscuro)
- Texto: `#abb2bf` (gris claro)
- Strings: `#98c379` (verde)
- Keywords: `#c678dd` (morado)
- Funciones: `#61afef` (azul)
- Comentarios: `#5c6370` (gris)

**Tema claro**:
- Fondo: `#ffffff` (blanco)
- Texto: `#2d3748` (gris oscuro)
- Acentos en tonos azules y naranjas

**Gruvbox**:
- Colores cálidos tierra
- Excelente para sesiones largas
- Fácil para los ojos

**Dracula**:
- Colores vibrantes
- Fondo morado oscuro
- Rosa y cyan para acentos

## Tips de uso

1. **Explorar archivos**: Usa `:e .` para abrir el explorador de archivos nativo
2. **Buscar y reemplazar**: `:%s/buscar/reemplazar/g`
3. **Múltiples archivos**: `:args *.py` para cargar múltiples archivos
4. **Macros**: `q<letra>` para grabar, `@<letra>` para reproducir
5. **Marks**: `m<letra>` para marcar, `'<letra>` para ir a la marca

## Troubleshooting

### Si no se ven los colores correctamente
```bash
export TERM=xterm-256color
```

### Si el portapapeles del sistema no funciona
- En Linux: Instalar `xclip` o `xsel`
- En macOS: Debería funcionar por defecto
- En Windows/WSL: Configurar apropiadamente el clipboard

### Para verificar las capacidades de Vim
```vim
:echo has('clipboard')
:echo has('python3')
:echo has('lua')
```
