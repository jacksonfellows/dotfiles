return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 0
      vim.g.vimtex_compiler_method = "latexmk"

      vim.g.vimtex_quickfix_mode = 2              -- open, but keep cursor in the tex buffe
      vim.g.vimtex_quickfix_open_on_warning = 0   -- errors only, no overfull-hbox noise
      vim.g.vimtex_quickfix_autoclose_after_keystrokes = 3

      vim.g.vimtex_compiler_latexmk = { out_dir = "build" }
      vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
    end,
  },
  {
    "nvim-telescope/telescope-bibtex.nvim",
    ft = "tex",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        extensions = { bibtex = { global_files = { "~/Documents/bib/zotero.bib" } } },
      })
      require("telescope").load_extension("bibtex")
      vim.keymap.set("n", "<leader>fb", "<cmd>Telescope bibtex<cr>")
    end,
  },
}
