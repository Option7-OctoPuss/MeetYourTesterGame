# MeetYourTesterGame

Game in godot

​

## Project structure

​

```
.
├── addons
├── audio
├── images
├── project.godot
└── ui
    ├── main_screen
    └── menus
        ├── difficulty
        ├── main_menu
        └── pause_menu

```

- `addons` used to saves Godot plugins, as suggested in Godot docs

- `project.godot` conf file used by Godot editor, auto-generated with a new project

- `audio` shared audio between every scene of the Game

- `images` shared images between scenes of the Game

- `ui` contains all sceene of the Game

    - `main_screen` scenes related to the map of the Game

    - `menus` contains all the menus scenes of the Game

        - `difficulty` difficulty menu 

        - `main_menu` the first menu shown when you launch the game

        - `pause_menu` menu shown when you pause the game while you play

​

Every new `.gd` and `.tscn` should be placed in the respective folder in according to this structure 

​

## Code conventions

​

We follow the Godot Style Guide [here](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html# )

​

- Every new folder and file names should be named following snake_case convention

- For node name use PascalCase

- Variable and function name should use snake_case

- Use tab for indentation

- Use [this](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools) extension for vsCode

## How To GUT

### Install GUT

Steps above are not needed since the required plugin is already in repo:
+ Open godot and click on "AssetLib" on top center bar
+ Search "GUT"
+ Select the one from "bitwes"

### Activate GUT in Godot project

Steps to activate GUT
+ Select "Project" tab from the menu
+ Select "Project Settings"
+ Select "Plugins"
+ Select "Gut"
+ Change "Status" to "Active"
+ Close settings

### Tests execution

#### GUI Execution using Godot

Here the steps to run tests using Godot
+ open "GUT" tab on the bottom
+ open desired test file in "res://test" folder
  + on "Settings" section change following values:
  + on "Test Directories":
    + set `Directory 0` to `res://test`
  + on "Various":
    + set `Script Prefix` to `test_`

#### CLI execution (optional)

Following steps are required to executes via CLI. Please, install `scoop` following "Install scoop" section before proceed with CLI tests execution 

Execute `cd` command to move to the current project directory

Execute the following command to run tests on `res://test/` containing prefix file name `test_` 

```bash
godot -d -s --path ./ addons/gut/gut_cmdln.gd -gdir=res://test/ -gprefix=test_ -gexit_on_success
```

### Install scoop (needed only to run tests using CLI)

`scoop` is required only if executing godot tests using CLI. Here powershell commands to install it:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop bucket add extras
scoop install godot
```

