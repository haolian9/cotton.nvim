
an example to integrate external linters into nvim

## features
* lint against the current content of buffers, no need to save first
* utilize vim.diagnostic, rather than flush quickfix/location list
* run multiple linters in parallel by spawning processes
* no overhead to go through lsp protocol

## status
* it just works(tm)
* it is feature-frozen

## prerequisites
* linux
* nvim 0.9.*
* haolian9/infra.nvim
* haolian9/cthulhu.nvim
* external linters: ruff, shellcheck

## usage
* `:lua require'linters'.lint()`
