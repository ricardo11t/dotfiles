-- =============================================================================
-- Gerenciador de Plugins: lazy.nvim
-- =============================================================================
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

-- =============================================================================
-- Opções Gerais do Vim
-- =============================================================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "
vim.opt.termguicolors = true

-- =============================================================================
-- Configurações de Identação
-- =============================================================================
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- =============================================================================
-- Configuração dos Plugins com Lazy.nvim
-- =============================================================================
require('lazy').setup({
  -- Tema (Colorscheme) - DEVE SER O PRIMEIRO
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000, -- Garante que o tema carregue antes de outros plugins de UI
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        transparent = false,
        terminalColors = true,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
      -- Aplica o tema após a configuração
      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_suggestion_enabled = true
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope.builtin')
      -- ATENÇÃO: O plugin "snacks.nvim" também usa <leader>ff, <leader>fg, etc.
      -- Decida quais atalhos você prefere usar para evitar conflitos.
      -- Por enquanto, estes do Telescope funcionarão.
      vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = "Telescope - Buscar arquivos" })
      vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = "Telescope - Buscar texto" })
      vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = "Telescope - Listar buffers" })
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat<cr>", desc = "CodeCompanion - Abrir Chat" },
      { "<leader>ae", "<cmd>CodeCompanion Action Explain<cr>", mode = "v", desc = "CodeCompanion - Explicar" },
      { "<leader>af", "<cmd>CodeCompanion Action Fix<cr>", mode = "v", desc = "CodeCompanion - Corrigir" },
      { "<leader>at", "<cmd>CodeCompanion Action Tests<cr>", mode = "v", desc = "CodeCompanion - Gerar Testes" },
      { "<leader>ad", "<cmd>CodeCompanion Action Docs<cr>", mode = "v", desc = "CodeCompanion - Gerar Docs" },
    },
    config = function()
      require("codecompanion").setup({
        provider = "anthropic",
        api_key = vim.env.ANTHROPIC_API_KEY,
        model = "claude-3-sonnet-20240229",
        tools = {
          telescope = true,
        },
        agents = {
          {
            name = "gemini-pro",
            provider = "google",
            api_key = vim.env.GOOGLE_API_KEY,
            model = "gemini-1.5-pro-latest",
          },
          {
            name = "gemini-flash",
            provider = "google",
            api_key = vim.env.GOOGLE_API_KEY,
            model = "gemini-1.5-flash-latest",
          },
        },
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
        require("lsp_signature").setup({
        bind = true,
        handler_opts = {
            border = "rounded"
        }
        })
        end
    },

  -- LSP e Autocomplete
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  },

  -- Tradutor de Erros do TypeScript
  { 'dmmulroy/ts-error-translator.nvim' },

  -- Treesitter para Syntax Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "javascript", "typescript", "html", "lua", "jsx", "tsx" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Integração com Git
  {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            signs = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signcolumn = true,
            numhl      = false,
            linehl     = false,
            word_diff  = false,
            watch_gitdir = {
                follow_files = true
            },
            auto_attach = true,
            attach_to_untracked = false,
            current_line_blame = false,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol',
                delay = 1000,
                ignore_whitespace = false,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        }
    end,
  },

  -- Ícones para a UI
  { "nvim-tree/nvim-web-devicons", opts = {} },

  -- Fechamento automático de tags HTML/JSX
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    after = 'nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
    
  -- Fechamento automático de pares (parênteses, etc.)
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        ts_config = {
          lua = {'string'},
          javascript = {'string', 'jsx_element'},
          typescript = {'string', 'jsx_element'},
        }
      })
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  },

  -- Explorador de Arquivos
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('nvim-tree').setup({})
    end,
  },

  -- UI e Utilidades (Snacks)
  {
    "folke/snacks.nvim",
    enable = false,
    lazy = false,
    opts = {
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      picker = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
        { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
        { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
        { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
        { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
        { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
        { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
        { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
})

-- =============================================================================
-- Configurações Pós-Plugins
-- =============================================================================

-- LSP Zero
local lsp_zero = require('lsp-zero')
lsp_zero.preset('recommended')

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'eslint', 'html'},
  handlers = {
    lsp_zero.default_setup,
  },
})

require("ts-error-translator").setup()

-- nvim-cmp (autocompletar)
local cmp = require('cmp')
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'luasnip'},
    {name = 'buffer'},
    {name = 'path'},
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
})

-- Handler para o tradutor de erros do TS
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
  require("ts-error-translator").translate_diagnostics(err, result, ctx)
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

-- Atalho para o Explorador de Arquivos
vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', {
  silent = true,
  noremap = true,
  desc = "Alternar explorador de arquivos (NvimTree)",
})
