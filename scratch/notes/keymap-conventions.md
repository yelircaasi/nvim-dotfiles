**Key sequences starting with `z` in Neovim (and Vim) are primarily used for scrolling/positioning the view, folding, and a few other utilities.**

### Main categories:
- **Scrolling / view positioning** (very common):
  - `zz` — Center the current line in the window.
  - `zt` — Put the current line at the top of the window.
  - `zb` — Put the current line at the bottom.
  - `z<CR>` (or `zt` variant) — Similar, with cursor on first non-blank.
  - `zh`/`zl`, `zH`/`zL` — Horizontal scrolling (when `wrap` is off).

- **Folding** (core use of the `z` prefix):
  - `za`/`zA` — Toggle fold (open/close, recursive).
  - [ ] `zo`/`zc` — Open/close fold.
  - [ ] `zO`/`zC` — Open/close recursively.
  - [ ] `zf` (with motion) or `zF` — Create fold.
  - [ ] `zd`/`zD` — Delete fold(s).
  - [ ] `zj`/`zk` — Move to next/previous fold.
  - [ ] Others like `zi` (toggle foldenable), `zE` (eliminate all folds), etc.

- **Other**:
  - [ ] `ZZ` — Write (save) and quit (like `:wq`).
  - [ ] `ZQ` — Quit without saving (like `:q!`).
  - [ ] `z=` — Spelling suggestions (when spellcheck is on).

`z` by itself doesn't do much; it's almost always a prefix for these two-character (or more) commands.

**`g` is the other major built-in prefix/sequence leader**, used for a wide variety of "extended" motions, jumps, and operations that didn't fit nicely elsewhere.

### Common `g` commands:
- **Navigation**:
  - [ ] `gg` — Go to first line.
  - [ ] `G` — Go to last line (note: single `G`, not prefixed, but related).
  - [ ] `g0`/`g^`/`g$` — Start/end of *screen* line (useful with wrapping).
  - [ ] `gj`/`gk` — Down/up by visual/display lines.

- **Jumps and info**:
  - [ ] `g*`/`g#` — Search forward/backward for word under cursor (no whole-word boundaries).
  - [ ] `gd`/`gD` — Goto local/global definition.
  - [ ] `gCtrl- ]` — Jump to tag.
  - [ ] `g,`/`g;` — Navigate change list.

- **Editing**:
  - [ ] `gJ` — Join lines without space.
  - [ ] `g&` — Repeat last substitute on all lines.
  - [ ] `gu`/`gU` — Lower/upper case motions.

- [ ] **Others**: `g Ctrl-G` (cursor info), `gI` (insert at column 1), undo navigation (`g+`/`g-`), etc.

These are the two main built-in **prefix keys** for multi-key sequences in normal mode.

### Other similar "leaders" or prefixes
- **`[` and `]`** — Often for navigation (e.g., `[b`/` ]b` for buffers, `[m`/` ]m` for methods, `[ [`/` ]]` for sections, fold navigation, etc.).
- **`<C-w>` (Ctrl-W)** — Window management prefix (splits, navigation, resizing).
- **`q`** — For recording macros (`qq` to start recording into register q, `q` to stop).
- **`@`** — For executing macros/registers.
- **Operator-pending** prefixes like `d`, `c`, `y` (delete/change/yank) + motion.
- **Custom `<leader>`** (default `\`, commonly remapped to `Space` or `,`) — This is the standard way users and plugins add their own hierarchical keymaps (e.g., `<leader>ff` for find files). Plugins like **which-key.nvim** specifically show help for `g`, `z`, `<C-w>`, and custom leaders.

You can explore all of these in Neovim with:
- `:help z`
- `:help g`
- `:help normal-index` (full normal mode command list)
- `:help quickref`

Many plugins (e.g., which-key) enhance discoverability for these prefixes.
