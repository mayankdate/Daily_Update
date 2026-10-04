# The Daily Brief · Signal Edition

A personal newspaper with a modern editorial/cyberpunk design, built in one editable Python notebook. No web app framework, paid news API, or LLM subscription is needed.

## Update your existing project

1. Copy `scripts/`, `requirements.txt`, `CLAUDE.md`, and `.gitignore` into the matching places in your project. Merge any project-specific ignore rules you have added.
2. Keep your existing local `notion_tasks_token.txt` and `notion_workoutdash_token.txt` in the project root. Tokens are not included in this download.
3. In VS Code, select your `.venv` Python kernel. In that environment run `python -m pip install -r requirements.txt`.
4. Open `scripts/build_brief.ipynb`, edit the split configuration files described below, and Run All. This writes `docs/index.html`, `docs/daily_brief.html`, both favicons, and `docs/news_diagnostics.json`.
5. Open `docs/index.html` locally or push your rendered `docs/` folder to your existing GitHub Pages repository.

The included `preview/index.html` uses **illustrative sample content**, clearly labelled on the page. It is for inspecting the layout before connecting Notion. Preview links lead to publisher homepages rather than fictional article URLs. The included `docs/` starts with the same labelled sample preview. Run your notebook to replace it with your personal edition. `preview/releases.html` demonstrates the new-release state; `preview/many.html` demonstrates a longer countdown list.

## What changed

- Dark green-black panels, warm editorial type, lime and cyan accents. A remembered light theme is also included. System fonts keep the page fast and avoid font downloads.
- Phone layout: swipable hourly weather, stacked collapsible daily panels, horizontally scrollable topic filters, full-width readable story cards, and generous tap targets.
- Gym loadout appears only inside Workout. The volume/issue numbers are gone.
- **Music is conditional:** without recent releases, a compact 152px Spotify player sits beside weather (right-aligned beneath it on phones). When tracked artists have releases, the player disappears and a dedicated music section lists them with artist/title Spotify search links. Search links avoid guessing a track or album ID; the button says “Find on Spotify.” Detection uses MusicBrainz and the configurable `music_lookback_days` (currently 60). Release groups are paginated; one failed artist check does not discard other artists’ releases. Failed checks are labelled.
- Compact task rows without checkboxes, plus compact countdown rows that fit additional events.
- Concise equal-width news cards with a short reason; expand “Details & score” for the excerpt and complete ranking breakdown.
- News filters, instant search, priority/newest sorting, show more, publisher labels, and an expandable score explanation per story.
- Comics are a compact horizontal strip at the end on phones.
- SVG and multi-resolution ICO favicons. The mark is a simple D for Daily Brief; replace the two files in `scripts/` to use a personal logo.

## Culture merge update

Culture & Worlds has been merged into Movies & Shows. Its sources and interests are retained in `config_topics/movies.yaml`. **When updating an existing project, delete `scripts/config_topics/culture.yaml`**; copying the new ZIP over old files will not remove it, and the loader would still create a Culture tab. Then Run All.

## Configuration: edit by purpose

Your supplied configuration was split by purpose; Culture is now merged into Movies & Shows: 44 sources, seven topics, and all personal settings are preserved.

| File under `scripts/` | Edit when you want to change |
| --- | --- |
| `config_tracked.yaml` | Countdowns, tracked artists, music lookback, comic subscriptions |
| `config_topics/movies.yaml` | Movies, shows, Harry Potter, fantasy, audiobooks, keywords, boosts and sources |
| `config_topics/gaming.yaml` | Games and franchises to follow |
| `config_topics/ai.yaml`, `data.yaml`, `tech.yaml` | Technical interests and topic-specific sources |
| `config_topics/geopolitics.yaml`, `lifestyle.yaml` | The other topic watchlists and preferences |
| `config_news.yaml` | Ranking weights, limits, freshness, discovery edition, topic order |
| `config_sources.yaml` | Publisher definitions, RSS URLs, domain rules, source preferences |
| `config_settings.yaml` | Name, timezone, location, workout loadout, Notion IDs, browser weather refresh |

**For this migration:** copy all four `config_*.yaml` files and the entire `config_topics/` folder alongside the updated notebook and templates. The previous `scripts/config.yaml` is no longer loaded; remove it or keep it outside `scripts/` as your own archive. Tokens stay in their existing files/environment variables.

After editing any configuration file, **Run All**. The loader works from the root, `scripts/`, or another descendant folder. It rejects malformed YAML, duplicate keys within files, repeated top-level settings between files, duplicate topic IDs, and unknown source references. The existing news validation checks ranking weights and topic ID syntax before collection.

To add a topic, copy a file in `config_topics/`, give it a unique `id`, and edit its fields. Every `.yaml` file there is loaded automatically. Optional `topic_order` in `config_news.yaml` controls display order; new topics not listed there appear afterwards. Remove a topic by moving its YAML file out of that folder (then tidy `topic_order` if desired).

Movie/show/game tracking is in that topic's `keywords`, `boost`, and `query`; music/comics/countdowns live in `config_tracked.yaml`. There are no duplicate watchlist settings to synchronize. Source IDs in topics refer to `config_sources.yaml`. `dedicated_sources` bypasses keyword matching, so use it only for focused feeds.

Use spaces, `true`/`false`, and `null` for an empty RSS URL. Quote dates and IDs. Unquoted countdown dates are also supported. Install requirements once if you have not already added PyYAML. Future notebook/template updates should preserve your customized configuration files.

English/global coverage remains exactly as supplied. A Google News edition is not a worldwide filter; the global source list provides geographic breadth. RSS availability, article language, streaming availability, publisher-level diversity, and spoiler filtering retain the existing limitations. Source scores are editorial preferences, not accuracy measurements.

## Selection and reliability

Default priority weights sum to 100:

| Component | Weight | Signal |
| --- | ---: | --- |
| Relevance | 35 | Topic keywords, dedicated feeds, interest boosts |
| Source preference | 25 | Your configured reliability preference |
| Freshness | 15 | Exponential decay with a 36-hour half-life |
| Practical usefulness | 15 | Code, tutorials, datasets, packages, benchmarks, APIs |
| Importance cues | 10 | Launches, releases, security, breaking changes, patches |

Rumor wording subtracts 12 points; shopping/promotion cues subtract 25. Your configuration uses a 7-day lookback, score floor of 35, up to 10 stories per group, and 2 per source ID per group. Weights are normalized if you change their total. A quiet group remains quiet; it is not filled with unapproved outlets.

These are **transparent title/excerpt heuristics**, not measured reliability probabilities, article-level fact-checks, importance judgments by an LLM, or proof of independent corroboration. Vendor, maintainer, community, and editorial sources are visibly distinguished. A maintainer is useful for its own release notes; vendor claims are still self-published claims. RSS excerpts are publisher text, not generated summaries.

Collection fetches direct feeds once, with bounded parallelism and timeouts. Optional Google News discovery uses `site:` constraints and accepts only source metadata matching the approved domain/path. Google redirect links remain Google links; the notebook does not silently guess the final article URL. Feeds or entries without usable dates, approved links, or relevant topics are rejected. Canonical URLs and conservatively similar headlines remove common duplicates, but cannot detect every syndicated/reworded story.

`docs/news_diagnostics.json` records candidates, component scores, selected IDs and source health. It contains no Notion task or workout data. Source failures are also visible in **Behind the briefing**. Change a source URL or preference when your editorial judgment changes.

## Weather cache and reading-time highlight

Each build fetches the full **local calendar day, 00:00–23:00**, in your configured timezone. It writes the successful result to `docs/weather_cache.json` and embeds those hourly slots in the HTML, so they remain readable offline. The cache includes the location, units, timezone and original fetch timestamp. The last good file is retained if a request fails; a cache for different coordinates/units/timezone is not reused.

At reading time, the page uses the clock in your configured timezone to highlight the current hour with **NOW**, show that hour’s cached conditions, and scroll it into view. Past hours remain to the left and the remaining hours of the day to the right. The marker updates every minute and when returning to the tab; scrolling only occurs initially or when the hour changes, so browsing other hours is not constantly interrupted. This retains the requested midnight-to-midnight range, not a rolling 24 hours into tomorrow.

The note always shows the cache’s date and timestamp. **The live element is the clock/marker; weather values are forecasts, not live observations.** If the current hour is outside the cache, the page says so and removes the NOW marker. It never re-labels yesterday’s forecast as today’s.

With `weather_browser_refresh: true` in `config_settings.yaml`, the page requests a fresh daily forecast once its data is at least an hour old, or the date changes. Failed refreshes retain the cached display and show an unavailable label; retries are spaced by at least five minutes. With refresh disabled or offline, the clock-based highlight still works for any hour in the cached day. News, Notion and countdowns still refresh only on notebook builds.

## GitHub automation

An updated `.github/workflows/daily-brief.yml` is included. It builds four times a day, at approximately 06:00, 12:00, 18:00 and 00:00 IST (schedulers may be delayed). Copy it if you want that schedule; retain your current workflow if you prefer once daily. Do not keep two equivalent workflows enabled.

Keep your existing repository secrets: `NOTION_TASKS_TOKEN` and `NOTION_WORKOUT_TOKEN`. A missing or failed Notion connection displays “unavailable”; it does not stop the news build or masquerade as an empty task list. Existing Notion property names/data-source IDs are preserved.

The supplied workflow is for the existing GitHub Pages **Deploy from a branch → docs/** setup. If your repository uses a custom Pages Actions deployment, retain that deployment workflow; this file only renders and commits the edition. Executed notebooks go to `/tmp`, not back into the repository. A push by the Actions token may not trigger another workflow, so a custom deployment must explicitly build/deploy in the same workflow or use its existing mechanism.

## Files

```
scripts/config_settings.yaml Personal and integration settings
scripts/config_tracked.yaml  Artists, comics and countdowns
scripts/config_news.yaml     Ranking, collection and topic ordering
scripts/config_sources.yaml  Publisher registry
scripts/config_topics/       One editable YAML file per topic
scripts/build_brief.ipynb     Configuration loader + all Python build logic
scripts/template_html.html  Semantic page template + small browser interactions
scripts/template_css.css    Responsive light/dark theme
scripts/favicon.svg         Editable vector favicon
scripts/favicon.ico         Browser fallback (16–256px)
docs/                       Rendered edition, persistent weather cache + news diagnostics
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

The initial split preserved all uploaded configuration values. The subsequent Culture merge combines its sources and interests into Movies & Shows without dropping them. Notebook syntax/schema, source matching, ranking, sample rendering, filtering/search/sort/pagination/theme, conditional music, and forecast handling pass fixture/DOM checks. Targeted checks cover cache persistence, failed requests, corrupt/mismatched caches, reading-time highlights, timezone-aware hour changes, midnight rollover, and retained expandable article details. Browser visual verification remains unavailable in this environment; inspect the labelled previews on your phone. Live source availability was not rechecked for all 44 supplied sources in this configuration/layout update.
