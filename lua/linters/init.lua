--todo: run on save?
--todo: run on leaving inset mode

local M = {}

local jelly = require("infra.jellyfish")("linters")
local prefer = require("infra.prefer")

local api = vim.api

local availables = {
  python = { "ruff" },
  bash = { "shellcheck" },
  sh = { "shellcheck" },
}

function M.lint()
  local bufnr = api.nvim_get_current_buf()
  local ft = prefer.bo(bufnr, "filetype")

  local linters = availables[ft]
  if linters == nil then return jelly.info("no available linters for buf=%d ft=%s", bufnr, ft) end

  for _, linter in ipairs(linters) do
    require(string.format("linters.%s", linter))(bufnr)
  end
end

return M
