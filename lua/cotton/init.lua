local M = {}

local BufTickRegulator = require("infra.BufTickRegulator")
local jelly = require("infra.jellyfish")("cotton")
local ni = require("infra.ni")
local prefer = require("infra.prefer")

local availables = {
  python = { "ruff" },
  bash = { "shellcheck" },
  sh = { "shellcheck" },
  lua = { "selene" },
}

local regulator = BufTickRegulator(1024)

function M.lint()
  local bufnr = ni.get_current_buf()
  if regulator:throttled(bufnr) then return jelly.debug("no changes for a new linting") end
  regulator:update(bufnr) -- since linting will not change the buffer

  local ft = prefer.bo(bufnr, "filetype")

  local linters = availables[ft]
  if linters == nil then return jelly.info("no available linters for buf=%d ft=%s", bufnr, ft) end

  for _, linter in ipairs(linters) do
    require(string.format("cotton.%s", linter))(bufnr)
  end
end

return M
