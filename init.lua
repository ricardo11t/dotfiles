-- [[ Gerenciador de Plugins: lazy.nvim ]]
-- Instala o lazy.nvim automaticamente se não estiver presente
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

-- [[ Opções Gerais do Vim ]]
vim.opt.number = true         -- Mostra o número da linha
vim.opt.relativenumber = true -- Mostra números de linha relativos
vim.g.mapleader = " "         -- Define a tecla líder como Espaço
vim.opt.termguicolors = true  -- Habilita cores de 24-bit para temas

-- [[ Configurações de Identação ]]
vim.opt.tabstop = 4	-- Largura visual de um caractere <Tab>.
vim.opt.shiftwidth = 4	-- Quantos espaços usar para indentação (com >>, <<, ou autoindent).
vim.opt.softtabstop = 4	-- Permite apagar 4 espaços como se fossem um único <Tab>.
vim.opt.expandtab = true-- Converte <Tab> em espaços. Essencial para usar espaços.

-- [[ Configuração dos Plugins ]]
require('lazy').setup({
  -- Tema de cores (carregado primeiro para evitar piscar de tela)
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight'
    end,
  },
  
  -- LSP, Autocompletar e Ferramentas (agrupados sob lsp-zero)
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      -- Essenciais para lsp-zero
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },

      -- Autocompletar (nvim-cmp)
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-path' },

      -- Snippets
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
  },

  {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = function()
	      require('nvim-autopairs').setup({})
      end
  },

  -- Outros plugins
  { 'lewis6991/gitsigns.nvim', config = true }, -- `config = true` é um atalho para chamar .setup()

  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({})
    end,
  },
})

-- [[ Configuração do LSP e Autocompletar ]]
-- Esta seção configura os plugins que foram carregados acima

local lsp_zero = require('lsp-zero')

-- O preset "recomendado" configura automaticamente nvim-cmp, lspconfig e os atalhos padrão.
-- É a maneira mais simples e eficaz de usar o lsp-zero v3.
lsp_zero.preset("recommended")

-- Define o que acontece quando um servidor LSP se anexa a um buffer.
lsp_zero.on_attach(function(client, bufnr)
  -- Cria os atalhos de teclado padrão do LSP (ex: `gd`, `K`, `gR`) no buffer atual.
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- Configura o Mason para que você possa instalar LSPs, formatadores e linters
require('mason').setup({})

-- Configura o mason-lspconfig para conectar o Mason ao lspconfig
require('mason-lspconfig').setup({
  -- Lista de servidores LSP que você quer que sejam instalados automaticamente
  ensure_installed = {
    -- Nomes corrigidos para o registro do Mason
    'tsserver', -- typescript-language-server
    'eslint',
    'pyright',
    'lua_ls', -- lua-language-server
    'rust_analyzer',
    'jdtls',
    'dotenv_linter',
    'docker_compose_language_service',
    'dockerls', -- dockerfile-language-server
  },
  handlers = {
    -- Esta função (do lsp-zero) garante que cada LSP instalado
    -- seja configurado com as configurações corretas (on_attach, capabilities)
    lsp_zero.default_setup,
  },
})

-- [[ Atalhos de Teclado Personalizados ]]
vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', {
  silent = true,
  noremap = true,
  desc = "Alternar explorador de arquivos (NvimTree)",
})
