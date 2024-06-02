colorscheme murphy

set number
set hlsearch
set smartindent
set wildmenu
set mouse=a
if has('mouse_sgr')
	set ttymouse=sgr
else
	set ttymouse=xterm
endif

let g:git_current_branch_name = ''
function GitStartBranchTracking(timer_id) abort
	call git#branch#start_tracking()
endfunction
call timer_start(1000, 'GitStartBranchTracking')
set laststatus=2
set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%3*%{'[🌲'.g:git_current_branch_name.']'}%*            "git current branch
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor

autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2

let s:home_dir = expand('~')
let s:pack_dir = s:home_dir.'/.vim/pack/vIDE'
if executable(s:pack_dir.'/phpactor/bin/phpactor')
	au User lsp_setup call lsp#register_server({
	\	'name': 'phpactor',
	\	'cmd': [s:pack_dir.'/phpactor/bin/phpactor', 'language-server'],
	\	'allowlist': ['php'],
	\ })
endif
if filereadable(s:pack_dir.'/node_modules/vim-language-server/bin/index.js')
	au User lsp_setup call lsp#register_server({
	\	'name': 'vim-language-server',
	\	'cmd': ['node', s:pack_dir.'/node_modules/vim-language-server/bin/index.js', '--stdio'],
	\	'allowlist': ['vim'],
	\	'initialization_options': {
		\	'isNeovim': has('nvim'),
		\	'vimruntime': $VIMRUNTIME,
		\	'runtimepath': &rtp,
		\	'iskeyword': &isk . ',:,-,#',
		\	'diagnostic': {'enable': v:true}
		\ },
	\ })
endif
if filereadable(s:pack_dir.'/make-lsp-vscode/server/src/server.js')
	au User lsp_setup call lsp#register_server({
	\	'name': 'make-lsp-server',
	\	'cmd': ['node', s:pack_dir.'/make-lsp-vscode/server/src/server.js', '--stdio'],
	\	'allowlist': ['make'],
	\ })
endif
if filereadable(s:pack_dir.'/node_modules/bash-language-server/out/cli.js')
	au User lsp_setup call lsp#register_server({
	\	'name': 'bash-language-server',
	\	'cmd': ['node', s:pack_dir.'/node_modules/bash-language-server/out/cli.js', 'start'],
	\	'allowlist': ['sh'],
	\ })
endif
if executable('ccls')
	au User lsp_setup call lsp#register_server({
	\	'name': 'ccls',
	\	'cmd': ['ccls'],
	\	'allowlist': ['c', 'cpp'],
	\ })
endif
if executable(s:pack_dir.'/node_modules/dockerfile-language-server-nodejs/bin/docker-langserver')
	au User lsp_setup call lsp#register_server({
	\	'name': 'dockerfile-language-server',
	\	'cmd': [s:pack_dir.'/node_modules/dockerfile-language-server-nodejs/bin/docker-langserver', '--stdio'],
	\	'allowlist': ['dockerfile'],
	\ })
endif
if filereadable(s:pack_dir.'/vscode/extensions/html-language-features/server/src/node/htmlServerMain.js')
	au User lsp_setup call lsp#register_server({
	\	'name': 'vscode-html-languageserver',
	\	'cmd': ['node', s:pack_dir.'/vscode/extensions/html-language-features/server/src/node/htmlServerMain.js', '--stdio'],
	\	'allowlist': ['html'],
	\ })
endif
if executable(s:pack_dir.'/node_modules/quick-lint-js/linux-x64/bin/quick-lint-js')
	au User lsp_setup call lsp#register_server({
	\	'name': 'quick-lint-js',
	\	'cmd': [s:pack_dir.'/node_modules/quick-lint-js/linux-x64/bin/quick-lint-js', '--lsp'],
	\	'allowlist': ['javascript'],
	\ })
endif

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

let s:this_vimrc = s:home_dir.'/.vimrc'
let s:cwd_vimrc = getcwd().'/.vimrc'
if s:cwd_vimrc != s:this_vimrc && exists(s:cwd_vimrc)
	execute('source '.s:cwd_vimrc)
endif
