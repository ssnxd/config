# VSCode Config

Minimal settings focused on Vim keybindings and essential editor behavior.

## Installation

Copy `settings.json` to your editor's user settings directory:

```bash
code --install-extension vscodevim.vim
```

## Key Bindings

Leader key is `<space>`.

| Mode | Keys | Action |
|------|------|--------|
| Insert | `jj` | Escape to Normal mode |
| Normal | `<leader>s` | Save file |
| Normal | `<leader>e` | Close buffer |
| Normal | `<leader>f` | Format document |
| Normal | `<C-h/j/k/l>` | Navigate splits |
| Normal | `<C-b>` | Toggle sidebar |
| Normal | `gd` | Peek definition |
| Normal | `gr` | Go to references |
| Normal | `<leader>ac` | Code actions |
| Normal | `<leader>cc` | Comment line |
| Visual | `<leader>cc` | Comment selection |
