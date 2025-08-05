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

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "

require('lazy').setup({
	'lewis6991/gitsigns.nvim',

	{
		'nvim-tree/nvim-tree.lua',
		config = function()
			require('nvim-tree').setup({})
		end
	},

	{'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {}},
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'neovim/nvim-lspconfig',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip'
		},
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		dependencies = {
    			'neovim/nvim-lspconfig',
    			'williamboman/mason.nvim',
    			'williamboman/mason-lspconfig.nvim',
		}
	},
})

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
end)

require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		'typescript-language-server',
		'eslint',
		'pyright',
		'lua-language-server',
		'rust_analyzer',
		'jdtls',
		'dotenv-linter',
		'docker-compose-language-service',
		'dockerfile-language-server'
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', {
	silent = true,
	noremap = true,
	desc = "Toggle NvimTree"
})

vim.cmd.colorscheme 'tokyonight'
