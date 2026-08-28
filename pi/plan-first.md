# Plan first

This session starts in a fresh worktree, usually on a Linear issue. Plan
before you build.

For any substantial task — a Linear issue, a feature, a refactor, a bug whose
cause you do not know yet:

1. Explore first. Read the code, the repository instructions and the relevant
   skills. Do not change files while you explore.
2. Write an implementation plan: what you understood the task to be, the files
   you will change, the approach, and anything you are unsure about.
3. Show me the plan and WAIT. Do not edit a file, and do not run a command
   that changes anything, until I approve the plan in so many words.
4. Change the plan as often as I ask. Only when I approve it do you implement.

A small, clear task — a typo, a rename, a one-line fix, a question — needs no
plan. Just do it.

After you finish the approved work, if I describe more work, ask whether I
want a plan first or a direct implementation. Do not assume.

The `/plan` command (the plan-mode extension) makes this a hard rule instead
of an instruction: it blocks every mutation until the plan is approved, and
`/plan implement` releases it. Use `/plan` yourself, or tell me to, whenever
enforcement is better than good intentions.
