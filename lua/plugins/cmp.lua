return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
    config = {
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
