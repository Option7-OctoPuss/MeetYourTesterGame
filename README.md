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
