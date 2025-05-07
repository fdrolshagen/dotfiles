return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      size = 10,
      open_mapping = [[<leader>t]],
      direction = 'horizontal',
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      close_on_exit = true,
      shell = vim.o.shell,
    }
  end,
}
