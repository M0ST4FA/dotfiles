return {
  {
    'neovim/nvim-lspconfig',
    config = function()

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      -- Shared config
      local on_attach = function(client, bufnr)
      end

      vim.diagnostic.config({
        signs = true,
        update_in_insert = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Setup the dart language lsp (it uses fvm as a wrapper, so it is special)
      vim.lsp.config.dartls = {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "fvm", "dart", "language-server", "--protocol=lsp" },
      }

      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "clangd", "asm_lsp", "bashls", "systemd_lsp", "docker_language_server", "lua_ls", "cssls", "html", "jsonls", "vtsls", "autotools_ls", "prismals" },
        function(server_name)
          lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,
        ["clangd"] = function()
          vim.lsp.config.clangd = {
            capabilities = capabilities,
            cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--function-arg-placeholders",
            "--cross-file-rename",
          },
          init_options = {
            fallbackFlags = { '-std=c++20', '-std=c23' },
            clangdFileStatus = true,
          },
          }
        end,
        ["gopls"] = function()
          vim.lsp.config.gopls = {
            capabilities = capabilities,
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_markers = { "go.work", "go.mod", ".git" },

            settings = {
              gopls = {
                gofumpt = true,
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,

                analyses = {
                  unusedparams = true,
                  nilness = true,
                  unusedwrite = true,
                  useany = true,
                },

                hints = {
                  assignVariableTypes = true,
                  compositeLiteralFields = true,
                  compositeLiteralTypes = true,
                  constantValues = true,
                  functionTypeParameters = true,
                  parameterNames = true,
                  rangeVariableTypes = true,
                },
              },
            },
          }
        end,
      })

      vim.lsp.inlay_hint.enable(true)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

      -- This tells Neovim to start all configured servers when the appropriate filetype is opened.
      vim.lsp.enable({
        "clangd",
        "gopls",
        "delve",
        "bashls",
        "html",
        "cssls",
        "tsserver",
        "systemd-lsp",
        "docker-language-server",
        "jsonls",
        "autotools_ls",
        "prismals",
      })

    end
},
   -- Completion engine
  {
    "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {

    -- nvim-cmp friends
    -- LSP source for nvim-cmp
    "hrsh7th/cmp-nvim-lsp",
    -- Buffer completions
    "hrsh7th/cmp-buffer",
    -- File path completions
    "hrsh7th/cmp-path",
    'hrsh7th/cmp-cmdline',

    -- Snippet engine and sources
    -- Snippet completions
    "saadparwaiz1/cmp_luasnip",
    -- LuaSnip snippets engine
    "L3MON4D3/LuaSnip",
    -- Useful snippet collection
    "rafamadriz/friendly-snippets",

    -- Completion UI icons
    "onsails/lspkind.nvim",
  },
  config = function() 
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    -- Completion UI icons
    local lspkind = require("lspkind")
    lspkind.init({
      symbol_map = {
        Function = "󰊕",
        Method = "󰆧",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Keyword = "󰌋",
        Snippet = "",
        File = "󰈙",
        Folder = "󰉋",
      },
    })

    -- Load snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      completion = {
        completeopt = "menu,menuone,noinsert",
      },

      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "…",
          menu = {
            nvim_lsp = "[LSP]",
            buffer   = "[Buf]",
            path     = "[Path]",
            luasnip  = "[Snip]",
            cmdline  = "[Cmd]",
          },
        }),
      },

      window = {
        completion = cmp.config.window.bordered({
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
        }),
        documentation = cmp.config.window.bordered(),
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
      }),

      experimental = {
        ghost_text = true,
      },
    })

    -- Cmdline completion
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "path" },
        { name = "cmdline" },
      },
    })
  end,
  }, {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
    lazy = false,
  }, {
    "williamboman/mason-lspconfig.nvim",
  }
}
