I want this daily brief to be almost like a daily newspaper specific to me!
It will show my tasks for the day. A list of wokrouts and their relevant details like current weight I'm using, reps anmd so on.
I would also like a news feeds,
- There are certain webcomics I follow so I want it to update whenever the RSS feed shows a new update.
- Certain bands I like so I want to be notfied when they release new music or album
- Certain news topics I can keep in the config block too. Like "Witcher" for news related to the witcher game, "Harry Potter", "etc."


How to structure the project
PROJECT ROOT/
├── .Rproj.user/
├── .venv/ ## VSCode will build this from the requirements
├── data/
│   ├── notion_daily_tasks.csv # Pulled from the Notion, if this is needed for the building
├── documents/
├── output/
│   ├── daily_brief.html # I assume this is the file that is rebuilt daily
├── scripts/
│   ├── template_html.html # HTML Template
│   ├── template_css.css # CSS Template
│   ├── build_brief.py # This script is what git has to rerun daily to build the html
│   ├── build_brief.py # Maybe the script needed to commit but ideally it could just be one
├── .gitignore   ## Standard ignore file already covers many basic - Only add project specific ignores
├── Claude.md    ## Also acts as README. Always update this
├── folder_tree_builder.R
├── Project_R.Rproj
├── Project_VSCode.code-workspace
├── notion_tasks_token ## This is where the connection token is stored
├── notion_workoutdash_token ## This is where the connection token is stored
└── requirements.txt ## If project is using python - Write all requirements for venv



Using “notion_tasks_token.txt” - Gets access to my To do list database 
```markdown
NOTION DATABASE DIAGNOSTIC

Generated: 2026-10-03T19:12:01+05:30
API version: 2026-03-11
Accessible data sources: 1
Metadata only: no task rows or connection token are included.

================================================================
DATA SOURCE 1: Tasks
Database name: Tasks
Database URL:  https://app.notion.com/p/2e2bec68aefa8049b6ededa890cbceee
Database ID:   2e2bec68-aefa-8049-b6ed-eda890cbceee
Data source ID: 2e2bec68-aefa-81be-bfda-000b7366ef2d

COLUMNS

  Done
    ID:   GXJC
    Type: checkbox

  Parent item
    ID:   uKYI
    Type: relation
    Related source/database: 2e2bec68-aefa-81be-bfda-000b7366ef2d

  Sub-item
    ID:   xlEU
    Type: relation
    Related source/database: 2e2bec68-aefa-81be-bfda-000b7366ef2d

  Task
    ID:   title
    Type: title

  Task Date
    ID:   %3CLvZ
    Type: date

  Type
    ID:   mLc%3B
    Type: select
    Options: ["RANGE", "PRIORITY", "WORK", "PERSONAL", "RECURRENT"]

COPYABLE CONSTANTS FOR THE REBUILD

NOTION_DATA_SOURCE_ID = '2e2bec68-aefa-81be-bfda-000b7366ef2d'
COLUMN_IDS = {
    "Task Date": "%3CLvZ",
    "Done": "GXJC",
    "Type": "mLc%3B",
    "Parent item": "uKYI",
    "Sub-item": "xlEU",
    "Task": "title"
}
```

Using “notion_workoutdash_token.txt” - Get access to my work out dashboard and manager
This needs to be adjusted in the config file - The workout that will be rendered will be whichever appear for that day of the week - Plus for whichever loadout I am currently using. Right now it is loadout 1 but I would like to be able to change that in the config block
```markdown
NOTION DATABASE DIAGNOSTIC

Generated: 2026-10-03T19:07:52+05:30
API version: 2026-03-11
Accessible data sources: 1
Metadata only: no task rows or connection token are included.

================================================================
DATA SOURCE 1: Workout Dash
Database name: Workout Dash
Database URL:  https://app.notion.com/p/72fa5f6a9c644d01995173dbaf6c2f20
Database ID:   72fa5f6a-9c64-4d01-9951-73dbaf6c2f20
Data source ID: 28676ddd-d907-4643-aa88-10ffd7e38889

COLUMNS

  Current Weight (kg)
    ID:   CN%7BG
    Type: number

  Current Weight (lb)
    ID:   %7D%3CBn
    Type: formula
    Formula: round(prop("Current Weight (kg)") * 22) / 10

  Day
    ID:   ofiK
    Type: multi_select
    Options: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

  Equipment
    ID:   dJFr
    Type: multi_select
    Options: ["Machine", "Cable Station", "Functional Trainer", "Smith Machine", "Dumbbells", "Barbell", "Kettlebell", "Bench", "Bodyweight", "Mat", "Resistance Band", "Treadmill", "Stationary Bike", "Elliptical", "Rower"]

  In Rotation
    ID:   dbm%3A
    Type: checkbox

  IsToday
    ID:   prYC
    Type: formula
    Formula: if(
  contains(prop("Day"), formatDate(now(), "dddd")),
  "Today",
  ""
)

  Loadout
    ID:   iSYm
    Type: multi_select
    Options: ["1 · Full Gym", "2 · Minimal Gym", "3 · No Equipment"]

  Muscle Groups
    ID:   S%3Cbz
    Type: multi_select
    Options: ["Chest", "Front Delts", "Side Delts", "Rear Delts", "Triceps", "Biceps", "Forearms", "Lats", "Upper Back", "Lower Back", "Abs", "Obliques", "Glutes", "Quads", "Hamstrings", "Adductors", "Abductors", "Calves", "Full Body"]

  Name
    ID:   title
    Type: title

  Progression
    ID:   h%40Za
    Type: rich_text

  Reps
    ID:   mUGG
    Type: rich_text

  Rest (sec)
    ID:   q~Yo
    Type: number

  Sets
    ID:   ckPv
    Type: number

  Type
    ID:   Al%3AB
    Type: select
    Options: ["Strength", "Cardio", "Core", "Mobility"]

COPYABLE CONSTANTS FOR THE REBUILD

NOTION_DATA_SOURCE_ID = '28676ddd-d907-4643-aa88-10ffd7e38889'
COLUMN_IDS = {
    "Type": "Al%3AB",
    "Current Weight (kg)": "CN%7BG",
    "Muscle Groups": "S%3Cbz",
    "Sets": "ckPv",
    "Equipment": "dJFr",
    "In Rotation": "dbm%3A",
    "Progression": "h%40Za",
    "Loadout": "iSYm",
    "Reps": "mUGG",
    "Day": "ofiK",
    "IsToday": "prYC",
    "Rest (sec)": "q~Yo",
    "Current Weight (lb)": "%7D%3CBn",
    "Name": "title"
}

```