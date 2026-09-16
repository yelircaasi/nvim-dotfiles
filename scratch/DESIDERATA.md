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

2. View Git status of repo

3. close Git status

4. Compile project via Cargo

5. Navigate to error from compilation output

6. Return to compilation window

7. Navigate to another error

8. Re-compile

9. Run clippy

10. Open reference from clippy output

11. Open two files in a vertical split

12. Select enclosing function using single keystroke

13. Yank selection to special register

14. Switch to file B in split

15. Paste yanked into selection into selection in file B, then another selection (must not overwrite given register; repeated paste)

16. Paste yanked into new selection in file B

17. Create new function skeleton using snippet

18. Create new struct with impl block, from snippet

19. Re-run and re-open clippy window

20. Navigate to Clippy reference: use window selection menu

21. Navigate to reference

22. Open menu with all open buffers and go to one of the buffers

23. Open LSP quickfix window and navigate to a specific error

24. Use fuzzy search menu to open a file (like ctrl+p in vscode)

25. Use file tree to upen new window (nvim-tree or neotree or oil)

26. Use overview to close (and save if needed/desired) certain open buffers

27. Go to tab to the left/right

