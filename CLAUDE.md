# Daily Brief

A personal "daily newspaper" built from Notion tasks + workout dashboard, webcomic RSS feeds, MusicBrainz release data for followed artists, and Google News RSS for followed topics. GitHub Actions runs the notebook every morning, renders a styled HTML page, and commits it back to the repo. GitHub Pages serves the result.

## Layout

```
.
├── .github/workflows/daily-brief.yml   # Daily cron + manual trigger
├── data/                               # (reserved for intermediate CSVs if ever needed)
├── documents/                          # (reserved)
├── output/
│   └── daily_brief.html                # Rebuilt daily, committed by Actions
├── scripts/
│   ├── build_brief.ipynb               # Config + all build logic
│   ├── template_html.html              # Jinja2 shell
│   └── template_css.css                # Styling (inlined at build time)
├── .gitignore
├── CLAUDE.md
├── notion_tasks_token.txt              # LOCAL ONLY — gitignored
├── notion_workoutdash_token.txt        # LOCAL ONLY — gitignored
└── requirements.txt
```

## What goes in the brief

- **Today's tasks** — Notion rows where `Task Date == today`.
- **Today's workout** — Notion rows where `Day` contains today's weekday, `Loadout` contains the configured loadout, `In Rotation` is checked.
- **Webcomics** — latest strips from each configured RSS feed in the last couple of days.
- **Music releases** — release-groups from MusicBrainz for each configured artist in the last `music_lookback_days`.
- **News** — Google News RSS for each configured topic.

All of this is editable from the `CONFIG` cell at the top of `scripts/build_brief.ipynb`. There is no separate config file.

## Running locally

```bash
python -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate
pip install -r requirements.txt
pip install jupyter

# Put your Notion integration tokens in these two files (gitignored):
echo "secret_xxx..." > notion_tasks_token.txt
echo "secret_yyy..." > notion_workoutdash_token.txt

jupyter notebook scripts/build_brief.ipynb
# or run end-to-end:
jupyter nbconvert --to notebook --execute scripts/build_brief.ipynb --output /tmp/executed.ipynb
```

Open `output/daily_brief.html` in a browser.

## GitHub Actions setup

See the step-by-step guide in the chat where this project was created. The short version:

1. Push this repo to GitHub.
2. **Settings → Secrets and variables → Actions** → add two repository secrets:
   - `NOTION_TASKS_TOKEN`
   - `NOTION_WORKOUT_TOKEN`
3. Share each Notion database with the matching integration (so the token has access).
4. **Settings → Actions → General → Workflow permissions** → "Read and write permissions".
5. **Settings → Pages** → source: "Deploy from a branch", branch `main`, folder `/output`. Your brief will be live at `https://<username>.github.io/<repo>/daily_brief.html`.
6. The workflow runs at 00:30 UTC (06:00 IST) daily and whenever you click **Run workflow**.

## Cost

Public repo: GitHub Actions is free with no cap. One run is under a minute.

Private repo: 2,000 free Actions minutes/month on the Free tier. One run of this is ~1 minute, so ~30 minutes/month — well under the limit.

## Changing the loadout, feeds, bands or topics

Edit the `CONFIG` dict in `scripts/build_brief.ipynb` and commit. The next scheduled run picks it up. Keys you'll touch most:

- `loadout` — must match a Notion `Loadout` option exactly (e.g. `"1 · Full Gym"`).
- `webcomic_feeds` — list of `{name, url}`.
- `bands` — list of artist names (matched via MusicBrainz search).
- `news_topics` — list of search strings for Google News.
