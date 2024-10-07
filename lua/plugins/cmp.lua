return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true
      return {

        auto_brackets = {}, -- configure any filetype to auto add brackets
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
          ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(entry, item)
            local icons = LazyVim.config.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end,
        },
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
    config = {

      window = {
        completion = {
          border = "rounded",
        },
        documentation = {
          border = "rounded",
        },
      },
      formatting = {
        format = function(entry, vim_item)
          local KIND_ICONS = {
            Tailwind = "󰹞󰹞󰹞󰹞",
            Color = " ",
            -- Class = 7,
            -- Constant = '󰚞',
            -- Constructor = 4,
            -- Enum = 13,
            -- EnumMember = 20,
            -- Event = 23,
            -- Field = 5,
            -- File = 17,
            -- Folder = 19,
            -- Function = 3,
            -- Interface = 8,
            -- Keyword = 14,
            -- Method = 2,
            -- Module = 9,
            -- Operator = 24,
            -- Property = 10,
            -- Reference = 18,
            -- Snippet = "󰅴 ",
            -- Struct = 22,
            -- Text = "",
            -- TypeParameter = 25,
            -- Unit = 11,
            -- Value = 12,
            -- Variable = 6
          }
          if vim_item.kind == "Color" and entry.completion_item.documentation then
            local color = tostring(entry.completion_item.documentation)
            color = string.gsub(color, "#", "")
            if string.match(color, "^#?%x%x%x%x%x%x$") ~= nil then
              local group = "Tw_" .. color

              if vim.api.nvim_call_function("hlID", { group }) < 1 then
                vim.api.nvim_command("highlight" .. " " .. group .. " " .. "guifg=#" .. color)
              end

              vim_item.kind = KIND_ICONS.Tailwind
              vim_item.kind_hl_group = group

              return vim_item
            end
          end

          vim_item.kind = KIND_ICONS[vim_item.kind] or vim_item.kind

          return vim_item
        end,
      },
    },
  },
}
