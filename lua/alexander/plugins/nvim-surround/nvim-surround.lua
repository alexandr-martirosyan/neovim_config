local M = {}

-- Default keys (vim-surround style; none clash with built-ins):
--   ys{motion}{char}  add       ysiw"   word      -> "word"
--   ds{char}          delete    ds"     "word"    -> word
--   cs{old}{new}      change    cs"'    "word"    -> 'word'
--   S{char} (Visual)  surround the selection
M.opts = {}

return M
