return {
  { "williamboman/mason.nvim", enabled = false },
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = { mason = false },
        lua_ls  = { mason = false },
        clangd  = { mason = false },
        nil_ls  = { mason = false },
      },
    },
  },
}
