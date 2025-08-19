# Lazy Recipe for `nvim-ufo` (and `statuscol.nvim`)

This recipe sets up these two plugins with some nicely customized behavior around folds

# 📦 Installation

[Lazy.nvim](https://github.com/folke/lazy.nvim) minimal installation:

```lua
return {
    "cosmicbuffalo/lazy_ufo_recipe",
}
```

## ⚙️ Customizable Configuration
```lua
return {
    "cosmicbuffalo/lazy_ufo_recipe",
    opts = {
        enable_next_line_virt_text = true, -- optional, when enabled, part of the text on the next line of the fold will show up in your folded line display
        enable_align_suffix = true,        -- optional, when enabled, the folded line count/percentage virtual text will be aligned vertically
        align_suffix_target_width = 80,    -- optional, set the column to use for the target aligned width. if not set, vim.o.textwidth will be used as the default
    }
}
```



