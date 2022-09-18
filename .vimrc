" mm    mm     ##
" *#    #*     **
"  ##  ##    ####     ####m##m   ##m####   m#####m
"  ##  ##      ##     ## ## ##   ##*      ##*    *
"   ####       ##     ## ## ##   ##       ##
"   ####    mmm##mmm  ## ## ##   ##       *##mmmm#
"   ****    ********  ** ** **   **        *******

" NOTE: The following vimrc requires vim built with Python3 and LUA support

" General Settings and keymappings {{{
set nocompatible        "Necessary for cool vim things
set noswapfile          "Disable swap files permanently
set title               "Show filename in the window titlebar
set number              "Show line numbers
set relativenumber      "Show line numbers relative to cursor
set encoding=utf-8      "Set encoding
set ruler               "Add ruler at the bottom of vim
set cursorline          "Highlight cursor line
set backspace=indent,eol,start  "Make backspace work like most text editors
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --follow
set grepformat=%f:%l:%c:%m,%f:%l:%m
set splitright

" Exit insert mode faster
inoremap <silent> jj <esc>

" Enter normal mode in terminal faster
tnoremap <c-o> <c-\><c-n>

"Select the active splits
nnoremap <silent> <c-k> :wincmd k<CR>
nnoremap <silent> <c-j> :wincmd j<CR>
nnoremap <silent> <c-h> :wincmd h<CR>
nnoremap <silent> <c-l> :wincmd l<CR>

nnoremap <silent> <c-q> :bd<CR>
nnoremap <silent> <c-s> :w<CR>

" Section folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax
nnoremap <space> za
" }}}
" Plugin management {{{
call plug#begin()

Plug 'arcticicestudio/nord-vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'voldikss/vim-floaterm'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'vim-test/vim-test'
Plug 'chrisbra/Colorizer'
Plug 'prabirshrestha/asyncomplete.vim'
\ | Plug 'prabirshrestha/asyncomplete-lsp.vim'
\ | Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
\ | Plug 'prabirshrestha/vim-lsp'
\ | Plug 'mattn/vim-lsp-settings'
\ | Plug 'SirVer/ultisnips'
\ | Plug 'honza/vim-snippets'

call plug#end()
" }}}
" Floaterm {{{
nnoremap <silent> <F12> :FloatermNew<CR>
tnoremap <silent> <F12> <c-\><c-n>:FloatermKill<CR>
let g:floaterm_width=0.9
let g:floaterm_height=0.9
" }}}
" NERDTree {{{
nmap <silent> <leader>n :NERDTreeToggle<CR>
" }}}
" Fzf {{{
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :Rg<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader>ft :Tags<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fs :Snippets<CR>

"Enable Rg with preview, but don't consider filenames as match
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>),
  \   1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

let g:fzf_layout={'window': { 'width': 0.9, 'height': 0.9 }}

"Customize fzf colors to match color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Normal'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" }}}
" Airline {{{
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
" }}}
" EditorConfig {{{
let g:EditorConfig_exclude_patterns=['fugitive://.*']  " Ensure compatibility
let g:EditorConfig_max_line_indicator='exceeding'
" }}}
" Fugitive {{{
nnoremap <silent> <leader>gs :Git<CR>
nnoremap <silent> <leader>gd :vert Git diff<CR>
nnoremap <silent> <leader>gb :Git blame<CR>
nnoremap <silent> <leader>gl :vert Git log<CR>
nnoremap <silent> <leader>glo :vert Git log --oneline<CR>
" }}}
" Colorizer {{{
let g:colorizer_vimcolors_disable = 1  " Throws error unless disabled
nnoremap <silent> <Leader>ct :ColorToggle<CR>
" }}}
" Colorscheme {{{
augroup nord-theme-overrides
  autocmd!
  " Make folded comments stand out more using a more bluish accent
  autocmd ColorScheme nord highlight Folded cterm=italic,bold ctermfg=6 guifg=#81A1C1 guibg=NONE ctermbg=NONE
  " Set LineNr to same color coding as Comments
  autocmd ColorScheme nord highlight LineNr ctermfg=8 guifg=#616E88
"augroup END

" Chicken-Egg problem: vim will return error code on exit until vim-plug has installed
" arcticicestudio/nord-vim'. Using :silent! will suppress the error.
silent! colorscheme nord

if (has("termguicolors"))
  set termguicolors
  "Use background settings of the termimal instead (i.e. for transparency)
  hi Normal guibg=NONE ctermbg=NONE
  hi SignColumn guibg=NONE ctermbg=NONE
endif



" }}}
" Test {{{

let test#strategy = 'floaterm'
let test#python#runner = 'pytest'

nnoremap <silent> <leader>tt :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ta :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>

" }}}
" VimWiki {{{
" Make vimwiki compatible with UltiSnips
" Note however, that 'UltiSnipsAddFiletypes markdown' must be added to
" ~/.vim/ftplugin/vimwiki.vim as well.
let g:vimwiki_list = [{'ext': '.markdown', 'path': '$HOME/vimwiki/', 'syntax': 'markdown'}]
let g:vimwiki_table_mappings = 0
" }}}
" Asyncomplete {{{
set shortmess+=c

inoremap <expr> <tab> pumvisible() ? "\<c-n>" : UltiSnips#CanJumpForwards() ? "<C-R>=UltiSnips#JumpForwards()<CR>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : UltiSnips#CanJumpBackwards() ? "<C-R>=UltiSnips#JumpBackwards()<CR>" : "\<s-tab>"
inoremap <expr> <cr> pumvisible() ? (UltiSnips#CanExpandSnippet() ? "<C-R>=UltiSnips#ExpandSnippet()<CR>" : asyncomplete#close_popup()) : "\<cr>"

" Additional (wanted) features:
"   1) Make completion suggestion (on enter) automatically enter snippet mode.
"      Normally, when pressing "enter" you just complete e.g. the func name,
"      but not the func prototype. Would be nice if it was possible to feed
"      the func prototype to ultisnip, making it easier to modify the input
"      parameters using ultisnip key bindings. This probably difficult without
"      using LSP snippets? not sure that even supports this kind of feature.
"inoremap <expr> <cr> pumvisible() ? (UltiSnips#CanExpandSnippet() ? "\<c-e>" : asyncomplete#close_popup()) : "\<cr>"

if has("nvim")
    imap <c-space> <Plug>(asyncomplete_force_refresh)
else
    imap <c-@> <Plug>(asyncomplete_force_refresh)
endif

function! s:sort_by_priority_preprocessor(options, matches) abort
  let l:items = []
  for [l:source_name, l:matches] in items(a:matches)
    for l:item in l:matches['items']
      if stridx(l:item['word'], a:options['base']) == 0
        let l:item['priority'] =
            \ get(asyncomplete#get_source_info(l:source_name),'priority',0)
        call add(l:items, l:item)
      endif
    endfor
  endfor
  let l:items = sort(l:items, {a, b -> b['priority'] - a['priority']})
  call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

let g:asyncomplete_min_chars = 2
let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]
" }}}
" Asyncomplete (LSP) {{{

let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_float_cursor = 1

" TODO: Turn off background color for diagnostics column

" Just use colors for highlighting the diagnostics column
let g:lsp_diagnostics_signs_error = {'text': ' '}
let g:lsp_diagnostics_signs_warning = {'text': ' '}
let g:lsp_diagnostics_signs_info = {'text': ' '}
let g:lsp_diagnostics_signs_hint = {'text': ' '}

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

if executable('yaml-language-server')
  augroup LspYaml
   autocmd!
   autocmd User lsp_setup call lsp#register_server({
       \ 'name': 'yaml-language-server',
       \ 'cmd': {server_info->['yaml-language-server', '--stdio']},
       \ 'whitelist': ['yaml', 'yaml.ansible'],
       \ 'workspace_config': {
       \   'yaml': {
       \     'validate': v:true,
       \     'hover': v:true,
       \     'completion': v:true,
       \     'customTags': [],
       \     'schemas': {},
       \     'schemaStore': { 'enable': v:true },
       \   }
       \ }
       \})
  augroup END
endif

" Seems like there's some issue with the lsp server
" Not sure if it's due to npm install version
"if executable('docker-langserver')
"    au User lsp_setup call lsp#register_server({
"        \ 'name': 'docker-langserver',
"        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
"        \ 'whitelist': ['dockerfile'],
"        \ })
"endif

if executable('bash-language-server')
  augroup LspBash
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'bash-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
          \ 'allowlist': ['sh'],
          \ })
  augroup END
endif

let g:lsp_settings = {
\   'pylsp-all': {
\     'workspace_config': {
\       'pylsp': {
\         'configurationSources': ['flake8']
\       }
\     }
\   },
\}

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" }}}
" Asyncomplete (UltiSnips) {{{
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
    \ 'name': 'ultisnips',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
    \ }))
" }}}

" vim:foldmethod=marker:foldlevel=0
