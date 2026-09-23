# Desiderata

Notes on things I notice while using Neovim that I want to add to my configuration later.

- always-present scratchpad file + keybind to toggle it
- similar to above, but specifically shell scratchpad file (most basic case: bash; potentially other shells, too), for use with wezterm-run.nvim


- view all references in popup/split/quickfix-style
- go to reference in:
  - new tab
  - split
- view reference in popup
- view all tabs/buffers in split/float

- LSP status in line

- expand snippet (in insert mode?)

- go to next diagnostic
- view all diagnostics under certain path

- 
- go to last buffer

## Editing sequence

1. Open repo
    
    ```
    $ nvim consilium-rs
    ```

2. View Git status of repo

    ```
    <leader>gl -> open lazygit tui
    map("n", "<leader>gl", function() snacks.lazygit.log() end, { desc = "Lazygit log" })

    <leader>eg -> open neo-tree directly on the git status source
    map("n", "<leader>eg", "<cmd>Neotree git_status<cr>", { desc = "Neo-tree git status" })

    map("n", "<leader>gg", function() snacks.lazygit() end, { desc = "Lazygit" })
    :Gitsigns status   " summary
    ]c / [c            " jump between hunks
    <leader>hs         " stage hunk (if you set that binding)

    <leader>gs -> require("fzf-lua").git_status()
    map("n", "<leader>gs", function() require("fzf-lua").git_status() end, { desc = "Git status" })
    ```

3. close Git status

    ```
    ???
    ```
4. Compile project via Cargo

    ```
    ???
    ```

5. Navigate to error from compilation output

    ```
    ???
    ```

6. Return to compilation window

    ```
    ???
    ```

7. Navigate to another error

    ```
    ???
    ```

8. Re-compile

    ```
    ???
    ```

9. Run clippy

    ```
    achievable with rustaceanvim?
    ```

9. b) Navigate clippy output

    ```
    vim.diagnostic.goto_next()
    vim.diagnostic.goto_prev()
    vim.diagnostic.open_float()
    ```

10. Open reference from clippy output

    ```
    ???
    ```

11. Open two files in a vertical split

    ```
    TODO: write function and assign leader sequence:
      - open one window
      - open yazi
      - vsplit, open yazi again
    ```

12. Select enclosing function using single keystroke

    ```
    TODO: wildfire?
    ```

13. Yank selection to special register

    ```
    ???
    ```

14. Switch to file B in split

    ```
    ???
    ```

15. Paste yanked into selection into selection in file B, then another selection (must not overwrite given register; repeated paste)

    ```
    ???
    ```

16. Paste yanked into new selection in file B

    ```
    ???
    ```

17. Create new function skeleton using snippet

    ```
    ???
    ```

18. Create new struct with impl block, from snippet

    ```
    TODO: use blink.cmp or LuaSnip
    ```

19. Re-run and re-open clippy window

    ```
    TODO: write function and add leader sequence
    ```

20. Navigate to Clippy reference: use window selection menu

    ```
    TODO: write function and select leader sequence; select terminal plugin
    ```

21. Navigate to reference

    ```
    <leader>gd
    ```

22. Open menu with all open buffers and go to one of the buffers

    ```
    TODO: flybuf? vuffers?
    ```

22. b) Open tree-shaped menu containing only open files

    ```
    TODO: write custom function/plugin?
    ```

22. c) Open tree-shaped menu containing only files matching rg search

    ```
    TODO: achievable with yazi plugin? xplr?
    ```

22. d) Create quickfix-like interface for all instances of an entity

    ```
    TODO trouble? quicker? bqf? combination?
    ```

23. Open LSP quickfix window and navigate to a specific error

    ```
    :copen
    ```

24. Use fuzzy search menu to open a file (like ctrl+p in vscode)

    ```
    <leader>fg
    ```

25. Use file tree to upen new window (nvim-tree or neotree or oil)

    ```
    TODO try oil first
    ```

26. Use overview to close (and save if needed/desired) certain open buffers

    ```
    TODO flybuf? vuffers? 
    ```

27. Go to tab to the left/right

    ```
    TODO: tabline?
    ```

