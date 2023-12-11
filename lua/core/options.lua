local opt = vim.opt

-- 行号
opt.relativenumber = true
opt.number = true
opt.textwidth = 80

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
-- opt.autoindent = true

-- 防止包裹
opt.wrap = false

-- 光标行
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

-- 系统剪贴板
opt.clipboard:append("unnamedplus")

-- 默认新窗口右和下
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
vim.cmd[[colorscheme tokyonight-moon]]
local api = vim.api

-- 当打开文件时的自动命令
api.nvim_create_autocmd({"BufRead"}, {
  callback = function()
    local buffer = api.nvim_get_current_buf()
    local last_position = vim.fn.line(".")
    api.nvim_win_set_cursor(0, {last_position, 0}) 
  end
})
