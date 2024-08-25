local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
  },
}

M.config = function()
  local cmp = require("cmp")
  local function prio(kind)
    return function(e1, e2)
      if e2:get_kind() == kind then
        return false
      end
      if e1:get_kind() == kind then
        return true
      end
    end
  end
  local function deprio(kind)
    return function(e1, e2)
      if e1:get_kind() == kind then
        return false
      end
      if e2:get_kind() == kind then
        return true
      end
    end
  end
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<TAB>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      {
        name = "nvim_lsp",
        -- entry_filter = function(entry)
        --   return cmp.lsp.CompletionItemKind.Snippet ~= entry:get_kind()
        -- end,
      },
      { name = "nvim_lua" },
      { name = "luasnip" }, -- For luasnip users.
      -- { name = "orgmode" },
    }, {
      { name = "buffer" },
      { name = "path" },
    }),
    sorting = {

      priority_weight = 10,
      comparators = {
        prio(cmp.lsp.CompletionItemKind.Field),
        prio(cmp.lsp.CompletionItemKind.Method),
        -- deprio(cmp.lsp.CompletionItemKind.Snippet),
        -- deprio(cmp.lsp.CompletionItemKind.Text),
        -- deprio(cmp.lsp.CompletionItemKind.Keyword),
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.recently_used,
        cmp.config.compare.locality,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  })

  -- cmp.setup.cmdline(":", {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = "path" },
  --   }, {
  --     { name = "cmdline" },
  --   }),
  -- })
end

return M
