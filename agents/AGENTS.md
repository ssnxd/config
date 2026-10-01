# Global rules

## Safety
- Do not delete or modify anything you were not asked to touch. If the task seems to need it, stop and ask first.
- Never create a PR, push, or deploy without asking first.

## Verification
- Never claim a fix works without running it. Show the command output as evidence.
- Before applying a fix, confirm it does not break existing flows. Prefer a local end-to-end run over reasoning about the code.
- Judge UI in the running local app, not from the source.

## Deploys
- A merge is not the end. Monitor the deploy logs until the deploy is live, then run the same end-to-end test against the deployed environment.
- Fix the immediate cause now. For each deferred follow-up, ask before you open a GitHub issue. Do not open issues automatically.

## Git and PRs
- Always use a git worktree when starting a new feature.
- Name the branch for what it does, for example `fix/lf-charging-policy`. Do not put "worktree" in a branch name.
- When work on a worktree is done, stop its running shells and delete the worktree.
- Never mention Claude, AI, or the model in commit messages or PRs. Do not add "Co-Authored-By: Claude" or "Generated with Claude Code" lines.
- Write PR titles and descriptions in Simplified Technical English (ASD-STE100): short sentences, active voice, one instruction per sentence, simple approved words.

## Tmux and other agents
- One tmux session per project. The `ssnxd` session is for general work: housekeeping, terminals and browsers. Many Claude sessions can run on this machine at the same time.
- Find your place first: `tmux display-message -p -t "$TMUX_PANE" '#S:#I.#P'`. Message another Claude session only when told to, and only the one you were told to message.
- Use `ListAgents`, then `SendMessage` (`notify_when_idle` to wait). Never type into a pane with `tmux send-keys`, because the Enter gets lost. Read panes only, with `tmux capture-pane`.
- Stop the servers and browsers you start before you report. Never stop another session's.

## Working style
- Do not patch speculatively. Find the cause with evidence first, and research the problem domain before changing code.
- Give the estimated cost before starting an expensive run, such as heavy API use or a large agent fan-out.
- Work through the full task list. Do not stop between independent items to check in.
- Estimate effort and timelines for AI execution, not human execution. Work that would take a human team weeks takes hours or days here. Never write plans in human-team units ("this week", "next sprint", "Effort M"); sequence by dependency and say what can start now.

## Artifacts
- Every artifact defaults to light mode. Pin the colour scheme to light, paint the page background explicitly, and do not add dark-theme token blocks unless asked.

## Writing style
- No em dashes, no filler phrases, no padded or overly formal prose.

## Slack messages
- Keep them SHORT. Always as small as possible. A long message does not get read, so length costs you the message. Aim for a few lines: the ask, the link, and the one or two things the reader must know before they act. Put the detail in the PR, doc or canvas and link it.
- Do not restate what the linked PR or doc already says. Link it instead.
- Never use markdown tables in Slack messages, they render as raw pipes.
- Small tables (up to ~4 columns and ~10 rows): send a space-aligned monospace table inside a triple-backtick code block.
- Larger tables: create a Slack canvas (canvases render real markdown tables) and send a message with the headline, the key fact, and the canvas link.
- Just 2-3 values: write them inline in the sentence, no table.
