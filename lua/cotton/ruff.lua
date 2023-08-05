local Collector = require("cotton.Collector")

local api = vim.api

local M = setmetatable({}, Collector)

M.ns = api.nvim_create_namespace("cotton.ruff")

---rows are 1-based
---@class cotton.ruff.Check.Edit
---@field content string
---@field end_location {column: integer, row: integer}
---@field location {column: integer, row: integer}
---
---rows are 1-based
---@class cotton.ruff.Check
---@field filename string
---@field code integer
---@field location {column: integer, row: integer}
---@field end_location {column: integer, row: integer}
---@field fix {applicability: string, edits: cotton.ruff.Check.Edit[], message: string}
---@field message string
---@field noqa_row integer
---@field url string

function M:cmd(outfile) return "ruff", { "--ignore-noqa", "--target-version", "py311", "--format=json", outfile } end

---@param plain string
---@return cotton.ruff.Check[]
function M:populate_checks(plain)
  assert(plain ~= nil and plain ~= "")
  return vim.json.decode(plain)
end

---@param check cotton.ruff.Check
---@return vim.Diagnostic
function M:check_to_diagnostic(bufnr, check)
  local severity = "WARN" --todo: ruff does not provide a severity field
  return { bufnr = bufnr, lnum = check.location.row - 1, end_lnum = check.end_location.row - 1, col = check.location.column - 1, end_col = check.end_location.column - 1, severity = severity, message = check.message, code = check.code }
end

return M
