return {
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        relculright = true,
        segments = {
          { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
          { text = { " " } },
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
          { text = { " " } },
          { text = { "%s" }, click = "v:lua.ScSa" },
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    lazy = false,
    opts = {
      open_fold_hl_timeout = 400,
      enable_get_fold_virt_text = true,
      enable_next_line_virt_text = false, -- toggle this to enable "next line" virtual text in folds
      align_suffix = true, -- toggle this to remove the padding between the virtual text and the fold suffix
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    keys = {
      -- stylua: ignore
      { "zr", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      -- stylua: ignore
      { "zm", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "<leader>z", "za", desc = "Toggle fold" },
      -- stylua: ignore
      { "<leader>Z", "<cmd>ToggleFoldsAtCurrentIndentation<cr>", desc = "Toggle folds at current indentation level" },
    },
    config = function(_, opts)
      -- Folding related options need to be set before ufo is loaded
      vim.opt.foldcolumn = "1"
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

      local handler = function(virtText, lnum, endLnum, width, truncate, ctx)
        local newVirtText = {}
        local totalLines = vim.api.nvim_buf_line_count(0)
        local foldedLines = endLnum - lnum
        local startLineText = vim.fn.getline(lnum)
        local curlyMatch = startLineText:match("^%s*{%s*$")
        local isOnlyCurlyBrace = curlyMatch ~= nil
        local nextLineLnum = lnum + 1
        local nextLineText = vim.fn.getline(nextLineLnum)
        local blankLineCount = 0
        while nextLineText:match("^%s*$") ~= nil and nextLineLnum <= endLnum - 1 do
          blankLineCount = blankLineCount + 1
          nextLineLnum = nextLineLnum + 1
          nextLineText = vim.fn.getline(nextLineLnum)
        end
        local showNextLine = opts.enable_next_line_virt_text
          and (isOnlyCurlyBrace or (foldedLines - blankLineCount) <= 2)
        if showNextLine and nextLineText then
          local nextLineVirtText = ctx.get_fold_virt_text(nextLineLnum)
          nextLineVirtText[1][1] = nextLineVirtText[1][1]:gsub("^%s+", " ")
          vim.list_extend(virtText, nextLineVirtText)
        end

        local lastLineVirtText = ctx.get_fold_virt_text(endLnum)
        if not opts.enable_next_line_virt_text or foldedLines - blankLineCount > 2 then
          lastLineVirtText[1][1] = lastLineVirtText[1][1]:gsub("^%s*", " ... ")
        else
          lastLineVirtText[1][1] = lastLineVirtText[1][1]:gsub("^%s*", " ")
        end
        vim.list_extend(virtText, lastLineVirtText)

        local suffix = (" 󰁂 %d %d%%"):format(foldedLines, foldedLines / totalLines * 100)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        if opts.align_suffix then
                    -- stylua: ignore
                    local rAlignAppndx = math.max(math.min(vim.opt.textwidth["_value"], width - 1) - curWidth - sufWidth, 0)
          suffix = (" "):rep(rAlignAppndx) .. suffix
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      opts["fold_virt_text_handler"] = handler
      local ufo = require("ufo")
      ufo.setup(opts)

      function fold_at_indent_level()
        local bufnr = vim.api.nvim_get_current_buf()
        local current_line = vim.fn.line(".")
        local current_indent = vim.fn.indent(current_line)
        local fold_ranges = ufo.getFolds(bufnr, "treesitter")
        local fold_closed = vim.fn.foldclosed(current_line) ~= -1

        for _, range in pairs(fold_ranges) do
          if range.startLine then
            local start_line = range.startLine + 1
            local start_indent = vim.fn.indent(start_line)

            if start_indent == current_indent then
              if fold_closed then
                vim.api.nvim_command(start_line .. "foldopen")
              else
                vim.api.nvim_command(start_line .. "foldclose")
              end
            end
          else
            print("Invalid range detected: ", vim.inspect(range))
          end
        end
      end

      vim.api.nvim_create_user_command("ToggleFoldsAtCurrentIndentation", function()
        fold_at_indent_level()
      end, { desc = "Toggle folds at current indentation level" })
    end,
  },
}
