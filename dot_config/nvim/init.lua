-- Leader keys must be set before lazy.setup().
-- localleader = "\" is what makes VimTeX's \ll, \lv mappings work.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Your previous init.vim, preserved.
local legacy = vim.fn.stdpath("config") .. "/legacy.vim"
if vim.uv.fs_stat(legacy) then
  vim.cmd("source " .. vim.fn.fnameescape(legacy))
end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
