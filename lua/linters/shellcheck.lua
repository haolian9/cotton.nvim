local Collector = require("linters.Collector")

local M = setmetatable({}, Collector)

function M:cmd(outfile) return "shellcheck", { "--format=json", outfile } end

do
  ---@class Check
  ---@field file string
  ---@field line integer
  ---@field endLine integer
  ---@field column integer
  ---@field endColumn integer
  ---@field level 'warning'|'error' @completeme
  ---@field code integer
  ---@field message string

  ---@param plain string
  ---@return Check[]
  function M:populate_checks(plain) return vim.json.decode(plain) end
end

do
  local level_severity = {
    warning = "WARN",
    ["error"] = "ERROR",
  }

  ---@param check Check
  ---@return vim.Diagnostic
  function M:check_to_diagnostic(bufnr, check)
    local lnum = check.line - 1
    local end_lnum = check.endLine and check.endLine - 1 or nil
    local severity = assert(level_severity[check.level], check.level)
    return { bufnr = bufnr, lnum = lnum, end_lnum = end_lnum, col = check.column, end_col = check.endColumn, severity = severity, message = check.message, code = check.code }
  end
end

return M
