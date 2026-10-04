# The Daily Brief · Signal Edition

A personal newspaper with a modern editorial/cyberpunk design, built in one editable Python notebook. No web app framework, paid news API, or LLM subscription is needed.

## Update your existing project

1. Copy `scripts/`, `requirements.txt`, `CLAUDE.md`, and `.gitignore` into the matching places in your project. Merge any project-specific ignore rules you have added.
2. Keep your existing local `notion_tasks_token.txt` and `notion_workoutdash_token.txt` in the project root. Tokens are not included in this download.
3. In VS Code, select your `.venv` Python kernel. In that environment run `python -m pip install -r requirements.txt`.
4. Open `scripts/build_brief.ipynb`, edit `scripts/config.yaml`, and Run All. This writes `docs/index.html`, `docs/daily_brief.html`, both favicons, and `docs/news_diagnostics.json`.
5. Open `docs/index.html` locally or push your rendered `docs/` folder to your existing GitHub Pages repository.

The included `preview/index.html` uses **illustrative sample content**, clearly labelled on the page. It is for inspecting the layout before connecting Notion. Preview links lead to publisher homepages rather than fictional article URLs. The included `docs/` starts with the same labelled sample preview. Run your notebook to replace it with your personal edition. `preview/releases.html` demonstrates the new-release state; `preview/many.html` demonstrates a longer countdown list.

## What changed

- Dark green-black panels, warm editorial type, lime and cyan accents. A remembered light theme is also included. System fonts keep the page fast and avoid font downloads.
- Phone layout: swipable hourly weather, stacked collapsible daily panels, horizontally scrollable topic filters, full-width readable story cards, and generous tap targets.
- Gym loadout appears only inside Workout. The volume/issue numbers are gone.
- **Music is conditional:** without recent releases, a compact 152px Spotify player sits beside weather (right-aligned beneath it on phones). When tracked artists have releases, the player disappears and a dedicated music section lists them with artist/title Spotify search links. Search links avoid guessing a track or album ID; the button says “Find on Spotify.” Detection uses MusicBrainz and the configurable `music_lookback_days` (currently 60). Release groups are paginated; one failed artist check does not discard other artists’ releases. Failed checks are labelled.
- Compact task rows without checkboxes, plus compact countdown rows that fit additional events.
- A visible “Why this story” reason and a clearly labelled score disclosure showing weighted points.
- News filters, instant search, priority/newest sorting, show more, publisher labels, and an expandable score explanation per story.
- Comics are a compact horizontal strip at the end on phones.
- SVG and multi-resolution ICO favicons. The mark is a simple D for Daily Brief; replace the two files in `scripts/` to use a personal logo.

## Configuration

All editable configuration lives in **`scripts/config.yaml`**. The notebook loads it when you Run All:

```text
scripts/
  config.yaml          ← edit preferences here
  build_brief.ipynb     ← run the build here
  template_html.html
  template_css.css
```

- `settings`: your identity, weather, workouts, countdowns, comics, artists, ranking controls, and Notion source IDs.
- `sources`: named publishers with a domain, optional RSS/Atom URL, source type, and an editable reliability preference from 0–100.
- `topics`: group names, source IDs, keyword gates, interest boosts, title exclusions, and optional discovery queries.

Defaults include AI & Models; Data & Building (R/Python/statistics); Gaming (with Witcher/GTA/RPG boosts); Culture & Worlds (Harry Potter/Hogwarts); and Geopolitics (conflicts, diplomacy, trade, sanctions, and technology policy, with India/Asia interests). Geopolitics uses BBC/Guardian world feeds and allowlisted Reuters/AP discovery, with topic-specific usefulness, importance, and rumor terms. These preferences are editable; no source is treated as infallible. Add or rename a group in `topics`; navigation and filters regenerate automatically. IDs must be unique lowercase slugs. Broad sources need a keyword match; `dedicated_sources` bypass that gate. Each story is assigned to its highest-scoring group, so cross-topic stories do not appear twice.

To add a publisher, add one entry to `sources` and include its ID in a topic's `sources`. Add it to `dedicated_sources` only if its entire feed is relevant. GitHub sources use a repository `path_prefix` so unrelated repositories cannot inherit their ranking preference.

### Editing YAML

Use spaces for indentation, `true`/`false` for switches, and `null` for an empty RSS URL. Add list entries with `-`. Dates should be quoted, e.g. `date: '2026-12-31'` (unquoted countdown dates also work). Notion and Spotify IDs should remain strings. Tokens stay in their existing files or environment variables; do not put tokens in YAML.

After editing, **Run All** so the configuration is reloaded before fetching and rendering. The loader finds `scripts/config.yaml` from either the root or a descendant folder. It reports malformed YAML, duplicate keys, missing sections, and unknown source IDs. Topic IDs and ranking weights are validated by the existing news logic.

Install the updated requirements once to add PyYAML. For subsequent updates, preserve your customized `config.yaml` when replacing the notebook/templates. The existing scheduled workflow installs requirements and loads this same file automatically.

## Selection and reliability

Default priority weights sum to 100:

| Component | Weight | Signal |
| --- | ---: | --- |
| Relevance | 30 | Topic keywords, dedicated feeds, interest boosts |
| Source preference | 25 | Your configured reliability preference |
| Freshness | 20 | Exponential decay with a 48-hour half-life |
| Practical usefulness | 15 | Code, tutorials, datasets, packages, benchmarks, APIs |
| Importance cues | 10 | Launches, releases, security, breaking changes, patches |

Rumor wording subtracts 12 points; shopping/promotion cues subtract 25. Defaults use a 7-day lookback, score floor of 35, up to 12 stories per group, and 3 per source per group. Weights are normalized if you change their total. A quiet group remains quiet; it is not filled with unapproved outlets.

These are **transparent title/excerpt heuristics**, not measured reliability probabilities, article-level fact-checks, importance judgments by an LLM, or proof of independent corroboration. Vendor, maintainer, community, and editorial sources are visibly distinguished. A maintainer is useful for its own release notes; vendor claims are still self-published claims. RSS excerpts are publisher text, not generated summaries.

Collection fetches direct feeds once, with bounded parallelism and timeouts. Optional Google News discovery uses `site:` constraints and accepts only source metadata matching the approved domain/path. Google redirect links remain Google links; the notebook does not silently guess the final article URL. Feeds or entries without usable dates, approved links, or relevant topics are rejected. Canonical URLs and conservatively similar headlines remove common duplicates, but cannot detect every syndicated/reworded story.

`docs/news_diagnostics.json` records candidates, component scores, selected IDs and source health. It contains no Notion task or workout data. Source failures are also visible in **Behind the briefing**. Change a source URL or preference when your editorial judgment changes.

## Weather freshness

The notebook requests the current **local calendar day, 00:00 through 23:00**, using `CONFIG["timezone"]` (Asia/Kolkata). It includes earlier hours even if you run it in the evening and never fills the list with tomorrow’s hours. Each slot includes temperature, feels-like temperature, rain probability, humidity and wind; metric/imperial follows CONFIG.

When the forecast is at least one hour old or the local calendar date has changed, the browser can refresh it directly from the public API, then retry hourly while the page is open or when returning to an old tab. Refresh keeps the same full-calendar-day rule and explicitly labels the forecast date, including when an old edition remains open overnight. This needs internet access and no secret. On failure, the last rendered forecast remains with an explicit failure/build-time note. Set `weather_browser_refresh=False` to use only the build snapshot. **Hourly forecasts are not minute-by-minute observations.** News, Notion and countdowns refresh only when the notebook rebuilds.

## GitHub automation

An updated `.github/workflows/daily-brief.yml` is included. It builds four times a day, at approximately 06:00, 12:00, 18:00 and 00:00 IST (schedulers may be delayed). Copy it if you want that schedule; retain your current workflow if you prefer once daily. Do not keep two equivalent workflows enabled.

Keep your existing repository secrets: `NOTION_TASKS_TOKEN` and `NOTION_WORKOUT_TOKEN`. A missing or failed Notion connection displays “unavailable”; it does not stop the news build or masquerade as an empty task list. Existing Notion property names/data-source IDs are preserved.

The supplied workflow is for the existing GitHub Pages **Deploy from a branch → docs/** setup. If your repository uses a custom Pages Actions deployment, retain that deployment workflow; this file only renders and commits the edition. Executed notebooks go to `/tmp`, not back into the repository. A push by the Actions token may not trigger another workflow, so a custom deployment must explicitly build/deploy in the same workflow or use its existing mechanism.

## Files

```
scripts/config.yaml          All editable preferences, sources and topic groups
scripts/build_brief.ipynb     Configuration loader + all Python build logic
scripts/template_html.html  Semantic page template + small browser interactions
scripts/template_css.css    Responsive light/dark theme
scripts/favicon.svg         Editable vector favicon
scripts/favicon.ico         Browser fallback (16–256px)
docs/                       Rendered edition + news diagnostics
preview/                    Labelled sample preview + icons
requirements.txt            Notebook/build dependencies
.github/workflows/          Optional build schedule
CLAUDE.md                   Project handoff notes
```

## Privacy behavior carried forward

`mask_private_tasks=True` masks titles only when the Notion Tasks database has a checked `Private` checkbox. It does not make the page private, hide task types, or conceal other task/workout metadata. Rendered `docs/` is whatever your existing Pages audience can access. Tokens stay in ignored local files or repository secrets.

## Integration references

- [Open-Meteo forecast documentation](https://open-meteo.com/en/docs)
- [Posit Open Source RSS subscription options](https://opensource.posit.co/subscribe/)
- [Hugging Face blog](https://huggingface.co/blog)
- [PC Gamer RSS](https://www.pcgamer.com/rss/)

Direct RSS endpoints were checked during this update. Runtime diagnostics, not an assumed permanent status, determine whether a feed is currently available.

## Validation in this update

Notebook syntax/schema and fixture checks pass for calendar-day weather (midnight, midday and late evening), conditional music states, release pagination/failures, source matching, geopolitics scoring, ranking explanations and HTML escaping. DOM checks cover filters/search/sort/show-more/theme plus browser weather refresh and midnight date rollover. Browser visual verification and live Spotify playback could not be completed because this environment blocks the browser process. Check the included previews on your phone before publishing. Notion credentials are not included or required for sample previews.
