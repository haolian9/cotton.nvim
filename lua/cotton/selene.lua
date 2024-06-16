local M = setmetatable({}, require("cotton.Collector"))
local its = require("infra.its")
local ni = require("infra.ni")

M.ns = ni.create_namespace("cotton.selene")

function M:cmd(outfile) return "selene", { "--no-summary", "--display-style=json", outfile } end

---@class cotton.selene.Check
---@field severity 'Warning'|'Error'
---@field code integer
---@field message string
---@field notes string[]
---@field secondary_labels string[]
---@field primary_label {filename: string, span: cotton.selene.Check.PrimaryLabelSpan, message: string}

---@class cotton.selene.Check.PrimaryLabelSpan
---@field start integer
---@field start_line integer
---@field start_column integer
---@field end integer
---@field end_line integer
---@field end_column integer

---@param plains string[]
---@return cotton.selene.Check[]
function M:populate_checks(plains)
  --selene outputs: 'check\ncheck'
  assert(#plains > 0)
  return its(plains):map(vim.json.decode):tolist()
end

do
  local severities = {
    Warning = "WARN",
    Error = "ERROR",
  }

  ---@param check cotton.selene.Check
  ---@return vim.Diagnostic
  function M:check_to_diagnostic(bufnr, check)
    local severity = assert(severities[check.severity], check.severity)
    local lnum = check.primary_label.span.start_line
    local end_lnum = check.primary_label.span.end_line
    local col = check.primary_label.span.start_column
    local end_col = check.primary_label.span.end_column

    return { bufng = bufnr, lnum = lnum, end_lnum = end_lnum, col = col, end_col = end_col, severity = severity, message = check.message, code = check.code }
  end
end

return M

