-- Rex configuration. Docs: https://www.superlogical.com/rex/docs/customize/config
-- Apply changes with `rex config reload` (Rex does not watch this file).
-- Check with `rex config check` and `rex keymap`.
--
-- Keybindings: Rex defaults, plus the few below. Find the defaults in the
-- command palette (Cmd+Shift+P) or Settings > Shortcuts.

-- Focus panes with Cmd+hjkl. Replaces macOS Hide (Cmd+H) and the default
-- session switcher on Cmd+K.
rex.bind("cmd+h", "pane.focus.left")
rex.bind("cmd+j", "pane.focus.down")
rex.bind("cmd+k", "pane.focus.up")
rex.bind("cmd+l", "pane.focus.right")

-- Split with Cmd+Shift+hjkl: the new pane opens on that side.
rex.bind("cmd+shift+h", "pane.split.left")
rex.bind("cmd+shift+j", "pane.split.down")
rex.bind("cmd+shift+k", "pane.split.up")
rex.bind("cmd+shift+l", "pane.split.right")

-- Session switcher moves from Cmd+K to Cmd+P.
rex.bind("cmd+p", "session.switch")

-- Rename the session with Cmd+, (replaces Settings; open it from the palette).
rex.bind("cmd+,", "session.rename")

-- Cycle sessions with Cmd+[ and ]. Replaces Rex's default pane cycling on
-- these keys; panes move with Cmd+hjkl above.
rex.bind("cmd+[BracketLeft]", "session.previous")
rex.bind("cmd+[BracketRight]", "session.next")
