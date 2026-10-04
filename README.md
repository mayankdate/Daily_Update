# The Daily Brief · Signal Edition

A personal newspaper with a modern editorial/cyberpunk design, built in one editable Python notebook. No web app framework, paid news API, or LLM subscription is needed.

## Update your existing project

1. Copy `scripts/`, `requirements.txt`, `CLAUDE.md`, and `.gitignore` into the matching places in your project. Merge any project-specific ignore rules you have added.
2. Keep your existing local `notion_tasks_token.txt` and `notion_workoutdash_token.txt` in the project root. Tokens are not included in this download.
3. In VS Code, select your `.venv` Python kernel. In that environment run `python -m pip install -r requirements.txt`.
4. Open `scripts/build_brief.ipynb`, review the configuration cell, and Run All. This writes `docs/index.html`, `docs/daily_brief.html`, both favicons, and `docs/news_diagnostics.json`.
5. Open `docs/index.html` locally or push your rendered `docs/` folder to your existing GitHub Pages repository.

The included `preview/index.html` uses **illustrative sample content**, clearly labelled on the page. It is for inspecting the layout before connecting Notion. Preview links lead to publisher homepages rather than fictional article URLs. The rendered `docs/` edition was built using public integrations; it does not contain your Notion task/workout data. Run your notebook to replace it with your personal edition.

## What changed

- Dark green-black panels, warm editorial type, lime and cyan accents. A remembered light theme is also included. System fonts keep the page fast and avoid font downloads.
- Phone layout: swipable hourly weather, stacked collapsible daily panels, horizontally scrollable topic filters, full-width readable story cards, and generous tap targets.
- Gym loadout appears only inside Workout. The volume/issue numbers are gone.
- **Music fallback is a compact artist label and an Open Spotify button next to weather. There is no embedded player or standalone music section.** Recent releases appear in an expandable list in the same small panel. The artist link is still available when releases exist.
- News filters, instant search, priority/newest sorting, show more, publisher labels, and an expandable score explanation per story.
- Comics are a compact horizontal strip at the end on phones.
- SVG and multi-resolution ICO favicons. The mark is a simple D for Daily Brief; replace the two files in `scripts/` to use a personal logo.

## Configuration

The first code cell contains three sections:

- `CONFIG`: your identity, weather, workouts, countdowns, comics, artists, and ranking controls.
- `SOURCES`: named publishers with a domain, optional RSS/Atom URL, source type, and an editable reliability preference from 0–100.
- `TOPICS`: group names, source IDs, keyword gates, interest boosts, title exclusions, and optional discovery queries.

Defaults include AI & Models; Data & Building (R/Python/statistics); Gaming (with Witcher/GTA/RPG boosts); and Culture & Worlds (Harry Potter/Hogwarts). Add or rename a group in `TOPICS`; navigation and filters regenerate automatically. IDs must be unique lowercase slugs. Broad sources need a keyword match; `dedicated_sources` bypass that gate. Each story is assigned to its highest-scoring group, so cross-topic stories do not appear twice.

To add a publisher, add one entry to `SOURCES` and include its ID in a topic's `sources`. Add it to `dedicated_sources` only if its entire feed is relevant. GitHub sources use a repository `path_prefix` so unrelated repositories cannot inherit their ranking preference.

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

The notebook requests the next 24 hourly forecast slots from Open-Meteo, starting at the build hour and crossing midnight as needed. Each slot includes temperature, feels-like temperature, rain probability, humidity and wind; metric/imperial follows CONFIG.

When the forecast is at least one hour old, the browser can refresh it directly from the public API, then retry hourly while the page is open or when returning to an old tab. This needs internet access and no secret. On failure, the last rendered forecast remains with an explicit failure/build-time note. Set `weather_browser_refresh=False` to use only the build snapshot. **Hourly forecasts are not minute-by-minute observations.** News, Notion and countdowns refresh only when the notebook rebuilds.

## GitHub automation

An updated `.github/workflows/daily-brief.yml` is included. It builds four times a day, at approximately 06:00, 12:00, 18:00 and 00:00 IST (schedulers may be delayed). Copy it if you want that schedule; retain your current workflow if you prefer once daily. Do not keep two equivalent workflows enabled.

Keep your existing repository secrets: `NOTION_TASKS_TOKEN` and `NOTION_WORKOUT_TOKEN`. A missing or failed Notion connection displays “unavailable”; it does not stop the news build or masquerade as an empty task list. Existing Notion property names/data-source IDs are preserved.

The supplied workflow is for the existing GitHub Pages **Deploy from a branch → docs/** setup. If your repository uses a custom Pages Actions deployment, retain that deployment workflow; this file only renders and commits the edition. Executed notebooks go to `/tmp`, not back into the repository. A push by the Actions token may not trigger another workflow, so a custom deployment must explicitly build/deploy in the same workflow or use its existing mechanism.

## Files

```
scripts/build_brief.ipynb     Configuration + all Python build logic
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

All notebook cells compile and the notebook schema validates. Fixture checks cover ranking, source allowlists, freshness, duplicate handling, malformed/future dates, failed feeds, 24-hour weather windows, escaped external text, empty integrations, and both music states. A public-data run completed and selected 19 stories from 12 successful feed requests. Notion could not be live-tested without your local tokens. MusicBrainz and two comic feeds returned unusable responses in this environment; those failures are surfaced. DOM interaction tests also passed for topic filters, search/empty results, sorting, pagination, mobile panel defaults and theme persistence writes. Browser-based visual verification was blocked by the execution environment, so the supplied preview should be checked on your phone before publishing.
