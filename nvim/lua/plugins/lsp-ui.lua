return {
  -- existing mason + lspconfig + ensure_installed earlier
  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup()
      -- example keymaps
      local map = vim.keymap.set
      map("n", "K", "<cmd>LspUI hover<CR>")
      map("n", "gd", "<cmd>LspUI definition<CR>")
      map("n", "<leader>ca", "<cmd>LspUI code_action<CR>")
      map("n", "<leader>rn", "<cmd>LspUI rename<CR>")
      map("n", "[d", "<cmd>LspUI diagnostic prev<CR>")
      map("n", "]d", "<cmd>LspUI diagnostic next<CR>")
    end
  },
  {
    "j-hui/fidget.nvim",
  }
}
