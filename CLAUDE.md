# Daily Brief

Personal "daily newspaper" built from Notion (tasks + workout dashboard), live weather, countdown dates, webcomic RSS feeds, MusicBrainz release data, Spotify as a music fallback, and Google News. GitHub Actions runs it each morning, renders a front page plus one page per news topic, and commits them back.

## Front page sections

1. **Weather** — horizontal timeline across 24 hours (every 3h), sunrise/sunset markers, min/max.
2. **Tasks + Workout + Countdowns** — three slim columns.
3. **Music** — new releases if any, else a Spotify "soundtrack of the day" embed.
4. **Comics + Headlines** — comics on the left, grouped news on the right with links to per-topic pages.

Each news group also gets its own page under `docs/news/<slug>.html` with the full set of stories for that group.

## Layout

```
.
├── .github/workflows/daily-brief.yml
├── data/                               (reserved)
├── documents/                          (reserved)
├── docs/                               GitHub Pages serves this folder
│   ├── index.html                      redirect to daily_brief.html
│   ├── daily_brief.html                front page
│   └── news/
│       ├── ai.html                     per-topic pages
│       ├── witcher.html
│       └── …
├── scripts/
│   ├── build_brief.ipynb               config + build
│   ├── template_html.html              front-page shell
│   ├── template_topic_html.html        topic-page shell
│   └── template_css.css                shared styles
├── .gitignore
├── CLAUDE.md
├── notion_tasks_token.txt              LOCAL ONLY, gitignored
├── notion_workoutdash_token.txt        LOCAL ONLY, gitignored
└── requirements.txt
```

## Config highlights

All in the `CONFIG` dict at the top of `scripts/build_brief.ipynb`.

- `mask_private_tasks: True` + a `Private` checkbox column on the Notion Tasks database → private tasks render as `(private task)` in the HTML. Safe for a public repo.
- `loadout` — exact match to a Notion `Loadout` multi-select option.
- `weather` — latitude, longitude, name, metric/imperial. No API key.
- `countdowns` — list of `{name, date}`. Shows days remaining.
- `webcomic_feeds` — each entry has its own `lookback_days` and `items` cap.
- `music_artists` — name + Spotify artist ID. The ID is the last path segment of the artist's `open.spotify.com` URL. Leave blank to skip the soundtrack.
- `news_feeds` — each entry has a `name`, a list of `queries` (merged + deduped), and an `items` cap for the front page. `news_items_on_topic_page` controls the per-topic page.

## Spotify soundtrack behavior

- Picked deterministically by day-of-year, so you get a different artist each morning.
- Only shown when there are no new music releases from `music_artists`.
- **Autoplay with sound is blocked by every modern browser** unless you've already clicked something on the page. The embed loads ready; one click plays it. There is no browser-side workaround for this.

## Running locally

```bash
python -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate
pip install -r requirements.txt
pip install jupyter

echo "secret_xxx..." > notion_tasks_token.txt
echo "secret_yyy..." > notion_workoutdash_token.txt

jupyter notebook scripts/build_brief.ipynb
# or run end-to-end:
jupyter nbconvert --to notebook --execute scripts/build_brief.ipynb --output /tmp/executed.ipynb
```

Open `docs/daily_brief.html`.

## GitHub Actions

Secrets: `NOTION_TASKS_TOKEN`, `NOTION_WORKOUT_TOKEN`.
Permissions: Settings → Actions → General → "Read and write permissions".
Schedule: 00:30 UTC = 06:00 IST, daily.

## Cost

Public repo: Actions unlimited. Private repo: 2,000 min/month free; one run ~1 min.
