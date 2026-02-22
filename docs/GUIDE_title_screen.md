# 🎮 Interactive Guide: Building the Pong Parry Title Screen in Godot 4.6

> **Goal**: Build the title screen from the design mockup — entirely inside the Godot Editor.
> **Time**: ~45–60 minutes | **Difficulty**: Beginner-friendly
> **What you'll learn**: Scene tree, Control nodes, Labels, Fonts, ColorRect, Buttons, Shaders, Anchors, and basic GDScript.

---

## 📐 Overview of What We're Building

```
┌──────────────────────────────────────────────────────┐
│  Dark navy background (#1A2332)                      │
│                                                      │
│       ░░ Ghost "PARRY" text (outline only) ░░        │
│                                                      │
│              ██ PONG ██  (white, huge)               │
│              ██ PARRY ██ (cyan, huge)                │
│                                                      │
│           ┌─ 🎮 PRESS START ─┐  (white button)      │
│           └──────────────────┘                       │
│                                                      │
│  ◯ circle (bottom-left)     MVP BUILD V0.1 (bottom) │
│  ▬ cyan bar ▪ white square                           │
└──────────────────────────────────────────────────────┘
```

---

## Phase 0: Project Setup (5 min)

### Step 0.1 — Set the Window Size

1. Open your project in Godot 4.6
2. Go to **Project → Project Settings** (top menu bar)
3. In the left sidebar, navigate to **Display → Window**
4. Set:
   - **Viewport Width**: `1920`
   - **Viewport Height**: `1080`
5. Scroll down to **Stretch** section:
   - **Mode**: `canvas_items`
   - **Aspect**: `keep`
6. Click **Close**

> 💡 **What you learned**: Project Settings controls your game's resolution and how it scales on different monitors. `canvas_items` mode makes 2D UI scale cleanly.

### Step 0.2 — Download a Bold Font

The design uses a heavy italic sans-serif. Download one of these free fonts:

- **Montserrat ExtraBold Italic** — [Google Fonts](https://fonts.google.com/specimen/Montserrat)
- **Outfit ExtraBold** — [Google Fonts](https://fonts.google.com/specimen/Outfit) (used in the `.pen` wireframes)

1. Download the font family `.ttf` or `.otf` files
2. Create a folder: right-click the **FileSystem** panel (bottom-left) → **New Folder** → name it `assets`
3. Inside `assets`, create another folder called `fonts`
4. Drag your font files from Finder into `res://assets/fonts/` in Godot's FileSystem panel

> 💡 **What you learned**: Godot's FileSystem panel mirrors your project folder. Dragging files in auto-imports them.

---

## Phase 1: The Scene Tree Foundation (10 min)

### Step 1.1 — Create a New Scene

1. Go to **Scene → New Scene** (top menu)
2. Click **User Interface** (this creates a root `Control` node)
3. The root node appears as "Control" — rename it by double-clicking → type `TitleScreen`
4. Save: **Ctrl+S** (Cmd+S on Mac) → save as `res://scenes/title_screen.tscn`

> 💡 **What you learned**: `Control` is the base node for all UI in Godot. Choosing "User Interface" as root means everything inside will use Godot's UI layout system (anchors, margins, containers).

### Step 1.2 — Understand the Node Tree We'll Build

Here's the full tree you'll create. Don't build it all yet — we'll go node by node:

```
TitleScreen (Control)
├── Background (ColorRect)
├── DecoCircle (Control)
│   └── CircleDrawer (script draws the circle)
├── GhostText (Label) — "PARRY" outline
├── TitleContainer (VBoxContainer)
│   ├── PongLabel (Label) — "PONG"
│   └── ParryLabel (Label) — "PARRY"
├── StartButton (Button) — "🎮 PRESS START"
├── BottomLeft (HBoxContainer)
│   ├── CyanBar (ColorRect)
│   └── WhiteSquare (ColorRect)
└── VersionLabel (Label) — "MVP BUILD V0.1"
```

> 💡 **What you learned**: Godot scenes are **trees of nodes**. Each node has a type and purpose. Planning the tree before building saves time.

---

## Phase 2: Background (5 min)

### Step 2.1 — Add the Background

1. Select `TitleScreen` in the Scene panel
2. Click the **+** button (Add Child Node) or press **Ctrl+A**
3. Search for `ColorRect` → select it → click **Create**
4. Rename it to `Background`

### Step 2.2 — Configure the Background

1. With `Background` selected, look at the **Inspector** panel (right side)
2. Find **Color** property → click the color swatch
3. Type `#1A2332` in the hex field (dark navy)
4. Now set it to fill the whole screen using **Anchors**:
   - In the toolbar above the viewport, click **Layout** menu (or the anchor preset dropdown)
   - Choose **Full Rect** (this stretches the node to fill its parent)

> 💡 **What you learned**: `ColorRect` is the simplest way to add a solid-color background. **Anchors** control how a Control node positions/sizes relative to its parent. "Full Rect" means "fill everything."

---

## Phase 3: The Title Text (15 min)

### Step 3.1 — Create a Container for the Title

1. Select `TitleScreen` → Add Child → search `VBoxContainer` → Create
2. Rename to `TitleContainer`
3. Set its anchor to **Full Rect** (Layout → Full Rect)
4. In Inspector, find **Theme Overrides → Constants**:
   - Set **Separation** to `-30` (this makes "PONG" and "PARRY" overlap vertically, creating the tight stacking)
5. Under **Layout → Alignment**:
   - **Alignment**: `Center`

> 💡 **What you learned**: `VBoxContainer` stacks children vertically. Negative separation creates overlapping text. Containers handle layout automatically — you rarely need to position children manually.

### Step 3.2 — Create the "PONG" Label

1. Select `TitleContainer` → Add Child → `Label` → Create
2. Rename to `PongLabel`
3. In Inspector:
   - **Text**: `PONG`
   - **Horizontal Alignment**: `Center`
4. Now add a custom font:
   - Expand **Label Settings** (or **Theme Overrides → Fonts**)
   - Click `[empty]` next to **Label Settings** → **New LabelSettings**
   - Click the new LabelSettings to expand it:
     - **Font**: Drag your bold/extrabold italic `.ttf` from the FileSystem panel
     - **Font Size**: `180`
     - **Font Color**: `#FFFFFF` (white)
5. Under **Theme Overrides → Font Sizes** (alternative approach):
   - Or set the font size here to `180`

> 💡 **What you learned**: `LabelSettings` is a resource that bundles font, size, color, and outline into one reusable object. You can share the same LabelSettings across multiple Labels.

### Step 3.3 — Create the "PARRY" Label

1. Select `TitleContainer` → Add Child → `Label` → Create
2. Rename to `ParryLabel`
3. In Inspector:
   - **Text**: `PARRY`
   - **Horizontal Alignment**: `Center`
4. Create new LabelSettings:
   - **Font**: Same bold italic font
   - **Font Size**: `180`
   - **Font Color**: `#00B5E2` (cyan)

> ✅ **Checkpoint**: Press **F6** to run this scene. You should see "PONG" in white and "PARRY" in cyan stacked tightly on a dark background.

### Step 3.4 — Create the Ghost "PARRY" Outline Text

This is the faint outlined "PARRY" text visible behind the main title.

1. Select `TitleScreen` (the root) → Add Child → `Label` → Create
2. Rename to `GhostText`
3. In Inspector:
   - **Text**: `PARRY`
   - **Horizontal Alignment**: `Center`
4. Set anchor to **Full Rect**, then adjust position:
   - **Layout → Anchors**: all to `0.5` center, or use **Center** anchor preset
5. Create new LabelSettings:
   - **Font**: Same bold italic font
   - **Font Size**: `220` (larger than the main text)
   - **Font Color**: `#00000000` (fully transparent — we only want the outline)
   - **Outline Size**: `2`
   - **Outline Color**: `#00B5E233` (cyan at ~20% opacity)
6. Position it behind the title:
   - In the Scene tree, make sure `GhostText` is **above** `TitleContainer` (drag it up). Nodes render in tree order — earlier = behind.
   - Adjust its **Position** in Inspector to offset it upward (Y around `250`–`300` from top)

> 💡 **What you learned**: 
> - **Drawing order** in Godot = tree order (top of tree = drawn first = behind).  
> - You can make text that's only an outline by setting the fill to transparent and enabling the outline.

---

## Phase 4: The "PRESS START" Button (10 min)

### Step 4.1 — Add the Button

1. Select `TitleScreen` → Add Child → `Button` → Create
2. Rename to `StartButton`
3. In Inspector:
   - **Text**: `  PRESS START` (add spaces for icon padding)
   - **Flat**: ✅ Check this ON (removes default Godot button chrome)

### Step 4.2 — Style the Button

1. With `StartButton` selected, go to Inspector → **Theme Overrides**
2. Under **Styles → Normal**:
   - Click `[empty]` → **New StyleBoxFlat**
   - Click the StyleBoxFlat to expand:
	 - **BG Color**: `#FFFFFF` (white)
	 - **Corner Radius**: all `0` (sharp edges)
	 - **Content Margin**: Left `40`, Top `16`, Right `40`, Bottom `16`
	 - **Skew**: `0.15` (this creates the parallelogram shape!)
3. Duplicate this StyleBoxFlat for **Hover** state:
   - Copy the StyleBoxFlat (right-click → Copy)
   - Paste into **Styles → Hover**
   - Change BG Color to `#E0E0E0` (slight grey for hover feedback)
4. Under **Theme Overrides → Colors**:
   - **Font Color**: `#000000` (black text)
5. Under **Theme Overrides → Fonts**:
   - Set your bold font, size `28`
6. Under **Theme Overrides → Constants**:
   - **H Separation**: `12`

### Step 4.3 — Position the Button

1. Set the button's **Anchor Preset** to **Center Bottom** or manually:
   - **Anchor Left/Right**: `0.5`
   - **Anchor Top/Bottom**: around `0.72` (72% down the screen)
   - **Grow Direction Horizontal**: `Both`
2. Or use the **Layout → Center** preset then manually adjust the Y position

> 💡 **What you learned**: 
> - `StyleBoxFlat` is Godot's way to style UI backgrounds with colors, corners, borders, and skew.
> - The **Skew** property creates the trendy parallelogram shape without any code.
> - Buttons have separate styles for Normal, Hover, Pressed, Disabled, and Focus states.

### Step 4.4 — Add the Gamepad Icon (Optional)

1. Find a gamepad icon (PNG, 24×24 or 32×32, white or black)
2. Import it into `res://assets/icons/`
3. Select `StartButton` → Inspector → **Icon**: drag the gamepad texture
4. **Icon Alignment**: `Left`
5. **Expand Icon**: OFF
6. Since button BG is white, ensure the icon is black

> 💡 Alternatively, you can use a Unicode gamepad emoji: change the button text to `🎮  PRESS START`

---

## Phase 5: Decorative Elements (10 min)

### Step 5.1 — Bottom-Left Bars

1. Select `TitleScreen` → Add Child → `HBoxContainer` → Create
2. Rename to `BottomLeft`
3. Position it:
   - **Anchor Preset**: Bottom Left
   - **Offset Left**: `40`
   - **Offset Bottom**: `-40`
4. Add children:
   - Add Child → `ColorRect` → rename `CyanBar`
	 - **Color**: `#00B5E2`
	 - **Custom Minimum Size**: `x: 60, y: 8`
   - Add Child → `ColorRect` → rename `WhiteSquare`
	 - **Color**: `#FFFFFF`
	 - **Custom Minimum Size**: `x: 24, y: 8`
5. In `BottomLeft` Inspector → **Theme Overrides → Constants → Separation**: `8`

### Step 5.2 — Version Label

1. Select `TitleScreen` → Add Child → `Label` → Create
2. Rename to `VersionLabel`
3. In Inspector:
   - **Text**: `MVP BUILD V0.1`
   - **Horizontal Alignment**: `Right`
4. Create LabelSettings:
   - **Font Size**: `16`
   - **Font Color**: `#4E606D` (muted grey)
5. **Anchor Preset**: Bottom Right
6. Adjust offsets: Right `-40`, Bottom `-40`

### Step 5.3 — Decorative Circle (via Script)

This teaches you basic `_draw()` — Godot's custom drawing API.

1. Select `TitleScreen` → Add Child → `Control` → Create
2. Rename to `DecoCircle`
3. Set **Anchor Preset**: Full Rect
4. With `DecoCircle` selected, click the **📜 script** icon (top-right of Inspector) → **New Script**
5. Save as `res://scripts/deco_circle.gd`
6. Replace the script content with:

```gdscript
extends Control

func _draw() -> void:
    # Large circle in bottom-left, mostly off-screen
    var center := Vector2(-80, size.y + 40)
    var radius := 300.0
    var color := Color("#1E2D3D")  # slightly lighter than background

    # Draw a thick ring (circle outline)
    draw_arc(center, radius, 0, TAU, 64, color, 8.0)
    draw_arc(center, radius - 40, 0, TAU, 64, color, 4.0)
```

7. Make sure `DecoCircle` is above `TitleContainer` in the scene tree (so it draws behind)

> 💡 **What you learned**: 
> - Every `CanvasItem` node (including `Control`) has a `_draw()` method for custom rendering.
> - `draw_arc()` draws circular arcs. `TAU` (6.28...) = full circle.
> - This is your first GDScript! Notice: typed variables (`: Vector2`), `:=` for inferred types, and `func` for functions.

---

## Phase 6: Make It Interactive (5 min)

### Step 6.1 — Add a Script to TitleScreen

1. Select `TitleScreen` → click the script icon → **New Script**
2. Save as `res://scripts/title_screen.gd`
3. Write this code:

```gdscript
extends Control

@onready var start_button: Button = $StartButton

func _ready() -> void:
    start_button.pressed.connect(_on_start_pressed)
    # Make the button text blink
    _start_blink()

func _on_start_pressed() -> void:
    # TODO: Change to your game scene later
    print("Game starting!")
    # get_tree().change_scene_to_file("res://scenes/game.tscn")

func _start_blink() -> void:
    var tween := create_tween().set_loops()
    tween.tween_property(start_button, "modulate:a", 0.3, 0.8)
    tween.tween_property(start_button, "modulate:a", 1.0, 0.8)
```

> 💡 **What you learned**:
> - `@onready` grabs a reference to a child node when the scene loads. `$StartButton` is shorthand for `get_node("StartButton")`.
> - **Signals** are Godot's event system. `pressed` is emitted when the button is clicked. `.connect()` links it to your function.
> - **Tweens** animate properties over time. This one fades the button opacity between 0.3 and 1.0 forever (`set_loops()`).

### Step 6.2 — Handle "Press Any Key" as Alternative

Add this to the same script to also respond to any key press:

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton:
		if event.is_pressed():
			_on_start_pressed()
```

> 💡 **What you learned**: `_unhandled_input()` receives input events that no other node consumed. This lets "press any key" work alongside the button.

---

## Phase 7: Set as Main Scene & Test (2 min)

1. Go to **Project → Project Settings → Application → Run**
2. Set **Main Scene** to `res://scenes/title_screen.tscn`
3. Press **F5** to run the project

> ✅ **Final Checkpoint**: You should see:
> - Dark navy background
> - "PONG" in white, "PARRY" in cyan, stacked tightly
> - Ghost "PARRY" outline behind the title
> - A white parallelogram "PRESS START" button that blinks
> - Decorative circle and bars in the corners
> - "MVP BUILD V0.1" in the bottom-right

---

## 🧠 Concepts You Learned

| Concept | Where You Used It |
|---|---|
| **Scene Tree** | Building the node hierarchy |
| **Control Nodes** | Every UI element (Label, Button, ColorRect, Container) |
| **Anchors & Layout** | Positioning elements relative to screen |
| **Containers** | VBoxContainer for title stacking, HBoxContainer for bottom bars |
| **LabelSettings** | Font, size, color, and outline configuration |
| **StyleBoxFlat** | Button styling with skew for parallelogram shape |
| **Custom Drawing** | `_draw()` for the decorative circle |
| **Signals** | Button `pressed` → function connection |
| **Tweens** | Blinking animation on the button |
| **GDScript basics** | Variables, functions, types, `@onready`, `_ready()` |
| **Input Handling** | `_unhandled_input()` for "press any key" |

---

## 🎯 Bonus Challenges

1. **Add a background shader**: Create a `ShaderMaterial` on the background ColorRect with animated grid lines
2. **Add sound**: Import a `.wav` and play it with `AudioStreamPlayer` when the button is pressed
3. **Scene transition**: Use `get_tree().change_scene_to_file()` to go to a game scene
4. **Animate the title**: Make "PONG" and "PARRY" slide in from the sides using tweens in `_ready()`
5. **Add screen shake**: Make the ghost text slowly drift using a sine wave in `_process()`

---

## 🔗 Godot Docs Reference

- [Control nodes](https://docs.godotengine.org/en/stable/classes/class_control.html)
- [Label](https://docs.godotengine.org/en/stable/classes/class_label.html)
- [Button](https://docs.godotengine.org/en/stable/classes/class_button.html)
- [StyleBoxFlat](https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html)
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html)
- [Custom Drawing](https://docs.godotengine.org/en/stable/tutorials/2d/custom_drawing_in_2d.html)
