弹棉花


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
* `:lua require'cotton'.lint()`

---

弹棉花啊弹棉花  
半斤棉弹成八两八哟  
旧棉花弹成了新棉花哟  
弹好了棉被那个姑娘要出嫁  
哎哟勒哟勒　哎哟勒哟勒  
弹好了棉被那个姑娘要出嫁  
那个姑娘要出嫁  
弹棉花罗弹棉花  
半斤棉弹出八两八哟  
旧棉花弹成了新棉花哟  
弹好了棉被姑娘要出嫁  
