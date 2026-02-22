# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**pong-parry** is a Godot 4.6 game project in early development. The name suggests a paddle/parry mechanic inspired by Pong.

## Engine & Configuration

- **Engine**: Godot 4.6
- **Renderer**: Forward Plus
- **Physics**: Jolt Physics (3D)
- **Windows renderer**: Direct3D 12

The main project config is `project.godot`. The `.godot/` directory is editor-generated cache — do not commit it (already in `.gitignore`).

## Running the Game

There is no CLI build script. All development happens through the Godot Editor:

- **Open project**: Launch Godot 4.6, then open `project.godot`
- **Run game**: Press `F5` (play from main scene) or `F6` (play current scene)
- **Export**: Via Editor → Project → Export, or CLI:
  ```
  godot --export-release "<preset>" <output_path>
  ```

## GDScript Conventions

- Scripts attach to nodes via `@tool` or `extends <NodeType>`
- Use `res://` paths for all resource references
- Prefer typed GDScript (`var speed: float = 5.0`) for clarity and error checking
- Scene files use `.tscn`, resources use `.tres`, scripts use `.gd`

## Project Structure (as it grows)

Recommended layout to follow as the game is built:

```
pong-parry/
├── scenes/          # .tscn scene files
├── scripts/         # .gd scripts (if not co-located with scenes)
├── assets/          # textures, audio, fonts
├── project.godot
└── icon.svg
```

## Current State

The project is freshly initialized with no scenes or scripts yet — only the base Godot 4.6 configuration. All game logic, scenes, and assets still need to be created.
