# Sean OS — A One-Person Company, Run by a Multi-Agent System

> Chairman (human) → CEO agent → domain agents, running 24/7.
> A working blueprint for orchestrating *your whole life's operations* with AI agents — not a toy demo.

I run a one-person operation spanning a restaurant, investments, a job search, personal logistics, and early-stage ventures. Instead of juggling them by hand, I built **Sean OS**: a human chairman delegating to a CEO agent, which orchestrates specialized domain agents on a fixed cadence.

This repo is the **architecture and methodology** — sanitized, reusable, no private data.

## The model

```
👤 Chairman (human)         — decisions only, single inbox
   │
🧠 CEO Agent                — orchestration, cross-domain priority, weekly board report
   │   (resident session: persistent memory, zero cold-start)
   ├── 🍜 COO      restaurant ops (scheduled reminders, inventory, daily close)
   ├── 💶 CFO      investing (weekly report, position watch)
   ├── 💼 CHRO     job search (delegated to a coding agent as executor)
   ├── 🏠 Steward  personal & travel
   ├── 🚀 BD       ventures
   └── 📣 CMO      personal brand
```

## Principles that made it work

1. **Deterministic shell, judgment-only agents.** Scripts handle data-fetch, delivery, idempotency, retries; the LLM only does synthesis. Cron + a resident chat session, not a heavy framework.
2. **Command & report.** The CEO commands executors and *reads their reports* — it never reaches past an executor into its workspace. Clear权责 boundaries prevent race conditions and half-state errors.
3. **One ledger.** A single cross-domain task ledger is the source of truth; the weekly board report is generated from it.
4. **Heartbeat, not babysitting.** A weekly "board meeting" surfaces 3 decisions for the human — the system watches the human's blind spots, not the other way around.
5. **Model routing by value density.** Cheap models for high-frequency reminders; frontier models for decisions; a coding agent for engineering.

## What's in here

- `architecture/` — the full diagram + domain contracts
- `patterns/` — resident-session vs one-shot, command-and-report, deterministic-shell
- `examples/` — sanitized skeletons of a scheduled briefing job and an agent skill

## What's NOT here
Private keys, client data, employer information, and the actual running config. This is the *pattern*, so you can build your own.

---
*Built by [Xiao Bi](https://www.linkedin.com/in/xiao-bi-bb6419148/) — AI Solutions Engineer, PhD EE (TUM). I ship GDPR-compliant AI systems.*
