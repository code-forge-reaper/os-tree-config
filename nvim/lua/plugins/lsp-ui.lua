return {
  -- existing mason + lspconfig + ensure_installed earlier
  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup()
      vim.diagnostic.config({
          virtual_text = false,
      })
    end
  },
  {
    "j-hui/fidget.nvim",
  }
}
