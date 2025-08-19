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

## 🖼️ Configuration Examples

### Default settings:
<img width="405" height="108" alt="Screenshot 2025-08-19 at 12 41 36 PM" src="https://github.com/user-attachments/assets/1df6371f-5fdb-40af-ba12-a5f9888c1b9d" />

### With `enable_align_suffix = true` (and `align_suffix_target_width = 80`)
<img width="647" height="102" alt="Screenshot 2025-08-19 at 12 41 05 PM" src="https://github.com/user-attachments/assets/dd961669-4eed-4379-934d-5648b6dee03d" />

### With `enable_next_line_virt_text = true`
<img width="446" height="108" alt="Screenshot 2025-08-19 at 12 39 54 PM" src="https://github.com/user-attachments/assets/a0f664f6-4d1e-43d3-b3c2-2b9dfc3ec535" />

### With `enable_next_line_virt_text = true` AND `enable_align_suffix = true`
<img width="653" height="107" alt="Screenshot 2025-08-19 at 12 40 42 PM" src="https://github.com/user-attachments/assets/9a27258c-f46f-4d07-9fa3-e0c39c15bf42" />



