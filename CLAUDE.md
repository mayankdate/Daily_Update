# Daily Brief — notebook-first personal newspaper

Keep all configuration and backend logic in `scripts/build_brief.ipynb`. Do not convert this project into a service, framework app, or collection of Python modules unless explicitly requested. Templates live beside the notebook; output lives in `docs/` for the existing GitHub Pages project.

## UI constraints

- Modern newspaper plus restrained cyberpunk: editorial serif headlines, dark green panels, cyan/lime accents, system fonts. Maintain light mode.
- Mobile-first. Weather and topic controls may scroll horizontally; the entire page must not overflow. Tasks/workout/countdowns are stacked native details panels; tasks start open on phones.
- No volume/issue numbers. Gym loadout belongs in Workout only.
- **Do not restore a standalone Spotify section or embedded player.** A compact soundtrack artist/button sits beside weather. Recent music releases use a compact expandable list there.
- Keep filters, search, priority/newest sort, show more, visible timestamps, source labels and score explanations. Progressive fallback must leave stories readable without JavaScript.
- Use Jinja autoescaping for external strings. Only trusted local stylesheet contents use `safe`; API URLs must be HTTP(S).
- New favicon assets must be copied from scripts to docs on every build.

## Backend

Configuration uses CONFIG (personal/build settings), SOURCES (domain/type/editorial reliability preference/RSS), TOPICS (keywords/dedicated sources/boosts/exclusions). Scores are adjustable heuristics, not fact-checks. Never present source preferences as measured accuracy or independent corroboration. Preserve vendor/maintainer/community/editorial labels.

Direct RSS collection runs once per source in a bounded thread pool. Google discovery is optional and strictly allowlisted using publisher source metadata, not names inferred from a title. GitHub feeds must keep repository path restrictions. Keep freshness filtering, future-date rejection, conservative duplicate removal and publisher caps. Do not silently fill failed topics with random sources.

Weather is a 24-hour forecast window from build time; browser refresh is optional and public. News/Notion/countdowns require a rebuild. Failures must be explicit, with per-source status and public-news-only `docs/news_diagnostics.json`.

Preserve the user's Notion data-source IDs, property names, artist IDs, comic feeds and local token filenames. Missing credentials must not crash unrelated sections. Never commit tokens, executed notebook outputs, or private fixtures. Masking private task titles requires an actual checked `Private` property and does not make public HTML private.

## Verification

Compile every notebook code cell. Verify ranking and source allowlists with fixtures, including malformed dates, feed timeouts, duplicate titles/URLs and different release versions. Render with StrictUndefined, including empty and failed sections. Check phone widths (320/390px), tablet and desktop; filter/search/sort/theme/show-more; no full-page horizontal overflow; no music iframe. Preview content must stay explicitly labelled as samples. Run the public integrations separately from private Notion checks.

Use README.md for setup, refresh behavior, selection limitations and GitHub Pages deployment assumptions.
