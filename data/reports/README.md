# Stream reports

One JSON file per accepted (or pending) stream report. File name: `<date>-<streamer-slug>[-<n>].json`.

Create one from a GitHub issue (`stream-report` label) with:

```bash
npm run ingest -- --issue 12          # issue number in purankuton2001/conjure-board; the log is read from the issue
```

or by hand from `_example.json`. New `stream-report` issues are also picked up hourly by `.github/workflows/ingest-issue.yml`, which opens a PR with the pending JSON. Files starting with `_` are ignored by every script.

| Field | Meaning |
|---|---|
| `status` | `pending` (not yet checked by a person), `accepted` (on the Board), `held` (bot suspicion or a failed check; not shown) |
| `app` | `castconjure` or `ai-oshibloom` |
| `external` | `true` when the idol belongs to someone other than the maintainer |
| `metrics.reactions` | Count of `play_start` events in the session log (acks excluded). This is the primary metric |
| `metrics.median_latency_ms` | Median of `play_start.sinceReceivedMs` |
| `metrics.cost_usd` | Sum of `gen_done.costUsd`. OshiBloom Director cost is self-reported |
| `metrics.views` / `peak_concurrent` | From YouTube `videos.list` (`npm run yt`) |
| `checks` | The four pledges from the issue form. All four must be `true` before `status` becomes `accepted` |

Before accepting, a person looks at the clip and the persona for: own OC, AI label on screen, adult character. Numbers come second. If in doubt, `held`.
