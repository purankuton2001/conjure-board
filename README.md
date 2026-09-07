# Conjure Board

**Your character. A world to meet.** Give the character you imagined a place to speak, move and meet someone new.

[castconjure](https://github.com/purankuton2001/castconjure) turns comments into generated video replies. [AI OshiBloom](https://github.com/purankuton2001/ai-oshibloom) starts with a character studio and a first streaming session. Both are open-source tools for your own original AI characters. Watch the demos, pick an app, and share a favorite moment on the Board.

The two apps began from the same specification, built with Claude Fable 5.1 and GPT-6. Both use fal H3 for video; no sponsors. The Board records reviewed stream activity, including reply languages. Those counts describe logged interactions, not a guarantee of audience growth.

**Site:** https://purankuton2001.github.io/conjure-board/

## Report a stream

Streamed with your own original character on either app? [Open a stream report](https://github.com/purankuton2001/conjure-board/issues/new?template=stream-report.yml). You need: the app, the stream URL, your idol's name, your language, the session log (JSONL), the reply model, a clip (≤ 15 s), and four pledges: own original character, "AI generated" label on, platform synthetic-content disclosure on, adult character.

日本語で書いて構いません（項目名はそのままに）。A person checks every report before it appears (weekly at first). Reactions and views help you look back on the session. Generation uses your own API keys and incurs provider costs. Entries with bot suspicion are held.

No real idols, groups or existing characters, and no "made to look like X". Both apps and this Board read the same [exclusion list](data/ip-names.txt). To have an entry removed, open a [takedown request](https://github.com/purankuton2001/conjure-board/issues/new?template=takedown.yml).

## What is here

This repository is generated. Everything in it is pushed automatically from the maintainers' private ops repo; pull requests here are not merged (open an issue instead).

```
index.html, gallery.html, versus.html, report.html, weekly.html   the site
board.json                       the Board as data
data/reports/*.json              accepted stream reports
data/tiers.json                  Board tiers
data/versus.json                 the comparison table and stream designs
data/apps.json                   both apps in one line each
data/spec/REQUIREMENTS-v0.8.md   the requirements document both apps were built from (Japanese)
data/ip-names.txt                shared exclusion list (real idols, groups, existing characters)
```

## Not sponsored

Neither Anthropic, OpenAI, fal nor MiniMax sponsors this. Both apps render video with fal's MiniMax H3, so on-screen differences come only from reply text, action direction, latency and product decisions.

Code and data files are MIT. Stream reports and clips belong to their streamers; ask before reusing them.
