# Daily Brief — notebook-first personal newspaper

Keep editable configuration in the split `scripts/config_*.yaml` files and `scripts/config_topics/*.yaml` and backend logic in `scripts/build_brief.ipynb`. The notebook loads YAML into CONFIG, SOURCES, and TOPICS; do not duplicate settings inside it. Do not convert this project into a service, framework app, or collection of Python modules unless explicitly requested. Templates live beside the notebook; output lives in `docs/` for the existing GitHub Pages project.

## UI constraints

- Modern newspaper plus restrained cyberpunk: editorial serif headlines, dark green panels, cyan/lime accents, system fonts. Maintain light mode.
- Mobile-first. Weather and topic controls may scroll horizontally; the entire page must not overflow. Tasks/workout/countdowns are stacked native details panels; tasks start open on phones.
- No volume/issue numbers. Gym loadout belongs in Workout only.
- **Conditional music:** no recent releases → compact 152px Spotify artist embed beside weather; recent releases → dedicated release section with Spotify links and no fallback player. On phones the fallback is right-aligned below weather. Keep unavailable checks explicit. Spotify links use artist/title searches unless an actual track/album ID is known.
- Tasks use compact text rows without checkboxes; countdowns use compact name/date/count rows. News cards are concise and equal-width; a single short reason stays visible while excerpts and full scoring expand under Details & score. Do not restore the oversized lead card. Keep filters, search, priority/newest sort, show more, visible timestamps, source labels and score explanations. Progressive fallback must leave stories readable without JavaScript.
- Use Jinja autoescaping for external strings. Only trusted local stylesheet contents use `safe`; API URLs must be HTTP(S).
- New favicon assets must be copied from scripts to docs on every build.

## Backend

Settings/tracked/news files merge into CONFIG; config_sources.yaml becomes SOURCES; config_topics/*.yaml becomes TOPICS, ordered by config_news.yaml topic_order. Preserve all files; the old config.yaml is not read. Preserve customized YAML during future code updates. Use the safe YAML loader and retain duplicate-key validation. Scores are adjustable heuristics, not fact-checks. Never present source preferences as measured accuracy or independent corroboration. Preserve vendor/maintainer/community/editorial labels.

Direct RSS collection runs once per source in a bounded thread pool. Google discovery is optional and strictly allowlisted using publisher source metadata, not names inferred from a title. GitHub feeds must keep repository path restrictions. Keep freshness filtering, future-date rejection, conservative duplicate removal and publisher caps. Do not silently fill failed topics with random sources.

Weather covers the local calendar day 00:00–23:00. Save each successful build forecast in docs/weather_cache.json and inline it in the page. Preserve the last good cache on failure; reject mismatched location/units/timezone. Highlight and scroll to the reader’s current hour using the configured timezone, update on hour changes and tab return, and label cache timestamps and expired coverage. Never present a cached forecast as a live observation. Browser refresh is optional and public. News/Notion/countdowns require a rebuild. Failures must be explicit, with per-source status and public-news-only `docs/news_diagnostics.json`.

Preserve the user's Notion data-source IDs, property names, artist IDs, comic feeds and local token filenames. Missing credentials must not crash unrelated sections. Never commit tokens, executed notebook outputs, or private fixtures. Masking private task titles requires an actual checked `Private` property and does not make public HTML private.

## Verification

Compile every notebook code cell. Verify ranking and source allowlists with fixtures, including malformed dates, feed timeouts, duplicate titles/URLs and different release versions. Render with StrictUndefined, including empty and failed sections. Check phone widths (320/390px), tablet and desktop; filter/search/sort/theme/show-more; no full-page horizontal overflow; exactly one small music iframe in the fallback state and none in the releases state. Preview content must stay explicitly labelled as samples. Run the public integrations separately from private Notion checks.

Use README.md for setup, refresh behavior, selection limitations and GitHub Pages deployment assumptions.
