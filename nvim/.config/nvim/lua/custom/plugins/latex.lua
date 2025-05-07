return {
  {
    'lervag/vimtex',
    lazy = false, -- Load on startup (important for filetype detection)
    config = function()
      -- General settings
      vim.g.vimtex_view_method = 'skim'
      vim.g.vimtex_compiler_method = 'latexmk'
      vim.g.vimtex_mappings_enabled = 1
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_main_file = 'main.tex'
      vim.g.vimtex_compiler_latexmk = {
        continuous = 0,
        background = 1,
        callback = 1,
        build_dir = 'out',
        options = {
          '-pdf',
          '-interaction=nonstopmode',
          '-synctex=1',
          '-outdir=out',
          '-shell-escape',
        },
      }

      -- Optional: Useful keymaps
      vim.keymap.set('n', '<leader>lc', '<cmd>VimtexCompile<CR>', { desc = 'LaTeX Compile' })
      vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<CR>', { desc = 'LaTeX View PDF' })
      vim.keymap.set('n', '<leader>lk', '<cmd>VimtexStop<CR>', { desc = 'LaTeX Kill Compiler' })
    end,
  },
}
