# 20 Tips From Someone Who Ships While You're Still Configuring Plugins

*A brutally honest review of this config by Claude Code, March 2026.*

---

## 1. Your PowerShell profile template isn't deployed

Your `profile.ps1.template` is actually solid — zoxide, fzf, eza, bat, starship, uv.
But it's sitting there as a *template*. There's no install script that copies it into
`$PROFILE`. If you're running on a fresh machine — or you've never actually deployed
this — you're navigating your filesystem without the tools you already configured.
Write a bootstrap script (`install.ps1`) that symlinks or copies this into place,
sets up WinGet/Chocolatey packages, and makes your environment reproducible in under
5 minutes. Every second you spend manually setting up a new machine is a second you're
not shipping.

## 2. You have no `CLAUDE.md` in your main projects

You've got one in your Obsidian vault (nice), but your actual *code* projects?
Nothing. A `CLAUDE.md` at the root of every project you work on is **the single
highest-leverage thing you can do** for agent-assisted development. It's your
project's brain dump — architecture decisions, conventions, "don't touch this
because...", test commands, build steps. Without it, every Claude Code session starts
from zero. You're throwing away context like it's free.

## 3. You're not using Claude Code's `/init` to bootstrap projects

Run `/init` in each project root. It generates a `CLAUDE.md` scaffold from your repo.
Then *maintain it*. This is your multiplier. An agent with great context is 10x faster
than an agent guessing.

## 4. Harpoon with 9 slots but no project-level automation

You've got harpoon marks for quick file jumping — good. But you're manually managing
which files matter per project. Use **session.lua** (which you already have!) combined
with harpoon's project-scoped marks more aggressively. Better yet: stop manually
navigating entirely. Tell Claude Code "open the auth module" and let it find the
files. Your brain shouldn't be a file index.

## 5. You're using Copilot as a cmp source instead of inline

You deliberately disabled Copilot inline suggestions and shoved it into the completion
menu. That's *backwards*. Inline ghost text for Copilot, completion menu for LSP
symbols and snippets. Copilot in cmp means you're manually triggering and selecting
completions for code that should just *appear*. You're adding friction to the one tool
designed to remove it.

## 6. No AI-assisted git workflow

Your git aliases are fine (`lol`, `squash`, `save`, `undo`) but you're still writing
commit messages by hand and doing manual code review. Use `/commit` in Claude Code —
it reads the diff, writes a proper message, and commits. Use agents to review PRs. The
boring parts of git should be fully automated.

## 7. You have zero test infrastructure outside of neotest

Neotest is configured but your actual test *strategy* is missing. No pre-commit hooks,
no CI config in your dotfiles repo, no test-on-save. The killer workflow: write code
with an agent, have it write the tests, run them automatically, fix failures in a
loop. If your test cycle isn't < 5 seconds, you're context-switching yourself to
death.

## 8. No task runner / just-file / Makefile

I see no `Justfile`, `Makefile`, or `Taskfile` in your workflow. Every project should
have a single entry point for "build", "test", "lint", "run". Not because *you* need
it — because *agents* need it. When Claude Code sees a `just test` command in your
`CLAUDE.md`, it can run your entire test suite without asking. Without it, every agent
session wastes time figuring out how to build your project.

## 9. Your formatting/linting is good but not *enforced*

You have conform.nvim and nvim-lint configured beautifully. But there's no pre-commit
hook, no `lint-staged`, nothing stopping bad code from hitting your repo.
Format-on-save is great until you edit from a different machine or a quick
`git commit -a` bypasses your editor. Use **pre-commit** hooks. Make it impossible to
commit garbage.

## 10. Terminal workflow is undercooked

You have `toggleterm` bound to `<C-\>` — one terminal. Power users run **multiple
named terminals**: one for builds, one for tests, one for a dev server, one for agent
output. Set up toggleterm with numbered terminals (`1<C-\>`, `2<C-\>`, etc.) or
switch to a psmux-first workflow where nvim is just one pane. Your current setup
forces you to toggle one terminal on and off like a light switch.

## 11. You're not using quickfix lists aggressively enough

You have `<F8>` for quickfix navigation and Trouble for diagnostics, but you're not
*populating* quickfix from agents. The workflow: Claude Code finds all the places that
need changing -> dumps them into a quickfix list -> you `:cdo` the fix across all of
them. Or better: the agent does the `:cdo` for you. Quickfix is the bridge between
"find" and "fix at scale."

## 12. No snippet library for your patterns

LuaSnip is installed with friendly-snippets, but you have zero custom snippets. You
write the same boilerplate — test scaffolds, error handling patterns, struct
definitions — over and over. Spend 30 minutes creating snippets for your top 10
patterns in Rust/C++/Lua. Or better: ask Claude Code to generate them from your
existing codebase.

## 13. Your Obsidian workflow is disconnected from your code

You have a PARA-structured vault, daily notes, project tracking — but it's a separate
world from your code. The killer move: link your Obsidian project notes to actual
repos, use Claude Code with MCP to query your vault when working on code, and have
agents update project notes when milestones ship. Your knowledge system and your code
system should be one system.

## 14. No workspace-specific settings

Every project gets the same nvim config. But your Rust projects need different
formatters than your Lua projects. Your C++ projects need different compile commands.
Use **exrc** (built into neovim) or `.nvim.lua` project-local configs to set
per-project LSP settings, formatters, and test commands. Stop relying on filetype
detection for everything.

## 15. You're not leveraging multiple agents in parallel

When you use Claude Code, you're probably running one task at a time. The real move:
kick off an agent in a worktree to refactor module A, another to write tests for
module B, and a third to update docs — all simultaneously. Your git worktree support
is sitting right there. Use `--worktree` flags. Parallelize your agents like you'd
parallelize your builds.

## 16. Your debug workflow needs ergonomic shortcuts

Your DAP config is solid but the keybindings are all `<leader>d` prefixed — that's
two keystrokes before every debug action during a hot debugging session. Map
F5/F9/F10/F11 to continue/breakpoint/step-over/step-into like every debugger since
1990. Your muscle memory from Visual Studio will thank you.

## 17. Leap.nvim is installed but you're probably still using `/search`

You have leap for `s`/`S` motion. Are you actually using it? Most people install
motion plugins and then forget they exist. Leap should replace 80% of your `/`
searches for navigation. If you're still typing `/functionName<CR>` to jump around a
file, you're doing it wrong. `s` + two chars = you're there.

## 18. No persistent undo strategy beyond Dropbox sync

You sync undo files to Dropbox — that's backup, not strategy. Combine persistent undo
with **telescope-undo** (which you have!) as your primary "oh no" recovery tool. But
more importantly: commit early, commit often, use `git save` (your alias) as a
checkpoint before risky changes. Undo trees are a safety net; frequent commits are the
real strategy.

## 19. Your config repo has no bootstrap/install script

You've got template files for zsh, PowerShell, starship, tmux — but no script that
actually *installs* everything. When you set up a new machine (or your SSD dies), you
should be one `.\install.ps1` away from a fully working environment. Bootstrap scripts
aren't just for you — they're documentation of your entire workflow. If you can't
reproduce your setup in under 5 minutes, your setup owns you, not the other way
around.

## 20. You're spending too much time in your config

Your `init.lua` has been touched more recently than your actual project code. I can
see it. 40+ plugins, meticulously configured keybindings, three backup colorschemes
you never use (gruvbox, kanagawa, oxocarbon — you always pick carbonfox). **Stop
configuring. Start shipping.** The best productivity hack isn't a new plugin — it's
closing your config and opening your project. Every minute spent on config is a minute
an agent could have been writing features for you.

---

## The TL;DR

Your nvim config is **competent but inward-facing** — it's optimized for *you editing
text* rather than *you orchestrating agents that edit text*. The paradigm shift: **you
are no longer the typist, you are the architect.** Your tools should be optimized for:

1. **Giving agents context** (CLAUDE.md, task runners, project docs)
2. **Reviewing agent output** (diffs, quickfix, test results)
3. **Running multiple agents in parallel** (worktrees, background tasks)
4. **Never doing manually what a machine can do** (commits, formatting, boilerplate,
   test writing)

Your fingers should be on `,` and `<leader>` less, and on "fix the auth module, add
tests, and open a PR" more. Ship the product, not the config.
