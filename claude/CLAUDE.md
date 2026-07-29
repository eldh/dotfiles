# Global instructions

Personal, machine-wide guidance for Claude Code. Versioned in
[`~/dotfiles`](https://github.com/eldh/dotfiles) and symlinked to
`~/.claude/CLAUDE.md`.

## Environment

- macOS, `zsh` (config in `~/dotfiles/zsh/`).
- Editor: Zed.
- Version control: [jujutsu (`jj`)](https://github.com/jj-vcs/jj) on top of git.
  Helpers live in `~/dotfiles/zsh/jj.zsh` — see the dotfiles README for the
  `jj*` command reference. Prefer these over raw git when working in a
  jj-colocated repo.

## Working style

- Keep changes focused; match the surrounding code's style and conventions.
- Don't commit or push unless asked.
- Ask before doing anything hard to reverse.
