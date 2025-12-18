# Catppuccin Mocha theme for tmux

# Colors
thm_bg="#1e1e2e"
thm_fg="#cdd6f4"
thm_cyan="#94e2d5"
thm_black="#181825"
thm_gray="#313244"
thm_magenta="#f5c2e7"
thm_pink="#cba6f7"
thm_red="#f38ba8"
thm_green="#a6e3a1"
thm_yellow="#f9e2af"
thm_blue="#89b4fa"
thm_orange="#fab387"
thm_black4="#585b70"

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
