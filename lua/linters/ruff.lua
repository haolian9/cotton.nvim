local Collector = require("linters.Collector")

local M = setmetatable({}, Collector)

---rows are 1-based
---@class linters.ruff.Check.Edit
---@field content string
---@field end_location {column: integer, row: integer}
---@field location {column: integer, row: integer}
---
---rows are 1-based
---@class linters.ruff.Check
---@field filename string
---@field code integer
---@field location {column: integer, row: integer}
---@field end_location {column: integer, row: integer}
---@field fix {applicability: string, edits: linters.ruff.Check.Edit[], message: string}
---@field message string
---@field noqa_row integer
---@field url string

function M:cmd(outfile) return "ruff", { "--ignore-noqa", "--target-version", "py311", "--format=json", outfile } end

---@param plain string
---@return linters.ruff.Check[]
function M:populate_checks(plain)
  assert(plain ~= nil and plain ~= "")
  return vim.json.decode(plain)
end

---@param check linters.ruff.Check
---@return vim.Diagnostic
function M:check_to_diagnostic(bufnr, check)
  local lnum = check.location.row - 1
  local end_lnum = check.end_location.row - 1
  local severity = "WARN" --todo: ruff does not provide a severity field
  return { bufnr = bufnr, lnum = lnum, end_lnum = end_lnum, col = check.location.column, end_col = check.end_location.column, severity = severity, message = check.message, code = check.code }
end

return M
