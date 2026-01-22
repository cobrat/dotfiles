-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
-- Treesitter
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        -- Use pcall to avoid crashing if the plugin is not yet installed
        local status, configs = pcall(require, "nvim-treesitter.configs")
        if not status then
            return
        end

        configs.setup({
            -- Add languages you want to be installed
            ensure_installed = { 
                "lua", 
                "vim", 
                "vimdoc", 
                "python",
            },
            highlight = { 
                enable = true 
            },
            indent = { 
                enable = true 
            },
        })
    end
},

-- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<cr>" },
      { "<leader>g", "<cmd>Telescope live_grep<cr>" },
    }
  },

  -- LSP configuration
  { "neovim/nvim-lspconfig" },

  -- Which key
    {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- Leave empty for default setup
    },
  },
})
