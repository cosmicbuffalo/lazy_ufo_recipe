local M = {}

M.setup = function(config)
  if config.enable_next_line_virt_text then
    vim.g.lazy_ufo_recipe_enable_next_line_virt_text = true
  end

  if config.enable_align_suffix then
    vim.g.lazy_ufo_recipe_enable_align_suffix = true
  end

  if config.align_suffix_target_width then
    vim.g.lazy_ufo_recipe_align_suffix_target_width = config.align_suffix_target_width
  end
end

return M
