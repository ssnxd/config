# Catppuccin Latte theme for tmux

# Colors
thm_bg="#eff1f5"
thm_fg="#4c4f69"
thm_cyan="#179299"
thm_black="#e6e9ef"
thm_gray="#bcc0cc"
thm_magenta="#ea76cb"
thm_pink="#8839ef"
thm_red="#d20f39"
thm_green="#40a02b"
thm_yellow="#df8e1d"
thm_blue="#1e66f5"
thm_orange="#fe640b"
thm_black4="#acb0be"

# Panes
set -g pane-border-style fg=$thm_gray
set -g pane-active-border-style fg=$thm_blue
set -g display-panes-colour $thm_fg
set -g display-panes-active-colour $thm_blue

# Mode
set -g mode-style bg=$thm_blue,fg=$thm_bg

# Windows
setw -g window-status-format "#[fg=$thm_fg,bg=default] #I #W "
setw -g window-status-current-format "#[fg=$thm_blue,bg=default,bold] [#I #W] "
setw -g window-status-style bg=default,fg=$thm_fg
setw -g window-status-activity-style bg=default,fg=$thm_pink

# Status bar
set -g status-style fg=$thm_fg,bg=default
set -g status-right '#[fg=$thm_fg,bg=default] #S #{?SSH_CLIENT,on #H ,} '

# Message styling
set -g message-style fg=$thm_blue,bg=default,bold
