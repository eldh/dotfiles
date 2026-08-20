# Global instructions

Always use ASD-STE100!

# Model split: plan on Fable, implement via subagents

Default working mode, unless I explicitly say otherwise in a session:

- Do planning, architecture decisions, and code review yourself (the main-loop Fable model).
- Delegate implementation — writing and editing code per an agreed plan — to subagents via the Agent tool, with `model: "sonnet"` for routine work and `model: "opus"` for complex or delicate changes. Give the subagent the full plan and relevant file paths; review its changes yourself afterwards.
- Exceptions where you should just edit directly: trivial changes (a few lines, config tweaks, renames) and fixes discovered during your own review.
- If I name a model or say "do it yourself" / "don't use subagents", that overrides this default for the request.

### Working with Linear Diffs and/or Github

When asked to "address" PR comments, whether from Codex or coworkers, first summarize them in a table with columns for the comment, assessment, and plan. Address each comment either by making a change or by replying with a concise reason no change is needed, such as when the concern is not valid or not worth acting on. Keep replies casual and concise, and do not reference git shas. For a simple comment fixed in code, "updated" is an acceptable reply. After pushing any changes and replying, resolve each thread that has been fully addressed.
