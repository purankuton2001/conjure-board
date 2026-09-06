# Conjure Board

**Two apps · one experiment · one Board.** The public Board site and report desk for [castconjure](https://github.com/purankuton2001/castconjure) and [AI OshiBloom](https://github.com/purankuton2001/ai-oshibloom), two open-source AI VTuber apps built from the same requirements document by two different models (Claude Fable 5.1 and GPT-6).

**Site:** https://purankuton2001.github.io/conjure-board/

## Report a stream

Streamed with your own original character on either app? [Open a stream report](https://github.com/purankuton2001/conjure-board/issues/new?template=stream-report.yml). You need: the app, the stream URL, your idol's name, the session log (JSONL), the reply model, a clip (≤ 15 s), and four pledges: own original character, "AI generated" label on, platform synthetic-content disclosure on, adult character.

A person checks every report before it appears (weekly at first). Reactions, each of which costs about $0.25 to generate, are the primary metric; views are the applause. Entries with bot suspicion are held.

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
