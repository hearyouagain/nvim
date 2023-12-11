-- 设置格式化程序
vim.g.formatter_clang_format_executable = 'clang-format'
vim.g.formatdef_my_cpp = '"clang-format"'
vim.g.formatdef_my_c = '"clang-format"'

-- 手动格式化快捷键
vim.api.nvim_set_keymap('n', '<Leader>f', ':Format<CR>', { noremap = true }) 

-- 保存时自动格式化
vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePre *.cpp,*.c FormatWrite
  augroup END
]], true)

vim.g.neoformat_python_black = {
  exe = 'black',
  args = {'-q', '-'},
  stdin = 1,
  opts = {
    line_length = 88,
    multi_line_output = 3,
    }
}
vim.g.neoformat_enabled_python = {'black'}
vim.api.nvim_exec([[
  augroup fmt
    autocmd!
    autocmd BufWritePre *.py Neoformat
  augroup END
]], true)

-- 创建文件自动添加头文件
-- 当新建指定类型文件时,调用SetTitle函数
vim.api.nvim_create_autocmd({"BufNewFile"}, {
  pattern = { "*.h", "*.c", "*.hpp", "*.cpp", "Makefile", "*.mk", "*.sh", "*.py"},
  callback = function()
    vim.cmd("lua SetTitle()")
    vim.cmd("normal G")
  end
})
local line = vim.fn.line(".")
local year = os.date("%Y")
local copyright = "* Copyright (C) " .. year .. "  Ltd. All rights reserved."
local filename = vim.fn.expand("%:t:r")
local define = string.upper(filename)
local macro = "_" .. string.upper(string.gsub(vim.fn.expand("%"), "[/.]", "_")) .. "_"
-- 插入文件头注释
function SetComment()
  vim.fn.setline(1, "/*================================================================")

  vim.fn.append(line, copyright)
  vim.fn.append(line + 1, "* ")
  vim.fn.append(line + 2, "* 文件名称:"..vim.fn.expand("%:t"))
  vim.fn.append(line + 3, "* 创 建 者:d00656493")
  vim.fn.append(line + 4, "* 创建日期:"..year.."年"..os.date("%m").."月"..os.date("%d").."日")
  vim.fn.append(line + 5, "* 描 述:")
  vim.fn.append(line + 6, "*")
  vim.fn.append(line + 7, "================================================================*/");
  vim.fn.append(line + 8, "");
  vim.fn.append(line + 9, "");
end

-- Makefile注释
function SetComment_sh()
  vim.fn.setline(3, "#===============================================================")

  vim.fn.setline(3, copyright)
  vim.fn.setline(4, "# ")
  vim.fn.setline(5, "# 文件名称:"..vim.fn.expand("%:t"))
  vim.fn.setline(6, "# 创 建 者:d00656493")
  vim.fn.setline(7, "# 创建日期:"..year.."年"..os.date("%m").."月"..os.date("%d").."日")
  vim.fn.setline(8, "# 描 述:")
  vim.fn.setline(9, "#")
  vim.fn.setline(10, "#");
  vim.fn.setline(11, "#================================================================*/");
  vim.fn.setline(12, "");
  vim.fn.setline(13, "");
end

-- 设置标题
function SetTitle()
  if vim.bo.filetype == "make" then
    vim.fn.setline(1, "")
    vim.fn.setline(2, "")
    SetComment_sh()

  elseif vim.bo.filetype == "sh" then
    -- vim.fn.setline(1, "#!/bin/sh")
    vim.fn.setline(1, "")
    vim.fn.setline(2, "")
    SetComment_sh()

  elseif vim.fn.expand("%:e") == "py" then
    vim.fn.setline(1, "# coding = utf-8")
    vim.fn.setline(2, "")

  else
    SetComment()

    if vim.fn.expand("%:e") == "hpp" then
      -- hpp注释

      vim.fn.append(line + 10, "#ifndef _"..define.."_H")
      vim.fn.append(line + 11, "#define _"..define.."_H")
      vim.fn.append(line + 12, "#ifdef __cplusplus")
      vim.fn.append(line + 13, "extern \"C\"")
      vim.fn.append(line + 14, "{")
      vim.fn.append(line + 15, "#endif")
      vim.fn.append(line + 16, "")
      vim.fn.append(line + 17, "#ifdef __cplusplus")
      vim.fn.append(line + 18, "}")
      vim.fn.append(line + 19, "#endif")
      vim.fn.append(line + 20, "#endif //_"..define.."_H")
    elseif vim.fn.expand("%:e") == "h" then
      vim.fn.setline(12, "#ifndef "..macro)
      vim.fn.setline(13, "#define "..macro)
      vim.fn.setline(14, "")
      vim.fn.setline(15, "#endif  // "..macro)
      vim.fn.append(line + 10, "#pragma once")
    elseif vim.bo.filetype == "c" then
      vim.fn.append(line + 10, '#include "'..filename..'.h"')
    elseif vim.bo.filetype == "cpp" then
      vim.fn.append(line + 10, '#include "'..filename..'.h"')
    end
  end
end
