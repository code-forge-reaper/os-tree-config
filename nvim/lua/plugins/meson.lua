
---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd"
        -- add more arguments for adding more language servers
      },
    },
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  }
}
