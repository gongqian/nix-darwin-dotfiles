local gl = require "galaxyline"
local condition = require "galaxyline.condition"

local gls = gl.section
gl.short_line_list = { "NvimTree", "packer" }

-- Colors
local colors = {
   bg = "#3B4252",
   fg = "#E5E9F0",
   section_bg = "#434C5E",
   section_bg2 = "#4C566A",
   yellow = "#EBCB8B",
   cyan = "#8FBCBB",
   darkblue = "#81A1C1",
   green = "#A3BE8C",
   orange = "#D08770",
   magenta = "#BF616A",
   blue = "#5E81AC",
   red = "#BF616A",
}

-- Local helper functions
local mode_color = function()
   local mode_colors = {
      n = colors.cyan,
      i = colors.green,
      c = colors.orange,
      V = colors.magenta,
      [""] = colors.magenta,
      v = colors.magenta,
      R = colors.red,
   }

   local color = mode_colors[vim.fn.mode()]

   if color == nil then
      color = colors.red
   end

   return color
end

-- Left side
gls.left[1] = {
   ViMode = {
      provider = function()
         local alias = {
            n = "λ",
            i = "",
            c = "",
            V = "麗",
            [""] = "麗",
            v = "麗",
            R = "",
         }
         vim.api.nvim_command("hi GalaxyViMode guibg=" .. mode_color())
         local alias_mode = alias[vim.fn.mode()]
         if alias_mode == nil then
            alias_mode = vim.fn.mode()
         end
         return "  " .. alias_mode .. " "
      end,
      highlight = { colors.bg, colors.bg },
      separator = " ",
      separator_highlight = { colors.section_bg2, colors.section_bg2 },
   },
}
gls.left[2] = {
   FileIcon = {
      provider = "FileIcon",
      highlight = {
         require("galaxyline.providers.fileinfo").get_file_icon_color,
         colors.section_bg2,
      },
   },
}
gls.left[3] = {
   FileName = {
      provider = "FileName",
      highlight = { colors.fg, colors.section_bg2 },
      separator = " ",
      separator_highlight = { colors.section_bg2, colors.section_bg },
   },
}
gls.left[4] = {
   GitIcon = {
      provider = function()
         return "  "
      end,
      condition = condition.check_git_workspace,
      highlight = { colors.red, colors.section_bg },
   },
}
gls.left[5] = {
   GitBranch = {
      provider = function()
         local vcs = require "galaxyline.providers.vcs"
         local branch_name = vcs.get_git_branch()
         if string.len(branch_name) > 28 then
            return string.sub(branch_name, 1, 25) .. "..."
         end
         return branch_name .. " "
      end,
      condition = condition.check_git_workspace,
      highlight = { colors.fg, colors.section_bg },
   },
}
gls.left[6] = {
   DiffAdd = {
      provider = "DiffAdd",
      condition = condition.check_git_workspace,
      icon = " ",
      highlight = { colors.green, colors.section_bg },
   },
}
gls.left[7] = {
   DiffModified = {
      provider = "DiffModified",
      condition = condition.check_git_workspace,
      icon = " ",
      highlight = { colors.orange, colors.section_bg },
   },
}
gls.left[8] = {
   DiffRemove = {
      provider = "DiffRemove",
      condition = condition.check_git_workspace,
      icon = " ",
      highlight = { colors.red, colors.section_bg },
   },
}
gls.left[9] = {
   LeftEnd = {
      provider = function()
         return " "
      end,
      highlight = { colors.bg, colors.section_bg },
   },
}
gls.left[10] = {
   DiagnosticError = {
      provider = "DiagnosticError",
      icon = "  ",
      highlight = { colors.red, colors.bg },
   },
}
gls.left[11] = {
   Space = {
      provider = function()
         return " "
      end,
      highlight = { colors.section_bg, colors.bg },
   },
}
gls.left[12] = {
   DiagnosticWarn = {
      provider = "DiagnosticWarn",
      icon = "  ",
      highlight = { colors.orange, colors.bg },
   },
}
gls.left[13] = {
   DiagnosticHint = {
      provider = "DiagnosticHint",
      icon = "  ",
      highlight = { colors.fg, colors.bg },
   },
}
gls.left[14] = {
   Space = {
      provider = function()
         return " "
      end,
      highlight = { colors.bg, colors.bg },
   },
}
gls.left[15] = {
   DiagnosticInfo = {
      provider = "DiagnosticInfo",
      icon = "  ",
      highlight = { colors.blue, colors.bg },
      separator = " ",
      separator_highlight = { colors.bg, colors.bg },
   },
}

-- Right side
gls.right[1] = {
   LineInfo = {
      provider = "LineColumn",
      highlight = { colors.fg, colors.section_bg },
      separator = "  ",
      separator_highlight = { colors.section_bg, colors.bg },
   },
}
gls.right[2] = {
   Logo = {
      provider = function()
         return "  "
      end,
      highlight = { colors.red, colors.section_bg2 },
      separator = "  ",
      separator_highlight = { colors.section_bg2, colors.section_bg },
   },
}

-- Short status line
gls.short_line_right[1] = {
   FileFormat = {
      provider = function()
         return vim.bo.filetype
      end,
      highlight = { colors.bg, colors.bg },
   },
}


