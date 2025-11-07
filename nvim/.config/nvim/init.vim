" ========== Neovim Lazy.nvim Bootstrap ==========
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
EOF

" ========== Load Plugins ==========
lua << EOF
require("lazy").setup("plugins")
EOF

" ========== General Settings ==========
set number
set relativenumber
set tabstop=2 shiftwidth=2 expandtab
set termguicolors
set cursorline
set laststatus=3
set clipboard=unnamedplus
set noswapfile
set hidden
