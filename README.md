# sean-os-blueprint

I run a one-person operation that spans a restaurant, investments, a job search, personal logistics, and some early ventures. Instead of juggling all of it by hand, I set it up as a small organization of agents: I'm the chairman who only makes decisions, a CEO agent does the orchestration, and domain agents handle each area on a schedule.

This repo is the architecture and the patterns behind it, sanitized. No private config, no keys.

## The shape of it

```
Chairman (me)            decisions only, one inbox
   |
CEO agent                orchestration, cross-domain priority, a weekly report
   |   (a resident session, so it keeps context instead of cold-starting)
   |-- restaurant ops    scheduled reminders, inventory, daily close
   |-- investing         weekly report, position watch
   |-- job search        delegated to a coding agent as the executor
   |-- personal/travel
   |-- ventures
   |-- personal brand
```

## What actually made it work

1. The shell is deterministic, the agent only judges. Scripts handle fetching data, delivery, retries, idempotency. The LLM only does the synthesis. Cron plus a resident chat session, not a heavy framework.
2. Command and report. The CEO tells an executor what to do and reads its report back. It never reaches past an executor into that executor's files. This one rule killed most of the race conditions and half-finished-state bugs.
3. One ledger. A single cross-domain task list is the source of truth. The weekly report is generated from it, not assembled ad hoc.
4. The system watches me, not the other way around. A weekly "board meeting" surfaces three decisions that need me. The rest runs on its own.
5. Cheap models for frequent small jobs, frontier models for decisions, a coding agent for engineering work.

## In here

- `architecture/` the diagram and the per-domain contracts
- `patterns/` resident session vs one-shot, command-and-report, deterministic shell
- `examples/` sanitized skeletons: a scheduled briefing job, a domain-agent skill

## Not in here

Keys, client data, employer information, the running config. This is the pattern so you can build your own.

---
Built by Xiao Bi. AI Solutions Engineer, EE PhD (TU Munich), Munich.
