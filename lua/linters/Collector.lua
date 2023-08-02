---@diagnostic disable: unused-local

local cthulhu = require("cthulhu")
local fn = require("infra.fn")
local jelly = require("infra.jellyfish")("linters.collector", "debug")
local listlib = require("infra.listlib")
local subprocess = require("infra.subprocess")

local api = vim.api
local uv = vim.loop

---@class linters.Collector
local Collector = {}
do
  Collector.__index = Collector

  ---@param outfile string
  ---@return string,string[] @bin, args
  function Collector:cmd(outfile) error("not implemented") end

  ---@param plain string
  ---@return any[]
  function Collector:populate_checks(plain) error("not implemented") end

  ---@param check any
  ---@return vim.Diagnostic
  function Collector:check_to_diagnostic(bufnr, check) error("not implemented") end

  function Collector:__call(bufnr)
    local outfile = os.tmpname()
    assert(cthulhu.nvim.dump_buffer(bufnr, outfile))

    local chunks = {}
    local function stdout_callback(output) listlib.extend(chunks, output) end

    local function on_exit(rc)
      local checks = {}
      if rc == 0 then
        checks = {}
      else
        assert(rc == 1)
        checks = self:populate_checks(fn.join(chunks))
      end

      vim.schedule(function()
        local ns = api.nvim_create_namespace("linters.ruff")
        local digs = fn.tolist(fn.map(function(check) return self:check_to_diagnostic(bufnr, check) end, checks))
        jelly.debug("feed %d diagnostics to nvim", #digs)
        vim.diagnostic.set(ns, bufnr, digs)
      end)

      uv.fs_unlink(outfile)
    end

    local bin, args = self:cmd(outfile)
    subprocess.spawn(bin, { args = args }, stdout_callback, on_exit)
  end
end

return Collector
